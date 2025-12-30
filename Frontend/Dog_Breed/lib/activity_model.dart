import 'dart:ui';

import 'package:intl/intl.dart';

class Activity {
  final String name;
  final String imagePath; // e.g., 'assets/images/walk.svg' or 'assets/images/eat.png'
  final Color color;

  // Saved activity fields
  final String? food;
  final DateTime dateTime;
  final String? note;
  final String? imagePathLocal; // User-taken photo
  final String? videoPathLocal; // User-recorded video
  final String? duration;       // e.g., "33:50" from Walk timer

  Activity({
    required this.name,
    required this.imagePath,
    required this.color,
    this.food,
    required this.dateTime,
    this.note,
    this.imagePathLocal,
    this.videoPathLocal,
    this.duration,
  });

  // Display helpers
  String get formattedDate => DateFormat('EEE, MMM d, yyyy').format(dateTime);
  String get formattedTime => DateFormat('h:mm a').format(dateTime);

  // // NEW: Detect if the icon is SVG
  // bool get isSvg {
  //   return imagePath.toLowerCase().endsWith('.svg');
  // }
  //
  // // Optional: Get file extension
  // String? get extension {
  //   final i = imagePath.lastIndexOf('.');
  //   if (i == -1) return null;
  //   return imagePath.substring(i + 1).toLowerCase();
  // }

  // JSON serialization (now includes duration!)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imagePath': imagePath,
      'color': color.value,
      'food': food,
      'dateTime': dateTime.toIso8601String(),
      'note': note,
      'imagePathLocal': imagePathLocal,
      'videoPathLocal': videoPathLocal,
      'duration': duration,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      color: Color(json['color'] as int),
      food: json['food'] as String?,
      dateTime: DateTime.parse(json['dateTime'] as String),
      note: json['note'] as String?,
      imagePathLocal: json['imagePathLocal'] as String?,
      videoPathLocal: json['videoPathLocal'] as String?,
      duration: json['duration'] as String?,
    );
  }
}

// // activity_model.dart
// import 'dart:ui';
//
// import 'package:intl/intl.dart';
//
// class Activity {
//   final String name;
//   final String imagePath;
//   final Color color;
//
//   // Fields for saved instance
//   final String? food;
//   final DateTime dateTime; // combined date + time
//   final String? note;
//   final String? imagePathLocal; // local file path
//   final String? videoPathLocal;
//   final String? duration;
//
//   Activity({
//     required this.name,
//     required this.imagePath,
//     required this.color,
//     this.food,
//     required this.dateTime,
//     this.note,
//     this.imagePathLocal,
//     this.videoPathLocal,
//     this.duration,
//   });
//
//   // For display
//   String get formattedDate => DateFormat('EEE, MMM d, yyyy').format(dateTime);
//   String get formattedTime => DateFormat('h:mm a').format(dateTime);
//
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'imagePath': imagePath,
//       'color': color.value, // Save color as int
//       'food': food,
//       'dateTime': dateTime.toIso8601String(),
//       'note': note,
//       'imagePathLocal': imagePathLocal,
//       'videoPathLocal': videoPathLocal,
//     };
//   }
//
//   factory Activity.fromJson(Map<String, dynamic> json) {
//     return Activity(
//       name: json['name'] as String,
//       imagePath: json['imagePath'] as String,
//       color: Color(json['color'] as int),
//       food: json['food'] as String?,
//       dateTime: DateTime.parse(json['dateTime'] as String),
//       note: json['note'] as String?,
//       imagePathLocal: json['imagePathLocal'] as String?,
//       videoPathLocal: json['videoPathLocal'] as String?,
//     );
//   }
// }