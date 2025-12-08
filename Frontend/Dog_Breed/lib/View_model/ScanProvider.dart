// View_model/ScanProvider.dart
import 'package:flutter/foundation.dart';

class ScanProvider with ChangeNotifier {
  List<Map<String, dynamic>> _recentScans = [];
  Set<String> _favoriteBreeds = {}; // Store favorite breed names
  Map<String, bool> _favoriteScans = {}; // Store favorite scan IDs/timestamps

  List<Map<String, dynamic>> get recentScans => _recentScans;
  Set<String> get favoriteBreeds => _favoriteBreeds;
  List<Map<String, dynamic>> get favoriteScans =>
      _recentScans.where((scan) => scan['isFavorite'] == true).toList();

  void addScan(Map<String, dynamic> scanData) {
    // Add a unique ID if not present
    if (!scanData.containsKey('id')) {
      scanData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }

    // Initialize isFavorite if not present
    if (!scanData.containsKey('isFavorite')) {
      scanData['isFavorite'] = false;
    }

    _recentScans.add(scanData);

    // Keep only last 50 scans to prevent memory issues
    if (_recentScans.length > 50) {
      _recentScans.removeAt(0);
    }

    notifyListeners();
  }

  void toggleScanFavorite(String scanId) {
    final index = _recentScans.indexWhere((scan) => scan['id'] == scanId);
    if (index != -1) {
      _recentScans[index]['isFavorite'] = !(_recentScans[index]['isFavorite'] ?? false);
      notifyListeners();
    }
  }

  void toggleBreedFavorite(String breedName) {
    if (_favoriteBreeds.contains(breedName)) {
      _favoriteBreeds.remove(breedName);
    } else {
      _favoriteBreeds.add(breedName);
    }
    notifyListeners();
  }

  bool isBreedFavorite(String breedName) {
    return _favoriteBreeds.contains(breedName);
  }

  bool isScanFavorite(String scanId) {
    final scan = _recentScans.firstWhere(
          (scan) => scan['id'] == scanId,
      orElse: () => {},
    );
    return scan['isFavorite'] == true;
  }

  void removeScan(String scanId) {
    _recentScans.removeWhere((scan) => scan['id'] == scanId);
    notifyListeners();
  }

  void clearAllFavorites() {
    // Clear favorite scans
    for (var scan in _recentScans) {
      scan['isFavorite'] = false;
    }
    // Clear favorite breeds
    _favoriteBreeds.clear();
    notifyListeners();
  }
}

//
// // scan_provider.dart
// import 'package:flutter/material.dart';
// import 'dart:io';
//
// class ScanProvider extends ChangeNotifier {
//   final List<Map<String, dynamic>> _recentScans = [];
//
//   List<Map<String, dynamic>> get recentScans => _recentScans;
//
//   void addScan(Map<String, dynamic> scan) {
//     _recentScans.insert(0, scan);
//     notifyListeners();
//     print('📊 ScanProvider: Added scan. Total: ${_recentScans.length}');
//   }
//
//   void removeScan(int index) {
//     _recentScans.removeAt(index);
//     notifyListeners();
//   }
//
//   void clearScans() {
//     _recentScans.clear();
//     notifyListeners();
//   }
// }