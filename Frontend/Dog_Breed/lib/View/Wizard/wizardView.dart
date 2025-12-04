import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Wizardview extends StatefulWidget {
  const Wizardview({super.key});

  @override
  State<Wizardview> createState() => _WizardviewState();
}

class _WizardviewState extends State<Wizardview> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFF7B2CBF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => currentPage = i),
                children: const [
                  OnboardingPage1(),
                  OnboardingPage2(),
                  OnboardingPage3(),
                  OnboardingPage4(),
                ],
              ),
            ),

            // Bottom Navigation Bar
            Container(
              height: 100.h,
              color: const Color(0xFF7B2CBF),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentPage < 3)
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, RoutesName.dashboard),
                      child:  Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                     SizedBox(width: 50.w),

                  // Page Dots
                  Row(
                    children: List.generate(
                      4,
                      (i) => AnimatedContainer(
                        duration:  Duration(milliseconds: 300),
                        margin:  EdgeInsets.only(right: 8),
                        width: currentPage == i ? 28 : 10,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: currentPage == i
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),

                  // Next / Get Started Button
                  GestureDetector(
                    onTap: () {
                      if (currentPage == 3) {
                        Navigator.pushNamed(context, RoutesName.dashboard);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        currentPage == 3 ? "Get Started" : "Next",
                        style: const TextStyle(
                          color: Color(0xFF6D09E8),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
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
class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10.r),
      child: Column(
        children: [
          SizedBox(height: 60.h,),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 360.w,
                height: 360.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D9FF).withOpacity(1),
                      blurRadius: 54,
                      spreadRadius: 0,
                      offset: Offset.zero,
                    ),
                  ],
                ),
              ),
              Container(
                width: 340.w,
                height: 340.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF7B2CBF), Color(0xFF5B0BAE)],
                  ),
                ),
              ),
              Container(
                width: 260.w,
                height: 260.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF7B2CBF),
                ),
              ),
              ClipOval(
                child: Image.asset(
                  'assets/images/Ellipse 777.png',
                  width: 246.w,
                  height: 266.h,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(height: 210.h),
           Text(
            "Find Out Your Dog's\nBreed Fast!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          SizedBox(height: 16.h),
           Text(
            "Capture a photo or upload from your gallery\nand discover your dog’s breed instantly!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.white,),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(16.r),
      child: Column(
        children: [
          SizedBox(height: 60.h,),
          SizedBox(
            width: 380.w,
            height: 420.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow
                Container(
                  width: 400.w,
                  height: 380.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D9FF).withOpacity(1),
                        blurRadius: 54,
                        spreadRadius: 0,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 320.w,
                  height: 320.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF7B2CBF), Color(0xFF5B0BAE)],
                    ),
                  ),
                ),
                Container(
                  width: 260.w,
                  height: 260.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color:Color(0xFF7B2CBF),
                  ),
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/images/Ellipse 77.png',
                    width: 258.w,
                    height: 260.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(top: 50.h,  left: 45.w,   child: _buildSmallDogCircle('assets/images/Ellipse 78.png')),
                Positioned(top: 160.h,  right: 10.w,  child: _buildSmallDogCircle('assets/images/Ellipse 78.png')),
                Positioned(bottom: 38.h, left: 68.w, child: _buildSmallDogCircle('assets/images/Ellipse 78.png')),
              ],
            ),
          ),
          SizedBox(height: 165.h),
           Text(
            "We need your\n permission",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "We need camera permission so you can make live \nscans of your pet.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.white,),
          ),
        ],
      ),
    );
  }
}


Widget _buildSmallDogCircle(String assetPath) {
  return ClipOval(
    child: Image.asset(
      assetPath,
      width: 100.w,
      height: 100.h,
      fit: BoxFit.cover,
    ),
  );
}
// PAGE 3 - Image Quality Grid
class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(32.r),
      child: Column(
        children: [
          SizedBox(height: 140.h,),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                bool showCloseIcon = index == 0 || index == 1 || index == 3;
                bool showCheckIcon = index == 2 || index == 4 || index == 5;
                final List<String> imagePaths = [
                  'assets/images/Ellipse 81 (1).png',
                  'assets/images/Ellipse 82.png',
                  'assets/images/Ellipse 83.png',
                  'assets/images/Ellipse 81 (2).png',
                  'assets/images/Ellipse 82 (1).png',
                  'assets/images/Ellipse 833.png',
                ];

                return Stack(
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        imagePaths[index],
                        width: 105.w,
                        height: 105.h,
                      ),
                    ),
                    if (showCloseIcon)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          radius: 15.r,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      )
                    else if (showCheckIcon)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          radius: 15.r,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 210.h),
          Text(
            "Maintain image quality",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Capture the full body if possible. The head must be \nvisible.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.white,),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage4 extends StatelessWidget {
  const OnboardingPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(32.r),
      child: Column(
        children: [
           SizedBox(height: 60.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 212.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: Image.asset(
                          'assets/images/Rectangle 3194.png',
                          height: 230.h,
                          width: 142.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: Image.asset(
                              'assets/images/Rectangle 3197.png',
                              width: 95.w,
                              height: 95.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: Image.asset(
                              'assets/images/Rectangle 3194.png',
                              width: 95.w,
                              height: 95.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: Image.asset(
                                'assets/images/Rectangle 3195.png',
                                width: 95.w,
                                height: 95.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: Image.asset(
                                'assets/images/Rectangle 3196.png',
                                width: 95.w,
                                height: 95.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: 370.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: AspectRatio(
                      aspectRatio: 3.5,
                      child: Image.asset(
                        'assets/images/Rectangle 319.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 210.h),
          Text(
            "Ensure your dog stays \n healthy and active.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Manage every detail of your dog—health, photos,\n activities, and more in one simple place.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.white,),
          ),
        ],
      ),
    );
  }
}
