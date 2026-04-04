// lib/models/guest_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class GuestModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final bool isVIP;
  final String status; // 'pending' or 'checked_in'
  final DateTime? rsvpDate; // When they RSVP'd
  final String source; // 'manual' or 'rsvp_link'

  GuestModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.isVIP,
    required this.status,
    this.rsvpDate,
    this.source = 'manual',
  });

  factory GuestModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return GuestModel(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      isVIP: data['isVIP'] ?? false,
      status: data['status'] ?? 'pending',
      source: data['source'] ?? 'manual',
      rsvpDate: (data['rsvpDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'isVIP': isVIP,
      'status': status,
      'source': source,
      'rsvpDate': rsvpDate != null ? Timestamp.fromDate(rsvpDate!) : FieldValue.serverTimestamp(),
    };
  }
}