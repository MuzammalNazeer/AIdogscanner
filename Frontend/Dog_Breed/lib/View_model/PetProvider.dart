// View_model/pet_provider.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/Pet.dart';

class PetProvider with ChangeNotifier {
  List<Pet> _pets = [];

  List<Pet> get pets => List.unmodifiable(_pets);



  // Key for shared preferences
  static const String _petsKey = 'saved_pets';

  String? _lastAddedPetId;
  String? get lastAddedPetId => _lastAddedPetId;

  void clearLastAddedPetId() {
    _lastAddedPetId = null;
  }

  PetProvider() {
    _init();
  }

  // Initialize and load pets
  Future<void> _init() async {
    await loadPets();
  }

  // Load pets from shared preferences
  Future<void> loadPets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final petsJson = prefs.getString(_petsKey);

      if (petsJson != null && petsJson.isNotEmpty) {
        final List<dynamic> petsList = json.decode(petsJson);
        _pets = petsList.map((item) => Pet.fromMap(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading pets: $e');
      _pets = [];
    }
  }

  // Save pets to shared preferences
  Future<bool> _savePets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final petsJson = json.encode(_pets.map((pet) => pet.toMap()).toList());
      return await prefs.setString(_petsKey, petsJson);
    } catch (e) {
      debugPrint('Error saving pets: $e');
      return false;
    }
  }

  // Add a new pet
  Future<bool> addPet(Pet pet) async {
    try {
      pet.generateId(); // Ensure pet has an ID
      _pets.add(pet);
      _lastAddedPetId = pet.id;
      final success = await _savePets();
      if (success) {
        notifyListeners();
      } else {
        _pets.remove(pet);
        _lastAddedPetId = null;
      }
      return success;
    } catch (e) {
      debugPrint('Error adding pet: $e');
      return false;
    }
  }

  // Update an existing pet
  Future<bool> updatePet(String id, Pet updatedPet) async {
    try {
      final index = _pets.indexWhere((pet) => pet.id == id);
      if (index != -1) {
        updatedPet.id = id; // Keep the same ID
        _pets[index] = updatedPet;
        notifyListeners(); // Update UI immediately
        final success = await _savePets();
        return success;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating pet: $e');
      return false;
    }
  }

  // Delete a pet
  Future<bool> deletePet(String id) async {
    try {
      final index = _pets.indexWhere((pet) => pet.id == id);
      if (index != -1) {
        final removedPet = _pets.removeAt(index);
        final success = await _savePets();
        if (success) {
          notifyListeners();
        } else {
          _pets.insert(index, removedPet);
        }
        return success;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting pet: $e');
      return false;
    }
  }

  // Get pet by ID
  Pet? getPetById(String id) {
    try {
      return _pets.firstWhere((pet) => pet.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get pet by index
  Pet getPetByIndex(int index) {
    if (index >= 0 && index < _pets.length) {
      return _pets[index];
    }
    throw RangeError('Index out of bounds');
  }

  // Clear all pets
  Future<bool> clearPets() async {
    try {
      _pets.clear();
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.remove(_petsKey);
      if (success) {
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint('Error clearing pets: $e');
      return false;
    }
  }

  // Get total count
  int get petCount => _pets.length;

  // Check if pets list is empty
  bool get hasPets => _pets.isNotEmpty;
}


// // View_model/pet_provider.dart
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'home/Pet.dart';
//
// class PetProvider with ChangeNotifier {
//   List<Pet> _pets = [];
//
//   List<Pet> get pets => List.unmodifiable(_pets);
//
//   // Key for shared preferences
//   static const String _petsKey = 'saved_pets';
//
//   PetProvider() {
//     _init();
//   }
//
//   // Initialize and load pets
//   Future<void> _init() async {
//     await loadPets();
//   }
//
//   // Load pets from shared preferences
//   Future<void> loadPets() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final petsJson = prefs.getString(_petsKey);
//
//       if (petsJson != null && petsJson.isNotEmpty) {
//         final List<dynamic> petsList = json.decode(petsJson);
//         _pets = petsList.map((item) => Pet.fromMap(item)).toList();
//         notifyListeners();
//       }
//     } catch (e) {
//       debugPrint('Error loading pets: $e');
//       _pets = [];
//     }
//   }
//
//   // Save pets to shared preferences
//   Future<bool> _savePets() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final petsJson = json.encode(_pets.map((pet) => pet.toMap()).toList());
//       return await prefs.setString(_petsKey, petsJson);
//     } catch (e) {
//       debugPrint('Error saving pets: $e');
//       return false;
//     }
//   }
//
//   // Add a new pet
//   Future<bool> addPet(Pet pet) async {
//     try {
//       pet.generateId(); // Ensure pet has an ID
//       _pets.add(pet);
//       final success = await _savePets();
//       if (success) {
//         notifyListeners();
//       } else {
//         _pets.remove(pet);
//       }
//       return success;
//     } catch (e) {
//       debugPrint('Error adding pet: $e');
//       return false;
//     }
//   }
//
//   // Update an existing pet
//   Future<bool> updatePet(String id, Pet updatedPet) async {
//     try {
//       final index = _pets.indexWhere((pet) => pet.id == id);
//       if (index != -1) {
//         updatedPet.id = id; // Keep the same ID
//         _pets[index] = updatedPet;
//         final success = await _savePets();
//         if (success) {
//           notifyListeners();
//         }
//         return success;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('Error updating pet: $e');
//       return false;
//     }
//   }
//
//   // Delete a pet
//   Future<bool> deletePet(String id) async {
//     try {
//       final index = _pets.indexWhere((pet) => pet.id == id);
//       if (index != -1) {
//         final removedPet = _pets.removeAt(index);
//         final success = await _savePets();
//         if (success) {
//           notifyListeners();
//         } else {
//           _pets.insert(index, removedPet);
//         }
//         return success;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('Error deleting pet: $e');
//       return false;
//     }
//   }
//
//   // Get pet by ID
//   Pet? getPetById(String id) {
//     try {
//       return _pets.firstWhere((pet) => pet.id == id);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   // Get pet by index
//   Pet getPetByIndex(int index) {
//     if (index >= 0 && index < _pets.length) {
//       return _pets[index];
//     }
//     throw RangeError('Index out of bounds');
//   }
//
//   // Clear all pets
//   Future<bool> clearPets() async {
//     try {
//       _pets.clear();
//       final prefs = await SharedPreferences.getInstance();
//       final success = await prefs.remove(_petsKey);
//       if (success) {
//         notifyListeners();
//       }
//       return success;
//     } catch (e) {
//       debugPrint('Error clearing pets: $e');
//       return false;
//     }
//   }
//
//   // Get total count
//   int get petCount => _pets.length;
//
//   // Check if pets list is empty
//   bool get hasPets => _pets.isNotEmpty;
// }

// // View_model/pet_provider.dart
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'home/Pet.dart';
//
// class PetProvider with ChangeNotifier {
//   List<Pet> _pets = [];
//
//   List<Pet> get pets => List.unmodifiable(_pets);
//
//
//
//   // Key for shared preferences
//   static const String _petsKey = 'saved_pets';
//
//   String? _lastAddedPetId;
//   String? get lastAddedPetId => _lastAddedPetId;
//
//   void clearLastAddedPetId() {
//     _lastAddedPetId = null;
//   }
//
//   PetProvider() {
//     _init();
//   }
//
//   // Initialize and load pets
//   Future<void> _init() async {
//     await loadPets();
//   }
//
//   // Load pets from shared preferences
//   Future<void> loadPets() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getInt("USER_ID"); // Get user ID from session
//       if (userId == null) {
//         _pets = [];
//         notifyListeners();
//         return;
//       }
//
//       final key = '${_petsKey}_$userId';
//       final petsJson = prefs.getString(key);
//
//       if (petsJson != null && petsJson.isNotEmpty) {
//         final List<dynamic> petsList = json.decode(petsJson);
//         _pets = petsList.map((item) => Pet.fromMap(item)).toList();
//         notifyListeners();
//       } else {
//         _pets = [];
//         notifyListeners();
//       }
//     } catch (e) {
//       debugPrint('Error loading pets: $e');
//       _pets = [];
//     }
//   }
//
//   // Save pets to shared preferences
//   Future<bool> _savePets() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getInt("USER_ID");
//       if (userId == null) return false;
//
//       final key = '${_petsKey}_$userId';
//       final petsJson = json.encode(_pets.map((pet) => pet.toMap()).toList());
//       return await prefs.setString(key, petsJson);
//     } catch (e) {
//       debugPrint('Error saving pets: $e');
//       return false;
//     }
//   }
//
//   // Add a new pet
//   Future<bool> addPet(Pet pet) async {
//     try {
//       pet.generateId(); // Ensure pet has an ID
//       _pets.add(pet);
//       _lastAddedPetId = pet.id;
//       final success = await _savePets();
//       if (success) {
//         notifyListeners();
//       } else {
//         _pets.remove(pet);
//         _lastAddedPetId = null;
//       }
//       return success;
//     } catch (e) {
//       debugPrint('Error adding pet: $e');
//       return false;
//     }
//   }
//
//   // Update an existing pet
//   Future<bool> updatePet(String id, Pet updatedPet) async {
//     try {
//       final index = _pets.indexWhere((pet) => pet.id == id);
//       if (index != -1) {
//         updatedPet.id = id; // Keep the same ID
//         _pets[index] = updatedPet;
//         notifyListeners(); // Update UI immediately
//         final success = await _savePets();
//         return success;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('Error updating pet: $e');
//       return false;
//     }
//   }
//
//   // Delete a pet
//   Future<bool> deletePet(String id) async {
//     try {
//       final index = _pets.indexWhere((pet) => pet.id == id);
//       if (index != -1) {
//         final removedPet = _pets.removeAt(index);
//         final success = await _savePets();
//         if (success) {
//           notifyListeners();
//         } else {
//           _pets.insert(index, removedPet);
//         }
//         return success;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('Error deleting pet: $e');
//       return false;
//     }
//   }
//
//   // Get pet by ID
//   Pet? getPetById(String id) {
//     try {
//       return _pets.firstWhere((pet) => pet.id == id);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   // Get pet by index
//   Pet getPetByIndex(int index) {
//     if (index >= 0 && index < _pets.length) {
//       return _pets[index];
//     }
//     throw RangeError('Index out of bounds');
//   }
//
//   // Clear all pets
//   Future<bool> clearPets() async {
//     try {
//       _pets.clear();
//       final prefs = await SharedPreferences.getInstance();
//       final success = await prefs.remove(_petsKey);
//       if (success) {
//         notifyListeners();
//       }
//       return success;
//     } catch (e) {
//       debugPrint('Error clearing pets: $e');
//       return false;
//     }
//   }
//
//   // Get total count
//   int get petCount => _pets.length;
//
//   // Check if pets list is empty
//   bool get hasPets => _pets.isNotEmpty;
// }
//
//
