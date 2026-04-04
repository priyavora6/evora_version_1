import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/vendor_model.dart';
import 'encryption_service.dart';
import 'notification_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool isUserVerified() {
    _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // 📝 REGISTER USER
  // ══════════════════════════════════════════════════════════════════════════════
  Future<UserModel?> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) return null;

      await userCredential.user!.sendEmailVerification();

      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        roles: ['user'],
        passwordHash: EncryptionService.hashPassword(password),
        isActive: true,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toFirestore());

      // ✅ FIXED: Removed the argument (uid) because the service gets it automatically
      await NotificationService().updateDeviceToken();

      return newUser;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // 🏪 APPLY TO BECOME VENDOR
  // ══════════════════════════════════════════════════════════════════════════════
  Future<bool> applyForVendor({
    required String userId,
    required String businessName,
    required String businessDescription,
    required String businessAddress,
    required String businessPhone,
    required List<String> categoryIds,
    String? logoUrl,
  }) async {
    try {
      DocumentReference vendorRef = _firestore.collection('vendors').doc();

      await vendorRef.set({
        'id': vendorRef.id,
        'userId': userId,
        'businessName': businessName,
        'description': businessDescription,
        'address': businessAddress,
        'phone': businessPhone,
        'categoryIds': categoryIds,
        'logo': logoUrl ?? '',
        'status': 'pending',
        'isActive': false,
        'rating': 0.0,
        'totalReviews': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('users').doc(userId).update({
        'pendingVendorId': vendorRef.id,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Vendor application error: $e');
      return false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // ✅ APPROVE VENDOR (Admin action)
  // ══════════════════════════════════════════════════════════════════════════════
  Future<bool> approveVendor(String vendorId) async {
    try {
      DocumentSnapshot vendorDoc = await _firestore.collection('vendors').doc(vendorId).get();
      if (!vendorDoc.exists) return false;

      String userId = vendorDoc['userId'];

      await _firestore.collection('vendors').doc(vendorId).update({
        'status': 'approved',
        'isActive': true,
        'approvedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('users').doc(userId).update({
        'roles': FieldValue.arrayUnion(['vendor']),
        'vendorId': vendorId,
        'pendingVendorId': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Vendor approval error: $e');
      return false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // ❌ REJECT VENDOR (Admin action)
  // ══════════════════════════════════════════════════════════════════════════════
  Future<bool> rejectVendor(String vendorId, {String? reason}) async {
    try {
      DocumentSnapshot vendorDoc = await _firestore.collection('vendors').doc(vendorId).get();
      if (!vendorDoc.exists) return false;

      String userId = vendorDoc['userId'];

      await _firestore.collection('vendors').doc(vendorId).update({
        'status': 'rejected',
        'rejectionReason': reason ?? 'Application rejected by admin',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('users').doc(userId).update({
        'pendingVendorId': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Vendor rejection error: $e');
      return false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // 📧 LOGIN
  // ══════════════════════════════════════════════════════════════════════════════
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ FIXED: Removed the argument (uid)
      await NotificationService().updateDeviceToken();

      return await getUserData(cred.user!.uid);
    } catch (e) {
      print('Login error: $e');
      throw e.toString();
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // 🔍 GET USER DATA
  // ══════════════════════════════════════════════════════════════════════════════
  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // 🔢 OTP GENERATION
  // ══════════════════════════════════════════════════════════════════════════════
  Future<String> generateAndStoreEmailOTP(String email) async {
    String otp = (Random().nextInt(900000) + 100000).toString();

    await _firestore.collection('email_otps').doc(email).set({
      'otp': otp,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': DateTime.now().add(const Duration(minutes: 10)).millisecondsSinceEpoch,
    });

    return otp;
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // ✅ OTP VERIFICATION
  // ══════════════════════════════════════════════════════════════════════════════
  Future<bool> verifyEmailOTP(String email, String enteredOtp) async {
    try {
      final doc = await _firestore.collection('email_otps').doc(email).get();
      if (!doc.exists) return false;

      int expiresAt = doc['expiresAt'];
      if (DateTime.now().millisecondsSinceEpoch > expiresAt) return false;

      if (doc['otp'] == enteredOtp) {
        await _firestore.collection('email_otps').doc(email).delete();
        return true;
      }
      return false;
    } catch (e) {
      print("OTP Verification Error: $e");
      return false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // 🚪 LOGOUT
  // ══════════════════════════════════════════════════════════════════════════════
  Future<void> logout() async {
    await NotificationService().deleteDeviceToken();
    await _auth.signOut();
  }
}