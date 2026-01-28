// services/activity_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ActivityConstants.dart';

class ActivityService {
  static const String _activitiesKey = 'activities';

  // Default activities derived from ActivityConstants
  static final List<Map<String, dynamic>> _defaultActivities = ActivityConstants.allActivities
      .map((activity) => {
    'title': activity.name,
    'icon': activity.image,
    'enabled': true,
  })
      .toList();

  // Save activities to SharedPreferences
  static Future<void> saveActivities(List<Map<String, dynamic>> activities) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(activities);
      await prefs.setString(_activitiesKey, jsonString);
    } catch (e) {
      print('Error saving activities: $e');
    }
  }

  // Load activities from SharedPreferences
  static Future<List<Map<String, dynamic>>> loadActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_activitiesKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading activities: $e');
      }
    }

    // Return default activities if nothing is saved
    return List.from(_defaultActivities);
  }

  // Add new activity
  static Future<void> addActivity(Map<String, dynamic> newActivity) async {
    final activities = await loadActivities();
    activities.add(newActivity);
    await saveActivities(activities);
  }

  // Delete activity by title
  static Future<void> deleteActivity(String title) async {
    final activities = await loadActivities();
    activities.removeWhere((activity) => activity['title'] == title);
    await saveActivities(activities);
  }

  // Update activity state
  static Future<void> updateActivityState(String title, bool enabled) async {
    final activities = await loadActivities();
    final index = activities.indexWhere((activity) => activity['title'] == title);
    if (index != -1) {
      activities[index]['enabled'] = enabled;
      await saveActivities(activities);
    }
  }

  // Update activity order
  static Future<void> updateActivityOrder(List<Map<String, dynamic>> activities) async {
    await saveActivities(activities);
  }
}

// // services/activity_service.dart
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ActivityService {
//   static const String _activitiesKey = 'activities';
//
//   // Default activities
//   static final List<Map<String, dynamic>> _defaultActivities = [
//     {'title': 'Eat', 'icon': 'assets/images/61.png', 'enabled': true},
//     {'title': 'Pee', 'icon': 'assets/images/62.png', 'enabled': true},
//     {'title': 'Drink', 'icon': 'assets/images/63.png', 'enabled': true},
//     {'title': 'Poop', 'icon': 'assets/images/66.png', 'enabled': true},
//     {'title': 'Walk', 'icon': 'assets/images/65.png', 'enabled': true},
//     {'title': 'Play', 'icon': 'assets/images/65.png', 'enabled': true},
//     {'title': 'Crate', 'icon': 'assets/images/68.png', 'enabled': true},
//     {'title': 'Sleep', 'icon': 'assets/images/69.png', 'enabled': true},
//     {'title': 'Training', 'icon': 'assets/images/70.png', 'enabled': true},
//     {'title': 'Treat', 'icon': 'assets/images/71.png', 'enabled': true},
//     {'title': 'Grooming', 'icon': 'assets/images/72.png', 'enabled': true},
//     {'title': 'Bathing', 'icon': 'assets/images/73.png', 'enabled': true},
//     {'title': 'Medication', 'icon': 'assets/images/74.png', 'enabled': true},
//     {'title': 'Vaccination', 'icon': 'assets/images/75.png', 'enabled': true},
//     {'title': 'Weight', 'icon': 'assets/images/77.png', 'enabled': true},
//     {'title': 'Temperature', 'icon': 'assets/images/78.png', 'enabled': true},
//     {'title': 'Health Condition', 'icon': 'assets/images/79.png', 'enabled': true},
//     {'title': 'Accident', 'icon': 'assets/images/80.png', 'enabled': true},
//     {'title': 'Journal', 'icon': 'assets/images/81.png', 'enabled': true},
//   ];
//
//   // Save activities to SharedPreferences
//   static Future<void> saveActivities(List<Map<String, dynamic>> activities) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final jsonString = jsonEncode(activities);
//       await prefs.setString(_activitiesKey, jsonString);
//     } catch (e) {
//       print('Error saving activities: $e');
//     }
//   }
//
//   // Load activities from SharedPreferences
//   static Future<List<Map<String, dynamic>>> loadActivities() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final jsonString = prefs.getString(_activitiesKey);
//
//       if (jsonString != null && jsonString.isNotEmpty) {
//         final List<dynamic> jsonList = jsonDecode(jsonString);
//         return jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
//       }
//     } catch (e) {
//       print('Error loading activities: $e');
//     }
//
//     // Return default activities if nothing is saved
//     return List.from(_defaultActivities);
//   }
//
//   // Add new activity
//   static Future<void> addActivity(Map<String, dynamic> newActivity) async {
//     final activities = await loadActivities();
//     activities.add(newActivity);
//     await saveActivities(activities);
//   }
//
//   // Delete activity by title
//   static Future<void> deleteActivity(String title) async {
//     final activities = await loadActivities();
//     activities.removeWhere((activity) => activity['title'] == title);
//     await saveActivities(activities);
//   }
//
//   // Update activity state
//   static Future<void> updateActivityState(String title, bool enabled) async {
//     final activities = await loadActivities();
//     final index = activities.indexWhere((activity) => activity['title'] == title);
//     if (index != -1) {
//       activities[index]['enabled'] = enabled;
//       await saveActivities(activities);
//     }
//   }
//
//   // Update activity order
//   static Future<void> updateActivityOrder(List<Map<String, dynamic>> activities) async {
//     await saveActivities(activities);
//   }
// }