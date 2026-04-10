// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/vendor_service.dart';
import '../models/user_model.dart';
import '../models/vendor_model.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  unknown
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();
  final VendorService _vendorService = VendorService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  VendorModel? _currentVendor;
  AuthStatus _status = AuthStatus.initial;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  UserModel? get user => _currentUser;
  VendorModel? get currentVendor => _currentVendor;
  AuthStatus get status => _status;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  String? get errorMessage => _errorMessage;
  String? get error => _errorMessage;

  // Status Checks
  bool get isVendor => _currentUser?.vendorId != null || _currentVendor != null;
  bool get isApprovedVendor => _currentVendor?.status.toLowerCase() == 'approved';
  String? get vendorStatus => _currentVendor?.status;
  bool get isUserVerified => _authService.isUserVerified();

  AuthProvider() {
    _checkCurrentUser();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔄 REFRESH USER & VENDOR DATA
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> refreshUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final updatedUser = await _authService.getUserData(uid);
      if (updatedUser == null) return;
      _currentUser = updatedUser;

      VendorModel? vendorDoc;
      if (updatedUser.vendorId != null && updatedUser.vendorId!.isNotEmpty) {
        vendorDoc = await _vendorService.getVendorById(updatedUser.vendorId!);
      }

      if (vendorDoc == null) {
        vendorDoc = await _vendorService.getVendorByUserId(uid);
        if (vendorDoc != null) {
          await _firestore.collection('users').doc(uid).update({
            'vendorId': vendorDoc.id,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          _currentUser = _currentUser!.copyWith(vendorId: vendorDoc.id);
        }
      }

      _currentVendor = vendorDoc;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Refresh error: $e");
    }
  }

  // ✅ NEW: Toggle Browse Vendors preference
  Future<void> toggleSeeVendors(bool value) async {
    if (_currentUser == null) return;
    try {
      await _firestore.collection('users').doc(_currentUser!.id).update({
        'wantToSeeVendors': value,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _currentUser = _currentUser!.copyWith(wantToSeeVendors: value);
      notifyListeners();
    } catch (e) {
      debugPrint('Toggle vendors error: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔑 OTP & VERIFICATION
  // ═══════════════════════════════════════════════════════════════════════
  Future<String?> sendEmailOTP(String email) async {
    _setLoading(true);
    try {
      return await _authService.generateAndStoreEmailOTP(email);
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyEmailOTP(String email, String enteredOtp) async {
    _setLoading(true);
    _setError(null);
    try {
      bool success = await _authService.verifyEmailOTP(email, enteredOtp);
      if (success) {
        await refreshUserData();
      }
      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📝 AUTH ACTIONS
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _setError(null);
    try {
      final user = await _authService.loginUser(email: email, password: password);
      if (user != null) {
        _currentUser = user;
        await refreshUserData();
        _status = AuthStatus.authenticated;
        await _syncFCMToken();
        
        // ✅ Fixed: Use correct parameter name 'isVendorMode'
        await _notificationService.sendWelcomeNotification(
          userId: user.id,
          userName: user.name,
          isVendorMode: isVendor,
        );
        
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String roleIntent,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final user = await _authService.registerUser(
        email: email, password: password, name: name, phone: phone,
      );

      if (user != null) {
        await _firestore.collection('users').doc(user.id).set({
          'id': user.id,
          'name': name,
          'email': email,
          'phone': phone,
          'roleIntent': roleIntent,
          'roles': ['user'],
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'wantToSeeVendors': false,
        }, SetOptions(merge: true));

        _currentUser = user;
        _status = AuthStatus.authenticated;

        await Future.delayed(const Duration(seconds: 1));
        await _syncFCMToken();
        
        // ✅ Fixed: Use correct parameter name 'isVendorMode'
        await _notificationService.sendWelcomeNotification(
          userId: user.id,
          userName: user.name,
          isVendorMode: roleIntent == 'vendor',
        );
        
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _syncLogoutFCMToken();
    await _authService.logout();
    _currentUser = null;
    _currentVendor = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🏢 VENDOR & PROFILE ACTIONS
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> applyAsVendor(VendorModel vendorData) async {
    if (_currentUser == null) return false;
    _setLoading(true);
    try {
      final vendorId = await _vendorService.createVendorApplication(vendorData);
      if (vendorId != null) {
        await _firestore.collection('users').doc(_currentUser!.id).update({
          'vendorId': vendorId,
          'roleIntent': 'vendor',
        });
        await refreshUserData();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateUserProfile({required String name, required String phone}) async {
    _setLoading(true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return false;
      await _firestore.collection('users').doc(uid).update({
        'name': name, 'phone': phone, 'updatedAt': FieldValue.serverTimestamp(),
      });
      await refreshUserData();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🛠️ INTERNAL HELPERS
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _checkCurrentUser() async {
    try {
      final firebaseUser = _authService.currentUser;
      if (firebaseUser != null) {
        await refreshUserData();
        if (_currentUser != null) {
          _status = AuthStatus.authenticated;
          await _syncFCMToken();
        } else {
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> updateVendorData() async => await refreshUserData();

  Future<void> _syncFCMToken() async {
    if (_currentUser != null) {
      try {
        await _notificationService.updateFCMToken();
      } catch (e) {
        debugPrint("FCM Error: $e");
      }
    }
  }

  Future<void> _syncLogoutFCMToken() async {
    if (_currentUser != null) {
      try {
        await _notificationService.deleteFCMToken();
      } catch (e) {
        debugPrint("FCM Logout Error: $e");
      }
    }
  }

  void _setLoading(bool value) { _isLoading = value; notifyListeners(); }
  void _setError(String? message) { _errorMessage = message; notifyListeners(); }
  void clearError() { _errorMessage = null; notifyListeners(); }
}
