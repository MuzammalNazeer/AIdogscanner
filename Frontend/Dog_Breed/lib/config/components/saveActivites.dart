import 'package:flutter/material.dart';

class ActivityLog {
  final String activityName;
  final String activityImagePath;
  final Color activityColor;
  final String food;
  final DateTime date;
  final TimeOfDay time;
  final String note;
  final String? imagePath;
  final String? videoPath;

  ActivityLog({
    required this.activityName,
    required this.activityImagePath,
    required this.activityColor,
    required this.food,
    required this.date,
    required this.time,
    required this.note,
    this.imagePath,
    this.videoPath,
  });
}


// class SavedActivity {
//   final String title;
//   final DateTime dateTime;
//   final String note;
//   final String? food;
//   final String? imagePath;
//   final String? videoPath;
//
//   SavedActivity({
//     required this.title,
//     required this.dateTime,
//     required this.note,
//     this.food,
//     this.imagePath,
//     this.videoPath,
//   });
// }
//
//
//
// // import 'package:flutter/material.dart';
// //
// // class SavedActivity {
// //   final String id;
// //   final String activityId;
// //   final String activityName;
// //   final String activityImagePath;
// //   final Color activityColor;
// //   final String food;
// //   final DateTime date;
// //   final TimeOfDay time;
// //   final String note;
// //   final String? imagePath;
// //   final String? videoPath;
// //   final DateTime createdAt;
// //
// //   SavedActivity({
// //     required this.id,
// //     required this.activityId,
// //     required this.activityName,
// //     required this.activityImagePath,
// //     required this.activityColor,
// //     required this.food,
// //     required this.date,
// //     required this.time,
// //     required this.note,
// //     this.imagePath,
// //     this.videoPath,
// //     required this.createdAt,
// //   });
// //
// //   factory SavedActivity.fromMap(Map<String, dynamic> map) {
// //     return SavedActivity(
// //       id: map['id'] ?? '',
// //       activityId: map['activityId'] ?? '',
// //       activityName: map['activityName'],
// //       activityImagePath: map['activityImagePath'],
// //       activityColor: Color(map['activityColor']),
// //       food: map['food'],
// //       date: DateTime.parse(map['date']),
// //       time: TimeOfDay(
// //         hour: map['time']['hour'],
// //         minute: map['time']['minute'],
// //       ),
// //       note: map['note'],
// //       imagePath: map['imagePath'],
// //       videoPath: map['videoPath'],
// //       createdAt: DateTime.parse(map['createdAt']),
// //     );
// //   }
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       'activityId': activityId,
// //       'activityName': activityName,
// //       'activityImagePath': activityImagePath,
// //       'activityColor': activityColor.value,
// //       'food': food,
// //       'date': date.toIso8601String(),
// //       'time': {
// //         'hour': time.hour,
// //         'minute': time.minute,
// //       },
// //       'note': note,
// //       'imagePath': imagePath,
// //       'videoPath': videoPath,
// //       'createdAt': createdAt.toIso8601String(),
// //     };
// //   }
// // }
