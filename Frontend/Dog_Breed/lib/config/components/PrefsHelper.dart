// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class PrefsHelper {
//   static const String recentScansKey = "recent_scans";
//
//   /// Save the entire list
//   static Future<void> saveRecentScans(List<Map<String, dynamic>> scans) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> encodedList = scans.map((scan) => jsonEncode(scan)).toList();
//     await prefs.setStringList(recentScansKey, encodedList);
//   }
//
//   /// Load the list
//   static Future<List<Map<String, dynamic>>?> loadRecentScans() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? savedList = prefs.getStringList(recentScansKey);
//
//     if (savedList == null) return [];
//
//     return savedList.map((item) => jsonDecode(item)).toList();
//   }
// }
