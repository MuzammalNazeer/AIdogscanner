// activity_model.dart
import 'dart:ui';

import 'package:intl/intl.dart';

class Activity {
  final String name;
  final String imagePath;
  final Color color;

  // Fields for saved instance
  final String? food;
  final DateTime dateTime; // combined date + time
  final String? note;
  final String? imagePathLocal; // local file path
  final String? videoPathLocal;

  Activity({
    required this.name,
    required this.imagePath,
    required this.color,
    this.food,
    required this.dateTime,
    this.note,
    this.imagePathLocal,
    this.videoPathLocal,
  });

  // For display
  String get formattedDate => DateFormat('EEE, MMM d, yyyy').format(dateTime);
  String get formattedTime => DateFormat('h:mm a').format(dateTime);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imagePath': imagePath,
      'color': color.value, // Save color as int
      'food': food,
      'dateTime': dateTime.toIso8601String(),
      'note': note,
      'imagePathLocal': imagePathLocal,
      'videoPathLocal': videoPathLocal,
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
    );
  }
}