import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String passwordHash;
  final String profileImage;
  final String address;
  final String? dateOfBirth;
  final String? gender;
  final List<String> roles;        // e.g. ['user', 'vendor']
  final String roleIntent;         // ✅ ADDED: 'user' or 'vendor' (Assigned at Signup)
  final String? vendorStatus;      // ✅ ADDED: 'pending', 'approved', 'rejected'
  final String? vendorId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.passwordHash = '',
    this.profileImage = '',
    this.address = '',
    this.dateOfBirth,
    this.gender,
    this.roles = const ['user'],
    this.roleIntent = 'user',      // ✅ Default to user
    this.vendorStatus,             // ✅ Null for normal users
    this.vendorId,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // ── Role Helpers ──
  bool get isUser => roles.contains('user');
  bool get isVendor => roles.contains('vendor');
  bool get isAdmin => roles.contains('admin');

  // Logic helper: Should we show the pending screen?
  bool get isPendingVendor => roleIntent == 'vendor' && vendorStatus == 'pending';

  // ── From Firestore ──
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      passwordHash: data['passwordHash'] ?? '',
      profileImage: data['profileImage'] ?? '',
      address: data['address'] ?? '',
      dateOfBirth: data['dateOfBirth'],
      gender: data['gender'],
      roles: List<String>.from(data['roles'] ?? ['user']),
      roleIntent: data['roleIntent'] ?? 'user',       // ✅ Added
      vendorStatus: data['vendorStatus'],             // ✅ Added
      vendorId: data['vendorId'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // ── From Map ──
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      passwordHash: data['passwordHash'] ?? '',
      profileImage: data['profileImage'] ?? '',
      address: data['address'] ?? '',
      dateOfBirth: data['dateOfBirth'],
      gender: data['gender'],
      roles: List<String>.from(data['roles'] ?? ['user']),
      roleIntent: data['roleIntent'] ?? 'user',       // ✅ Added
      vendorStatus: data['vendorStatus'],             // ✅ Added
      vendorId: data['vendorId'],
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
      updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null,
    );
  }

  // ── To Firestore ──
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'passwordHash': passwordHash,
      'profileImage': profileImage,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'roles': roles,
      'roleIntent': roleIntent,                       // ✅ Added
      'vendorStatus': vendorStatus,                   // ✅ Added
      'vendorId': vendorId,
      'isActive': isActive,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // ── To Map ──
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'passwordHash': passwordHash,
      'profileImage': profileImage,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'roles': roles,
      'roleIntent': roleIntent,                       // ✅ Added
      'vendorStatus': vendorStatus,                   // ✅ Added
      'vendorId': vendorId,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // ── Copy With ──
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? passwordHash,
    String? profileImage,
    String? address,
    String? dateOfBirth,
    String? gender,
    List<String>? roles,
    String? roleIntent,                               // ✅ Added
    String? vendorStatus,                             // ✅ Added
    String? vendorId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      passwordHash: passwordHash ?? this.passwordHash,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      roles: roles ?? this.roles,
      roleIntent: roleIntent ?? this.roleIntent,      // ✅ Added
      vendorStatus: vendorStatus ?? this.vendorStatus,// ✅ Added
      vendorId: vendorId ?? this.vendorId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, roleIntent: $roleIntent, status: $vendorStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}