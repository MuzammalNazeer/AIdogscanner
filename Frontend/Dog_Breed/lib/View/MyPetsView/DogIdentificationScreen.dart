// lib/View/MyPetsView/DogIdentificationScreen.dart

import 'dart:io';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'DogResultScreen.dart';

class DogIdentificationScreen extends StatefulWidget {
  final File imageFile;

  const DogIdentificationScreen({super.key, required this.imageFile});

  @override
  State<DogIdentificationScreen> createState() => _DogIdentificationScreenState();
}

class _DogIdentificationScreenState extends State<DogIdentificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _percentage = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {
        _percentage = _controller.value * 100;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animation 100% → Go to full result screen
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => DogResultScreen(imageFile: widget.imageFile),
              transitionDuration: const Duration(milliseconds: 600),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                  'assets/images/walking1.png'
              ),
              SizedBox(height: 40.h),
              _buildWalkingLine(),
              SizedBox(height: 40.h),
              Text(
                '${_percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.vibrantPurple,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'AI identifying Your DOG',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                'This usually takes up 1 minute...',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalkingLine() {
    return Column(
      children: [
        // Line track
        Container(
          width: double.infinity,
          height: 8.h,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Stack(
            children: [

              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    left: (MediaQuery.of(context).size.width - 40.w) * _animation.value,
                    top: -12.h,
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.vibrantPurple,
                            blurRadius: 8.r,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                      ),
                      child: Image.asset(
                          'assets/images/walking1.png'
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: MediaQuery.of(context).size.width * _animation.value,
                    height: 8.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.vibrantPurple, AppColors.vibrantPurple],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),

      ],
    );
  }
}
