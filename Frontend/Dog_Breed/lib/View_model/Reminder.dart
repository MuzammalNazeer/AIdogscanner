// reminder_model.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';


class Reminder {
  final String id;
  final String title;
  final DateTime dateTime;
  final String? description;
  final String category;
  final String? activityType;
  final String? frequency;
  final String? note;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? petId;


  Reminder({
    String? id,
    required this.title,
    required this.dateTime,
    this.description,
    required this.category,
    this.activityType,
    this.frequency,
    this.note,
    this.isCompleted = false,
    this.completedAt,
    this.petId,
  }) : id = id ?? const Uuid().v4();

  // Get activity color based on type
  int get activityColor {
    final activity = ActivityConstants.getType(activityType ?? '');
    if (activity != null) {
      return activity.color.value;
    }
    return 0xFF820DFF;
  }

  // Get activity icon based on type
  IconData get activityIcon {
    final icons = {
      'Veterinary': Icons.local_hospital,
      'Pee': Icons.water_drop,
      'Eat': Icons.restaurant,
      'Drink': Icons.local_drink,
      'Play': Icons.sports_baseball,
      'Poop': Icons.wc,
      'Walk': Icons.directions_walk,
      'Crate': Icons.home,
      'Sleep': Icons.bedtime,
      'Training': Icons.school,
      'Treat': Icons.cake,
      'Grooming': Icons.cut,
      'Cleaning': Icons.cleaning_services,
      'Medication': Icons.medical_services,
      'Vaccination': Icons.vaccines,
      'Weight': Icons.monitor_weight,
      'Height': Icons.straighten,
      'Temperature': Icons.thermostat,
      'Health Condition': Icons.favorite,
      'Accident': Icons.warning,
      'Journal': Icons.book,
    };

    return icons[activityType] ?? Icons.alarm;
  }

  // Create a copyWith method for editing
  Reminder copyWith({
    String? id,
    String? title,
    DateTime? dateTime,
    String? description,
    String? category,
    String? activityType,
    String? frequency,
    String? note,
    bool? isCompleted,
    DateTime? completedAt,
    String? petId,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
      category: category ?? this.category,
      activityType: activityType ?? this.activityType,
      frequency: frequency ?? this.frequency,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      petId: petId ?? this.petId,
    );
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'description': description,
      'category': category,
      'activityType': activityType,
      'frequency': frequency,
      'note': note,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'petId': petId,
    };
  }

  // Create from Map
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      dateTime: DateTime.parse(map['dateTime']),
      description: map['description'],
      category: map['category'],
      activityType: map['activityType'],
      frequency: map['frequency'],
      note: map['note'],
      isCompleted: map['isCompleted'] ?? false,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      petId: map['petId'],
    );
  }

  // Mark as completed
  Reminder markAsCompleted() {
    return copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
  }

  // Mark as not completed
  Reminder markAsNotCompleted() {
    return copyWith(
      isCompleted: false,
      completedAt: null,
    );
  }

  // Get formatted date
  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  // Get formatted time
  String get formattedTime {
    return DateFormat('hh:mm a').format(dateTime);
  }

  // Get formatted date and time
  String get formattedDateTime {
    return '$formattedDate at $formattedTime';
  }

  // Check if reminder is overdue
  bool get isOverdue {
    return !isCompleted && dateTime.isBefore(DateTime.now());
  }

  // Check if reminder is due today
  bool get isDueToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Reminder &&
        other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}

extension on Reminder {
  get ActivityConstants => null;
}






// // reminder_model.dart
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
// import 'package:intl/intl.dart';
//
// class Reminder {
//   final String id;
//   final String title;
//   final DateTime dateTime;
//   final String? description;
//   final String category;
//   final String? activityType;
//   final String? frequency;
//   final String? note;
//   final bool isCompleted;
//   final DateTime? completedAt;
//   final String? petId;
//
//
//   Reminder({
//     String? id,
//     required this.title,
//     required this.dateTime,
//     this.description,
//     required this.category,
//     this.activityType,
//     this.frequency,
//     this.note,
//     this.isCompleted = false,
//     this.completedAt,
//     this.petId,
//   }) : id = id ?? const Uuid().v4();
//
//   // Get activity color based on type
//   int get activityColor {
//     final colors = {
//       'Veterinary': 0xFFB9E6FF,
//       'Pee': 0xFFFFD6C9,
//       'Eat': 0xFFFFE3B9,
//       'Drink': 0xFFB9DFFF,
//       'Play': 0xFFC5F9FF,
//       'Poop': 0xFFFFDEC5,
//       'Walk': 0xFFF2F2F2,
//       'Crate': 0xFFFFCFC7,
//       'Sleep': 0xFFFFDDC2,
//       'Training': 0xFFFFF1C2,
//       'Treat': 0xFFFFEBD3,
//       'Grooming': 0xFFD0FAFF,
//       'Cleaning': 0xFFFFCFD5,
//       'Medication': 0xFFFFEBEE,
//       'Vaccination': 0xFFFFEAE3,
//       'Weight': 0xFFD2F3FF,
//       'Height': 0xFFEAD8D5,
//       'Temperature': 0xFFE0EEFF,
//       'Health Condition': 0xFFFFE7C0,
//       'Accident': 0xFFFDFFD9,
//       'Journal': 0xFFFFD5CA,
//     };
//
//     return colors[activityType] ?? 0xFF820DFF;
//   }
//
//   // Get activity icon based on type
//   IconData get activityIcon {
//     final icons = {
//       'Veterinary': Icons.local_hospital,
//       'Pee': Icons.water_drop,
//       'Eat': Icons.restaurant,
//       'Drink': Icons.local_drink,
//       'Play': Icons.sports_baseball,
//       'Poop': Icons.wc,
//       'Walk': Icons.directions_walk,
//       'Crate': Icons.home,
//       'Sleep': Icons.bedtime,
//       'Training': Icons.school,
//       'Treat': Icons.cake,
//       'Grooming': Icons.cut,
//       'Cleaning': Icons.cleaning_services,
//       'Medication': Icons.medical_services,
//       'Vaccination': Icons.vaccines,
//       'Weight': Icons.monitor_weight,
//       'Height': Icons.straighten,
//       'Temperature': Icons.thermostat,
//       'Health Condition': Icons.favorite,
//       'Accident': Icons.warning,
//       'Journal': Icons.book,
//     };
//
//     return icons[activityType] ?? Icons.alarm;
//   }
//
//   // Create a copyWith method for editing
//   Reminder copyWith({
//     String? id,
//     String? title,
//     DateTime? dateTime,
//     String? description,
//     String? category,
//     String? activityType,
//     String? frequency,
//     String? note,
//     bool? isCompleted,
//     DateTime? completedAt,
//     String? petId,
//   }) {
//     return Reminder(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       dateTime: dateTime ?? this.dateTime,
//       description: description ?? this.description,
//       category: category ?? this.category,
//       activityType: activityType ?? this.activityType,
//       frequency: frequency ?? this.frequency,
//       note: note ?? this.note,
//       isCompleted: isCompleted ?? this.isCompleted,
//       completedAt: completedAt ?? this.completedAt,
//       petId: petId ?? this.petId,
//     );
//   }
//
//   // Convert to Map for storage
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'dateTime': dateTime.toIso8601String(),
//       'description': description,
//       'category': category,
//       'activityType': activityType,
//       'frequency': frequency,
//       'note': note,
//       'isCompleted': isCompleted,
//       'completedAt': completedAt?.toIso8601String(),
//       'petId': petId,
//     };
//   }
//
//   // Create from Map
//   factory Reminder.fromMap(Map<String, dynamic> map) {
//     return Reminder(
//       id: map['id'],
//       title: map['title'],
//       dateTime: DateTime.parse(map['dateTime']),
//       description: map['description'],
//       category: map['category'],
//       activityType: map['activityType'],
//       frequency: map['frequency'],
//       note: map['note'],
//       isCompleted: map['isCompleted'] ?? false,
//       completedAt: map['completedAt'] != null
//           ? DateTime.parse(map['completedAt'])
//           : null,
//       petId: map['petId'],
//     );
//   }
//
//   // Mark as completed
//   Reminder markAsCompleted() {
//     return copyWith(
//       isCompleted: true,
//       completedAt: DateTime.now(),
//     );
//   }
//
//   // Mark as not completed
//   Reminder markAsNotCompleted() {
//     return copyWith(
//       isCompleted: false,
//       completedAt: null,
//     );
//   }
//
//   // Get formatted date
//   String get formattedDate {
//     return DateFormat('MMM dd, yyyy').format(dateTime);
//   }
//
//   // Get formatted time
//   String get formattedTime {
//     return DateFormat('hh:mm a').format(dateTime);
//   }
//
//   // Get formatted date and time
//   String get formattedDateTime {
//     return '$formattedDate at $formattedTime';
//   }
//
//   // Check if reminder is overdue
//   bool get isOverdue {
//     return !isCompleted && dateTime.isBefore(DateTime.now());
//   }
//
//   // Check if reminder is due today
//   bool get isDueToday {
//     final now = DateTime.now();
//     return dateTime.year == now.year &&
//         dateTime.month == now.month &&
//         dateTime.day == now.day;
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//
//     return other is Reminder &&
//         other.id == id;
//   }
//
//   @override
//   int get hashCode {
//     return id.hashCode;
//   }
// }
//
//
//
