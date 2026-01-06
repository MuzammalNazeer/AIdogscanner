// models/user_model.dart
import '../database/DatabaseHelper.dart';

class User {
  int? id;
  String username;
  String email;
  String password;
  String? fullName;
  String? phoneNumber;
  String? address;
  String? profileImage;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.fullName,
    this.phoneNumber,
    this.address,
    this.profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper().colUsername: username,
      DatabaseHelper().colEmail: email,
      DatabaseHelper().colPassword: password,
      DatabaseHelper().colFullName: fullName,
      DatabaseHelper().colPhoneNumber: phoneNumber,
      DatabaseHelper().colAddress: address,
      DatabaseHelper().colProfileImage: profileImage,
      DatabaseHelper().colCreatedAt: createdAt.toIso8601String(),
      DatabaseHelper().colUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[DatabaseHelper().colId],
      username: map[DatabaseHelper().colUsername],
      email: map[DatabaseHelper().colEmail],
      password: map[DatabaseHelper().colPassword],
      fullName: map[DatabaseHelper().colFullName],
      phoneNumber: map[DatabaseHelper().colPhoneNumber],
      address: map[DatabaseHelper().colAddress],
      profileImage: map[DatabaseHelper().colProfileImage],
      createdAt: DateTime.parse(map[DatabaseHelper().colCreatedAt]),
      updatedAt: DateTime.parse(map[DatabaseHelper().colUpdatedAt]),
    );
  }
}