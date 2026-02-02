import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../activity_model.dart';

class ActivityNotifier extends ChangeNotifier {
  List<Activity> _activities = [];
  static const String _storageKey = 'dog_activities_list';

  List<Activity> get activities => List.unmodifiable(_activities);

  ActivityNotifier() {
    _loadActivities();
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


  void updateActivity(Activity updatedActivity) {
    final index = _activities.indexWhere((activity) =>
    activity.dateTime == updatedActivity.dateTime &&
        activity.name == updatedActivity.name
    );

    if (index != -1) {
      _activities[index] = updatedActivity;
      _saveActivities();
      notifyListeners();
    } else {
      // If not found, add it
      _activities.add(updatedActivity);
      _saveActivities();
      notifyListeners();
    }
  }

  // Other methods you might have:
  void addActivity(Activity activity) {
    _activities.add(activity);
    _saveActivities();
    notifyListeners();
  }

  void deleteActivitiesByName(String name) {
    _activities.removeWhere((activity) => activity.name == name);
    _saveActivities();
    notifyListeners();
  }

  void deleteActivitiesForPet(String petId) {
    _activities.removeWhere((activity) => activity.petId == petId);
    _saveActivities();
    notifyListeners();
  }

  void deleteActivity(Activity activityToDelete) {
    _activities.removeWhere((activity) =>
    activity.dateTime == activityToDelete.dateTime &&
        activity.name == activityToDelete.name
    );
    _saveActivities();
    notifyListeners();
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
  void removeActivity(Activity activity) {
    _activities.remove(activity);
    notifyListeners();
  }
  // void addActivity(Activity activity) {
  //   _activities.add(activity);
  //   _saveActivities(); // Persist immediately
  //   notifyListeners();
  // }

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
