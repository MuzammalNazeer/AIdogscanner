import 'dart:convert';
import 'dart:typed_data';
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

  // Initialize method - call this in main.dart
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
          print('Error encoding image to base64: $e');
          scanData['imageBytes'] = null;
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

    } catch (e) {
      print('Error in addScan: $e');
    }
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
      print('Error in toggleScanFavorite: $e');
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
      print('Error in toggleBreedFavorite: $e');
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
    } catch (e) {
      print('Error in removeScan: $e');
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
      print('Error in clearAllFavorites: $e');
    }
  }

  Future<void> clearAllScans() async {
    try {
      _recentScans.clear();
      await _saveData();
      notifyListeners();
    } catch (e) {
      print('Error in clearAllScans: $e');
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
        print('Failed to decode image in parseImageData: $e');
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

        // Handle image bytes - ensure it's base64 string
        if (scanCopy['imageBytes'] is Uint8List) {
          try {
            scanCopy['imageBytes'] = base64.encode(scanCopy['imageBytes']);
          } catch (e) {
            scanCopy['imageBytes'] = null;
          }
        }

        return scanCopy;
      }).toList();

      final scansJson = json.encode(serializableScans);
      await prefs.setString(_recentScansKey, scansJson);

      // Save favorite breeds
      final breedsList = _favoriteBreeds.toList();
      final breedsJson = json.encode(breedsList);
      await prefs.setString(_favoriteBreedsKey, breedsJson);

      print('✅ Data saved. Scans: ${_recentScans.length}');

    } catch (e) {
      print('❌ Error saving data: $e');
    }
  }

  // Load all data from shared preferences
  Future<void> _loadData() async {
    try {
      print('📥 Loading data from SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();

      // Load recent scans
      final scansJson = prefs.getString(_recentScansKey);
      if (scansJson != null && scansJson.isNotEmpty) {
        final List<dynamic> loadedScans = json.decode(scansJson);
        _recentScans = loadedScans.map((item) {
          try {
            return Map<String, dynamic>.from(item);
          } catch (e) {
            print('Error parsing scan item: $e');
            return <String, dynamic>{};
          }
        }).where((scan) => scan.isNotEmpty).toList();
        print('✅ Loaded ${_recentScans.length} scans from storage');
      } else {
        print('ℹ️ No scans found in storage');
      }

      // Load favorite breeds
      final breedsJson = prefs.getString(_favoriteBreedsKey);
      if (breedsJson != null && breedsJson.isNotEmpty) {
        final List<dynamic> loadedBreeds = json.decode(breedsJson);
        _favoriteBreeds = Set<String>.from(loadedBreeds);
        print('✅ Loaded ${_favoriteBreeds.length} favorite breeds');
      }

      notifyListeners();

    } catch (e, stackTrace) {
      print('❌ Error loading data: $e');
      print('Stack trace: $stackTrace');
      _recentScans = [];
      _favoriteBreeds = {};
    }
  }
}

// // View_model/ScanProvider.dart
// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
//
// class ScanProvider with ChangeNotifier {
//   final List<Map<String, dynamic>> _recentScans = [];
//   final Set<String> _favoriteBreeds = {}; // Store favorite breed names
//   final Map<String, bool> _favoriteScans = {}; // Store favorite scan IDs/timestamps
//
//   List<Map<String, dynamic>> get recentScans => _recentScans;
//   Set<String> get favoriteBreeds => _favoriteBreeds;
//   List<Map<String, dynamic>> get favoriteScans =>
//       _recentScans.where((scan) => scan['isFavorite'] == true).toList();
//
//   void addScan(Map<String, dynamic> scanData) {
//     // Add a unique ID if not present
//     if (!scanData.containsKey('id')) {
//       scanData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
//     }
//
//     // Initialize isFavorite if not present
//     if (!scanData.containsKey('isFavorite')) {
//       scanData['isFavorite'] = false;
//     }
//
//     _recentScans.add(scanData);
//
//     // Keep only last 50 scans to prevent memory issues
//     if (_recentScans.length > 50) {
//       _recentScans.removeAt(0);
//     }
//
//     notifyListeners();
//   }
//
//   void toggleScanFavorite(String scanId) {
//     final index = _recentScans.indexWhere((scan) => scan['id'] == scanId);
//     if (index != -1) {
//       _recentScans[index]['isFavorite'] = !(_recentScans[index]['isFavorite'] ?? false);
//       notifyListeners();
//     }
//   }
//
//   void toggleBreedFavorite(String breedName) {
//     if (_favoriteBreeds.contains(breedName)) {
//       _favoriteBreeds.remove(breedName);
//     } else {
//       _favoriteBreeds.add(breedName);
//     }
//     notifyListeners();
//   }
//
//   bool isBreedFavorite(String breedName) {
//     return _favoriteBreeds.contains(breedName);
//   }
//
//   bool isScanFavorite(String scanId) {
//     final scan = _recentScans.firstWhere(
//           (scan) => scan['id'] == scanId,
//       orElse: () => {},
//     );
//     return scan['isFavorite'] == true;
//   }
//
//   void removeScan(String scanId) {
//     _recentScans.removeWhere((scan) => scan['id'] == scanId);
//     notifyListeners();
//   }
//
//   void clearAllFavorites() {
//     // Clear favorite scans
//     for (var scan in _recentScans) {
//       scan['isFavorite'] = false;
//     }
//     // Clear favorite breeds
//     _favoriteBreeds.clear();
//     notifyListeners();
//   }
//
//
//   // In your ScanProvider class, add this method:
//   Uint8List? _parseImageData(dynamic imageData) {
//     if (imageData == null) return null;
//
//     if (imageData is Uint8List) {
//       return imageData;
//     } else if (imageData is String) {
//       try {
//         String base64String = imageData;
//
//         if (imageData.contains('base64,')) {
//           final parts = imageData.split('base64,');
//           if (parts.length > 1) {
//             base64String = parts[1];
//           }
//         }
//
//         return base64.decode(base64String);
//       } catch (e) {
//         print('Failed to decode image in ScanProvider: $e');
//         return null;
//       }
//     }
//     return null;
//   }
//
// }
//
