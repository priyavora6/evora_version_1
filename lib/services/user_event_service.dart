// lib/services/user_event_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_event_model.dart';
import '../models/cart_item_model.dart';

class UserEventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'userEvents';

  // Stream user events
  Stream<List<UserEvent>> streamUserEvents(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('eventDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserEvent.fromFirestore(doc))
            .toList());
  }

  // Get all events for a user
  Future<List<UserEvent>> getUserEvents(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('eventDate', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => UserEvent.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting user events: $e');
      return [];
    }
  }

  // Get a single event by ID
  Future<UserEvent?> getEventById(String eventId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(eventId).get();
      if (doc.exists) {
        UserEvent event = UserEvent.fromFirestore(doc);
        
        // 🔥 Fetch selected items from sub-collection
        List<CartItem> items = await getSelectedItems(eventId);
        
        return event.copyWith(selectedItems: items);
      }
    } catch (e) {
      print('Error getting event by ID: $e');
    }
    return null;
  }

  // Create event
  Future<String?> createEvent(UserEvent event) async {
    try {
      final List<CartItem> selectedItems = event.selectedItems;
      final eventData = event.toFirestore();
      
      // We keep it in the main doc AND sub-collection for safety/ease of access
      // But based on previous implementation, let's keep sub-collection as source of truth
      eventData.remove('selectedItems'); 

      DocumentReference eventRef = await _firestore.collection(_collection).add(eventData);
      String eventId = eventRef.id;

      WriteBatch batch = _firestore.batch();
      for (var item in selectedItems) {
        DocumentReference itemRef = _firestore
            .collection(_collection)
            .doc(eventId)
            .collection('selectedItems') 
            .doc();
        batch.set(itemRef, item.toMap());
      }
      await batch.commit();

      return eventId;
    } catch (e) {
      print('Error creating event: $e');
      return null;
    }
  }

  // Update event
  Future<bool> updateEvent(String eventId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(eventId).update(data);
      return true;
    } catch (e) {
      print('Error updating event: $e');
      return false;
    }
  }

  // Delete event
  Future<bool> deleteEvent(String eventId) async {
    try {
      await _firestore.collection(_collection).doc(eventId).delete();
      return true;
    } catch (e) {
      print('Error deleting event: $e');
      return false;
    }
  }
  
  // Get events on a specific date
  Future<List<UserEvent>> getEventsOnDate(DateTime date) async {
    try {
      // Normalize date to remove time component
      DateTime startDate = DateTime(date.year, date.month, date.day);
      DateTime endDate = startDate.add(const Duration(days: 1));

      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('eventDate', isGreaterThanOrEqualTo: startDate)
          .where('eventDate', isLessThan: endDate)
          .get();

      return snapshot.docs
          .map((doc) => UserEvent.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting events on date: $e');
      return [];
    }
  }
  
    // 🔥 NEW METHOD
  Future<void> updateEventCount(String eventId, int count) async {
    await _firestore.collection(_collection).doc(eventId).update({
      'checkedInCount': count,
    });
  }

  Future<Map<String, dynamic>> checkInGuest(String eventId, String qrCodeData) async {
    try {
      // 1. Find the guest in the sub-collection with this QR code
      final guestQuery = await _firestore
          .collection(_collection)
          .doc(eventId)
          .collection('guests')
          .where('qrCode', isEqualTo: qrCodeData)
          .limit(1)
          .get();

      if (guestQuery.docs.isEmpty) {
        return {'success': false, 'message': 'Invalid Pass: Guest not found'};
      }

      final guestDoc = guestQuery.docs.first;
      final guestData = guestDoc.data();

      // 2. Check if they already entered
      if (guestData['hasEntered'] == true) {
        return {'success': false, 'message': 'Already Entered: ${guestData['name']}'};
      }

      // 3. Mark guest as entered and increment event counter
      WriteBatch batch = _firestore.batch();
      
      // Update Guest Status
      batch.update(guestDoc.reference, {'hasEntered': true, 'rsvpStatus': 'confirmed'});
      
      // Update Main Event Counter
      batch.update(_firestore.collection(_collection).doc(eventId), {
        'checkedInCount': FieldValue.increment(1)
      });

      await batch.commit();

      return {
        'success': true, 
        'message': 'Welcome, ${guestData['name']}!', 
        'guestName': guestData['name']
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<List<CartItem>> getSelectedItems(String eventId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .doc(eventId)
          .collection('selectedItems') 
          .get();

      return snapshot.docs
          .map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching selected items: $e");
      return [];
    }
  }
}