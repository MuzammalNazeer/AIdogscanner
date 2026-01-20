import 'package:flutter/material.dart';

class ActivityType {
  final String name;
  final String image;
  final Color color;

  const ActivityType({
    required this.name,
    required this.image,
    required this.color,
  });
}

class ActivityConstants {
  static const List<ActivityType> allActivities = [
    ActivityType(
      name: 'Walk',
      image: 'assets/images/walking.svg',
      color: Color(0xFFFF6B6B),
    ),
    ActivityType(
      name: 'Feed',
      image: 'assets/images/feed.png',
      color: Color(0xFFFFD93D),
    ),
    ActivityType(
      name: 'Water',
      image: 'assets/images/122.svg',
      color: Color(0xFF4D96FF),
    ),
    ActivityType(
      name: 'Medical',
      image: 'assets/images/medical.svg',
      color: Color(0xFFFF4757),
    ),
    ActivityType(
      name: 'Grooming',
      image: 'assets/images/124.svg',
      color: Color(0xFFA29BFE),
    ),
    ActivityType(
      name: 'Vaccination',
      image: 'assets/images/125.svg',
      color: Color(0xFF2ECC71),
    ),
    ActivityType(
      name: 'Training',
      image: 'assets/images/126.svg',
      color: Color(0xFF6C5CE7),
    ),
    ActivityType(
      name: 'Other',
      image: 'assets/images/127.svg',
      color: Color(0xFF95A5A6),
    ),
  ];
}
