
// scan_provider.dart
import 'package:flutter/material.dart';
import 'dart:io';

class ScanProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _recentScans = [];

  List<Map<String, dynamic>> get recentScans => _recentScans;

  void addScan(Map<String, dynamic> scan) {
    _recentScans.insert(0, scan);
    notifyListeners();
    print('📊 ScanProvider: Added scan. Total: ${_recentScans.length}');
  }

  void removeScan(int index) {
    _recentScans.removeAt(index);
    notifyListeners();
  }

  void clearScans() {
    _recentScans.clear();
    notifyListeners();
  }
}