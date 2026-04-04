import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/guest_model.dart';

class GuestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ═══════════════════════════════════════════════════════════════════════
  // ➕ ADD GUEST
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> addGuest(String eventId, GuestModel guest) async {
    try {
      await _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('guests')
          .add(guest.toMap());
      return true;
    } catch (e) {
      print("Error adding guest: $e");
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔍 GET GUEST BY ID (✅ ADD THIS METHOD)
  // ═══════════════════════════════════════════════════════════════════════
  Future<GuestModel?> getGuestById(String eventId, String guestId) async {
    try {
      final doc = await _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('guests')
          .doc(guestId)
          .get();

      if (doc.exists) {
        return GuestModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print("Error getting guest: $e");
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ✅ CHECK IN GUEST
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> checkInGuest(String eventId, String guestId) async {
    try {
      final docRef = _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('guests')
          .doc(guestId);

      final snapshot = await docRef.get();
      if (!snapshot.exists) return false;

      final data = snapshot.data() as Map<String, dynamic>;
      if (data['status'] == 'checked_in') return false;

      await docRef.update({
        'status': 'checked_in',
        'checkedInAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Check-in error: $e");
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🗑️ DELETE GUEST
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> deleteGuest(String eventId, String guestId) async {
    try {
      await _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('guests')
          .doc(guestId)
          .delete();
      return true;
    } catch (e) {
      print("Delete guest error: $e");
      return false;
    }
  }
}