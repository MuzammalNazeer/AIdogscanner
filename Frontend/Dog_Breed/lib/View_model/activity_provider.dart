// lib/View_model/activity_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../activity_model.dart';

class ActivityNotifier extends ChangeNotifier {
  List<Activity> _activities = [];
  static const String _storageKey = 'dog_activities_list';
  static const String _visibilityStorageKey = 'dog_activities_visibility';

  List<Activity> get activities => List.unmodifiable(_activities);
  Map<String, bool> _visibilitySettings = {};
  Map<String, bool> get visibilitySettings => Map.unmodifiable(_visibilitySettings);

  ActivityNotifier() {
    _loadActivities();
    _loadVisibilitySettings();
  }

  Future<void> _loadVisibilitySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_visibilityStorageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        _visibilitySettings = Map<String, bool>.from(jsonDecode(jsonString));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading visibility settings: $e');
    }
  }

  Future<void> toggleVisibility(String? petId, String activityName, bool isVisible) async {
    final key = "${petId ?? 'global'}_$activityName";
    _visibilitySettings[key] = isVisible;
    notifyListeners();
    await _saveVisibilitySettings();
  }

  Future<void> _saveVisibilitySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_visibilityStorageKey, jsonEncode(_visibilitySettings));
    } catch (e) {
      debugPrint('Error saving visibility settings: $e');
    }
  }

  bool isActivityVisible(String? petId, String name) {
    final key = "${petId ?? 'global'}_$name";
    return _visibilitySettings[key] ?? true;
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




// // lib/View_model/activity_provider.dart
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../activity_model.dart';
//
// class ActivityNotifier extends ChangeNotifier {
//   List<Activity> _activities = [];
//   static const String _storageKey = 'dog_activities_list';
//
//   List<Activity> get activities => List.unmodifiable(_activities);
//
//   ActivityNotifier() {
//     _loadActivities(); // Load saved activities on initialization
//   }
//
//   /// Load activities from SharedPreferences
//   Future<void> _loadActivities() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final jsonString = prefs.getString(_storageKey);
//
//       if (jsonString != null && jsonString.isNotEmpty) {
//         final List<dynamic> jsonList = jsonDecode(jsonString);
//         _activities = jsonList
//             .map((json) => Activity.fromJson(json as Map<String, dynamic>))
//             .toList();
//         notifyListeners();
//       }
//     } catch (e) {
//       debugPrint('Error loading activities: $e');
//     }
//   }
//
//   /// Save activities to SharedPreferences
//   Future<void> _saveActivities() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final jsonList = _activities.map((activity) => activity.toJson()).toList();
//       final jsonString = jsonEncode(jsonList);
//       await prefs.setString(_storageKey, jsonString);
//     } catch (e) {
//       debugPrint('Error saving activities: $e');
//     }
//   }
//   void removeActivity(Activity activity) {
//     _activities.remove(activity);
//     notifyListeners();
//   }
//   void addActivity(Activity activity) {
//     _activities.add(activity);
//     _saveActivities(); // Persist immediately
//     notifyListeners();
//   }
//
//   void clear() {
//     _activities.clear();
//     _saveActivities();
//     notifyListeners();
//   }
//
// // Optional: Add delete functionality later if needed
// // void deleteActivity(Activity activity) {
// //   _activities.remove(activity);
// //   _saveActivities();
// //   notifyListeners();
// // }
// }
//
// // // lib/View_model/activity_provider.dart
// // import 'package:flutter/foundation.dart';
// // import '../activity_model.dart';
// //
// // class ActivityNotifier extends ChangeNotifier {
// //   List<Activity> _activities = [];
// //
// //   List<Activity> get activities => List.unmodifiable(_activities);
// //
// //   void addActivity(Activity activity) {
// //     _activities.add(activity);
// //     notifyListeners();
// //   }
// //
// //   void clear() {
// //     _activities.clear();
// //     notifyListeners();
// //   }
// // }
// //
// //
