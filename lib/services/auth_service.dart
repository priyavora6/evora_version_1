import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'encryption_service.dart';
import 'notification_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // ✅ ADDED: Check if user is verified
  bool isUserVerified() {
    _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  // ✅ ADDED: Send verification email
  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
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
        email: email, password: password,
      );

      if (userCredential.user == null) return null;

      // Send verification email
      await userCredential.user!.sendEmailVerification();

      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        roles: ['user'], // Default role
        passwordHash: EncryptionService.hashPassword(password),
        isActive: true,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set(newUser.toFirestore());

      // Sync Token so they can receive the welcome push
      await NotificationService().updateFCMToken();

      return newUser;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // ✅ APPROVE VENDOR (One-Time Registration Logic)
  // ══════════════════════════════════════════════════════════════════════════════
  Future<bool> approveVendor(String vendorId) async {
    try {
      DocumentSnapshot vendorDoc = await _firestore.collection('vendors').doc(vendorId).get();
      if (!vendorDoc.exists) return false;

      String userId = vendorDoc['userId'];

      // 1. Update Vendor Doc
      await _firestore.collection('vendors').doc(vendorId).update({
        'status': 'approved',
        'isActive': true,
        'approvedAt': FieldValue.serverTimestamp(),
      });

      // 2. ✅ Update User Doc: Add 'vendor' role permanently
      await _firestore.collection('users').doc(userId).update({
        'roles': FieldValue.arrayUnion(['vendor']),
        'vendorId': vendorId,
        'roleIntent': 'vendor',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Vendor approval error: $e');
      return false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // 📧 LOGIN
  // ══════════════════════════════════════════════════════════════════════════════
  Future<UserModel?> loginUser({required String email, required String password}) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);

      // ✅ Sync FCM Token on every login
      await NotificationService().updateFCMToken();

      return await getUserData(cred.user!.uid);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? UserModel.fromFirestore(doc) : null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<void> logout() async {
    // ✅ Delete token so they don't get notifications after logging out
    await NotificationService().deleteFCMToken();
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> verifyEmailOTP(String email, String enteredOtp) async {
    try {
      final doc = await _firestore.collection('email_otps').doc(email).get();
      if (!doc.exists) return false;

      String otp = doc['otp'];
      int expiresAt = doc['expiresAt'];

      if (DateTime.now().millisecondsSinceEpoch > expiresAt) return false;

      if (otp == enteredOtp) {
        await _firestore.collection('email_otps').doc(email).delete();
        return true;
      }
      return false;
    } catch (e) {
      print("OTP Verification Error: $e");
      return false;
    }
  }

  // OTP Generation logic...
  Future<String> generateAndStoreEmailOTP(String email) async {
    String otp = (Random().nextInt(900000) + 100000).toString();
    await _firestore.collection('email_otps').doc(email).set({
      'otp': otp,
      'expiresAt': DateTime.now().add(const Duration(minutes: 10)).millisecondsSinceEpoch,
    });
    return otp;
  }
}