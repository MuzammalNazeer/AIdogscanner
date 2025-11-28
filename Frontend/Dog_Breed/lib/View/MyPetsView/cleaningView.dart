import 'package:dog_breed/config/components/HygieneCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cleaningview extends StatefulWidget {
  const Cleaningview({super.key});

  @override
  State<Cleaningview> createState() => _HygieneViewState();
}

class _HygieneViewState extends State<Cleaningview> {
  final Map<String, bool> _hasReminder = {};
  final Map<String, String> _notes = {};
  final List<Color> iconTintColors = [
    const Color(0xFF2196F3),
    const Color(0xFF4CAF50),
    const Color(0xFFFF9800),
    const Color(0xFFFFC107),
    const Color(0xFF9C27B0),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40.305.w,
                      height: 40.305.h,
                      padding: const EdgeInsets.all(8.96),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F6F3), // #F3F6F3
                        borderRadius: BorderRadius.circular(8.96),
                      ),
                      child:  Icon(
                        CupertinoIcons.chevron_left,
                        size: 20.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Cleaning',
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w300,
                          fontSize: 29.75.w,
                          height: 1.0,
                          letterSpacing: 0.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h,),            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  HygieneCard(
                    key: const ValueKey('bath'),
                    title: 'Food Plate',
                    iconColor: iconTintColors[0],
                    hasReminder: _hasReminder['Food'] ?? false,
                    note: _notes['Food'] ?? '',
                    imagePath: 'assets/images/Vector (3).png',
                    onReminderTap: () {
                      setState(() {
                        _hasReminder['Food'] = !(_hasReminder['Food'] ?? false);
                      });
                    },
                    onAddNote: (note) {
                      setState(() {
                        _notes['Food'] = note;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  HygieneCard(
                    key: const ValueKey('Bed'),
                    title: 'Bed',
                    iconColor: iconTintColors[1],
                    hasReminder: _hasReminder['Bed'] ?? false,
                    note: _notes['Bed'] ?? '',
                    imagePath: 'assets/images/Vector (8).png',
                    onReminderTap: () {
                      setState(() {
                        _hasReminder['Bed'] = !(_hasReminder['Bed'] ?? false);
                      });
                    },
                    onAddNote: (note) {
                      setState(() {
                        _notes['Bed'] = note;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  HygieneCard(
                    key: const ValueKey('Toys'),
                    title: 'Toys',
                    iconColor: iconTintColors[2],
                    hasReminder: _hasReminder['Toys'] ?? false,
                    note: _notes['Toys'] ?? '',
                    imagePath: 'assets/images/Vector (2).png',
                    onReminderTap: () {
                      setState(() {
                        _hasReminder['Toys'] = !(_hasReminder['Toys'] ?? false);
                      });
                    },
                    onAddNote: (note) {
                      setState(() {
                        _notes['Toys'] = note;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  HygieneCard(
                    key: const ValueKey('Water'),
                    title: 'Water Fountain',
                    iconColor: iconTintColors[3],
                    hasReminder: _hasReminder['Water'] ?? false,
                    note: _notes['Water'] ?? '',
                    imagePath: 'assets/images/Vector (6).png',
                    onReminderTap: () {
                      setState(() {
                        _hasReminder['Water'] = !(_hasReminder['Water'] ?? false);
                      });
                    },
                    onAddNote: (note) {
                      setState(() {
                        _notes['Water'] = note;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  HygieneCard(
                    key: const ValueKey('Leash'),
                    title: 'Leash & Collar',
                    iconColor: iconTintColors[4],
                    hasReminder: _hasReminder['Leash'] ?? false,
                    note: _notes['Leash'] ?? '',
                    imagePath: 'assets/images/Vector (1).png',
                    onReminderTap: () {
                      setState(() {
                        _hasReminder['Leash'] = !(_hasReminder['Leash'] ?? false);
                      });
                    },
                    onAddNote: (note) {
                      setState(() {
                        _notes['Leash'] = note;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
