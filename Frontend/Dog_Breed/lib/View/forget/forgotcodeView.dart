import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Valid/AppColors.dart';
import '../../config/components/roundButton.dart';
import '../../utils/routes/routes_name.dart';

class Forgotcodeview extends StatefulWidget {
  const Forgotcodeview({super.key});

  @override
  State<Forgotcodeview> createState() => _ForgotcodeviewState();
}

class _ForgotcodeviewState extends State<Forgotcodeview> {
  String truncateEmail(String email) {
    if (email.length <= 20) return email;
    final prefix = email.split('@')[0];
    final domain = email.split('@')[1];

    if (prefix.length > 10) {
      return '${prefix.substring(0, 10)}...@$domain';
    }
    return email;
  }

  int resendTimer = 10;
  late bool _onEditing = true;
  late Timer countdownTimer;
  final List<TextEditingController> _controllers = List.generate(
    5,
    (index) => TextEditingController(),
  );

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        resendTimer = resendTimer - 1;
      });
      if (resendTimer < 1) {
        countdownTimer.cancel();
      }
    });
  }

  stopTimer() {
    if (countdownTimer.isActive) {
      countdownTimer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40.305.w,
                    height: 40.305.h,
                    padding: EdgeInsets.all(8.96.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(8.96.r),
                    ),
                    child: Icon(
                      CupertinoIcons.chevron_left,
                      size: 20.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Text(
                'Check your email',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101010),
                  height: 1.20,
                  letterSpacing: -0.16,
                ),
              ),
              SizedBox(height: 11.h),
              Text.rich(
                TextSpan(
                  text: 'We sent a reset link to ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xff6d6d6d),
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: truncateEmail('contact@dscode.com'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: ' enter 5 digit code that mentioned in the email',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xff6d6d6d),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return SizedBox(
                    width: 56,
                    height: 56,
                    child: TextFormField(
                      controller: _controllers[index],
                      onChanged: (value) {
                        if (value.length == 1 && index <= 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: Theme.of(context).textTheme.headlineSmall,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onEditingComplete: () {
                        _onEditing = !_onEditing;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(height: 22.h),
              RoundButton(
                title: "Reset Password",
                height: 50.h,
                width: double.infinity,
                backgroundColors: AppColors.vibrantPurple,
                isSelected: true,
                onPress: () {
                  Navigator.pushNamed(context, RoutesName.confirm);
                },
              ),
              SizedBox(height: 39.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Haven’t got the email yet?",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      height: 1.20,
                      letterSpacing: -0.16,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  resendTimer == 0
                      ? InkWell(
                          onTap: () {
                            resendTimer = 10;
                            startTimer();
                          },
                          child: Text(
                            "Resend email ",
                            style: TextStyle(
                              color: const Color(0xFF2E67F6),
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              height: 1.20,
                              letterSpacing: -0.16,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              Center(
                child: resendTimer != 0
                    ? Text("You can resend OTP after $resendTimer second(s)")
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
