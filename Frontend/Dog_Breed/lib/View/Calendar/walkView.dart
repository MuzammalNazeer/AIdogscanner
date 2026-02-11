import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import '../../View_model/home/home_view_model.dart';
import '../../activity_model.dart';
import 'dart:async';
import '../../config/components/roundButton.dart';
import 'package:dog_breed/l10n/app_localizations.dart';

import '../../utils/routes/routes_name.dart';

class Walkview extends StatefulWidget {
  final Activity? selectedActivity;

  const Walkview({super.key, this.selectedActivity});

  @override
  State<Walkview> createState() => _WalkviewState();
}

class _WalkviewState extends State<Walkview> {
  final TextEditingController _noteController = TextEditingController();

  // Timer variables
  Timer? _timer;
  Duration _duration = Duration.zero;
  bool _isRunning = false;

  // Format duration to include hours, minutes, and seconds for display in card
  String get _formattedDuration {
    final hours = _duration.inHours;
    final minutes = _duration.inMinutes.remainder(60);
    final seconds = _duration.inSeconds.remainder(60);

    if (hours == 0 && minutes == 0 && seconds == 0) {
      return '';
    }

    final loc = AppLocalizations.of(context)!;

    if (hours > 0) {
      return '$hours ${loc.durationHr} '
          '${minutes > 0 ? '$minutes ${loc.durationMin} ' : ''}'
          '${seconds > 0 ? '$seconds ${loc.durationSec}' : ''}'
          .trim();
    }

    if (minutes > 0) {
      return '$minutes ${loc.durationMin} ${seconds > 0 ? '$seconds ${loc.durationSec}' : ''}'.trim();
    }

    return '$seconds ${loc.durationSec}';
  }

  // Format duration for the timer display (HH:MM:SS)
  String get _formattedTime {
    final hours = _duration.inHours.toString().padLeft(2, '0');
    final minutes =
    _duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
    _duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  // Start or Pause timer
  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _duration = _duration + const Duration(seconds: 1);
        });
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  // Reset timer
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _duration = Duration.zero;
      _isRunning = false;
    });
  }

  void _deleteWalk() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 10,
        shadowColor: Theme.of(context).shadowColor.withOpacity(0.1),
        title: Text(
          AppLocalizations.of(context)!.walkDeleteTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.walkDeleteContent,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).hintColor,
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.walkCancel,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.walkDelete,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveWalk() {
    if (_duration == Duration.zero) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.walkStartTimerWarning,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.vibrantPurple,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        ),
      );
      return;
    }

    // Return data to previous screen
    Navigator.pop(context, {
      'duration': _duration,
      'formattedDuration': _formattedDuration,
      'note': _noteController.text.trim(),
    });
  }

  void _saveNote() {
    setState(() {});
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _noteController.dispose();
    super.dispose();
  }

  String _getLocalizedActivityName(BuildContext context, String name) {
    final localizations = AppLocalizations.of(context)!;
    switch (name) {

      case 'Pee':
        return localizations.activityPee;
      case 'Eat':
        return localizations.activityEat;
      case 'Drink':
        return localizations.activityDrink;
      case 'Play':
        return localizations.activityPlay;
      case 'Poop':
        return localizations.activityPoop;
      case 'Walk':
        return localizations.activityWalk;
      case 'Crate':
        return localizations.activityCrate;
      case 'Sleep':
        return localizations.activitySleep;
      case 'Training':
        return localizations.activityTraining;
      case 'Treat':
        return localizations.activityTreat;
      case 'Grooming':
        return localizations.activityGrooming;
      case 'Cleaning':
        return localizations.activityCleaning;
      case 'Medication':
        return localizations.activityMedication;
      case 'Vaccination':
        return localizations.activityVaccination;
      case 'Weight':
        return localizations.activityWeight;
      case 'Height':
        return localizations.activityHeight;
      case 'Temperature':
        return localizations.activityTemperature;
      case 'Health Condition':
        return localizations.activityHealthCondition;
      case 'Accident':
        return localizations.activityAccident;
      case 'Journal':
        return localizations.activityJournal;
      default:
        return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16),
          child: Column(
            children: [
              // Header with back and save buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(CupertinoIcons.chevron_left, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  GestureDetector(
                    onTap: _saveWalk,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(CupertinoIcons.check_mark, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),

                      // Activity Image and Name
                      Column(
                        children: [
                          Container(
                            width: 120.w,
                            height: 120.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.08),
                              //     blurRadius: 20,
                              //     offset: const Offset(0, 4),
                              //   ),
                              // ],
                            ),
                            child: Center(
                              child: Image.asset(
                                widget.selectedActivity?.imagePath ??
                                    'assets/images/67.png',
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            _getLocalizedActivityName(context, widget.selectedActivity?.name ?? AppLocalizations.of(context)!.activityWalk),
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),

                      // Timer Circle
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background ticks
                          SizedBox(
                            width: 360.w,
                            height: 360.h,
                            child: CustomPaint(
                              painter: MinimalTickPainter(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey
                                    : Colors.black.withOpacity(0.1),
                              ),
                            ),
                          ),

                          // Gray background ring
                          SizedBox(
                            width: 340.w,
                            height: 340.h,
                            child: CircularProgressIndicator(
                              value: 1.0,
                              strokeWidth: 12,
                              backgroundColor: Theme.of(context).colorScheme.onSurface,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.1)
                                      : const Color(0xFFF4F7F6)),
                            ),
                          ),

                          // Purple progress ring
                          SizedBox(
                            width: 340.w,
                            height: 340.h,
                            child: CircularProgressIndicator(
                              value:
                              (_duration.inSeconds / 3600.0).clamp(0.0, 1.0),
                              strokeWidth: 12,
                              backgroundColor: Colors.transparent,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.vibrantPurple),
                              strokeCap: StrokeCap.round,
                            ),
                          ),

                          // Timer and duration text
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Timer in MM:SS format
                              Text(
                                _formattedTime,
                                style: TextStyle(
                                  fontSize: 64.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              // Duration in hr/min format
                              Text(
                                _formattedDuration,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.vibrantPurple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),

                      // Control buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _controlButton(Icons.delete_outline,
                              color: AppColors.vibrantPurple,
                              onTap: _deleteWalk),
                          SizedBox(width: 32.w),
                          _controlButton(
                            _isRunning ? Icons.pause : Icons.play_arrow,
                            size: 40,
                            onTap: _toggleTimer,
                            color: AppColors.vibrantPurple,
                          ),
                          SizedBox(width: 32.w),
                          _controlButton(Icons.refresh,
                              color: AppColors.vibrantPurple, onTap: _resetTimer),
                          SizedBox(width: 32.w),
                          _controlButton(Icons.check,
                              color: AppColors.vibrantPurple, onTap: _saveWalk),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
              if (_noteController.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Container(
                    width: double.infinity,
                    padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _noteController.text,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: _showNoteBottomSheet,
                          child: Icon(
                            Icons.edit_note,
                            color: Theme.of(context).hintColor,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              RoundButton(
                title: _noteController.text.isEmpty ? AppLocalizations.of(context)!.walkAddNote : AppLocalizations.of(context)!.walkSave,
                isSelected: true,
                textColors: Colors.white,
                backgroundColors: AppColors.vibrantPurple,
                onPress: _noteController.text.isEmpty
                    ? _showNoteBottomSheet
                    : _saveWalk,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Control button widget
  Widget _controlButton(
      IconData icon, {
        double size = 28,
        Color? color,
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60.w,
        height: 60.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).cardColor,
          border: Border.all(color: AppColors.vibrantPurple, width: 1.5),
        ),
        child: Icon(icon, size: size.sp, color: color ?? Theme.of(context).hintColor),
      ),
    );
  }

  void _showNoteBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  AppLocalizations.of(context)!.walkNote,
                  style:
                  TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _noteController,
                maxLines: 5,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.walkNoteHint,
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.w),
                ),
              ),
              SizedBox(height: 24.h),
              RoundButton(
                title: AppLocalizations.of(context)!.walkSave,
                isSelected: true,
                textColors: Colors.white,
                backgroundColors: AppColors.vibrantPurple,
                onPress: _saveNote,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for timer ticks
class MinimalTickPainter extends CustomPainter {
  final Color color;

  MinimalTickPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 60; i++) {
      final angle = i * 6 * (math.pi / 180); // 6 degrees per tick
      final tickLength = i % 5 == 0 ? 19.0 : 19.0; // Slightly longer every 5 minutes

      final start = Offset(
        center.dx + math.cos(angle) * (radius - tickLength),
        center.dy + math.sin(angle) * (radius - tickLength),
      );
      final end = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
