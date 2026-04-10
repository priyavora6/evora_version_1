import 'package:cloud_firestore/cloud_firestore.dart';

class VendorModel {
  final String id;
  final String userId;
  final String vendorName;
  final String businessName;
  final String serviceType;
  final String description;
  final String ownerName;
  final String businessPhone;
  final String businessEmail;
  final String businessAddress;
  final String city;
  final String experience;
  final String priceRange;
  final double rating;
  final int totalEvents;
  final int totalReviews;
  final String status;
  final bool isApproved;
  final bool isAvailable;

  final String? logoUrl;
  final String? whatsappNumber;
  final String? websiteUrl;
  final String? instagramHandle;
  final String? facebookUrl;
  final String? references;

  final String? rejectedReason;
  final DateTime? appliedDate;
  final DateTime? approvedDate;
  final DateTime? rejectedDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VendorModel({
    required this.id,
    required this.userId,
    required this.vendorName,
    required this.businessName,
    required this.serviceType,
    required this.description,
    required this.ownerName,
    required this.businessPhone,
    required this.businessEmail,
    required this.businessAddress,
    required this.city,
    required this.experience,
    required this.priceRange,
    this.rating = 0.0,
    this.totalEvents = 0,
    this.totalReviews = 0,
    this.status = 'pending',
    this.isApproved = false,
    this.isAvailable = false,
    this.logoUrl,
    this.whatsappNumber,
    this.websiteUrl,
    this.instagramHandle,
    this.facebookUrl,
    this.references,
    this.rejectedReason,
    this.appliedDate,
    this.approvedDate,
    this.rejectedDate,
    this.createdAt,
    this.updatedAt,
  });

  bool get isPending => status == 'pending';
  bool get isRejected => status == 'rejected';
  bool get isApprovedVendor => status == 'approved' && isApproved;

  factory VendorModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return VendorModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      vendorName: data['vendorName'] ?? data['businessName'] ?? '',
      businessName: data['businessName'] ?? '',
      serviceType: data['serviceType'] ?? '',
      description: data['description'] ?? '',
      ownerName: data['ownerName'] ?? '',
      businessPhone: data['businessPhone'] ?? '',
      businessEmail: data['businessEmail'] ?? '',
      businessAddress: data['businessAddress'] ?? '',
      city: data['city'] ?? '',
      experience: data['experience'] ?? '',
      priceRange: data['priceRange'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalEvents: data['totalEvents'] ?? 0,
      totalReviews: data['totalReviews'] ?? 0,
      status: data['status'] ?? 'pending',
      isApproved: data['isApproved'] ?? false,
      isAvailable: data['isAvailable'] ?? false,
      logoUrl: data['logoUrl'] ?? data['logo'],
      whatsappNumber: data['whatsappNumber'],
      websiteUrl: data['websiteUrl'],
      instagramHandle: data['instagramHandle'],
      facebookUrl: data['facebookUrl'],
      references: data['references'],
      rejectedReason: data['rejectedReason'],
      appliedDate: (data['appliedDate'] as Timestamp?)?.toDate(),
      approvedDate: (data['approvedDate'] as Timestamp?)?.toDate(),
      rejectedDate: (data['rejectedDate'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'vendorName': vendorName,
      'businessName': businessName,
      'serviceType': serviceType,
      'description': description,
      'ownerName': ownerName,
      'businessPhone': businessPhone,
      'businessEmail': businessEmail,
      'businessAddress': businessAddress,
      'city': city,
      'experience': experience,
      'priceRange': priceRange,
      'rating': rating,
      'totalEvents': totalEvents,
      'totalReviews': totalReviews,
      'status': status,
      'isApproved': isApproved,
      'isAvailable': isAvailable,
      'logoUrl': logoUrl,
      'whatsappNumber': whatsappNumber,
      'websiteUrl': websiteUrl,
      'instagramHandle': instagramHandle,
      'facebookUrl': facebookUrl,
      'references': references,
      'rejectedReason': rejectedReason,
      'appliedDate': appliedDate ?? FieldValue.serverTimestamp(),
      'approvedDate': approvedDate,
      'rejectedDate': rejectedDate,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  VendorModel copyWith({
    String? id,
    String? userId,
    String? vendorName,
    String? businessName,
    String? serviceType,
    String? description,
    String? ownerName,
    String? businessPhone,
    String? businessEmail,
    String? businessAddress,
    String? city,
    String? experience,
    String? priceRange,
    double? rating,
    int? totalEvents,
    int? totalReviews,
    String? status,
    bool? isApproved,
    bool? isAvailable,
    String? logoUrl,
    String? whatsappNumber,
    String? websiteUrl,
    String? instagramHandle,
    String? facebookUrl,
    String? references,
    String? rejectedReason,
    DateTime? appliedDate,
    DateTime? approvedDate,
    DateTime? rejectedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vendorName: vendorName ?? this.vendorName,
      businessName: businessName ?? this.businessName,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      ownerName: ownerName ?? this.ownerName,
      businessPhone: businessPhone ?? this.businessPhone,
      businessEmail: businessEmail ?? this.businessEmail,
      businessAddress: businessAddress ?? this.businessAddress,
      city: city ?? this.city,
      experience: experience ?? this.experience,
      priceRange: priceRange ?? this.priceRange,
      rating: rating ?? this.rating,
      totalEvents: totalEvents ?? this.totalEvents,
      totalReviews: totalReviews ?? this.totalReviews,
      status: status ?? this.status,
      isApproved: isApproved ?? this.isApproved,
      isAvailable: isAvailable ?? this.isAvailable,
      logoUrl: logoUrl ?? this.logoUrl,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      references: references ?? this.references,
      rejectedReason: rejectedReason ?? this.rejectedReason,
      appliedDate: appliedDate ?? this.appliedDate,
      approvedDate: approvedDate ?? this.approvedDate,
      rejectedDate: rejectedDate ?? this.rejectedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
