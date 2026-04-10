// lib/services/vendor_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/vendor_model.dart';
import 'notification_service.dart';

class VendorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ═══════════════════════════════════════════════════════════════════════
  // 📝 CREATE VENDOR APPLICATION
  // ═══════════════════════════════════════════════════════════════════════
  Future<String?> createVendorApplication(VendorModel vendor) async {
    try {
      final docRef = await _firestore.collection('vendors').add(vendor.toFirestore());
      debugPrint('✅ Vendor application created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error creating vendor application: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔍 GET VENDOR BY ID
  // ═══════════════════════════════════════════════════════════════════════
  Future<VendorModel?> getVendorById(String vendorId) async {
    try {
      final doc = await _firestore.collection('vendors').doc(vendorId).get();
      if (doc.exists) {
        return VendorModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error fetching vendor: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔍 GET VENDOR BY USER ID
  // ═══════════════════════════════════════════════════════════════════════
  Future<VendorModel?> getVendorByUserId(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('vendors')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return VendorModel.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error fetching vendor by userId: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📋 GET ALL APPROVED VENDORS
  // ═══════════════════════════════════════════════════════════════════════
  Future<List<VendorModel>> getApprovedVendors() async {
    try {
      final snapshot = await _firestore
          .collection('vendors')
          .where('isApproved', isEqualTo: true)
          .where('isAvailable', isEqualTo: true)
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VendorModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching approved vendors: $e');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📋 GET VENDORS BY SERVICE TYPE
  // ═══════════════════════════════════════════════════════════════════════
  Future<List<VendorModel>> getVendorsByServiceType(String serviceType) async {
    try {
      final snapshot = await _firestore
          .collection('vendors')
          .where('serviceType', isEqualTo: serviceType)
          .where('isApproved', isEqualTo: true)
          .where('isAvailable', isEqualTo: true)
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VendorModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching vendors by service type: $e');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📋 GET PENDING VENDOR APPLICATIONS
  // ═══════════════════════════════════════════════════════════════════════
  Future<List<VendorModel>> getPendingApplications() async {
    try {
      final snapshot = await _firestore
          .collection('vendors')
          .where('status', isEqualTo: 'pending')
          .orderBy('appliedDate', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => VendorModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching pending applications: $e');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ✅ APPROVE VENDOR (Admin)
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> approveVendor(String vendorId) async {
    try {
      await _firestore.collection('vendors').doc(vendorId).update({
        'status': 'approved',
        'isApproved': true,
        'isAvailable': true,
        'approvedDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Get vendor to send notification
      final vendorDoc = await _firestore.collection('vendors').doc(vendorId).get();
      if (vendorDoc.exists) {
        final userId = vendorDoc.data()?['userId'];
        final businessName = vendorDoc.data()?['businessName'] ?? 'Your business';

        // ✅ Send vendor-side notification
        await _firestore.collection('notifications').add({
          'userId': userId,
          'title': '🎉 Vendor Application Approved!',
          'message': 'Congratulations! $businessName has been approved. You can now start receiving event assignments.',
          'type': NotificationType.vendorApproved,
          'relatedId': vendorId,
          'isRead': false,
          'isVendorSide': true, // ✅ Separates from user panel
          'createdAt': FieldValue.serverTimestamp(),
        });

        // ✅ Also send a user-side notification so they know they can switch
        await _firestore.collection('notifications').add({
          'userId': userId,
          'title': 'You are now an approved Vendor!',
          'message': 'Switch to Vendor Mode to start receiving assignments.',
          'type': NotificationType.vendorApproved,
          'relatedId': vendorId,
          'isRead': false,
          'isVendorSide': false, // ✅ Shows in user panel
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      debugPrint('✅ Vendor approved: $vendorId');
      return true;
    } catch (e) {
      debugPrint('❌ Error approving vendor: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ❌ REJECT VENDOR (Admin)
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> rejectVendor(String vendorId, String reason) async {
    try {
      await _firestore.collection('vendors').doc(vendorId).update({
        'status': 'rejected',
        'isApproved': false,
        'rejectedReason': reason,
        'rejectedDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Get vendor to send notification
      final vendorDoc = await _firestore.collection('vendors').doc(vendorId).get();
      if (vendorDoc.exists) {
        final userId = vendorDoc.data()?['userId'];

        // ✅ Send notification to both sides or just one as needed
        await _firestore.collection('notifications').add({
          'userId': userId,
          'title': '❌ Vendor Application Rejected',
          'message': 'Unfortunately, your vendor application was rejected. Reason: $reason',
          'type': NotificationType.vendorRejected,
          'relatedId': vendorId,
          'isRead': false,
          'isVendorSide': false, // Show on user side since they are applying as user
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      debugPrint('✅ Vendor rejected: $vendorId');
      return true;
    } catch (e) {
      debugPrint('❌ Error rejecting vendor: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔄 UPDATE VENDOR PROFILE
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> updateVendor(String vendorId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('vendors').doc(vendorId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Vendor updated: $vendorId');
      return true;
    } catch (e) {
      debugPrint('❌ Error updating vendor: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔘 TOGGLE AVAILABILITY
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> toggleAvailability(String vendorId, bool isAvailable) async {
    try {
      await _firestore.collection('vendors').doc(vendorId).update({
        'isAvailable': isAvailable,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Availability toggled: $isAvailable');
      return true;
    } catch (e) {
      debugPrint('❌ Error toggling availability: $e');
      return false;
    }
  }

  // 📡 STREAM: APPROVED VENDORS
  Stream<List<VendorModel>> getApprovedVendorsStream() {
    return _firestore
        .collection('vendors')
        .where('isApproved', isEqualTo: true)
        .where('isAvailable', isEqualTo: true)
        .orderBy('rating', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => VendorModel.fromFirestore(doc)).toList());
  }

  // 📡 STREAM: VENDOR BY ID
  Stream<VendorModel?> getVendorStream(String vendorId) {
    return _firestore
        .collection('vendors')
        .doc(vendorId)
        .snapshots()
        .map((doc) => doc.exists ? VendorModel.fromFirestore(doc) : null);
  }
}