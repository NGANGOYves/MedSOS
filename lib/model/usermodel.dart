import 'dart:convert';

class UserModel {
  final String fullName;
  final String phone;
  final String email;
  final String role;
  final String? photoUrl;
  final String? address;
  final String? occupation;

  // New optional attributes for doctor details
  final int? years;
  final double? rating;
  final int? reviews;
  final bool? isFeatured;
  final String? speciality; // ✅ Added for filtering

  UserModel({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.role,
    this.photoUrl,
    this.address,
    this.occupation,
    this.years,
    this.rating,
    this.reviews,
    this.isFeatured,
    this.speciality,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      photoUrl: map['photoUrl'],
      address: map['address'],
      occupation: map['occupation'],
      years: map['years'],
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      reviews: map['reviews'],
      isFeatured: map['isFeatured'],
      speciality: map['speciality'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'address': address,
      'occupation': occupation,
      'years': years,
      'rating': rating,
      'reviews': reviews,
      'isFeatured': isFeatured,
      'speciality': speciality,
    };
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
