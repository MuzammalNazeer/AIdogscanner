// View_model/pet.dart
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class Pet with ChangeNotifier {
  String? id;
  String name;
  String breed;
  String gender;
  DateTime birthday;
  Uint8List? imageBytes;

  Pet({
    this.id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.birthday,
    this.imageBytes,
  });

  // Generate a unique ID if not provided
  String generateId() {
    id ??= 'pet_${DateTime.now().millisecondsSinceEpoch}_${name.hashCode}';
    return id!;
  }

  // Convert to Map for serialization
  Map<String, dynamic> toMap() {
    return {
      'id': generateId(),
      'name': name,
      'breed': breed,
      'gender': gender,
      'birthday': birthday.toIso8601String(),
      'imageBytes': imageBytes?.toList(),
    };
  }

  // Create Pet from Map
  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'] ?? '',
      breed: map['breed'] ?? '',
      gender: map['gender'] ?? '',
      birthday: DateTime.parse(map['birthday']),
      imageBytes: map['imageBytes'] != null
          ? Uint8List.fromList(List<int>.from(map['imageBytes']))
          : null,
    );
  }
}