import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/guest_model.dart';

class GuestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ═══════════════════════════════════════════════════════════════════════
  // ➕ ADD GUEST (MANUAL / VIP)
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
  // 🔍 GET GUEST BY ID (Used by QR Scanner) ✅ ADDED
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
  // ✅ MARK GUEST AS CHECKED IN (Used by QR Scanner)
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> checkInGuest(String eventId, String guestId) async {
    try {
      final docRef = _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('guests')
          .doc(guestId);

      // Verify guest exists and is not already checked in
      final snapshot = await docRef.get();
      if (!snapshot.exists) {
        throw Exception("Guest not found");
      }

      final data = snapshot.data() as Map<String, dynamic>;
      if (data['status'] == 'checked_in') {
        throw Exception("Guest already checked in!");
      }

      // Mark as checked in
      await docRef.update({
        'status': 'checked_in',
        'checkedInAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Check-in error: $e");
      return false; // You can modify this to return the error message if you prefer
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