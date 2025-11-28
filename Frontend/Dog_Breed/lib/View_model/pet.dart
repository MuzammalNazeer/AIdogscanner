// lib/View_model/pet.dart
import 'package:flutter/foundation.dart';

// Simple data model for a single pet
class Pet {
  final String name;
  final String breed;
  final String gender;
  final DateTime birthday;
  String? imageUrl;
  final Uint8List? imageBytes; // Or store image as bytes

  Pet({
    required this.name,
    required this.breed,
    required this.gender,
    required this.birthday,
    this.imageUrl,
    this.imageBytes,

  });
}

// Provider class to manage the list of pets
class PetProvid with ChangeNotifier {
  final List<Pet> _pets = [];

  List<Pet> get pets => _pets;

  void addPet(Pet pet) {
    _pets.add(pet);
    notifyListeners();
  }

  void removePet(Pet pet) {
    _pets.remove(pet);
    notifyListeners();
  }
}