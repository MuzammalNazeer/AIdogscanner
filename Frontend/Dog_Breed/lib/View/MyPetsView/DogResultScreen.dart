// lib/View/MyPetsView/DogResultScreen.dart

import 'dart:io';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DogResultScreen extends StatefulWidget {
  final File imageFile;

  const DogResultScreen({super.key, required this.imageFile});

  @override
  State<DogResultScreen> createState() => _DogResultScreenState();
}

class _DogResultScreenState extends State<DogResultScreen> {
  int _selectedTab = 0;

  final String _summaryText = '''
People have been breeding dogs since prehistoric times. The earliest dog breeders used wolves to create domestic dogs. From the beginning, humans purposefully bred dogs to perform various tasks. Hunting, guarding, and herding are thought to be among the earliest jobs eagerly performed by the animal destined to be called “man’s best friend.”
For thousands of years, humans bred dogs toward the physical and mental traits best suited for the work expected of them. The sleek Greyhound types bred to chase fleet-footed prey, and the huge mastiff types used as guard dogs and warriors, are two ancient examples of dogs bred for specific jobs.
''';
  final String _summaryText1 = '''
On average, there is a chance of 70-10% to correctly classify a pure breed Shih Tzu.
Once the app identified one, the prediction is correct with a likelihood of 70-10%.
The breed will be listed as one of the possible results with an accuracy of 90.72%.
''';
  final String _descriptionText = '''
The Shih Tzu is a small but sturdy toy dog breed known for its long, flowing double coat and distinctively sweet and playful temperament. Originally bred as companion dogs for Chinese royalty, they make excellent family pets and adapt well to various living situations.

Key Characteristics:
• Size: Small, typically 9-16 pounds
• Coat: Long, luxurious double coat requiring regular grooming
• Temperament: Affectionate, outgoing, alert, and lively
• Energy Level: Moderate - enjoys playtime but also loves to cuddle
• Lifespan: 10-16 years with proper care

Care Requirements:
• Daily brushing to prevent matting
• Regular professional grooming every 4-6 weeks
• Moderate exercise needs - short walks and indoor play
• Regular dental care due to small mouth structure
• Socialization from early age for well-rounded behavior

The Shih Tzu's friendly nature and adaptable size make them wonderful companions for families, singles, and seniors alike.
''';

  void _shareResults() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing dog identification results...'),
        duration: Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                        'Dog Results',
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
              SizedBox(height: 26.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    // Circular Dog Photo
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF9B59B6),
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.file(
                          widget.imageFile,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.pets,
                                size: 40.sp,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(width: 20.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shih Tzu',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'The dog you scanned looks',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '99.0%',
                            style: TextStyle(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF9B59B6),
                            ),
                          ),
                          Text(
                            'like Shih Tzu',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: _shareResults,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.share,
                                  color: const Color(0xFF9B59B6),
                                  size: 18.sp,
                                ),
                                SizedBox(width: 6.w),
                                GestureDetector(
                                  onTap: (){},
                                  child: Text(
                                    'Share',
                                    style: TextStyle(
                                      color: const Color(0xFF9B59B6),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
                children: List.generate(
                  4,
                  (_) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              RoundButton(
                  title: 'See more photos',
                  isSelected: true,
                  textColors: AppColors.vibrantPurple,
                  backgroundColors: AppColors.backgroundGreen,
                  onPress: (){}
              ),
              SizedBox(height: 21.h),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTab('Breed Standard', 0),
                    _buildTab('Summary', 1),
                    _buildTab('Description', 2),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              _buildContent(),
              SizedBox(height: 30.h),
              RoundButton(
                  title: 'Save Results',
                  isSelected: true,
                  textColors: AppColors.white,
                  backgroundColors: AppColors.vibrantPurple,
                  onPress: (){}
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: _selectedTab == index
              ?  Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: _selectedTab == index ? AppColors.vibrantPurple : AppColors.grayColor,
            fontWeight: _selectedTab == index
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Breed Standards',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.vibrantPurple,
              ),
            ),
            SizedBox(height: 15.h),
            _buildBreedInfoItem(
              'Fédération Cynologique Internationale (FCI)',
              'Number 208',
            ),
            _buildBreedInfoItem('Group', '9 Companion and Toy Dogs'),
            _buildBreedInfoItem('Section', '5.0 Tibetan Breeds'),
            _buildBreedInfoItem('American Kennel Club (AKC)', 'Toy Group'),
            _buildBreedInfoItem(
              'Australian National Kennel Council (ANKC)',
              'Group 7 (Non-Sporting)',
            ),
            _buildBreedInfoItem(
              'Canadian Kennel Club (CKC)',
              'Group 6 - Non-Sporting',
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.vibrantPurple,
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              child: Text(
                _summaryText,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              'How Accurate is this app in general?',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.vibrantPurple,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              child: Text(
                _summaryText1,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
            ),

          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.vibrantPurple,
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              child: Text(
                _descriptionText,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildBreedInfoItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.vibrantPurple,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(fontSize: 15.sp, color: Colors.grey[700]),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

// // lib/View/MyPetsView/DogResultScreen.dart
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class DogResultScreen extends StatelessWidget {
//   final File imageFile;
//
//   const DogResultScreen({super.key, required this.imageFile});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Top Bar
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: Icon(Icons.arrow_back_ios, size: 22.sp),
//                   ),
//                   Text(
//                     'Dog Results',
//                     style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 20.h),
//
//               // Main Result Card
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(20.w),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[50],
//                   borderRadius: BorderRadius.circular(20.r),
//                   border: Border.all(color: const Color(0xFF9B59B6), width: 4),
//                 ),
//                 child: Row(
//                   children: [
//                     // Circular Dog Photo
//                     Container(
//                       width: 110.w,
//                       height: 110.h,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: const Color(0xFF9B59B6), width: 5),
//                       ),
//                       child: ClipOval(
//                         child: Image.file(imageFile, fit: BoxFit.cover),
//                       ),
//                     ),
//
//                     SizedBox(width: 20.w),
//
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Shih Tzu', style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold)),
//                           Text('The dog you scanned looks', style: TextStyle(fontSize: 16.sp)),
//                           Text('99.0%', style: TextStyle(fontSize: 38.sp, fontWeight: FontWeight.bold, color: const Color(0xFF9B59B6))),
//                           Text('like Shih Tzu', style: TextStyle(fontSize: 18.sp)),
//                           SizedBox(height: 10.h),
//                           Row(
//                             children: [
//                               Icon(Icons.share, color: Colors.grey[700]),
//                               SizedBox(width: 8.w),
//                               Text('Share', style: TextStyle(color: Colors.grey[700])),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               SizedBox(height: 25.h),
//
//               // Similar Photos
//               GridView.count(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisCount: 4,
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 childAspectRatio: 1,
//                 children: List.generate(4, (_) => Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.grey[300],
//                   ),
//                 )),
//               ),
//
//               Center(
//                 child: TextButton(
//                   onPressed: () {},
//                   child: Text('See more photos', style: TextStyle(color: const Color(0xFF9B59B6), fontSize: 16.sp)),
//                 ),
//               ),
//
//               SizedBox(height: 20.h),
//
//               // Tabs
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 14.h),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(30.r),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: ['Breed Standard', 'Summary', 'Description']
//                       .map((e) => Text(e, style: TextStyle(fontSize: 15.sp)))
//                       .toList(),
//                 ),
//               ),
//
//               SizedBox(height: 25.h),
//
//               // Breed Info
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _infoRow('Fédération Cynologique Internationale (FCI)', 'Number 208'),
//                   _infoRow('Group', '9 Companion and Toy Dogs'),
//                   _infoRow('Section', '5.0 Tibetan Breeds'),
//                   _infoRow('American Kennel Club (AKC)', 'Toy Group'),
//                   _infoRow('Australian National Kennel Council (ANKC)', 'Group 07 (Non-Sporting)'),
//                 ],
//               ),
//
//               SizedBox(height: 40.h),
//
//               // Save Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF9B59B6),
//                     padding: EdgeInsets.symmetric(vertical: 20.h),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
//                   ),
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Saved to My Pets!')),
//                     );
//                     Navigator.popUntil(context, (route) => route.isFirst);
//                   },
//                   child: Text('Save Results', style: TextStyle(fontSize: 20.sp, color: Colors.white)),
//                 ),
//               ),
//
//               SizedBox(height: 30.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _infoRow(String title, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: RichText(
//         text: TextSpan(
//           style: TextStyle(fontSize: 16.sp, color: Colors.black87),
//           children: [
//             TextSpan(text: '$title\n', style: const TextStyle(fontWeight: FontWeight.bold)),
//             TextSpan(text: value, style: TextStyle(color: Colors.grey[700])),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // // lib/View/MyPetsView/DogResultScreen.dart
// //
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// //
// // class DogResultScreen extends StatelessWidget {
// //   final File imageFile;
// //
// //   const DogResultScreen({super.key, required this.imageFile});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.symmetric(horizontal: 20.w),
// //           child: Column(
// //             children: [
// //               SizedBox(height: 10.h),
// //
// //               // Top Bar
// //               Row(
// //                 children: [
// //                   IconButton(
// //                     icon: Icon(Icons.arrow_back_ios, size: 22.sp),
// //                     onPressed: () => Navigator.pop(context),
// //                   ),
// //                   Text(
// //                     'Dog Results',
// //                     style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
// //                   ),
// //                 ],
// //               ),
// //
// //               SizedBox(height: 20.h),
// //
// //               // Main Result Card
// //               Container(
// //                 padding: EdgeInsets.all(20.w),
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[50],
// //                   borderRadius: BorderRadius.circular(20.r),
// //                   border: Border.all(color: const Color(0xFF9B59B6), width: 4),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Container(
// //                       width: 110.w,
// //                       height: 110.h,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         border: Border.all(color: const Color(0xFF9B59B6), width: 5),
// //                       ),
// //                       child: ClipOval(
// //                         child: Image.file(imageFile, fit: BoxFit.cover),
// //                       ),
// //                     ),
// //                     SizedBox(width: 20.w),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text('Shih Tzu', style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold)),
// //                           Text('The dog you scanned looks', style: TextStyle(fontSize: 16.sp)),
// //                           Text('99.0%', style: TextStyle(fontSize: 38.sp, fontWeight: FontWeight.bold, color: const Color(0xFF9B59B6))),
// //                           Text('like Shih Tzu', style: TextStyle(fontSize: 18.sp)),
// //                           SizedBox(height: 10.h),
// //                           Row(
// //                             children: [
// //                               Icon(Icons.share, color: Colors.grey[700]),
// //                               SizedBox(width: 8.w),
// //                               Text('Share', style: TextStyle(color: Colors.grey[700])),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //
// //               SizedBox(height: 20.h),
// //
// //               // Similar Photos
// //               GridView.count(
// //                 shrinkWrap: true,
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 crossAxisCount: 4,
// //                 mainAxisSpacing: 10,
// //                 crossAxisSpacing: 10,
// //                 childAspectRatio: 1,
// //                 children: List.generate(4, (_) => Container(
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(12),
// //                     color: Colors.grey[300],
// //                   ),
// //                 )),
// //               ),
// //
// //               TextButton(
// //                 onPressed: () {},
// //                 child: Text('See more photos', style: TextStyle(color: const Color(0xFF9B59B6), fontSize: 16.sp)),
// //               ),
// //
// //               SizedBox(height: 20.h),
// //
// //               // Tabs
// //               Container(
// //                 padding: EdgeInsets.symmetric(vertical: 14.h),
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[100],
// //                   borderRadius: BorderRadius.circular(30.r),
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: ['Breed Standard', 'Summary', 'Description']
// //                       .map((e) => Text(e, style: TextStyle(fontSize: 15.sp)))
// //                       .toList(),
// //                 ),
// //               ),
// //
// //               SizedBox(height: 20.h),
// //
// //               // Breed Info
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _infoRow('Fédération Cynologique Internationale (FCI)', 'Number 208'),
// //                   _infoRow('Group', '9 Companion and Toy Dogs'),
// //                   _infoRow('Section', '5.0 Tibetan Breeds'),
// //                   _infoRow('American Kennel Club (AKC)', 'Toy Group'),
// //                   _infoRow('Australian National Kennel Council (ANKC)', 'Group 07 (Non-Sporting)'),
// //                 ],
// //               ),
// //
// //               SizedBox(height: 40.h),
// //
// //               // Save Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFF9B59B6),
// //                     padding: EdgeInsets.symmetric(vertical: 20.h),
// //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
// //                   ),
// //                   onPressed: () {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(content: Text('Saved to My Pets!')),
// //                     );
// //                     Navigator.popUntil(context, (route) => route.isFirst);
// //                   },
// //                   child: Text('Save Results', style: TextStyle(fontSize: 20.sp, color: Colors.white)),
// //                 ),
// //               ),
// //
// //               SizedBox(height: 30.h),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _infoRow(String title, String value) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(vertical: 8.h),
// //       child: RichText(
// //         text: TextSpan(
// //           style: TextStyle(fontSize: 16.sp, color: Colors.black87),
// //           children: [
// //             TextSpan(text: '$title\n', style: const TextStyle(fontWeight: FontWeight.bold)),
// //             TextSpan(text: value, style: TextStyle(color: Colors.grey[700])),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
