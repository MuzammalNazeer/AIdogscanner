import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanProvider with ChangeNotifier {
  List<Map<String, dynamic>> _recentScans = [];
  Set<String> _favoriteBreeds = {};

  // Keys for shared preferences
  static const String _recentScansKey = 'recent_scans';
  static const String _favoriteBreedsKey = 'favorite_breeds';

  ScanProvider() {
    _loadData();
  }

  List<Map<String, dynamic>> get recentScans => List.from(_recentScans);
  Set<String> get favoriteBreeds => Set.from(_favoriteBreeds);

  List<Map<String, dynamic>> get favoriteScans =>
      _recentScans.where((scan) => scan['isFavorite'] == true).toList();

  Future<void> initialize() async {
    await _loadData();
  }

  Future<void> addScan(Map<String, dynamic> scanData) async {
    try {
      // Add a unique ID if not present
      if (!scanData.containsKey('id') || scanData['id'] == null) {
        scanData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      }

      // Add timestamp if not present
      if (!scanData.containsKey('timestamp') || scanData['timestamp'] == null) {
        scanData['timestamp'] = DateTime.now().toIso8601String();
      }

      // Initialize isFavorite if not present
      if (!scanData.containsKey('isFavorite')) {
        scanData['isFavorite'] = false;
      }

      // Convert Uint8List image to base64 string for storage
      if (scanData['imageBytes'] is Uint8List) {
        scanData = Map<String, dynamic>.from(scanData);
        try {
          scanData['imageBytes'] = base64.encode(scanData['imageBytes']);
        } catch (e) {
          if (kDebugMode) {
            print('Error encoding image to base64: $e');
          }
          scanData['imageBytes'] = null;
        }
      }

      // Ensure all nested maps are properly serializable
      scanData = _ensureSerializable(scanData);

      // Debug: Print what we're saving
      if (kDebugMode) {
        print('📝 Saving scan with data:');
        print('   Breed: ${scanData['breedName']}');
        print('   Has characteristics: ${scanData.containsKey('characteristics')}');
        if (scanData.containsKey('characteristics')) {
          final chars = scanData['characteristics'];
          print('   Characteristics type: ${chars.runtimeType}');
          if (chars is Map) {
            print('   Characteristics keys: ${chars.keys.toList()}');
          }
        }
      }

      // Remove any existing scan with same ID
      _recentScans.removeWhere((scan) => scan['id'] == scanData['id']);

      // Add to beginning (newest first)
      _recentScans.insert(0, scanData);

      // Keep only last 50 scans
      if (_recentScans.length > 50) {
        _recentScans = _recentScans.sublist(0, 50);
      }

      await _saveData();
      notifyListeners();

      if (kDebugMode) {
        print('✅ Scan saved successfully. Total scans: ${_recentScans.length}');
      }

    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error in addScan: $e');
        print('Stack trace: $stackTrace');
      }
    }
  }

  // Helper to ensure all data is JSON serializable
  Map<String, dynamic> _ensureSerializable(Map<String, dynamic> data) {
    final result = <String, dynamic>{};

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is Map<String, dynamic>) {
        // Recursively process nested maps
        result[key] = _ensureSerializable(value);
      } else if (value is Map) {
        // Convert generic Map to Map<String, dynamic>
        final Map<String, dynamic> convertedMap = {};
        for (final innerEntry in value.entries) {
          final innerKey = innerEntry.key.toString();
          final innerValue = innerEntry.value;

          if (innerValue is Map) {
            convertedMap[innerKey] = _ensureSerializable(
                Map<String, dynamic>.from(innerValue)
            );
          } else {
            convertedMap[innerKey] = innerValue;
          }
        }
        result[key] = convertedMap;
      } else if (value is Uint8List) {
        // Convert Uint8List to base64 string
        result[key] = base64.encode(value);
      } else if (value is DateTime) {
        // Convert DateTime to ISO string
        result[key] = value.toIso8601String();
      } else {
        // Keep other types as-is (String, num, bool, null)
        result[key] = value;
      }
    }

    return result;
  }

  Future<void> toggleScanFavorite(String scanId) async {
    try {
      final index = _recentScans.indexWhere((scan) => scan['id'] == scanId);
      if (index != -1) {
        _recentScans[index]['isFavorite'] = !(_recentScans[index]['isFavorite'] ?? false);
        await _saveData();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in toggleScanFavorite: $e');
      }
    }
  }

  Future<void> toggleBreedFavorite(String breedName) async {
    try {
      if (_favoriteBreeds.contains(breedName)) {
        _favoriteBreeds.remove(breedName);
      } else {
        _favoriteBreeds.add(breedName);
      }
      await _saveData();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error in toggleBreedFavorite: $e');
      }
    }
  }

  bool isBreedFavorite(String breedName) {
    return _favoriteBreeds.contains(breedName);
  }

  bool isScanFavorite(String scanId) {
    try {
      final scan = _recentScans.firstWhere(
            (scan) => scan['id'] == scanId,
        orElse: () => {},
      );
      return scan['isFavorite'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeScan(String scanId) async {
    try {
      _recentScans.removeWhere((scan) => scan['id'] == scanId);
      await _saveData();
      notifyListeners();
      if (kDebugMode) {
        print('🗑️ Scan removed: $scanId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in removeScan: $e');
      }
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      // Clear favorite scans
      for (var scan in _recentScans) {
        scan['isFavorite'] = false;
      }
      // Clear favorite breeds
      _favoriteBreeds.clear();
      await _saveData();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error in clearAllFavorites: $e');
      }
    }
  }

  Future<void> clearAllScans() async {
    try {
      _recentScans.clear();
      await _saveData();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error in clearAllScans: $e');
      }
    }
  }

  Uint8List? parseImageData(dynamic imageData) {
    if (imageData == null) return null;

    if (imageData is Uint8List) {
      return imageData;
    } else if (imageData is String && imageData.isNotEmpty) {
      try {
        String base64String = imageData;

        // Handle data URL format
        if (imageData.contains('base64,')) {
          final parts = imageData.split('base64,');
          if (parts.length > 1) {
            base64String = parts[1];
          }
        }

        // Decode base64
        final decoded = base64.decode(base64String);
        return decoded;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to decode image in parseImageData: $e');
        }
        return null;
      }
    }
    return null;
  }

  // Save all data to shared preferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert scans to JSON-serializable format
      final List<Map<String, dynamic>> serializableScans = _recentScans.map((scan) {
        final Map<String, dynamic> scanCopy = Map<String, dynamic>.from(scan);

        // Ensure all nested data is serializable
        return _ensureSerializable(scanCopy);
      }).toList();

      final scansJson = json.encode(serializableScans);
      await prefs.setString(_recentScansKey, scansJson);

      // Save favorite breeds
      final breedsList = _favoriteBreeds.toList();
      final breedsJson = json.encode(breedsList);
      await prefs.setString(_favoriteBreedsKey, breedsJson);

      if (kDebugMode) {
        print('✅ Data saved. Scans: ${_recentScans.length}');
      }

    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error saving data: $e');
        print('Stack trace: $stackTrace');
      }
    }
  }

  // Load all data from shared preferences
  Future<void> _loadData() async {
    try {
      if (kDebugMode) {
        print('📥 Loading data from SharedPreferences...');
      }
      final prefs = await SharedPreferences.getInstance();

      // Load recent scans
      final scansJson = prefs.getString(_recentScansKey);
      if (scansJson != null && scansJson.isNotEmpty) {
        try {
          final List<dynamic> loadedScans = json.decode(scansJson);
          _recentScans = loadedScans.map((item) {
            try {
              return Map<String, dynamic>.from(item);
            } catch (e) {
              if (kDebugMode) {
                print('Error parsing scan item: $e');
              }
              return <String, dynamic>{};
            }
          }).where((scan) => scan.isNotEmpty).toList();

          if (kDebugMode) {
            print('✅ Loaded ${_recentScans.length} scans from storage');
            if (_recentScans.isNotEmpty) {
              print('🔍 First scan sample data:');
              final firstScan = _recentScans.first;
              print('   ID: ${firstScan['id']}');
              print('   Breed: ${firstScan['breedName']}');
              print('   Has characteristics: ${firstScan.containsKey('characteristics')}');
              if (firstScan.containsKey('characteristics')) {
                final chars = firstScan['characteristics'];
                if (chars is Map) {
                  print('   Characteristics keys: ${chars.keys.toList()}');
                }
              }
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ Error parsing scans JSON: $e');
          }
          _recentScans = [];
        }
      } else {
        if (kDebugMode) {
          print('ℹ️ No scans found in storage');
        }
      }

      // Load favorite breeds
      final breedsJson = prefs.getString(_favoriteBreedsKey);
      if (breedsJson != null && breedsJson.isNotEmpty) {
        try {
          final List<dynamic> loadedBreeds = json.decode(breedsJson);
          _favoriteBreeds = Set<String>.from(loadedBreeds);
          if (kDebugMode) {
            print('✅ Loaded ${_favoriteBreeds.length} favorite breeds');
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ Error parsing breeds JSON: $e');
          }
          _favoriteBreeds = {};
        }
      }

      notifyListeners();

    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error loading data: $e');
        print('Stack trace: $stackTrace');
      }
      _recentScans = [];
      _favoriteBreeds = {};
    }
  }

  // Helper method to debug scan data
  void debugPrintScans() {
    if (kDebugMode) {
      print('🔍 Debug - All Scans (${_recentScans.length}):');
      for (var i = 0; i < _recentScans.length; i++) {
        final scan = _recentScans[i];
        print('   Scan ${i + 1}:');
        print('     ID: ${scan['id']}');
        print('     Breed: ${scan['breedName']}');
        print('     Confidence: ${scan['confidence']}');
        print('     Has image: ${scan['imageBytes'] != null}');
        print('     Has characteristics: ${scan.containsKey('characteristics')}');
        if (scan.containsKey('characteristics')) {
          final chars = scan['characteristics'];
          if (chars is Map) {
            print('     Characteristics: ${chars.keys.toList()}');
          }
        }
        print('     ---');
      }
    }
  }
}






// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ScanProvider with ChangeNotifier {
//   List<Map<String, dynamic>> _recentScans = [];
//   Set<String> _favoriteBreeds = {};
//
//   // Keys for shared preferences
//   static const String _recentScansKey = 'recent_scans';
//   static const String _favoriteBreedsKey = 'favorite_breeds';
//
//   ScanProvider() {
//     _loadData();
//   }
//
//   List<Map<String, dynamic>> get recentScans => List.from(_recentScans);
//   Set<String> get favoriteBreeds => Set.from(_favoriteBreeds);
//
//   List<Map<String, dynamic>> get favoriteScans =>
//       _recentScans.where((scan) => scan['isFavorite'] == true).toList();
//
//   // Initialize method - call this in main.dart
//   Future<void> initialize() async {
//     await _loadData();
//   }
//
//   Future<void> addScan(Map<String, dynamic> scanData) async {
//     try {
//       // Add a unique ID if not present
//       if (!scanData.containsKey('id') || scanData['id'] == null) {
//         scanData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
//       }
//
//       // Add timestamp if not present
//       if (!scanData.containsKey('timestamp') || scanData['timestamp'] == null) {
//         scanData['timestamp'] = DateTime.now().toIso8601String();
//       }
//
//       // Initialize isFavorite if not present
//       if (!scanData.containsKey('isFavorite')) {
//         scanData['isFavorite'] = false;
//       }
//
//       // Convert Uint8List image to base64 string for storage
//       if (scanData['imageBytes'] is Uint8List) {
//         scanData = Map<String, dynamic>.from(scanData);
//         try {
//           scanData['imageBytes'] = base64.encode(scanData['imageBytes']);
//         } catch (e) {
//           print('Error encoding image to base64: $e');
//           scanData['imageBytes'] = null;
//         }
//       }
//
//       // Remove any existing scan with same ID
//       _recentScans.removeWhere((scan) => scan['id'] == scanData['id']);
//
//       // Add to beginning (newest first)
//       _recentScans.insert(0, scanData);
//
//       // Keep only last 50 scans
//       if (_recentScans.length > 50) {
//         _recentScans = _recentScans.sublist(0, 50);
//       }
//
//       await _saveData();
//       notifyListeners();
//
//     } catch (e) {
//       print('Error in addScan: $e');
//     }
//   }
//
//   Future<void> toggleScanFavorite(String scanId) async {
//     try {
//       final index = _recentScans.indexWhere((scan) => scan['id'] == scanId);
//       if (index != -1) {
//         _recentScans[index]['isFavorite'] = !(_recentScans[index]['isFavorite'] ?? false);
//         await _saveData();
//         notifyListeners();
//       }
//     } catch (e) {
//       print('Error in toggleScanFavorite: $e');
//     }
//   }
//
//   Future<void> toggleBreedFavorite(String breedName) async {
//     try {
//       if (_favoriteBreeds.contains(breedName)) {
//         _favoriteBreeds.remove(breedName);
//       } else {
//         _favoriteBreeds.add(breedName);
//       }
//       await _saveData();
//       notifyListeners();
//     } catch (e) {
//       print('Error in toggleBreedFavorite: $e');
//     }
//   }
//
//   bool isBreedFavorite(String breedName) {
//     return _favoriteBreeds.contains(breedName);
//   }
//
//   bool isScanFavorite(String scanId) {
//     try {
//       final scan = _recentScans.firstWhere(
//             (scan) => scan['id'] == scanId,
//         orElse: () => {},
//       );
//       return scan['isFavorite'] == true;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   Future<void> removeScan(String scanId) async {
//     try {
//       _recentScans.removeWhere((scan) => scan['id'] == scanId);
//       await _saveData();
//       notifyListeners();
//     } catch (e) {
//       print('Error in removeScan: $e');
//     }
//   }
//
//   Future<void> clearAllFavorites() async {
//     try {
//       // Clear favorite scans
//       for (var scan in _recentScans) {
//         scan['isFavorite'] = false;
//       }
//       // Clear favorite breeds
//       _favoriteBreeds.clear();
//       await _saveData();
//       notifyListeners();
//     } catch (e) {
//       print('Error in clearAllFavorites: $e');
//     }
//   }
//
//   Future<void> clearAllScans() async {
//     try {
//       _recentScans.clear();
//       await _saveData();
//       notifyListeners();
//     } catch (e) {
//       print('Error in clearAllScans: $e');
//     }
//   }
//
//   Uint8List? parseImageData(dynamic imageData) {
//     if (imageData == null) return null;
//
//     if (imageData is Uint8List) {
//       return imageData;
//     } else if (imageData is String && imageData.isNotEmpty) {
//       try {
//         String base64String = imageData;
//
//         // Handle data URL format
//         if (imageData.contains('base64,')) {
//           final parts = imageData.split('base64,');
//           if (parts.length > 1) {
//             base64String = parts[1];
//           }
//         }
//
//         // Decode base64
//         final decoded = base64.decode(base64String);
//         return decoded;
//       } catch (e) {
//         print('Failed to decode image in parseImageData: $e');
//         return null;
//       }
//     }
//     return null;
//   }
//
//   // Save all data to shared preferences
//   Future<void> _saveData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//
//       // Convert scans to JSON-serializable format
//       final List<Map<String, dynamic>> serializableScans = _recentScans.map((scan) {
//         final Map<String, dynamic> scanCopy = Map<String, dynamic>.from(scan);
//
//         // Handle image bytes - ensure it's base64 string
//         if (scanCopy['imageBytes'] is Uint8List) {
//           try {
//             scanCopy['imageBytes'] = base64.encode(scanCopy['imageBytes']);
//           } catch (e) {
//             scanCopy['imageBytes'] = null;
//           }
//         }
//
//         return scanCopy;
//       }).toList();
//
//       final scansJson = json.encode(serializableScans);
//       await prefs.setString(_recentScansKey, scansJson);
//
//       // Save favorite breeds
//       final breedsList = _favoriteBreeds.toList();
//       final breedsJson = json.encode(breedsList);
//       await prefs.setString(_favoriteBreedsKey, breedsJson);
//
//       print('✅ Data saved. Scans: ${_recentScans.length}');
//
//     } catch (e) {
//       print('❌ Error saving data: $e');
//     }
//   }
//
//   // Load all data from shared preferences
//   Future<void> _loadData() async {
//     try {
//       print('📥 Loading data from SharedPreferences...');
//       final prefs = await SharedPreferences.getInstance();
//
//       // Load recent scans
//       final scansJson = prefs.getString(_recentScansKey);
//       if (scansJson != null && scansJson.isNotEmpty) {
//         final List<dynamic> loadedScans = json.decode(scansJson);
//         _recentScans = loadedScans.map((item) {
//           try {
//             return Map<String, dynamic>.from(item);
//           } catch (e) {
//             print('Error parsing scan item: $e');
//             return <String, dynamic>{};
//           }
//         }).where((scan) => scan.isNotEmpty).toList();
//         print('✅ Loaded ${_recentScans.length} scans from storage');
//       } else {
//         print('ℹ️ No scans found in storage');
//       }
//
//       // Load favorite breeds
//       final breedsJson = prefs.getString(_favoriteBreedsKey);
//       if (breedsJson != null && breedsJson.isNotEmpty) {
//         final List<dynamic> loadedBreeds = json.decode(breedsJson);
//         _favoriteBreeds = Set<String>.from(loadedBreeds);
//         print('✅ Loaded ${_favoriteBreeds.length} favorite breeds');
//       }
//
//       notifyListeners();
//
//     } catch (e, stackTrace) {
//       print('❌ Error loading data: $e');
//       print('Stack trace: $stackTrace');
//       _recentScans = [];
//       _favoriteBreeds = {};
//     }
//   }
// }
