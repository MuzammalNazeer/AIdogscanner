
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../View_model/activity_provider.dart';
import '../../activity_model.dart';
import 'allActivityView.dart';
import 'package:dog_breed/Valid/ActivityConstants.dart';
import 'package:dog_breed/l10n/app_localizations.dart';

class AddActivitiesView extends StatefulWidget {
  final String? initialActivityName;
  final DateTime? initialDate;
  final String? selectedPetId;

  const AddActivitiesView({
    super.key,
    this.initialActivityName,
    this.initialDate,
    this.selectedPetId,
  });

  @override
  State<AddActivitiesView> createState() => _AddActivitiesViewState();
}

class _AddActivitiesViewState extends State<AddActivitiesView> {
  Activity? _selectedActivity;

  final List<Activity> _activities = ActivityConstants.allActivities
      .map((e) => Activity(
    name: e.name,
    imagePath: e.image,
    color: e.color,
    dateTime: DateTime.now(),
  ))
      .toList();

  @override
  void initState() {
    super.initState();

    // Auto-select activity if passed from home screen
    if (widget.initialActivityName != null) {
      try {
        _selectedActivity = _activities.firstWhere(
              (a) => a.name.toLowerCase() == widget.initialActivityName!.toLowerCase(),
          orElse: () => _activities[0], // fallback
        );
      } catch (e) {
        // not found → no selection
      }
    }
  }

  String _getLocalizedActivityName(BuildContext context, String name) {
    final localizations = AppLocalizations.of(context)!;
    switch (name) {
      case 'Veterinary': return localizations.activityVeterinary;
      case 'Pee': return localizations.activityPee;
      case 'Eat': return localizations.activityEat;
      case 'Drink': return localizations.activityDrink;
      case 'Play': return localizations.activityPlay;
      case 'Poop': return localizations.activityPoop;
      case 'Walk': return localizations.activityWalk;
      case 'Crate': return localizations.activityCrate;
      case 'Sleep': return localizations.activitySleep;
      case 'Training': return localizations.activityTraining;
      case 'Treat': return localizations.activityTreat;
      case 'Grooming': return localizations.activityGrooming;
      case 'Cleaning': return localizations.activityCleaning;
      case 'Medication': return localizations.activityMedication;
      case 'Vaccination': return localizations.activityVaccination;
      case 'Weight': return localizations.activityWeight;
      case 'Height': return localizations.activityHeight;
      case 'Temperature': return localizations.activityTemperature;
      case 'Health Condition': return localizations.activityHealthCondition;
      case 'Accident': return localizations.activityAccident;
      case 'Journal': return localizations.activityJournal;
      default: return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityNotifier = Provider.of<ActivityNotifier>(context);

    // Filter activities based on visibility settings
    final visibleActivities = _activities.where((activity) {
      return activityNotifier.isActivityVisible(widget.selectedPetId, activity.name);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
               Center(
                child: Text(
                  AppLocalizations.of(context)!.calendarAddActivity,
                  style: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 17.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: visibleActivities.length,
                    itemBuilder: (context, index) {
                      final activity = visibleActivities[index];
                      final isSelected = _selectedActivity?.name == activity.name;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedActivity = activity;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Allactivityview(
                                selectedActivity: activity,
                                initialDate: widget.initialDate,
                                selectedPetId: widget.selectedPetId,
                              ),
                            ),
                          ).then((_) {

                          });
                        },
                        child: _ActivityCard(
                          activity: activity,
                          isSelected: isSelected,
                          activityName: _getLocalizedActivityName(context, activity.name),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 12.h),

            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool isSelected;
  final String activityName;

  const _ActivityCard({
    required this.activity,
    required this.isSelected,
    required this.activityName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 90.w,
          height: 70.h,
          decoration: BoxDecoration(
            color: activity.color,
            borderRadius: BorderRadius.circular(10.r),
            border: isSelected
                ? Border.all(color: Colors.red, width: 3.w)
                : null,
          ),
          child: Center(
            child: Image.asset(
              activity.imagePath,
              width: 42.w,
              height: 42.h,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.pets,
                  size: 32.w,
                  color: Colors.grey[600],
                );
              },
            ),
          ),
        ),
        SizedBox(height: 11.h),
        Text(
          activityName,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: isSelected ? const Color(0xFF820DFF) : Colors.black87,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}


// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/activity_provider.dart';
// import '../../activity_model.dart';
// import 'allActivityView.dart';
//
// class AddActivitiesView extends StatefulWidget {
//   final String? initialActivityName;
//   final DateTime? initialDate;
//   final String? selectedPetId;
//
//   const AddActivitiesView({
//     super.key,
//     this.initialActivityName,
//     this.initialDate,
//     this.selectedPetId,
//   });
//
//   @override
//   State<AddActivitiesView> createState() => _AddActivitiesViewState();
// }
//
// class _AddActivitiesViewState extends State<AddActivitiesView> {
//   Activity? _selectedActivity;
//
//   final List<Activity> _activities = [
//     Activity(name: 'Veterinary', imagePath: 'assets/images/61.png', color: const Color(0xFFB9E6FF), dateTime: DateTime.now()),
//     Activity(name: 'Pee', imagePath: 'assets/images/62.png', color: const Color(0xFFFFD6C9), dateTime: DateTime.now()),
//     Activity(name: 'Eat', imagePath: 'assets/images/63.png', color: const Color(0xFFFFE3B9), dateTime: DateTime.now()),
//     Activity(name: 'Drink', imagePath: 'assets/images/64.png', color: const Color(0xFFB9DFFF), dateTime: DateTime.now()),
//     Activity(name: 'Play', imagePath: 'assets/images/65.png', color: const Color(0xFFC5F9FF), dateTime: DateTime.now()),
//     Activity(name: 'Poop', imagePath: 'assets/images/66.png', color: const Color(0xFFFFDEC5), dateTime: DateTime.now()),
//     Activity(name: 'Walk', imagePath: 'assets/images/67.png', color: const Color(0xFFF2F2F2), dateTime: DateTime.now()),
//     Activity(name: 'Crate', imagePath: 'assets/images/68.png', color: const Color(0xFFFFCFC7), dateTime: DateTime.now()),
//     Activity(name: 'Sleep', imagePath: 'assets/images/69.png', color: const Color(0xFFFFDDC2), dateTime: DateTime.now()),
//     Activity(name: 'Training', imagePath: 'assets/images/70.png', color: const Color(0xFFFFF1C2), dateTime: DateTime.now()),
//     Activity(name: 'Treat', imagePath: 'assets/images/71.png', color: const Color(0xFFFFEBD3), dateTime: DateTime.now()),
//     Activity(name: 'Grooming', imagePath: 'assets/images/72.png', color: const Color(0xFFD0FAFF), dateTime: DateTime.now()),
//     Activity(name: 'Cleaning', imagePath: 'assets/images/73.png', color: const Color(0xFFFFCFD5), dateTime: DateTime.now()),
//     Activity(name: 'Medication', imagePath: 'assets/images/74.png', color: const Color(0xFFFFEBEE), dateTime: DateTime.now()),
//     Activity(name: 'Vaccination', imagePath: 'assets/images/75.png', color: const Color(0xFFFFEAE3), dateTime: DateTime.now()),
//     Activity(name: 'Weight', imagePath: 'assets/images/76.png', color: const Color(0xFFD2F3FF), dateTime: DateTime.now()),
//     Activity(name: 'Height', imagePath: 'assets/images/77.png', color: const Color(0xFFEAD8D5), dateTime: DateTime.now()),
//     Activity(name: 'Temperature', imagePath: 'assets/images/78.png', color: const Color(0xFFE0EEFF), dateTime: DateTime.now()),
//     Activity(name: 'Health Condition', imagePath: 'assets/images/79.png', color: const Color(0xFFFFE7C0), dateTime: DateTime.now()),
//     Activity(name: 'Accident', imagePath: 'assets/images/80.png', color: const Color(0xFFFDFFD9), dateTime: DateTime.now()),
//     Activity(name: 'Journal', imagePath: 'assets/images/81.png', color: const Color(0xFFFFD5CA), dateTime: DateTime.now()),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Auto-select activity if passed from home screen
//     if (widget.initialActivityName != null) {
//       try {
//         _selectedActivity = _activities.firstWhere(
//               (a) => a.name.toLowerCase() == widget.initialActivityName!.toLowerCase(),
//           orElse: () => _activities[0], // fallback
//         );
//       } catch (e) {
//         // not found → no selection
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final activityNotifier = Provider.of<ActivityNotifier>(context);
//
//     // Filter activities based on visibility settings
//     final visibleActivities = _activities.where((activity) {
//       return activityNotifier.isActivityVisible(activity.name);
//     }).toList();
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SafeArea(
//           child: Column(
//             children: [
//               const Center(
//                 child: Text(
//                   "Add Activity",
//                   style: TextStyle(
//                     color: Color(0xFF000000),
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 4,
//                       crossAxisSpacing: 17.w,
//                       mainAxisSpacing: 10.h,
//                       childAspectRatio: 0.8,
//                     ),
//                     itemCount: visibleActivities.length,
//                     itemBuilder: (context, index) {
//                       final activity = visibleActivities[index];
//                       final isSelected = _selectedActivity?.name == activity.name;
//
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _selectedActivity = activity;
//                           });
//
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => Allactivityview(
//                                 selectedActivity: activity,
//                                 initialDate: widget.initialDate,
//                                 selectedPetId: widget.selectedPetId,
//                               ),
//                             ),
//                           ).then((_) {
//
//                           });
//                         },
//                         child: _ActivityCard(
//                           activity: activity,
//                           isSelected: isSelected,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(height: 12.h),
//               RoundButton(
//                 title: '+ Add more activities',
//                 isSelected: true,
//                 textColors: const Color(0xFFFFFFFF),
//                 backgroundColors: const Color(0xFF820DFF),
//                 onPress: () {
//                   // TODO: Implement custom activity addition
//                 },
//               ),
//               SizedBox(height: 16.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _ActivityCard extends StatelessWidget {
//   final Activity activity;
//   final bool isSelected;
//
//   const _ActivityCard({
//     required this.activity,
//     required this.isSelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 90.w,
//           height: 70.h,
//           decoration: BoxDecoration(
//             color: activity.color,
//             borderRadius: BorderRadius.circular(10.r),
//             border: isSelected
//                 ? Border.all(color: Colors.red, width: 3.w)
//                 : null,
//           ),
//           child: Center(
//             child: Image.asset(
//               activity.imagePath,
//               width: 42.w,
//               height: 42.h,
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 return Icon(
//                   Icons.pets,
//                   size: 32.w,
//                   color: Colors.grey[600],
//                 );
//               },
//             ),
//           ),
//         ),
//         SizedBox(height: 11.h),
//         Text(
//           activity.name,
//           style: TextStyle(
//             fontSize: 10.sp,
//             fontWeight: FontWeight.bold,
//             color: isSelected ? const Color(0xFF820DFF) : Colors.black87,
//           ),
//           textAlign: TextAlign.center,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     );
//   }
// }
