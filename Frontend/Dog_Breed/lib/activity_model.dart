import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Activity {
  final String name;
  final String imagePath;
  final Color color;
  final String? food; // For drink: "8.5 oz", for walk: "1.2 km" or "2.5 mi"
  final DateTime dateTime;
  final String? note;
  final String? imagePathLocal;
  final String? videoPathLocal;
  final Duration? duration; // For walk activities
  final String? formattedDuration; // For walk activities: "1 hr 30 min"
  final String? walkDistance; // For walk: distance in km/mi
  final String? petId; // Associated Pet ID
  bool hasReminder;
  DateTime? reminderDateTime;
  String? reminderId;
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
    this.formattedDuration,
    this.walkDistance,
    this.petId,
    this.hasReminder = false,
    this.reminderDateTime,
    this.reminderId,
  });

  // Factory constructor to create an Activity from JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    // Parse duration from seconds
    Duration? duration;
    if (json['durationSeconds'] != null) {
      duration = Duration(seconds: json['durationSeconds'] as int);
    }

    return Activity(
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      color: Color(json['color'] as int),
      food: json['food'] as String?,
      dateTime: DateTime.parse(json['dateTime'] as String),
      note: json['note'] as String?,
      imagePathLocal: json['imagePathLocal'] as String?,
      videoPathLocal: json['videoPathLocal'] as String?,
      duration: duration,
      formattedDuration: json['formattedDuration'] as String?,
      walkDistance: json['walkDistance'] as String?,
      petId: json['petId'] as String?,
      hasReminder: json['hasReminder'] as bool? ?? false,
      reminderDateTime: json['reminderDateTime'] != null
          ? DateTime.parse(json['reminderDateTime'] as String)
          : null,
      reminderId: json['reminderId'] as String?,
    );
  }

  // Convert Activity to JSON
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
      'durationSeconds': duration?.inSeconds,
      'formattedDuration': formattedDuration,
      'walkDistance': walkDistance,
      'petId': petId,
      'hasReminder': hasReminder,
      'reminderDateTime': reminderDateTime?.toIso8601String(),
      'reminderId': reminderId,
    };
  }

  // Date formatters
  String get formattedDate => DateFormat('MMM dd, yyyy').format(dateTime);
  String get formattedTime => DateFormat('hh:mm a').format(dateTime);

  // Helper method to get display duration
  String get displayDuration {
    if (formattedDuration != null && formattedDuration!.isNotEmpty) {
      return formattedDuration!;
    }
    if (duration != null) {
      final hours = duration!.inHours;
      final minutes = duration!.inMinutes.remainder(60);
      final seconds = duration!.inSeconds.remainder(60);

      if (hours == 0 && minutes == 0 && seconds == 0) {
        return '';
      }

      if (hours > 0) {
        return '$hours hr '
                '${minutes > 0 ? '$minutes min ' : ''}'
                '${seconds > 0 ? '$seconds sec' : ''}'
            .trim();
      }

      if (minutes > 0) {
        return '$minutes min ${seconds > 0 ? '$seconds sec' : ''}'.trim();
      }

      return '$seconds sec';
    }
    return '';
  }

  // Helper method to get display text (for walk/drink)
  String get displayText {
    final activityName = name.toLowerCase();
    if (activityName == 'walk') {
      if (displayDuration.isNotEmpty) {
        return displayDuration;
      }
      if (walkDistance != null && walkDistance!.isNotEmpty) {
        return walkDistance!;
      }
    }
    if (activityName == 'drink' && food != null && food!.isNotEmpty) {
      return food!;
    }
    return '';
  }

  // Copy with method for updating
  Activity copyWith({
    String? name,
    String? imagePath,
    Color? color,
    String? food,
    DateTime? dateTime,
    String? note,
    String? imagePathLocal,
    String? videoPathLocal,
    Duration? duration,
    String? formattedDuration,
    String? walkDistance,
    String? petId,
    bool? hasReminder,
    DateTime? reminderDateTime,
    String? reminderId,
  }) {
    return Activity(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      color: color ?? this.color,
      food: food ?? this.food,
      dateTime: dateTime ?? this.dateTime,
      note: note ?? this.note,
      imagePathLocal: imagePathLocal ?? this.imagePathLocal,
      videoPathLocal: videoPathLocal ?? this.videoPathLocal,
      duration: duration ?? this.duration,
      formattedDuration: formattedDuration ?? this.formattedDuration,
      walkDistance: walkDistance ?? this.walkDistance,
      petId: petId ?? this.petId,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderDateTime: reminderDateTime ?? this.reminderDateTime,
      reminderId: reminderId ?? this.reminderId,
    );
  }
}

// import 'dart:ui';
//
// import 'package:intl/intl.dart';
//
// class Activity {
//   final String name;
//   final String imagePath; // e.g., 'assets/images/walking1.png' or 'assets/images/feed.png'
//   final Color color;
//
//   // Saved activity fields
//   final String? food;
//   final DateTime dateTime;
//   final String? note;
//   final String? imagePathLocal; // User-taken photo
//   final String? videoPathLocal; // User-recorded video
//   final String? duration;
//   final String? formattedDuration;// e.g., "33:50" from Walk timer
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
//     this.formattedDuration,
//   });
//
//   // Display helpers
//   String get formattedDate => DateFormat('EEE, MMM d, yyyy').format(dateTime);
//   String get formattedTime => DateFormat('h:mm a').format(dateTime);
//
//   String get displayDuration {
//     if (formattedDuration != null) {
//       return formattedDuration!;
//     }
//     if (duration != null) {
//       final hours = duration!.inHours;
//       final minutes = duration!.inMinutes.remainder(60);
//       if (hours > 0) {
//         return '$hours hr ${minutes > 0 ? '$minutes min' : ''}'.trim();
//       } else {
//         return '$minutes min';
//       }
//     }
//     return '';
//   }
//   // // NEW: Detect if the icon is SVG
//   // bool get isSvg {
//   //   return imagePath.toLowerCase().endsWith('.svg');
//   // }
//   //
//   // // Optional: Get file extension
//   // String? get extension {
//   //   final i = imagePath.lastIndexOf('.');
//   //   if (i == -1) return null;
//   //   return imagePath.substring(i + 1).toLowerCase();
//   // }
//
//   // JSON serialization (now includes duration!)
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'imagePath': imagePath,
//       'color': color.value,
//       'food': food,
//       'dateTime': dateTime.toIso8601String(),
//       'note': note,
//       'imagePathLocal': imagePathLocal,
//       'videoPathLocal': videoPathLocal,
//       'duration': duration,
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
//       duration: json['duration'] as String?,
//     );
//   }
// }
//
// // // activity_model.dart
// // import 'dart:ui';
// //
// // import 'package:intl/intl.dart';
// //
// // class Activity {
// //   final String name;
// //   final String imagePath;
// //   final Color color;
// //
// //   // Fields for saved instance
// //   final String? food;
// //   final DateTime dateTime; // combined date + time
// //   final String? note;
// //   final String? imagePathLocal; // local file path
// //   final String? videoPathLocal;
// //   final String? duration;
// //
// //   Activity({
// //     required this.name,
// //     required this.imagePath,
// //     required this.color,
// //     this.food,
// //     required this.dateTime,
// //     this.note,
// //     this.imagePathLocal,
// //     this.videoPathLocal,
// //     this.duration,
// //   });
// //
// //   // For display
// //   String get formattedDate => DateFormat('EEE, MMM d, yyyy').format(dateTime);
// //   String get formattedTime => DateFormat('h:mm a').format(dateTime);
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'name': name,
// //       'imagePath': imagePath,
// //       'color': color.value, // Save color as int
// //       'food': food,
// //       'dateTime': dateTime.toIso8601String(),
// //       'note': note,
// //       'imagePathLocal': imagePathLocal,
// //       'videoPathLocal': videoPathLocal,
// //     };
// //   }
// //
// //   factory Activity.fromJson(Map<String, dynamic> json) {
// //     return Activity(
// //       name: json['name'] as String,
// //       imagePath: json['imagePath'] as String,
// //       color: Color(json['color'] as int),
// //       food: json['food'] as String?,
// //       dateTime: DateTime.parse(json['dateTime'] as String),
// //       note: json['note'] as String?,
// //       imagePathLocal: json['imagePathLocal'] as String?,
// //       videoPathLocal: json['videoPathLocal'] as String?,
// //     );
// //   }
// // }


// import 'dart:ui';
//
// import 'package:intl/intl.dart';
//
// class Activity {
//   final String name;
//   final String imagePath; // e.g., 'assets/images/walk.svg' or 'assets/images/eat.png'
//   final Color color;
//
//   // Saved activity fields
//   final String? food;
//   final DateTime dateTime;
//   final String? note;
//   final String? imagePathLocal; // User-taken photo
//   final String? videoPathLocal; // User-recorded video
//   final String? duration;       // e.g., "33:50" from Walk timer
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
//     this.duration, required String formattedDuration,
//   });
//
//   // Display helpers
//   String get formattedDate => DateFormat('EEE, MMM d, yyyy').format(dateTime);
//   String get formattedTime => DateFormat('h:mm a').format(dateTime);
//
//   // // NEW: Detect if the icon is SVG
//   // bool get isSvg {
//   //   return imagePath.toLowerCase().endsWith('.svg');
//   // }
//   //
//   // // Optional: Get file extension
//   // String? get extension {
//   //   final i = imagePath.lastIndexOf('.');
//   //   if (i == -1) return null;
//   //   return imagePath.substring(i + 1).toLowerCase();
//   // }
//
//   // JSON serialization (now includes duration!)
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'imagePath': imagePath,
//       'color': color.value,
//       'food': food,
//       'dateTime': dateTime.toIso8601String(),
//       'note': note,
//       'imagePathLocal': imagePathLocal,
//       'videoPathLocal': videoPathLocal,
//       'duration': duration,
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
//       duration: json['duration'] as String?,
//     );
//   }
// }
//
// // // activity_model.dart
// // import 'dart:ui';
// //
// // import 'package:intl/intl.dart';
// //
// // class Activity {
// //   final String name;
// //   final String imagePath;
// //   final Color color;
// //
// //   // Fields for saved instance
// //   final String? food;
// //   final DateTime dateTime; // combined date + time
// //   final String? note;
// //   final String? imagePathLocal; // local file path
// //   final String? videoPathLocal;
// //   final String? duration;
// //
// //   Activity({
// //     required this.name,
// //     required this.imagePath,
// //     required this.color,
// //     this.food,
// //     required this.dateTime,
// //     this.note,
// //     this.imagePathLocal,
// //     this.videoPathLocal,
// //     this.duration,
// //   });
// //
// //   // For display
// //   String get formattedDate => DateFormat('EEE, MMM d, yyyy').format(dateTime);
// //   String get formattedTime => DateFormat('h:mm a').format(dateTime);
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'name': name,
// //       'imagePath': imagePath,
// //       'color': color.value, // Save color as int
// //       'food': food,
// //       'dateTime': dateTime.toIso8601String(),
// //       'note': note,
// //       'imagePathLocal': imagePathLocal,
// //       'videoPathLocal': videoPathLocal,
// //     };
// //   }
// //
// //   factory Activity.fromJson(Map<String, dynamic> json) {
// //     return Activity(
// //       name: json['name'] as String,
// //       imagePath: json['imagePath'] as String,
// //       color: Color(json['color'] as int),
// //       food: json['food'] as String?,
// //       dateTime: DateTime.parse(json['dateTime'] as String),
// //       note: json['note'] as String?,
// //       imagePathLocal: json['imagePathLocal'] as String?,
// //       videoPathLocal: json['videoPathLocal'] as String?,
// //     );
// //   }
// // }
