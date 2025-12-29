// lib/View_model/activity_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../activity_model.dart';

class ActivityNotifier extends ChangeNotifier {
  List<Activity> _activities = [];
  static const String _storageKey = 'dog_activities_list';

  List<Activity> get activities => List.unmodifiable(_activities);

  ActivityNotifier() {
    _loadActivities(); // Load saved activities on initialization
  }

  /// Load activities from SharedPreferences
  Future<void> _loadActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _activities = jsonList
            .map((json) => Activity.fromJson(json as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading activities: $e');
    }
  }

  /// Save activities to SharedPreferences
  Future<void> _saveActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _activities.map((activity) => activity.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      debugPrint('Error saving activities: $e');
    }
  }

  void addActivity(Activity activity) {
    _activities.add(activity);
    _saveActivities(); // Persist immediately
    notifyListeners();
  }

  void clear() {
    _activities.clear();
    _saveActivities();
    notifyListeners();
  }

// Optional: Add delete functionality later if needed
// void deleteActivity(Activity activity) {
//   _activities.remove(activity);
//   _saveActivities();
//   notifyListeners();
// }
}

// // lib/View_model/activity_provider.dart
// import 'package:flutter/foundation.dart';
// import '../activity_model.dart';
//
// class ActivityNotifier extends ChangeNotifier {
//   List<Activity> _activities = [];
//
//   List<Activity> get activities => List.unmodifiable(_activities);
//
//   void addActivity(Activity activity) {
//     _activities.add(activity);
//     notifyListeners();
//   }
//
//   void clear() {
//     _activities.clear();
//     notifyListeners();
//   }
// }
//
//
