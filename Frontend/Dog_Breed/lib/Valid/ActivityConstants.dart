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
      name: 'Doctor Visit',
      image: 'assets/images/doctor.png',
      color: Color(0xFFD0FAFF),
    ),
    ActivityType(
      name: 'Pee',
      image: 'assets/images/62.png',
      color: Color(0xFFFFD6C9),
    ),
    ActivityType(
      name: 'Eat',
      image: 'assets/images/image 1556.png',
      color: Color(0xFFFFE3B9),
    ),
    ActivityType(
      name: 'Drink',
      image: 'assets/images/drink.png',
      color: Color(0xFFB9DFFF),
    ),
    ActivityType(
      name: 'Play',
      image: 'assets/images/play.png',
      color: Color(0xFFC5F9FF),
    ),
    ActivityType(
      name: 'Poop',
      image: 'assets/images/poop.png',
      color: Color(0xFFFFDEC5),
    ),
    ActivityType(
      name: 'Walk',
      image: 'assets/images/walk1.png',
      color: Color(0xFFF2F2F2),
    ),
    ActivityType(
      name: 'Crate',
      image: 'assets/images/crate.png',
      color: Color(0xFFFFCFC7),
    ),
    ActivityType(
      name: 'Sleep',
      image: 'assets/images/sleep.png',
      color: Color(0xFFFFDDC2),
    ),
    ActivityType(
      name: 'Training',
      image: 'assets/images/training.png',
      color: Color(0xFFFFF1C2),
    ),
    ActivityType(
      name: 'Treat',
      image: 'assets/images/treat.png',
      color: Color(0xFFFFEBD3),
    ),
    ActivityType(
      name: 'Grooming',
      image: 'assets/images/grooming.png',
      color: Color(0xFFD0FAFF),
    ),
    ActivityType(
      name: 'Cleaning',
      image: 'assets/images/73.png',
      color: Color(0xFFFFCFD5),
    ),
    ActivityType(
      name: 'Medication',
      image: 'assets/images/medi.png',
      color: Color(0xFFFFEBEE),
    ),
    ActivityType(
      name: 'Vaccination',
      image: 'assets/images/vacc.png',
      color: Color(0xFFFFEAE3),
    ),
    ActivityType(
      name: 'Weight',
      image: 'assets/images/weight.png',
      color: Color(0xFFD2F3FF),
    ),
    ActivityType(
      name: 'Height',
      image: 'assets/images/height.png',
      color: Color(0xFFEAD8D5),
    ),
    ActivityType(
      name: 'Temperature',
      image: 'assets/images/temp.png',
      color: Color(0xFFE0EEFF),
    ),
    ActivityType(
      name: 'Health Condition',
      image: 'assets/images/healt.png',
      color: Color(0xFFFFE7C0),
    ),
    ActivityType(
      name: 'Accident',
      image: 'assets/images/acc.png',
      color: Color(0xFFFDFFD9),
    ),
    ActivityType(
      name: 'Journal',
      image: 'assets/images/jour.png',
      color: Color(0xFFFFD5CA),
    ),
  ];
  // static const List<ActivityType> allActivities = [
  //   ActivityType(
  //     name: 'Walk',
  //     image: 'assets/images/walking.svg',
  //     color: Color(0xFFFF6B6B),
  //   ),
  //   ActivityType(
  //     name: 'Feed',
  //     image: 'assets/images/feed.png',
  //     color: Color(0xFFFFD93D),
  //   ),
  //   ActivityType(
  //     name: 'Water',
  //     image: 'assets/images/122.svg',
  //     color: Color(0xFF4D96FF),
  //   ),
  //   ActivityType(
  //     name: 'Medical',
  //     image: 'assets/images/medical.svg',
  //     color: Color(0xFFFF4757),
  //   ),
  //   ActivityType(
  //     name: 'Grooming',
  //     image: 'assets/images/124.svg',
  //     color: Color(0xFFA29BFE),
  //   ),
  //   ActivityType(
  //     name: 'Vaccination',
  //     image: 'assets/images/125.svg',
  //     color: Color(0xFF2ECC71),
  //   ),
  //   ActivityType(
  //     name: 'Training',
  //     image: 'assets/images/126.svg',
  //     color: Color(0xFF6C5CE7),
  //   ),
  //   ActivityType(
  //     name: 'Other',
  //     image: 'assets/images/127.svg',
  //     color: Color(0xFF95A5A6),
  //   ),
  // ];
}
