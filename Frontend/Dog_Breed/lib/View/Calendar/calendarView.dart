import 'dart:typed_data';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/View/Calendar/AddReminderView.dart';
import 'package:dog_breed/View/MyPetsView/addPetView.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:dog_breed/View_model/home/home_view_model.dart';
import '../../View_model/ReminderNotifier.dart';
import '../../View_model/activity_provider.dart';
import '../../View_model/PetProvider.dart';
import '../../View_model/home/Pet.dart';
import '../../activity_model.dart';
import '../../config/components/DocumentsScreen.dart';
import '../../config/components/DrinkScreen.dart';
import '../../config/components/OtherCalculatorWidget.dart';
import 'add_activities_View.dart';
import 'allActivityView.dart';

class Calendarview extends StatefulWidget {
  final void Function(String message)? onShowSnackBar;

  const Calendarview({super.key, this.onShowSnackBar});

  @override
  State<Calendarview> createState() => _CalendarviewState();
}

class _CalendarviewState extends State<Calendarview> {
  int _selectedProgressTab = 0; // 0: Calendar, 1: Chart, 2: Compare
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  String? _selectedPetId;
  List<String> get tabs => [
    AppLocalizations.of(context)!.calendarTabActivities,
    AppLocalizations.of(context)!.calendarTabReminders,
    AppLocalizations.of(context)!.calendarTabProgress,
    AppLocalizations.of(context)!.calendarTabDocuments,
    AppLocalizations.of(context)!.calendarTabSettings,
  ];

  List<Map<String, dynamic>> get _allActivityTypes => [
    {
      'key': 'Veterinary',
      'name': AppLocalizations.of(context)!.activityVeterinary,
      'image': 'assets/images/Veterinary.png',
      'color': const Color(0xFFB9E6FF),
    },
    {
      'key': 'Pee',
      'name': AppLocalizations.of(context)!.activityPee,
      'image': 'assets/images/62.png',
      'color': const Color(0xFFFFD6C9),
    },
    {
      'key': 'Eat',
      'name': AppLocalizations.of(context)!.activityEat,
      'image': 'assets/images/image 1556.png',
      'color': const Color(0xFFFFE3B9),
    },
    {
      'key': 'Drink',
      'name': AppLocalizations.of(context)!.activityDrink,
      'image': 'assets/images/drink.png',
      'color': const Color(0xFFB9DFFF),
    },
    {
      'key': 'Play',
      'name': AppLocalizations.of(context)!.activityPlay,
      'image': 'assets/images/play.png',
      'color': const Color(0xFFC5F9FF),
    },
    {
      'key': 'Poop',
      'name': AppLocalizations.of(context)!.activityPoop,
      'image': 'assets/images/poop.png',
      'color': const Color(0xFFFFDEC5),
    },
    {
      'key': 'Walk',
      'name': AppLocalizations.of(context)!.activityWalk,
      'image': 'assets/images/walk1.png',
      'color': const Color(0xFFF2F2F2),
    },
    {
      'key': 'Crate',
      'name': AppLocalizations.of(context)!.activityCrate,
      'image': 'assets/images/crate.png',
      'color': const Color(0xFFFFCFC7),
    },
    {
      'key': 'Sleep',
      'name': AppLocalizations.of(context)!.activitySleep,
      'image': 'assets/images/sleep.png',
      'color': const Color(0xFFFFDDC2),
    },
    {
      'key': 'Training',
      'name': AppLocalizations.of(context)!.activityTraining,
      'image': 'assets/images/training.png',
      'color': const Color(0xFFFFF1C2),
    },
    {
      'key': 'Treat',
      'name': AppLocalizations.of(context)!.activityTreat,
      'image': 'assets/images/treat.png',
      'color': const Color(0xFFFFEBD3),
    },
    {
      'key': 'Grooming',
      'name': AppLocalizations.of(context)!.activityGrooming,
      'image': 'assets/images/grooming.png',
      'color': const Color(0xFFD0FAFF),
    },
    {
      'key': 'Cleaning',
      'name': AppLocalizations.of(context)!.activityCleaning,
      'image': 'assets/images/73.png',
      'color': const Color(0xFFFFCFD5),
    },
    {
      'key': 'Medication',
      'name': AppLocalizations.of(context)!.activityMedication,
      'image': 'assets/images/medi.png',
      'color': const Color(0xFFFFEBEE),
    },
    {
      'key': 'Vaccination',
      'name': AppLocalizations.of(context)!.activityVaccination,
      'image': 'assets/images/vacc.png',
      'color': const Color(0xFFFFEAE3),
    },
    {
      'key': 'Weight',
      'name': AppLocalizations.of(context)!.activityWeight,
      'image': 'assets/images/weight.png',
      'color': const Color(0xFFD2F3FF),
    },
    {
      'key': 'Height',
      'name': AppLocalizations.of(context)!.activityHeight,
      'image': 'assets/images/height.png',
      'color': const Color(0xFFEAD8D5),
    },
    {
      'key': 'Temperature',
      'name': AppLocalizations.of(context)!.activityTemperature,
      'image': 'assets/images/temp.png',
      'color': const Color(0xFFE0EEFF),
    },
    {
      'key': 'Health Condition',
      'name': AppLocalizations.of(context)!.activityHealthCondition,
      'image': 'assets/images/healt.png',
      'color': const Color(0xFFFFE7C0),
    },
    {
      'key': 'Accident',
      'name': AppLocalizations.of(context)!.activityAccident,
      'image': 'assets/images/healt.png',
      'color': const Color(0xFFFDFFD9),
    },
    {
      'key': 'Journal',
      'name': AppLocalizations.of(context)!.activityJournal,
      'image': 'assets/images/jour.png',
      'color': const Color(0xFFFFD5CA),
    },
  ];

  bool isDefault = false;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _loadSelectedProgressTab();
    _loadSelectedPetId();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  Future<void> _loadSelectedPetId() async {
    final prefs = await SharedPreferences.getInstance();
    
    // If _selectedPetId is already set (e.g. by didChangeDependencies from navigation),
    // do NOT overwrite it with the old value from SharedPreferences.
    if (_selectedPetId != null) {
      return;
    }

    final savedPetId = prefs.getString('selectedPetId');

    final petProvider = Provider.of<PetProvider>(context, listen: false);

    // Optimistically set the selected pet ID from preferences
    if (savedPetId != null) {
      setState(() {
        _selectedPetId = savedPetId;
      });
    }

    if (petProvider.hasPets) {
      // If we have a saved ID, check if it's valid
      final isValid = savedPetId != null &&
          petProvider.pets.any((p) => p.id == savedPetId);

      // If no saved ID or it's invalid, fallback to the first pet
      if (!isValid) {
        setState(() {
          _selectedPetId = petProvider.pets.first.id;
        });
        await prefs.setString('selectedPetId', _selectedPetId!);
      }
    }
    // Note: We do NOT clear the preference if !hasPets, because PetProvider
    // might still be loading. We wait for it to populate.
  }
  Future<void> _saveSelectedPetId(String? petId) async {
    final prefs = await SharedPreferences.getInstance();
    if (petId != null && petId.isNotEmpty) {
      await prefs.setString('selectedPetId', petId);
    } else {
      await prefs.remove('selectedPetId');
    }
  }


  // Future<void> _loadSelectedPetId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final savedPetId = prefs.getString('selectedPetId');
  //   final petProvider = Provider.of<PetProvider>(context, listen: false);
  //
  //   if (petProvider.hasPets) {
  //     // If saved ID exists and is still valid → keep it
  //     if (savedPetId != null && petProvider.pets.any((p) => p.id == savedPetId)) {
  //       setState(() {
  //         _selectedPetId = savedPetId;
  //       });
  //     }
  //     // If no saved ID or saved ID is invalid → auto-select first pet
  //     else {
  //       setState(() {
  //         _selectedPetId = petProvider.pets.first.id;
  //       });
  //       await prefs.setString('selectedPetId', _selectedPetId!);
  //     }
  //   } else {
  //     // No pets → clear any old saved value
  //     setState(() {
  //       _selectedPetId = null;
  //     });
  //     await prefs.remove('selectedPetId');
  //   }
  // }
  //
  // Future<void> _saveSelectedPetId(String? petId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (petId != null && petId.isNotEmpty) {
  //     await prefs.setString('selectedPetId', petId);
  //   } else {
  //     await prefs.remove('selectedPetId');
  //   }
  // }

  Future<void> _loadSelectedProgressTab() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _selectedProgressTab = prefs.getInt('selectedProgressTab') ?? 0;
      });
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate() {
    if (_scrollController == null || !_scrollController!.hasClients) return;
    final days = _getDaysInMonth(_currentMonth);
    final selectedIndex = days.indexWhere(
          (date) =>
      date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day,
    );
    if (selectedIndex == -1) return;
    final double itemWidth = 70.w + 12.w;
    final double viewportWidth = MediaQuery.of(context).size.width - 16.w;
    final double targetOffset =
        selectedIndex * itemWidth - (viewportWidth - itemWidth) / 2;
    final double maxScrollExtent = _scrollController!.position.maxScrollExtent;
    final double offset = targetOffset.clamp(0.0, maxScrollExtent);
    _scrollController!.animateTo(
      offset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final _ = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final days = <DateTime>[];
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }
    return days;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final petProvider = Provider.of<PetProvider>(context);
    if (petProvider.lastAddedPetId != null) {
      _selectedPetId = petProvider.lastAddedPetId;
      _saveSelectedPetId(_selectedPetId);
      petProvider.clearLastAddedPetId();
    }

    final homeViewModel = Provider.of<HomeViewModel>(context);
    if (homeViewModel.selectedPetId != null) {
      _selectedPetId = homeViewModel.selectedPetId;
      _saveSelectedPetId(_selectedPetId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (homeViewModel.selectedPetId != null) {
          homeViewModel.setSelectedPetId(null);
        }
      });
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
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final int selectedTab = homeViewModel.calendarTabIndex;
    final bool shouldShowCalendar = selectedTab == 0 || selectedTab == 1;
    final _ = DateTime.now();
    final activityNotifier = Provider.of<ActivityNotifier>(context);
    final petProvider = Provider.of<PetProvider>(context);
    final effectivePetId = _selectedPetId;

    // Get ALL activities for the selected pet
    final allActivities = activityNotifier.activities
        .where((activity) => effectivePetId == null || activity.petId == effectivePetId)
        .toList();

    // Filter activities based on selected tab
    List<Activity> filteredActivities;

    if (selectedTab == 0) {
      // Tab 0: Activities - Show only non-reminder activities for selected date
      filteredActivities = allActivities
          .where((activity) {
        return !activity.hasReminder && // EXCLUDE reminders
            activity.dateTime.year == _selectedDate.year &&
            activity.dateTime.month == _selectedDate.month &&
            activity.dateTime.day == _selectedDate.day;
      })
          .toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } else if (selectedTab == 2 || selectedTab == 3 || selectedTab == 4) {
      // Tabs 2,3,4: Progress, Documents, Settings - Show activities for selected date
      filteredActivities = allActivities
          .where((activity) {
        return activity.dateTime.year == _selectedDate.year &&
            activity.dateTime.month == _selectedDate.month &&
            activity.dateTime.day == _selectedDate.day;
      })
          .toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } else {
      // For other tabs (like Reminders tab 1), return empty list
      filteredActivities = [];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                AppLocalizations.of(context)!.calendarManage,
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Horizontal Tabs
            SizedBox(
              height: 50.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                separatorBuilder: (_, __) => SizedBox(width: 24.w),
                itemBuilder: (context, index) {
                  final isSelected = selectedTab == index;
                  return GestureDetector(
                    onTap: () {
                      if (!petProvider.hasPets) {
                        _showNoPetsDialog(context);
                        return;
                      }
                      homeViewModel.calendarTabIndex = index;
                      if (index == 0 || index == 1) {
                        WidgetsBinding.instance.addPostFrameCallback(
                              (_) => _scrollToSelectedDate(),
                        );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tabs[index],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 41.w,
                            height: 3.h,
                            margin: EdgeInsets.only(top: 4.h),
                            decoration: const BoxDecoration(
                              color: Color(0xFF820DFF),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),
            if (selectedTab >= 0 && selectedTab <= 4) ...[
              _buildSelectedPetHeader(),
              SizedBox(height: 12.h),
            ],

            if (shouldShowCalendar) ...[
              // Calendar header and navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40.h,
                    width: 41.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7F6),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left, size: 28),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month - 1,
                            );
                            if (_selectedDate.month != _currentMonth.month) {
                              _selectedDate = DateTime(
                                _currentMonth.year,
                                _currentMonth.month,
                                1,
                              );
                            }
                          });
                          _scrollToSelectedDate();
                        },
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        DateFormat('MMMM yyyy', Localizations.localeOf(context).toString()).format(_currentMonth),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.calendarMonth,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF820DFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    height: 40.h,
                    width: 41.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7F6),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.chevron_right, size: 28),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month + 1,
                            );

                            if (_selectedDate.month != _currentMonth.month) {
                              _selectedDate = DateTime(
                                _currentMonth.year,
                                _currentMonth.month,
                                1,
                              );
                            }
                          });
                          _scrollToSelectedDate();
                        },
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Calendar days
              SizedBox(
                height: 100.h,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: _getDaysInMonth(_currentMonth).length,
                  itemBuilder: (context, index) {
                    final date = _getDaysInMonth(_currentMonth)[index];
                    final isSelected =
                        date.year == _selectedDate.year &&
                            date.month == _selectedDate.month &&
                            date.day == _selectedDate.day;
                    return GestureDetector(
                      onTap: () {
                        if (!petProvider.hasPets) {
                          _showNoPetsDialog(context);
                          return;
                        }
                        setState(() => _selectedDate = date);
                        _scrollToSelectedDate();
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 70.w,
                            margin: EdgeInsets.symmetric(horizontal: 6.w),
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF820DFF)
                                  : const Color(0xFFF4F7F6),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('MMM', Localizations.localeOf(context).toString()).format(date),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  DateFormat('EEE', Localizations.localeOf(context).toString()).format(date),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Consumer<ReminderNotifier>(
                            builder: (context, reminderNotifier, child) {
                              final count = reminderNotifier
                                  .getRemindersCountForDate(date, petId: effectivePetId);
                              if (count > 0) {
                                return Positioned(
                                  top: -1.h,
                                  right: 0,
                                  child: Container(
                                    width: 22.w,
                                    height: 22.h,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        count.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20.h),
            ],

            // Tab Content
            Expanded(child: _buildTabContent(filteredActivities, selectedTab)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(List<Activity> filteredActivities, int selectedTab) {
    final petProvider = Provider.of<PetProvider>(context);
    final effectivePetId = _selectedPetId ?? (petProvider.hasPets ? petProvider.pets.first.id : null);

    switch (selectedTab) {
      case 0: // Activities - Show only activities (no reminders)
        return _buildActivitiesList(filteredActivities);
      case 1: // Reminders - Show only reminders
        return AddReminderView(
          selectedPetId: effectivePetId,
          selectedDate: _selectedDate,
        );
      case 2: // Progress
        return _buildProgressList(filteredActivities);
      case 3: // Documents
        return DocumentsScreen(selectedPetId: effectivePetId);
      case 4: // Settings
        return _buildSettingList();
      default:
        return Center(child: Text(AppLocalizations.of(context)!.calendarComingSoon));
    }
  }

  Widget _buildActivitiesList(List<Activity> activities, {bool shrinkWrap = false, int? limit}) {
    final displayActivities = (limit != null && activities.length > limit)
        ? activities.sublist(0, limit)
        : activities;
    final hasActivities = displayActivities.isNotEmpty;
    final formattedDate = DateFormat('EEEE, MMMM d', Localizations.localeOf(context).toString()).format(_selectedDate);

    Widget content;
    if (hasActivities) {
      content = ListView.builder(
        shrinkWrap: shrinkWrap,
        physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
        itemCount: displayActivities.length,
        itemBuilder: (context, index) => _buildActivityCard(displayActivities[index], index),
      );
    } else {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/images136.png',
              width: 100.w,
              height: 110.h,
            ),
            SizedBox(height: 20.h),
            Text(
              AppLocalizations.of(context)!.calendarNoActivityLogged,
              style: TextStyle(fontSize: 20.sp, color: const Color(0xFF000000)),
            ),
            SizedBox(height: 8.h),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF878787)),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 70.h,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F6),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildHeaderIcon('assets/images/61.png'),
                    SizedBox(width: 5.w),
                    _buildHeaderIcon('assets/images/62.png'),
                    SizedBox(width: 5.w),
                    _buildHeaderIcon('assets/images/63.png'),
                    SizedBox(width: 5.w),
                    SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: Image.asset('assets/images/a2.png')
                    ),
                  ],
                ),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: () => _showAddActivitySheet(context),
                  child: Text(
                    AppLocalizations.of(context)!.calendarAddActivity,
                    style:  TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/add.svg',
                      width: 28.w,
                      height: 28.h,
                    ),
                    onPressed: () => _showAddActivitySheet(context),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 24.h),

        if (shrinkWrap) content else Expanded(child: content),
      ],
    );
  }

  Widget _buildProgressList(List<Activity> dailyActivities) {
    return Column(
      children: [
        Container(
          height: 50.h,
          color: const Color(0xFF820DFF),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressTabItem(AppLocalizations.of(context)!.progressTabCalendar, 0),
              _buildProgressTabItem(AppLocalizations.of(context)!.progressTabChart, 1),
              _buildProgressTabItem(AppLocalizations.of(context)!.progressTabCompare, 2),
            ],
          ),
        ),
        Expanded(child: _buildProgressContent(dailyActivities)),
      ],
    );
  }

  Widget _buildProgressTabItem(String title, int index) {
    final isSelected = _selectedProgressTab == index;
    return GestureDetector(
      onTap: () async {
        setState(() {
          _selectedProgressTab = index;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('selectedProgressTab', index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            SizedBox(height: 6.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isSelected ? 3.h : 0,
              width: 42.w,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressContent(List<Activity> dailyActivities) {
    switch (_selectedProgressTab) {
      case 0:
        return _buildProgressCalendarView(dailyActivities);
      case 1:
        return _buildProgressChartView(dailyActivities);
      case 2:
        return _buildProgressCompareView(dailyActivities);
      default:
        return _buildProgressCalendarView(dailyActivities);
    }
  }

  Widget _buildProgressChartView(List<Activity> dailyActivities) {
    final List<Map<String, dynamic>> progressItems = [
      {'key': 'Eat', 'title': AppLocalizations.of(context)!.activityEat, 'icon': 'assets/images/image 1556.png'},
      {'key': 'Pee', 'title': AppLocalizations.of(context)!.activityPee, 'icon': 'assets/images/62.png'},
      {'key': 'Drink', 'title': AppLocalizations.of(context)!.activityDrink, 'icon': 'assets/images/drink.png'},
      {'key': 'Poop', 'title': AppLocalizations.of(context)!.activityPoop, 'icon': 'assets/images/poop.png'},
      {'key': 'Walk', 'title': AppLocalizations.of(context)!.activityWalk, 'icon': 'assets/images/walk1.png'},
      {'key': 'Play', 'title': AppLocalizations.of(context)!.activityPlay, 'icon': 'assets/images/play.png'},
      {'key': 'Crate', 'title': AppLocalizations.of(context)!.activityCrate, 'icon': 'assets/images/crate.png'},
      {'key': 'Sleep', 'title': AppLocalizations.of(context)!.activitySleep, 'icon': 'assets/images/sleep.png'},
      {'key': 'Training', 'title': AppLocalizations.of(context)!.activityTraining, 'icon': 'assets/images/training.png'},
      {'key': 'Treat', 'title': AppLocalizations.of(context)!.activityTreat, 'icon': 'assets/images/treat.png'},
      {'key': 'Grooming', 'title': AppLocalizations.of(context)!.activityGrooming, 'icon': 'assets/images/grooming.png'},
      {'key': 'Cleaning', 'title': AppLocalizations.of(context)!.activityCleaning, 'icon': 'assets/images/73.png'},
      {'key': 'Medication', 'title': AppLocalizations.of(context)!.activityMedication, 'icon': 'assets/images/medi.png'},
      {'key': 'Vaccination', 'title': AppLocalizations.of(context)!.activityVaccination, 'icon': 'assets/images/vacc.png'},
      {'key': 'Weight', 'title': AppLocalizations.of(context)!.activityWeight, 'icon': 'assets/images/weight.png'},
      {'key': 'Height', 'title': AppLocalizations.of(context)!.activityHeight, 'icon': 'assets/images/height.png'},
      {'key': 'Temperature', 'title': AppLocalizations.of(context)!.activityTemperature, 'icon': 'assets/images/temp.png'},
      {'key': 'Health Condition', 'title': AppLocalizations.of(context)!.activityHealthCondition, 'icon': 'assets/images/healt.png'},
      {'key': 'Accident', 'title': AppLocalizations.of(context)!.activityAccident, 'icon': 'assets/images/acc.png'},
      {'key': 'Journal', 'title': AppLocalizations.of(context)!.activityJournal, 'icon': 'assets/images/jour.png'},
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: progressItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.2,
              ),
              itemBuilder: (context, index) {
                final item = progressItems[index];
                final String title = item['title'];
                final String key = item['key'];
                final String iconPath = item['icon'];

                final int count = dailyActivities
                    .where((a) => a.name.toLowerCase() == title.toLowerCase())
                    .length;

                return GestureDetector(
                  onTap: () {
                    final petProvider = Provider.of<PetProvider>(context, listen: false);
                    final effectivePetId = _selectedPetId ?? (petProvider.hasPets ? petProvider.pets.first.id : null);

                    if (key.toLowerCase() == 'drink') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DrinkScreen(initialTab: 2, selectedPetId: effectivePetId),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Othercalculatorwidget(
                            initialTab: 2,
                            activityTitle: title,
                            activityCount: count,
                            selectedPetId: effectivePetId,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                iconPath,
                                width: 28.w,
                                height: 28.h,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.pets,
                                      color: Colors.grey[400],
                                      size: 24.w,
                                    ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _getLocalizedActivityName(context, title),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              count.toString(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.black54,
                              size: 24.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCalendarView(List<Activity> dailyActivities) {
    final startOfWeek = _selectedDate.subtract(
      Duration(days: _selectedDate.weekday - 1),
    );
    final _ = List.generate(
      7,
          (index) => startOfWeek.add(Duration(days: index)),
    );

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.subtract(
                      const Duration(days: 1),
                    );
                    if (_selectedDate.month != _currentMonth.month) {
                      _currentMonth = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                      );
                    }
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToSelectedDate();
                  });
                },
              ),
              Text(
                DateFormat('MMMM d, y', Localizations.localeOf(context).toString()).format(_selectedDate),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.add(const Duration(days: 1));
                    if (_selectedDate.month != _currentMonth.month) {
                      _currentMonth = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                      );
                    }
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToSelectedDate();
                  });
                },
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: List.generate(24, (index) {
                final time = DateTime(2024, 1, 1, index, 0);
                final timeString = DateFormat('h a', Localizations.localeOf(context).toString()).format(time).toLowerCase();

                final activitiesInHour = dailyActivities
                    .where((a) => a.dateTime.hour == index)
                    .toList();

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 50.w,
                        child: Column(
                          children: [
                            Text(
                              timeString,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1.w, color: Colors.grey.shade200),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(height: 1, color: Colors.grey.shade200),
                            SizedBox(height: 20.h),
                            ...activitiesInHour
                                .map(
                                  (activity) => _buildTimelineActivityItem(activity),
                            )
                                .toList(),
                            if (activitiesInHour.isEmpty)
                              SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineActivityItem(Activity activity) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F6),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Image.asset(
            activity.imagePath,
            width: 24.w,
            height: 24.h,
            errorBuilder: (c, e, s) => Icon(Icons.pets, size: 24.w),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              _getLocalizedActivityName(context, activity.name),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            DateFormat('h:mm a', Localizations.localeOf(context).toString()).format(activity.dateTime),
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCompareView(List<Activity> dailyActivities) {
    final activityNotifier = Provider.of<ActivityNotifier>(context);
    final allActivities = activityNotifier.activities;

    DateTime startOfWeek = _selectedDate.subtract(
      Duration(days: _selectedDate.weekday - 1),
    );
    startOfWeek = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    endOfWeek = DateTime(
      endOfWeek.year,
      endOfWeek.month,
      endOfWeek.day,
      23,
      59,
      59,
    );

    final weeklyActivities = allActivities.where((activity) {
      return activity.dateTime.isAfter(
        startOfWeek.subtract(const Duration(seconds: 1)),
      ) &&
          activity.dateTime.isBefore(endOfWeek.add(const Duration(seconds: 1)));
    }).toList();

    Map<int, List<Activity>> groupedByDay = {};
    for (int i = 1; i <= 7; i++) {
      groupedByDay[i] = [];
    }

    for (var activity in weeklyActivities) {
      groupedByDay[activity.dateTime.weekday]?.add(activity);
    }

    List<BarChartGroupData> barGroups = [];
    double maxY = 0;

    for (int i = 1; i <= 7; i++) {
      final dayActivities = groupedByDay[i]!;

      Map<String, List<Activity>> groupedByType = {};
      for (var activity in dayActivities) {
        if (!groupedByType.containsKey(activity.name)) {
          groupedByType[activity.name] = [];
        }
        groupedByType[activity.name]!.add(activity);
      }

      List<BarChartRodStackItem> rodStackItems = [];
      double currentY = 0;

      groupedByType.forEach((name, activities) {
        final count = activities.length.toDouble();
        final color = activities.first.color;

        if (count > 0) {
          rodStackItems.add(
            BarChartRodStackItem(currentY, currentY + count, color),
          );
          currentY += count;
        }
      });

      if (currentY > maxY) maxY = currentY;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: currentY,
              width: 16.w,
              borderRadius: BorderRadius.circular(4.r),
              rodStackItems: rodStackItems,
              color: Colors.transparent,
            ),
          ],
        ),
      );
    }

    if (maxY < 6) maxY = 6;
    final int maxYInt = maxY.ceil().toInt();
    maxY = maxYInt.toDouble();

    final _ =
        "${DateFormat('MMMM d, y', Localizations.localeOf(context).toString()).format(startOfWeek)} - ${DateFormat('MMMM d, y', Localizations.localeOf(context).toString()).format(endOfWeek)}";

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toInt().toString(),
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 100.h,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 1:
                            text = Text(AppLocalizations.of(context)!.dayMon, style: style);
                            break;
                          case 2:
                            text = Text(AppLocalizations.of(context)!.dayTue, style: style);
                            break;
                          case 3:
                            text = Text(AppLocalizations.of(context)!.dayWed, style: style);
                            break;
                          case 4:
                            text = Text(AppLocalizations.of(context)!.dayThu, style: style);
                            break;
                          case 5:
                            text = Text(AppLocalizations.of(context)!.dayFri, style: style);
                            break;
                          case 6:
                            text = Text(AppLocalizations.of(context)!.daySat, style: style);
                            break;
                          case 7:
                            text = Text(AppLocalizations.of(context)!.daySun, style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: text,
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30.w,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value % 1 == 0 && value <= maxY) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey[300],
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey[300],
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                barGroups: barGroups,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedPetHeader() {
    final petProvider = Provider.of<PetProvider>(context);
    final hasPets = petProvider.hasPets;
    final pets = petProvider.pets;

    String displayName = hasPets ? AppLocalizations.of(context)!.petSelectPet : AppLocalizations.of(context)!.petNoPetSelected;
    Uint8List? displayImage;
    Color borderColor = Colors.grey;

    Pet? displayedPet;

    if (hasPets) {
      // Priority 1: use explicitly selected pet
      if (_selectedPetId != null) {
        try {
          displayedPet = pets.firstWhere((p) => p.id == _selectedPetId);
        } catch (_) {
          // invalid ID → fallback to first
        }
      }

      // Priority 2: fallback to first pet if nothing selected or invalid
      displayedPet ??= pets.first;

      displayName = displayedPet.name;
      displayImage = displayedPet.imageBytes;
      borderColor = const Color(0xFF820DFF);
    }

    return GestureDetector(
      onTap: hasPets ? () => _showPetPicker(petProvider) : null,
      child: Container(
        height: 66.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7F6),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor, width: 3),
                    ),
                    child: ClipOval(
                      child: displayImage != null
                          ? Image.memory(displayImage, fit: BoxFit.cover)
                          : Image.asset(
                        'assets/images/a2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF301934),
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 24,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPetPicker(PetProvider petProvider) {
    if (!petProvider.hasPets) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        final currentSelectedId = _selectedPetId;

        return SizedBox(
          height: 360.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
            AppLocalizations.of(context)!.petSelectPet,
            style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: petProvider.pets.length + 1, // +1 for "No pet" option
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // "No pet selected" / default option
                      final isSelected = currentSelectedId == null;
                      return GestureDetector(
                        onTap: () async {
                          setState(() => _selectedPetId = null);
                          await _saveSelectedPetId(null);
                          if (mounted) Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF820DFF) : const Color(0xFFF4F7F6),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48.w,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.white : const Color(0xFF820DFF),
                                    width: 3,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/a2.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.petNoPetSelected,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final pet = petProvider.pets[index - 1];
                    final isSelected = pet.id == currentSelectedId;

                    return GestureDetector(
                      onTap: () async {
                        setState(() => _selectedPetId = pet.id);
                        await _saveSelectedPetId(pet.id);
                        if (mounted) Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF820DFF) : const Color(0xFFF4F7F6),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48.w,
                              height: 48.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.white : const Color(0xFF820DFF),
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: pet.imageBytes != null
                                    ? Image.memory(pet.imageBytes!, fit: BoxFit.cover)
                                    : Image.asset('assets/images/a2.png', fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Text(
                                pet.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingList() {
    final activityNotifier = Provider.of<ActivityNotifier>(context);

    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7F6),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
              itemCount: _allActivityTypes.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final activityType = _allActivityTypes[index];
                final String key = activityType['key'];
                final String name = activityType['name'];
                final String imagePath = activityType['image'];
                final Color color = activityType['color'];
                final bool isVisible = activityNotifier.isActivityVisible(key);

                return Container(
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Image.asset(imagePath, fit: BoxFit.contain),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36.r),
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 0),
                        ),
                        child: Switch(
                          value: isVisible,
                          activeColor: Colors.white,
                          activeTrackColor: const Color(0xFF820DFF),
                          inactiveTrackColor: Colors.grey.shade200,
                          inactiveThumbColor: Colors.white,
                          trackOutlineColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          onChanged: (value) {
                            activityNotifier.toggleVisibility(key, value);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _getLocalizedDuration(BuildContext context, Duration duration) {
    final loc = AppLocalizations.of(context)!;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours ${loc.durationHr} '
          '${minutes > 0 ? '$minutes ${loc.durationMin} ' : ''}'
          '${seconds > 0 ? '$seconds ${loc.durationSec}' : ''}'
          .trim();
    }
    if (minutes > 0) {
      return '$minutes ${loc.durationMin} '
          '${seconds > 0 ? '$seconds ${loc.durationSec}' : ''}'
          .trim();
    }
    return '$seconds ${loc.durationSec}';
  }

  String _localizeDurationString(BuildContext context, String durationStr) {
    final loc = AppLocalizations.of(context)!;
    String text = durationStr;
    text = text.replaceAll(RegExp(r'\bhr\b'), loc.durationHr);
    text = text.replaceAll(RegExp(r'\bmin\b'), loc.durationMin);
    text = text.replaceAll(RegExp(r'\bsec\b'), loc.durationSec);
    return text;
  }

  String _localizeAmount(BuildContext context, String rawAmount) {
    final loc = AppLocalizations.of(context)!;
    String text = rawAmount;

    text = text.replaceAll(RegExp(r'\bkm\b', caseSensitive: false), loc.unitKm);
    text = text.replaceAll(RegExp(r'\bmi\b', caseSensitive: false), loc.unitMi);
    text = text.replaceAll(RegExp(r'\boz\b', caseSensitive: false), loc.unitOz);
    text = text.replaceAll(RegExp(r'\bml\b', caseSensitive: false), loc.unitMl);
    text = text.replaceAll(RegExp(r'\blbs\b', caseSensitive: false), loc.unitLbs);
    text = text.replaceAll(RegExp(r'\bkg\b', caseSensitive: false), loc.unitKg);
    text = text.replaceAll(RegExp(r'\bInches\b'), loc.unitInches);
    text = text.replaceAll(RegExp(r'\bcm\b', caseSensitive: false), loc.unitCm);
    text = text.replaceAll(RegExp(r'\bF\b'), loc.unitF);
    text = text.replaceAll(RegExp(r'\bC\b'), loc.unitC);

    return text;
  }

  Widget _buildActivityCard(Activity activity, int index) {
    final DateTime effectiveDateTime = activity.dateTime;
    final String activityName = activity.name.toLowerCase();

    final bool isDrink = activityName == 'drink';
    final bool isEat = activityName == 'eat';
    final bool isTreat = activityName == 'treat';
    final bool isGrooming = activityName == 'grooming';
    final bool isMedication = activityName == 'medication';
    final bool isVaccination = activityName == 'vaccination';
    final bool isWeight = activityName == 'weight';
    final bool isHeight = activityName == 'height';
    final bool isTemperature = activityName == 'temperature';
    final bool isHealth = activityName == 'health condition';
    final bool isAccident = activityName == 'accident';
    final bool isJournal = activityName == 'journal';
    final bool isCleaning = activityName == 'cleaning';

    final bool isWalk = activityName == 'walk';
    final bool isPlay = activityName == 'play';
    final bool isCrate = activityName == 'crate';
    final bool isTraining = activityName == 'training';
    final bool isSleep = activityName == 'sleep';
    final bool isTimerActivity = isWalk || isPlay || isCrate || isTraining || isSleep;

    final bool hasNote = activity.note != null && activity.note!.isNotEmpty;

    String distanceText = '';
    String durationText = '';
    String displayName = _getLocalizedActivityName(context, activity.name);

    if (isTimerActivity) {
      if (isWalk && activity.food != null && activity.food!.isNotEmpty) {
        distanceText = _localizeAmount(context, activity.food!);
      }
      if (activity.duration != null) {
        durationText = _getLocalizedDuration(context, activity.duration!);
      } else {
        durationText = _localizeDurationString(context, activity.displayDuration);
      }
    } else if (isDrink && activity.food != null && activity.food!.isNotEmpty) {
      String food = activity.food!;
      final RegExp quantityRegex = RegExp(r'^(\d+(?:\.\d+)?\s*[a-zA-Z]+)(.*)$');
      final match = quantityRegex.firstMatch(food);

      if (match != null) {
        String rawAmount = match.group(1)?.trim() ?? '';
        distanceText = _localizeAmount(context, rawAmount);

        String namePart = match.group(2)?.trim() ?? '';
        if (namePart.isNotEmpty) {
          displayName = _getLocalizedActivityName(context, namePart);
        }
      } else {
        displayName = _localizeAmount(context, food);
      }
    }

    return Dismissible(
      key: Key('activity_${activity.name}_${activity.dateTime.millisecondsSinceEpoch}'),
      background: _buildSwipeBackground(isLeft: true),
      secondaryBackground: _buildSwipeBackground(isLeft: false),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(activity);
        }
        _editActivity(activity);
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
          final reminderNotifier = Provider.of<ReminderNotifier>(context, listen: false);

          if (activity.reminderId != null) {
            reminderNotifier.cancelReminder(activity.reminderId!);
          }
          activityNotifier.deleteActivity(activity);
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        color: const Color(0xFFF4F7F6),
        child: Container(
          padding: EdgeInsets.all(10.w),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ClipOval(
                          child: Image.asset(
                            activity.imagePath,
                            fit: BoxFit.cover,
                            width: 54.w,
                            height: 54.h,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.pets,
                              color: activity.color,
                              size: 28.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isDrink && distanceText.isNotEmpty)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _getLocalizedActivityName(context, activity.name),
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            distanceText,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF7D7D7D),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            displayName,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF7D7D7D),
                                            ),
                                          ),
                                        ],
                                      )
                                    else ...[
                                      Text(
                                        displayName,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      if (isTimerActivity)
                                        Row(
                                          children: [
                                            if (distanceText.isNotEmpty)
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.directions_walk,
                                                    size: 16.sp,
                                                    color: const Color(0xFF7D7D7D),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    distanceText,
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: const Color(0xFF7D7D7D),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            SizedBox(width: 5.w),
                                            if (durationText.isNotEmpty)
                                              Text(
                                                durationText,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(0xFF7D7D7D),
                                                ),
                                              ),
                                          ],
                                        )
                                      else if ((isEat ||
                                          isTreat ||
                                          isGrooming ||
                                          isMedication ||
                                          isVaccination ||
                                          isWeight ||
                                          isHeight ||
                                          isTemperature ||
                                          isHealth ||
                                          isAccident ||
                                          isJournal ||
                                          isCleaning) &&
                                          activity.food != null &&
                                          activity.food!.isNotEmpty)
                                        Text(
                                          _localizeAmount(context, activity.food!),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF7D7D7D),
                                          ),
                                        ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    DateFormat('MMM dd, yyyy', Localizations.localeOf(context).toString())
                                        .format(effectiveDateTime)
                                        .toLowerCase(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16.w,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        DateFormat('hh:mm a', Localizations.localeOf(context).toString()).format(effectiveDateTime),
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1, height: 1, color: Color(0xFFCBE4DC)),
              SizedBox(height: 2.h),
              if (hasNote)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                          AppLocalizations.of(context)!.activityNote,
                          style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Text(
                                activity.note!,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black87,
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
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      decoration: BoxDecoration(
        color: isLeft ? const Color(0xFF820DFF) : Colors.red,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: isLeft
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              Icon(
                isLeft ? Icons.edit : Icons.delete,
                color: Colors.white,
                size: 24.w,
              ),
              SizedBox(width: 8.w),
              Text(
                isLeft ? AppLocalizations.of(context)!.actionEdit : AppLocalizations.of(context)!.actionDelete,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(Activity activity) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.dialogDeleteActivityTitle),
        content: Text(AppLocalizations.of(context)!.dialogDeleteActivityContent(_getLocalizedActivityName(context, activity.name))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.dialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.actionDelete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _editActivity(Activity activity) {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final effectivePetId = _selectedPetId ?? (petProvider.hasPets ? petProvider.pets.first.id : null);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Allactivityview(
          selectedActivity: activity,
          selectedPetId: effectivePetId,
        ),
      ),
    ).then((edited) {
      if (edited == true && mounted) setState(() {});
    });
  }

  Widget _buildHeaderIcon(String path) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Image.asset(path, width: 24.w, height: 24.h),
      ),
    );
  }

  void _showNoPetsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              spreadRadius: 4,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.dialogActionsRequired,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000),
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.dialogAddPetMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            RoundButton(
              title: AppLocalizations.of(context)!.dialogGotIt,
              height: 66.h,
              borderRadius: 10.r,
              isSelected: true,
              backgroundColors: AppColors.vibrantPurple,
              textColors: Colors.white,
              onPress: () {
                Navigator.pop(context);
                Provider.of<HomeViewModel>(context, listen: false).selectedIndex = 2;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => const AddPetView(),
                );
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  void _showAddActivitySheet(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final effectivePetId = _selectedPetId ??
        (petProvider.hasPets ? petProvider.pets.first.id : null);

    if (!petProvider.hasPets) {
      _showNoPetsDialog(context);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.92,
        child: AddActivitiesView(
          initialDate: _selectedDate,
          selectedPetId: effectivePetId,
        ),
      ),
    );
  }
}



//
// import 'dart:typed_data';
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/View/Calendar/AddReminderView.dart';
// import 'package:dog_breed/View/MyPetsView/addPetView.dart';
// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:dog_breed/View_model/home/home_view_model.dart';
// import '../../View_model/ReminderNotifier.dart';
// import '../../View_model/activity_provider.dart';
// import '../../View_model/PetProvider.dart';
// import '../../View_model/home/Pet.dart';
// import '../../activity_model.dart';
// import '../../config/components/DocumentsScreen.dart';
// import '../../config/components/DrinkScreen.dart';
// import '../../config/components/OtherCalculatorWidget.dart';
// import 'add_activities_View.dart';
// import 'allActivityView.dart';
// import '../../utils/routes/routes_name.dart';
// class Calendarview extends StatefulWidget {
//   final void Function(String message)? onShowSnackBar;
//
//   const Calendarview({super.key, this.onShowSnackBar});
//
//   @override
//   State<Calendarview> createState() => _CalendarviewState();
// }
//
// class _CalendarviewState extends State<Calendarview> {
//   // int _selectedTab = 0; // Managed by HomeViewModel
//   int _selectedProgressTab = 0; // 0: Calendar, 1: Chart, 2: Compare
//
//   DateTime _selectedDate = DateTime.now();
//
//   DateTime _currentMonth = DateTime.now();
//   String? _selectedPetId;
//   final List<String> tabs = [
//     'Activities',
//     'Reminders',
//     'Progress',
//     'Documents',
//     'Settings',
//   ];
//
//   final List<Map<String, dynamic>> _allActivityTypes = [
//     {
//       'name': 'Veterinary',
//       'image': 'assets/images/Veterinary.png',
//       'color': const Color(0xFFB9E6FF),
//     },
//     {
//       'name': 'Pee',
//       'image': 'assets/images/62.png',
//       'color': const Color(0xFFFFD6C9),
//     },
//     {
//       'name': 'Eat',
//       'image': 'assets/images/image 1556.png',
//       'color': const Color(0xFFFFE3B9),
//     },
//     {
//       'name': 'Drink',
//       'image': 'assets/images/drink.png',
//       'color': const Color(0xFFB9DFFF),
//     },
//     {
//       'name': 'Play',
//       'image': 'assets/images/play.png',
//       'color': const Color(0xFFC5F9FF),
//     },
//     {
//       'name': 'Poop',
//       'image': 'assets/images/poop.png',
//       'color': const Color(0xFFFFDEC5),
//     },
//     {
//       'name': 'Walk',
//       'image': 'assets/images/walk1.png',
//       'color': const Color(0xFFF2F2F2),
//     },
//     {
//       'name': 'Crate',
//       'image': 'assets/images/crate.png',
//       'color': const Color(0xFFFFCFC7),
//     },
//     {
//       'name': 'Sleep',
//       'image': 'assets/images/sleep.png',
//       'color': const Color(0xFFFFDDC2),
//     },
//     {
//       'name': 'Training',
//       'image': 'assets/images/training.png',
//       'color': const Color(0xFFFFF1C2),
//     },
//     {
//       'name': 'Treat',
//       'image': 'assets/images/treat.png',
//       'color': const Color(0xFFFFEBD3),
//     },
//     {
//       'name': 'Grooming',
//       'image': 'assets/images/grooming.png',
//       'color': const Color(0xFFD0FAFF),
//     },
//     {
//       'name': 'Cleaning',
//       'image': 'assets/images/73.png',
//       'color': const Color(0xFFFFCFD5),
//     },
//     {
//       'name': 'Medication',
//       'image': 'assets/images/medi.png',
//       'color': const Color(0xFFFFEBEE),
//     },
//     {
//       'name': 'Vaccination',
//       'image': 'assets/images/vacc.png',
//       'color': const Color(0xFFFFEAE3),
//     },
//     {
//       'name': 'Weight',
//       'image': 'assets/images/weight.png',
//       'color': const Color(0xFFD2F3FF),
//     },
//     {
//       'name': 'Height',
//       'image': 'assets/images/height.png',
//       'color': const Color(0xFFEAD8D5),
//     },
//     {
//       'name': 'Temperature',
//       'image': 'assets/images/temp.png',
//       'color': const Color(0xFFE0EEFF),
//     },
//     {
//       'name': 'Health Condition',
//       'image': 'assets/images/healt.png',
//       'color': const Color(0xFFFFE7C0),
//     },
//     {
//       'name': 'Accident',
//       'image': 'assets/images/healt.png',
//       'color': const Color(0xFFFDFFD9),
//     },
//     {
//       'name': 'Journal',
//       'image': 'assets/images/jour.png',
//       'color': const Color(0xFFFFD5CA),
//     },
//   ];
//
//   bool isDefault = false;
//   ScrollController? _scrollController;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSelectedProgressTab();
//     _loadSelectedPetId();
//     _scrollController = ScrollController();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollToSelectedDate();
//     });
//   }
//
//   Future<void> _loadSelectedPetId() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedPetId = prefs.getString('selectedPetId');
//
//     final petProvider = Provider.of<PetProvider>(context, listen: false);
//
//     if (petProvider.hasPets) {
//       // If saved ID exists and is still valid → keep it
//       if (savedPetId != null && petProvider.pets.any((p) => p.id == savedPetId)) {
//         setState(() {
//           _selectedPetId = savedPetId;
//         });
//       }
//       // If no saved ID or saved ID is invalid → auto-select first pet
//       else {
//         setState(() {
//           _selectedPetId = petProvider.pets.first.id;
//         });
//         await prefs.setString('selectedPetId', _selectedPetId!);
//       }
//     } else {
//       // No pets → clear any old saved value
//       setState(() {
//         _selectedPetId = null;
//       });
//       await prefs.remove('selectedPetId');
//     }
//   }
//   Future<void> _saveSelectedPetId(String? petId) async {
//     final prefs = await SharedPreferences.getInstance();
//     if (petId != null && petId.isNotEmpty) {
//       await prefs.setString('selectedPetId', petId);
//     } else {
//       await prefs.remove('selectedPetId');
//     }
//   }
//
//   // Future<void> _loadSelectedPetId() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final savedPetId = prefs.getString('selectedPetId');
//   //   if (mounted && savedPetId != null) {
//   //     setState(() {
//   //       _selectedPetId = savedPetId;
//   //     });
//   //   }
//   // }
//   //
//   // Future<void> _saveSelectedPetId(String? petId) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   if (petId != null) {
//   //     await prefs.setString('selectedPetId', petId);
//   //   } else {
//   //     await prefs.remove('selectedPetId');
//   //   }
//   // }
//
//   Future<void> _loadSelectedProgressTab() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (mounted) {
//       setState(() {
//         _selectedProgressTab = prefs.getInt('selectedProgressTab') ?? 0;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _scrollController?.dispose();
//     super.dispose();
//   }
//
//   void _scrollToSelectedDate() {
//     if (_scrollController == null || !_scrollController!.hasClients) return;
//     final days = _getDaysInMonth(_currentMonth);
//     final selectedIndex = days.indexWhere(
//           (date) =>
//       date.year == _selectedDate.year &&
//           date.month == _selectedDate.month &&
//           date.day == _selectedDate.day,
//     );
//     if (selectedIndex == -1) return;
//     final double itemWidth = 70.w + 12.w;
//     final double viewportWidth = MediaQuery.of(context).size.width - 16.w;
//     final double targetOffset =
//         selectedIndex * itemWidth - (viewportWidth - itemWidth) / 2;
//     final double maxScrollExtent = _scrollController!.position.maxScrollExtent;
//     final double offset = targetOffset.clamp(0.0, maxScrollExtent);
//     _scrollController!.animateTo(
//       offset,
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   List<DateTime> _getDaysInMonth(DateTime month) {
//     final firstDayOfMonth = DateTime(month.year, month.month, 1);
//     final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
//     final days = <DateTime>[];
//     for (int i = 1; i <= lastDayOfMonth.day; i++) {
//       days.add(DateTime(month.year, month.month, i));
//     }
//
//     return days;
//   }
//
//   // bool get _shouldShowCalendar => _selectedTab == 0 || _selectedTab == 1;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final petProvider = Provider.of<PetProvider>(context);
//     if (petProvider.lastAddedPetId != null) {
//       _selectedPetId = petProvider.lastAddedPetId;
//       petProvider.clearLastAddedPetId();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final homeViewModel = Provider.of<HomeViewModel>(context);
//     final int _selectedTab = homeViewModel.calendarTabIndex;
//     final bool _shouldShowCalendar = _selectedTab == 0 || _selectedTab == 1;
//
//     final now = DateTime.now();
//     final activityNotifier = Provider.of<ActivityNotifier>(context);
//     final petProvider = Provider.of<PetProvider>(context);
//     final effectivePetId = _selectedPetId;
//
//     final activities = activityNotifier.activities;
//     final filteredActivities = activities
//         .where((activity) {
//       final isSamePet = effectivePetId == null || activity.petId == effectivePetId;
//       if (!isSamePet) return false;
//
//       final isActivityToday =
//           activity.dateTime.year == _selectedDate.year &&
//               activity.dateTime.month == _selectedDate.month &&
//               activity.dateTime.day == _selectedDate.day;
//
//       final isReminderToday = activity.hasReminder &&
//           activity.reminderDateTime != null &&
//           !activity.reminderDateTime!.isBefore(now) &&
//           activity.reminderDateTime!.year == _selectedDate.year &&
//           activity.reminderDateTime!.month == _selectedDate.month &&
//           activity.reminderDateTime!.day == _selectedDate.day;
//
//       return isActivityToday || isReminderToday;
//     })
//         .toList()
//       ..sort((a, b) => b.dateTime.compareTo(a.dateTime)); // newest first
//
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 13.w),
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 12.h),
//               child: Text(
//                 'Manage',
//                 style: TextStyle(
//                   fontSize: 40.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//
//             // Horizontal Tabs
//             SizedBox(
//               height: 50.h,
//               child: ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: tabs.length,
//                 separatorBuilder: (_, __) => SizedBox(width: 24.w),
//                 itemBuilder: (context, index) {
//                   final isSelected = _selectedTab == index;
//                   return GestureDetector(
//                     onTap: () {
//                       if (!petProvider.hasPets) {
//                         _showNoPetsDialog(context);
//                         return;
//                       }
//                       homeViewModel.calendarTabIndex = index;
//                       if (index == 0 || index == 1) {
//                         WidgetsBinding.instance.addPostFrameCallback(
//                               (_) => _scrollToSelectedDate(),
//                         );
//                       }
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           tabs[index],
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: isSelected
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                             color: isSelected ? Colors.black : Colors.grey,
//                           ),
//                         ),
//                         if (isSelected)
//                           Container(
//                             width: 41.w,
//                             height: 3.h,
//                             margin: EdgeInsets.only(top: 4.h),
//                             decoration: const BoxDecoration(
//                               color: Color(0xFF820DFF),
//                             ),
//                           ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             SizedBox(height: 16.h),
//             if (_selectedTab >= 0 && _selectedTab <= 4) ...[
//               _buildSelectedPetHeader(),
//               SizedBox(height: 12.h),
//             ],
//             if (_shouldShowCalendar) ...[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     height: 40.h,
//                     width: 41.w,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF4F7F6),
//                       borderRadius: BorderRadius.circular(9),
//                     ),
//                     child: Center(
//                       child: IconButton(
//                         icon: const Icon(Icons.chevron_left, size: 28),
//                         padding: EdgeInsets.zero,
//                         onPressed: () {
//                           setState(() {
//                             _currentMonth = DateTime(
//                               _currentMonth.year,
//                               _currentMonth.month - 1,
//                             );
//                             if (_selectedDate.month != _currentMonth.month) {
//                               _selectedDate = DateTime(
//                                 _currentMonth.year,
//                                 _currentMonth.month,
//                                 1,
//                               );
//                             }
//                           });
//                           _scrollToSelectedDate();
//                         },
//                       ),
//                     ),
//                   ),
//
//                   Row(
//                     children: [
//                       Text(
//                         DateFormat('MMMM yyyy').format(_currentMonth),
//                         style: TextStyle(
//                           fontSize: 20.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(width: 16.w),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 12.w,
//                           vertical: 6.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[100],
//                           borderRadius: BorderRadius.circular(12.r),
//                         ),
//                         child: Text(
//                           'Month',
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: const Color(0xFF820DFF),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   Container(
//                     height: 40.h,
//                     width: 41.w,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF4F7F6),
//                       borderRadius: BorderRadius.circular(9),
//                     ),
//                     child: Center(
//                       child: IconButton(
//                         icon: const Icon(Icons.chevron_right, size: 28),
//                         padding: EdgeInsets.zero,
//                         onPressed: () {
//                           setState(() {
//                             _currentMonth = DateTime(
//                               _currentMonth.year,
//                               _currentMonth.month + 1,
//                             );
//
//                             if (_selectedDate.month != _currentMonth.month) {
//                               _selectedDate = DateTime(
//                                 _currentMonth.year,
//                                 _currentMonth.month,
//                                 1,
//                               );
//                             }
//                           });
//
//                           _scrollToSelectedDate();
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 20.h),
//
//               SizedBox(
//                 height: 100.h,
//                 child: ListView.builder(
//                   controller: _scrollController,
//                   padding: EdgeInsets.zero,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: _getDaysInMonth(_currentMonth).length,
//                   itemBuilder: (context, index) {
//                     final date = _getDaysInMonth(_currentMonth)[index];
//                     final isSelected =
//                         date.year == _selectedDate.year &&
//                             date.month == _selectedDate.month &&
//                             date.day == _selectedDate.day;
//                     return GestureDetector(
//                       onTap: () {
//                         if (!petProvider.hasPets) {
//                           _showNoPetsDialog(context);
//                           return;
//                         }
//                         setState(() => _selectedDate = date);
//
//                         _scrollToSelectedDate();
//                       },
//                       child: Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           Container(
//                             width: 70.w,
//                             margin: EdgeInsets.symmetric(horizontal: 6.w),
//                             padding: EdgeInsets.symmetric(vertical: 8.h),
//                             decoration: BoxDecoration(
//                               color: isSelected
//                                   ? const Color(0xFF820DFF)
//                                   : const Color(0xFFF4F7F6),
//
//                               borderRadius: BorderRadius.circular(16.r),
//                             ),
//
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   DateFormat('MMM').format(date),
//
//                                   style: TextStyle(
//                                     fontSize: 12.sp,
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Colors.black54,
//                                   ),
//                                 ),
//
//                                 SizedBox(height: 2.h),
//
//                                 Text(
//                                   date.day.toString(),
//
//                                   style: TextStyle(
//                                     fontSize: 22.sp,
//
//                                     fontWeight: FontWeight.bold,
//
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Colors.black,
//                                   ),
//                                 ),
//
//                                 SizedBox(height: 2.h),
//
//                                 Text(
//                                   DateFormat('EEE').format(date),
//
//                                   style: TextStyle(
//                                     fontSize: 12.sp,
//
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Colors.black54,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           Consumer<ReminderNotifier>(
//                             builder: (context, reminderNotifier, child) {
//                               final count = reminderNotifier
//                                   .getRemindersCountForDate(date, petId: effectivePetId);
//                               if (count > 0) {
//                                 return Positioned(
//                                   top: -1.h,
//                                   right: 0,
//                                   child: Container(
//                                     width: 22.w,
//
//                                     height: 22.h,
//
//                                     decoration: const BoxDecoration(
//                                       color: Colors.red,
//
//                                       shape: BoxShape.circle,
//                                     ),
//
//                                     child: Center(
//                                       child: Text(
//                                         count.toString(),
//
//                                         style: TextStyle(
//                                           color: Colors.white,
//
//                                           fontSize: 12.sp,
//
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }
//
//                               return const SizedBox.shrink();
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//               SizedBox(height: 20.h),
//             ],
//
//             // Tab Content
//             Expanded(child: _buildTabContent(filteredActivities, _selectedTab)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabContent(List<Activity> filteredActivities, int selectedTab) {
//     final petProvider = Provider.of<PetProvider>(context);
//     final effectivePetId = _selectedPetId ?? (petProvider.hasPets ? petProvider.pets.first.id : null);
//
//     switch (selectedTab) {
//       case 0: // Activities
//
//         return _buildActivitiesList(filteredActivities);
//       case 1:
//         return AddReminderView(selectedPetId: effectivePetId);
//     // case 1:
//     //   return AddReminderView(selectedPetId: effectivePetId);
//       case 2: // Progress
//
//         return _buildProgressList(filteredActivities);
//
//       case 3: // Documents
//
//         return DocumentsScreen(selectedPetId: effectivePetId);
//
//       case 4: // Settings
//
//         return _buildSettingList();
//
//       default:
//         return const Center(child: Text('Coming soon...'));
//     }
//   }
//
//   Widget _buildProgressList(List<Activity> dailyActivities) {
//     return Column(
//       children: [
//         Container(
//           height: 50.h,
//           color: const Color(0xFF820DFF),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildProgressTabItem("Calendar", 0),
//               _buildProgressTabItem("Chart", 1),
//               _buildProgressTabItem("Compare", 2),
//             ],
//           ),
//         ),
//         Expanded(child: _buildProgressContent(dailyActivities)),
//       ],
//     );
//   }
//
//   Widget _buildProgressTabItem(String title, int index) {
//     final isSelected = _selectedProgressTab == index;
//     return GestureDetector(
//       onTap: () async {
//         setState(() {
//           _selectedProgressTab = index;
//         });
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setInt('selectedProgressTab', index);
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16.sp,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//             SizedBox(height: 6.h),
//
//             // Divider that appears only for selected tab
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               height: isSelected ? 3.h : 0,
//               width: 42.w, // Fixed width
//               color: Colors.white,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProgressContent(List<Activity> dailyActivities) {
//     switch (_selectedProgressTab) {
//       case 0:
//         return _buildProgressCalendarView(dailyActivities);
//       case 1:
//         return _buildProgressChartView(dailyActivities);
//       case 2:
//         return _buildProgressCompareView(dailyActivities);
//       default:
//         return _buildProgressCalendarView(dailyActivities);
//     }
//   }
//
//   Widget _buildProgressChartView(List<Activity> dailyActivities) {
//     final List<Map<String, dynamic>> progressItems = [
//       {'title': 'Eat', 'icon': 'assets/images/image 1556.png'},
//       {'title': 'Pee', 'icon': 'assets/images/62.png'},
//       {'title': 'Drink', 'icon': 'assets/images/drink.png'},
//       {'title': 'Poop', 'icon': 'assets/images/poop.png'},
//       {'title': 'Walk', 'icon': 'assets/images/walk1.png'},
//       {'title': 'Play', 'icon': 'assets/images/play.png'},
//       {'title': 'Crate', 'icon': 'assets/images/crate.png'},
//       {'title': 'Sleep', 'icon': 'assets/images/sleep.png'},
//       {'title': 'Training', 'icon': 'assets/images/training.png'},
//       {'title': 'Treat', 'icon': 'assets/images/treat.png'},
//       {'title': 'Grooming', 'icon': 'assets/images/grooming.png'},
//       {'title': 'Cleaning', 'icon': 'assets/images/73.png'},
//       {'title': 'Medication', 'icon': 'assets/images/medi.png'},
//       {'title': 'Vaccination', 'icon': 'assets/images/vacc.png'},
//       {'title': 'Weight', 'icon': 'assets/images/weight.png'},
//       {'title': 'Height', 'icon': 'assets/images/height.png'},
//       {'title': 'Temperature', 'icon': 'assets/images/temp.png'},
//       {'title': 'Health Condition', 'icon': 'assets/images/healt.png'},
//       {'title': 'Accident', 'icon': 'assets/images/acc.png'},
//       {'title': 'Journal', 'icon': 'assets/images/jour.png'},
//     ];
//
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 16.h),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//             child: GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: progressItems.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 2.2,
//               ),
//               itemBuilder: (context, index) {
//                 final item = progressItems[index];
//                 final String title = item['title'];
//                 final String iconPath = item['icon'];
//
//                 final int count = dailyActivities
//                     .where((a) => a.name.toLowerCase() == title.toLowerCase())
//                     .length;
//
//                 return GestureDetector(
//                   onTap: () {
//                     final petProvider = Provider.of<PetProvider>(context, listen: false);
//                     final effectivePetId = _selectedPetId ?? (petProvider.hasPets ? petProvider.pets.first.id : null);
//
//                     if (title.toLowerCase() == 'drink') {
//                       // Open DrinkScreen directly on Drink Calculator tab (index 2)
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               DrinkScreen(initialTab: 2, selectedPetId: effectivePetId),
//                         ),
//                       );
//                     } else {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => Othercalculatorwidget(
//                             initialTab: 2,
//                             activityTitle: title, // Pass the title
//                             activityCount: count,
//                             selectedPetId: effectivePetId,
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16.r),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 12.w,
//                       vertical: 8.h,
//                     ),
//                     child: Row(
//                       children: [
//                         // Icon + Title
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 iconPath,
//                                 width: 28.w,
//                                 height: 28.h,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     Icon(
//                                       Icons.pets,
//                                       color: Colors.grey[400],
//                                       size: 24.w,
//                                     ),
//                               ),
//                               SizedBox(height: 4.h),
//                               Text(
//                                 title,
//                                 style: TextStyle(
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black87,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Count + Arrow
//                         Row(
//                           children: [
//                             Text(
//                               count.toString(),
//                               style: TextStyle(
//                                 fontSize: 20.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             SizedBox(width: 4.w),
//                             Icon(
//                               Icons.chevron_right,
//                               color: Colors.black54,
//                               size: 24.w,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProgressCalendarView(List<Activity> dailyActivities) {
//     final startOfWeek = _selectedDate.subtract(
//       Duration(days: _selectedDate.weekday - 1),
//     );
//     final weekDays = List.generate(
//       7,
//           (index) => startOfWeek.add(Duration(days: index)),
//     );
//
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 10.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.chevron_left, color: Colors.black),
//                 onPressed: () {
//                   setState(() {
//                     _selectedDate = _selectedDate.subtract(
//                       const Duration(days: 1),
//                     );
//                     if (_selectedDate.month != _currentMonth.month) {
//                       _currentMonth = DateTime(
//                         _selectedDate.year,
//                         _selectedDate.month,
//                       );
//                     }
//                   });
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     _scrollToSelectedDate();
//                   });
//                 },
//               ),
//               Text(
//                 DateFormat('MMMM d, y').format(_selectedDate),
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.chevron_right, color: Colors.black),
//                 onPressed: () {
//                   setState(() {
//                     _selectedDate = _selectedDate.add(const Duration(days: 1));
//                     if (_selectedDate.month != _currentMonth.month) {
//                       _currentMonth = DateTime(
//                         _selectedDate.year,
//                         _selectedDate.month,
//                       );
//                     }
//                   });
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     _scrollToSelectedDate();
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//
//         Expanded(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Column(
//               children: List.generate(24, (index) {
//                 final time = DateTime(2024, 1, 1, index, 0);
//                 final timeString = DateFormat('h a').format(time).toLowerCase();
//
//                 final activitiesInHour = dailyActivities
//                     .where((a) => a.dateTime.hour == index)
//                     .toList();
//
//                 return IntrinsicHeight(
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: 50.w,
//                         child: Column(
//                           children: [
//                             Text(
//                               timeString,
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12.sp,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(width: 1.w, color: Colors.grey.shade200),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Divider(height: 1, color: Colors.grey.shade200),
//                             SizedBox(height: 20.h),
//                             ...activitiesInHour
//                                 .map(
//                                   (activity) =>
//                                   _buildTimelineActivityItem(activity),
//                             )
//                                 .toList(),
//                             if (activitiesInHour.isEmpty)
//                               SizedBox(height: 30.h),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//
//
//
//
//   Widget _buildTimelineActivityItem(Activity activity) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 8.h),
//       padding: EdgeInsets.all(8.r),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF4F7F6),
//         borderRadius: BorderRadius.circular(8.r),
//         border: Border.all(color: const Color(0xFFE0E0E0)),
//       ),
//       child: Row(
//         children: [
//           Image.asset(
//             activity.imagePath,
//             width: 24.w,
//             height: 24.h,
//             errorBuilder: (c, e, s) => Icon(Icons.pets, size: 24.w),
//           ),
//           SizedBox(width: 8.w),
//           Expanded(
//             child: Text(
//               activity.name,
//               style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
//             ),
//           ),
//           Text(
//             DateFormat('h:mm a').format(activity.dateTime),
//             style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProgressCompareView(List<Activity> dailyActivities) {
//     final activityNotifier = Provider.of<ActivityNotifier>(context);
//     final allActivities = activityNotifier.activities;
//
//     DateTime startOfWeek = _selectedDate.subtract(
//       Duration(days: _selectedDate.weekday - 1),
//     );
//     startOfWeek = DateTime(
//       startOfWeek.year,
//       startOfWeek.month,
//       startOfWeek.day,
//     ); // Strip time
//
//     DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
//     endOfWeek = DateTime(
//       endOfWeek.year,
//       endOfWeek.month,
//       endOfWeek.day,
//       23,
//       59,
//       59,
//     );
//
//     final weeklyActivities = allActivities.where((activity) {
//       return activity.dateTime.isAfter(
//         startOfWeek.subtract(const Duration(seconds: 1)),
//       ) &&
//           activity.dateTime.isBefore(endOfWeek.add(const Duration(seconds: 1)));
//     }).toList();
//
//     Map<int, List<Activity>> groupedByDay = {};
//     for (int i = 1; i <= 7; i++) {
//       groupedByDay[i] = [];
//     }
//
//     for (var activity in weeklyActivities) {
//       groupedByDay[activity.dateTime.weekday]?.add(activity);
//     }
//
//     List<BarChartGroupData> barGroups = [];
//     double maxY = 0;
//
//     for (int i = 1; i <= 7; i++) {
//       final dayActivities = groupedByDay[i]!;
//
//       Map<String, List<Activity>> groupedByType = {};
//       for (var activity in dayActivities) {
//         if (!groupedByType.containsKey(activity.name)) {
//           groupedByType[activity.name] = [];
//         }
//         groupedByType[activity.name]!.add(activity);
//       }
//
//       List<BarChartRodStackItem> rodStackItems = [];
//       double currentY = 0;
//
//       groupedByType.forEach((name, activities) {
//         final count = activities.length.toDouble();
//         final color = activities.first.color;
//
//         if (count > 0) {
//           rodStackItems.add(
//             BarChartRodStackItem(currentY, currentY + count, color),
//           );
//           currentY += count;
//         }
//       });
//
//       if (currentY > maxY) maxY = currentY;
//
//       barGroups.add(
//         BarChartGroupData(
//           x: i,
//           barRods: [
//             BarChartRodData(
//               toY: currentY,
//               width: 16.w,
//               borderRadius: BorderRadius.circular(4.r),
//               rodStackItems: rodStackItems,
//               color: Colors.transparent,
//             ),
//           ],
//         ),
//       );
//     }
//
//     if (maxY < 6) maxY = 6;
//
//     final int maxYInt = maxY.ceil().toInt();
//     maxY = maxYInt.toDouble();
//
//     final dateRangeText =
//         "${DateFormat('MMMM d, y').format(startOfWeek)} - ${DateFormat('MMMM d, y').format(endOfWeek)}";
//
//     return Column(
//       children: [
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
//             child: BarChart(
//               BarChartData(
//                 alignment: BarChartAlignment.spaceAround,
//                 maxY: maxY,
//                 barTouchData: BarTouchData(
//                   enabled: true,
//                   touchTooltipData: BarTouchTooltipData(
//                     getTooltipColor: (group) => Colors.blueGrey,
//                     getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                       return BarTooltipItem(
//                         rod.toY.toInt().toString(),
//                         const TextStyle(color: Colors.white),
//                       );
//                     },
//                   ),
//                 ),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 100.h,
//                       getTitlesWidget: (double value, TitleMeta meta) {
//                         const style = TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         );
//                         Widget text;
//                         switch (value.toInt()) {
//                           case 1:
//                             text = const Text('Mon', style: style);
//                             break;
//                           case 2:
//                             text = const Text('Tue', style: style);
//                             break;
//                           case 3:
//                             text = const Text('Wed', style: style);
//                             break;
//                           case 4:
//                             text = const Text('Thu', style: style);
//                             break;
//                           case 5:
//                             text = const Text('Fri', style: style);
//                             break;
//                           case 6:
//                             text = const Text('Sat', style: style);
//                             break;
//                           case 7:
//                             text = const Text('Sun', style: style);
//                             break;
//                           default:
//                             text = const Text('', style: style);
//                         }
//                         return SideTitleWidget(
//                           axisSide: meta.axisSide,
//                           child: text,
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30.w,
//                       interval: 1,
//                       getTitlesWidget: (value, meta) {
//                         if (value % 1 == 0 && value <= maxY) {
//                           return Text(
//                             value.toInt().toString(),
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12,
//                             ),
//                           );
//                         }
//                         return Container();
//                       },
//                     ),
//                   ),
//                   topTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   rightTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: true,
//                   horizontalInterval: 1,
//                   getDrawingHorizontalLine: (value) => FlLine(
//                     color: Colors.grey[300],
//                     strokeWidth: 1,
//                     dashArray: [5, 5],
//                   ),
//                   getDrawingVerticalLine: (value) => FlLine(
//                     color: Colors.grey[300],
//                     strokeWidth: 1,
//                     dashArray: [5, 5],
//                   ),
//                 ),
//                 borderData: FlBorderData(
//                   show: true,
//                   border: const Border(
//                     bottom: BorderSide(color: Colors.black, width: 1),
//                   ),
//                 ),
//                 barGroups: barGroups,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Widget _buildSelectedPetHeader() {
//   //   final petProvider = Provider.of<PetProvider>(context);
//   //   final hasPets = petProvider.hasPets;
//   //   final pets = petProvider.pets;
//   //
//   //   String displayName = 'My Lovely Tomy';
//   //   Uint8List? displayImage;
//   //
//   //   if (hasPets) {
//   //     if (_selectedPetId != null) {
//   //       try {
//   //         final pet = pets.firstWhere((p) => p.id == _selectedPetId);
//   //         displayName = pet.name;
//   //         displayImage = pet.imageBytes;
//   //       } catch (_) {
//   //
//   //       }
//   //     } else {
//   //
//   //     }
//   //   }
//   //
//   //   return GestureDetector(
//   //     onTap: hasPets ? () => _showPetPicker(petProvider) : null,
//   //     child: Container(
//   //       height: 66.h,
//   //       margin: EdgeInsets.symmetric(horizontal: 8.w),
//   //       decoration: BoxDecoration(
//   //         color: const Color(0xFFF4F7F6),
//   //         borderRadius: BorderRadius.circular(16.r),
//   //       ),
//   //       child: Padding(
//   //         padding: EdgeInsets.symmetric(horizontal: 16.w),
//   //         child: Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             Row(
//   //               children: [
//   //                 Container(
//   //                   width: 40.w,
//   //                   height: 40.h,
//   //                   decoration: BoxDecoration(
//   //                     shape: BoxShape.circle,
//   //                     border: Border.all(
//   //                       color: const Color(0xFF820DFF),
//   //                       width: 3,
//   //                     ),
//   //                   ),
//   //                   child: ClipOval(
//   //                     child: displayImage != null
//   //                         ? Image.memory(
//   //                       displayImage,
//   //                       fit: BoxFit.cover,
//   //                     )
//   //                         : Image.asset(
//   //                       'assets/images/a2.png',
//   //                       fit: BoxFit.cover,
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 SizedBox(width: 12.w),
//   //                 Text(
//   //                   displayName,
//   //                   style: TextStyle(
//   //                     fontSize: 18.sp,
//   //                     fontWeight: FontWeight.w600,
//   //                     color: const Color(0xFF301934),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //             const Icon(
//   //               Icons.keyboard_arrow_down,
//   //               size: 24,
//   //               color: Colors.black,
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//
//   Widget _buildSelectedPetHeader() {
//     final petProvider = Provider.of<PetProvider>(context);
//     final hasPets = petProvider.hasPets;
//     final pets = petProvider.pets;
//
//     String displayName = hasPets ? 'Select Pet' : 'No Pet Selected';
//     Uint8List? displayImage;
//     Color borderColor = Colors.grey;
//
//     Pet? displayedPet;
//
//     if (hasPets) {
//       // Priority 1: use explicitly selected pet
//       if (_selectedPetId != null) {
//         try {
//           displayedPet = pets.firstWhere((p) => p.id == _selectedPetId);
//         } catch (_) {
//           // invalid ID → fallback to first
//         }
//       }
//
//       // Priority 2: fallback to first pet if nothing selected or invalid
//       displayedPet ??= pets.first;
//
//       displayName = displayedPet.name;
//       displayImage = displayedPet.imageBytes;
//       borderColor = const Color(0xFF820DFF);
//     }
//
//     return GestureDetector(
//       onTap: hasPets ? () => _showPetPicker(petProvider) : null,
//       child: Container(
//         height: 66.h,
//         margin: EdgeInsets.symmetric(horizontal: 8.w),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF4F7F6),
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 40.w,
//                     height: 40.h,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: borderColor, width: 3),
//                     ),
//                     child: ClipOval(
//                       child: displayImage != null
//                           ? Image.memory(displayImage, fit: BoxFit.cover)
//                           : Image.asset(
//                         'assets/images/a2.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 12.w),
//                   Text(
//                     displayName,
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xFF301934),
//                     ),
//                   ),
//                 ],
//               ),
//               const Icon(
//                 Icons.keyboard_arrow_down,
//                 size: 24,
//                 color: Colors.black,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showPetPicker(PetProvider petProvider) {
//     if (!petProvider.hasPets) return;
//
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
//       ),
//       builder: (context) {
//         final currentSelectedId = _selectedPetId;
//
//         return SizedBox(
//           height: 360.h,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(height: 8.h),
//               Container(
//                 width: 40.w,
//                 height: 4.h,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(20.r),
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               Text(
//                 'Select Pet',
//                 style: TextStyle(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               Expanded(
//                 child: ListView.separated(
//                   padding: EdgeInsets.symmetric(horizontal: 16.w),
//                   itemCount: petProvider.pets.length + 1, // +1 for "No pet" option
//                   separatorBuilder: (_, __) => SizedBox(height: 8.h),
//                   itemBuilder: (context, index) {
//                     if (index == 0) {
//                       // "No pet selected" / default option
//                       final isSelected = currentSelectedId == null;
//                       return GestureDetector(
//                         onTap: () async {
//                           setState(() => _selectedPetId = null);
//                           await _saveSelectedPetId(null);
//                           if (mounted) Navigator.pop(context);
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//                           decoration: BoxDecoration(
//                             color: isSelected ? const Color(0xFF820DFF) : const Color(0xFFF4F7F6),
//                             borderRadius: BorderRadius.circular(16.r),
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 48.w,
//                                 height: 48.h,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: isSelected ? Colors.white : const Color(0xFF820DFF),
//                                     width: 3,
//                                   ),
//                                 ),
//                                 child: ClipOval(
//                                   child: Image.asset(
//                                     'assets/images/a2.png',
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 16.w),
//                               Expanded(
//                                 child: Text(
//                                   'No pet selected',
//                                   style: TextStyle(
//                                     fontSize: 16.sp,
//                                     fontWeight: FontWeight.w600,
//                                     color: isSelected ? Colors.white : Colors.black87,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//
//                     final pet = petProvider.pets[index - 1];
//                     final isSelected = pet.id == currentSelectedId;
//
//                     return GestureDetector(
//                       onTap: () async {
//                         setState(() => _selectedPetId = pet.id);
//                         await _saveSelectedPetId(pet.id);
//                         if (mounted) Navigator.pop(context);
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//                         decoration: BoxDecoration(
//                           color: isSelected ? const Color(0xFF820DFF) : const Color(0xFFF4F7F6),
//                           borderRadius: BorderRadius.circular(16.r),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 48.w,
//                               height: 48.h,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: isSelected ? Colors.white : const Color(0xFF820DFF),
//                                   width: 3,
//                                 ),
//                               ),
//                               child: ClipOval(
//                                 child: pet.imageBytes != null
//                                     ? Image.memory(pet.imageBytes!, fit: BoxFit.cover)
//                                     : Image.asset('assets/images/a2.png', fit: BoxFit.cover),
//                               ),
//                             ),
//                             SizedBox(width: 16.w),
//                             Expanded(
//                               child: Text(
//                                 pet.name,
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: isSelected ? Colors.white : Colors.black87,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // void _showPetPicker(PetProvider petProvider) {
//   //   if (!petProvider.hasPets) return;
//   //
//   //   showModalBottomSheet(
//   //     context: context,
//   //     backgroundColor: Colors.white,
//   //     shape: RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
//   //     ),
//   //     builder: (context) {
//   //       final currentSelectedId = _selectedPetId;
//   //
//   //       return SizedBox(
//   //         height: 320.h,
//   //         child: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             SizedBox(height: 8.h),
//   //             Container(
//   //               width: 40.w,
//   //               height: 4.h,
//   //               decoration: BoxDecoration(
//   //                 color: Colors.grey[300],
//   //                 borderRadius: BorderRadius.circular(20.r),
//   //               ),
//   //             ),
//   //             SizedBox(height: 12.h),
//   //             Text(
//   //               'Select Pet',
//   //               style: TextStyle(
//   //                 fontSize: 18.sp,
//   //                 fontWeight: FontWeight.w600,
//   //                 color: Colors.black,
//   //               ),
//   //             ),
//   //             SizedBox(height: 12.h),
//   //             Expanded(
//   //               child: ListView.separated(
//   //                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//   //                 itemCount: petProvider.pets.length + 1,
//   //                 separatorBuilder: (_, __) => SizedBox(height: 8.h),
//   //                 itemBuilder: (context, index) {
//   //                   if (index == 0) {
//   //                     final isSelected = currentSelectedId == null;
//   //                     return GestureDetector(
//   //                       onTap: () {
//   //                         setState(() {
//   //                           _selectedPetId = null;
//   //                         });
//   //                         Navigator.pop(context);
//   //                       },
//   //                       child: Container(
//   //                         padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
//   //                         decoration: BoxDecoration(
//   //                           color: isSelected
//   //                               ? const Color(0xFF820DFF)
//   //                               : const Color(0xFFF4F7F6),
//   //                           borderRadius: BorderRadius.circular(18.r),
//   //                         ),
//   //                         child: Row(
//   //                           children: [
//   //                             Container(
//   //                               width: 44.w,
//   //                               height: 44.h,
//   //                               decoration: BoxDecoration(
//   //                                 shape: BoxShape.circle,
//   //                                 border: Border.all(
//   //                                   color: isSelected
//   //                                       ? Colors.grey.shade200
//   //                                       : const Color(0xFF820DFF),
//   //                                   width: 2,
//   //                                 ),
//   //                               ),
//   //                               child: ClipOval(
//   //                                 child: Image.asset(
//   //                                   'assets/images/a2.png',
//   //                                   fit: BoxFit.cover,
//   //                                 ),
//   //                               ),
//   //                             ),
//   //                             SizedBox(width: 12.w),
//   //                             Expanded(
//   //                               child: Text(
//   //                                 'My Lovely Tomy',
//   //                                 style: TextStyle(
//   //                                   fontSize: 16.sp,
//   //                                   fontWeight: FontWeight.w600,
//   //                                   color: isSelected ? Colors.white : Colors.black,
//   //                                 ),
//   //                               ),
//   //                             ),
//   //                           ],
//   //                         ),
//   //                       ),
//   //                     );
//   //                   }
//   //                   final pet = petProvider.pets[index - 1];
//   //                   final bool isSelected = pet.id == currentSelectedId;
//   //
//   //                   return GestureDetector(
//   //                     onTap: () {
//   //                       setState(() {
//   //                         _selectedPetId = pet.id;
//   //                       });
//   //                       Navigator.pop(context);
//   //                     },
//   //                     child: Container(
//   //                       padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
//   //                       decoration: BoxDecoration(
//   //                         color: isSelected
//   //                             ? const Color(0xFF820DFF)
//   //                             : const Color(0xFFF4F7F6),
//   //                         borderRadius: BorderRadius.circular(18.r),
//   //                       ),
//   //                       child: Row(
//   //                         children: [
//   //                           Container(
//   //                             width: 44.w,
//   //                             height: 44.h,
//   //                             decoration: BoxDecoration(
//   //                               shape: BoxShape.circle,
//   //                               border: Border.all(
//   //                                 color: isSelected
//   //                                     ? Colors.grey.shade200
//   //                                     : const Color(0xFF820DFF),
//   //                                 width: 2,
//   //                               ),
//   //                             ),
//   //                             child: ClipOval(
//   //                               child: pet.imageBytes != null
//   //                                   ? Image.memory(
//   //                                 pet.imageBytes!,
//   //                                 fit: BoxFit.cover,
//   //                               )
//   //                                   : Image.asset(
//   //                                 'assets/images/a2.png',
//   //                                 fit: BoxFit.cover,
//   //                               ),
//   //                             ),
//   //                           ),
//   //                           SizedBox(width: 12.w),
//   //                           Expanded(
//   //                             child: Text(
//   //                               pet.name,
//   //                               style: TextStyle(
//   //                                 fontSize: 16.sp,
//   //                                 fontWeight: FontWeight.w600,
//   //                                 color: isSelected ? Colors.white : Colors.black,
//   //                               ),
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ),
//   //                   );
//   //                 },
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//
//
//
//   Widget _buildActivitiesList(List<Activity> activities) {
//     final hasActivities = activities.isNotEmpty;
//
//     final formattedDate = DateFormat('EEEE, MMMM d').format(_selectedDate);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//
//       children: [
//         Container(
//           height: 70.h,
//
//           margin: EdgeInsets.symmetric(horizontal: 8.w),
//
//           decoration: BoxDecoration(
//             color: const Color(0xFFF4F7F6),
//
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//               children: [
//                 Row(
//                   children: [
//                     _buildHeaderIcon('assets/images/61.png'),
//                     SizedBox(width: 6.w),
//                     _buildHeaderIcon('assets/images/62.png'),
//                     SizedBox(width: 6.w),
//                     _buildHeaderIcon('assets/images/63.png'),
//                     SizedBox(width: 6.w),
//                     SizedBox(
//                         width: 40.w,
//                         height: 40.h,
//                         child: Image.asset('assets/images/a2.png')
//                     ),
//                   ],
//                 ),
//                 SizedBox(width: 6.w),
//                 GestureDetector(
//                   onTap: () => _showAddActivitySheet(context),
//                   child: const Text(
//                     'Add Activity',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Container(
//                   width: 50.w,
//
//                   height: 50.h,
//
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: IconButton(
//                     icon: SvgPicture.asset(
//                       'assets/images/add.svg',
//                       width: 28.w,
//                       height: 28.h,
//                     ),
//
//                     onPressed: () => _showAddActivitySheet(context),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         SizedBox(height: 24.h),
//
//         if (hasActivities)
//           Expanded(
//             child: ListView.builder(
//               itemCount: activities.length,
//
//               itemBuilder: (context, index) =>
//                   _buildActivityCard(activities[index], index),
//             ),
//           )
//         else
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//
//                 children: [
//                   Image.asset(
//                     'assets/images/images136.png',
//                     width: 100.w,
//                     height: 110.h,
//                   ),
//
//                   SizedBox(height: 20.h),
//
//                   Text(
//                     'No Activity Logged',
//                     style: TextStyle(fontSize: 20.sp, color: const Color(0xFF000000)),
//                   ),
//
//                   SizedBox(height: 8.h),
//
//                   Text(
//                     formattedDate,
//                     style:  TextStyle(fontSize: 12.sp, color: Color(0xFF878787)),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//
//
//   Widget _buildSettingList() {
//     final activityNotifier = Provider.of<ActivityNotifier>(context);
//
//     return Column(
//       children: [
//         // Padding(
//         //   padding: const EdgeInsets.all(8.0),
//         //   child: Container(
//         //     height: 101.h,
//         //     width: double.infinity,
//         //     decoration: const BoxDecoration(color: Color(0xFFF4F7F6)),
//         //     child: Padding(
//         //       padding: const EdgeInsets.all(8.0),
//         //       child: Row(
//         //         crossAxisAlignment: CrossAxisAlignment.start,
//         //         children: [
//         //           Expanded(
//         //             child: Column(
//         //               crossAxisAlignment: CrossAxisAlignment.start,
//         //               children: [
//         //                 Text(
//         //                   'Set As Default',
//         //                   style: TextStyle(
//         //                     fontSize: 24.sp,
//         //                     fontWeight: FontWeight.bold,
//         //                     color: Colors.black,
//         //                   ),
//         //                 ),
//         //                 SizedBox(height: 3.h),
//         //                 Text(
//         //                   'Open Meow automatically when you \nlaunch the app',
//         //                   style: TextStyle(
//         //                     fontSize: 14.sp,
//         //                     color: const Color(0xFF000000),
//         //                   ),
//         //                 ),
//         //               ],
//         //             ),
//         //           ),
//         //
//         //           Switch(
//         //             value: isDefault,
//         //             onChanged: (value) {
//         //               setState(() {
//         //                 isDefault = value;
//         //               });
//         //             },
//         //             activeColor: Colors.white,
//         //             activeTrackColor: const Color(0xFF820DFF),
//         //             inactiveTrackColor: Colors.white,
//         //             inactiveThumbColor: Colors.grey.shade400,
//         //
//         //             trackOutlineColor: WidgetStateProperty.all(
//         //               Colors.transparent,
//         //             ),
//         //           ),
//         //         ],
//         //       ),
//         //     ),
//         //   ),
//         // ),
//         // Padding(
//         //   padding: const EdgeInsets.all(8.0),
//         //   child: Container(
//         //     height: 160.h,
//         //     width: double.infinity,
//         //     decoration: const BoxDecoration(color: Color(0xFFF4F7F6)),
//         //     child: Padding(
//         //       padding: const EdgeInsets.all(8.0),
//         //       child: Column(
//         //         children: [
//         //           SizedBox(height: 8.h),
//         //           Padding(
//         //             padding: const EdgeInsets.only(left: 15),
//         //             child: Center(
//         //               child: Text(
//         //                 'Select the activities you\'d like to use. Drag the activities to change the order',
//         //
//         //                 style: TextStyle(
//         //                   fontSize: 18.sp,
//         //                   color: const Color(0xFF000000),
//         //                 ),
//         //               ),
//         //             ),
//         //           ),
//         //           SizedBox(height: 14.h),
//         //           RoundButton(
//         //             title: '+ Add new Activity',
//         //
//         //             isSelected: true,
//         //
//         //             textColors: Colors.white,
//         //
//         //             backgroundColors: AppColors.vibrantPurple,
//         //
//         //             onPress: () {
//         //               _showAddActivitySheet(context);
//         //             },
//         //           ),
//         //         ],
//         //       ),
//         //     ),
//         //   ),
//         // ),
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFFF4F7F6),
//               borderRadius: BorderRadius.circular(10.r),
//             ),
//             child: ListView.separated(
//               padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
//               itemCount: _allActivityTypes.length,
//               separatorBuilder: (context, index) => SizedBox(height: 12.h),
//               itemBuilder: (context, index) {
//                 final activityType = _allActivityTypes[index];
//                 final String name = activityType['name'];
//                 final String imagePath = activityType['image'];
//                 final Color color = activityType['color'];
//                 final bool isVisible = activityNotifier.isActivityVisible(name);
//
//                 return Container(
//                   height: 64.h,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 16.w,
//                     vertical: 12.h,
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 40.w,
//                         height: 40.h,
//                         decoration: BoxDecoration(
//                           color: color,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(8.w),
//                           child: Image.asset(imagePath, fit: BoxFit.contain),
//                         ),
//                       ),
//                       SizedBox(width: 16.w),
//                       Expanded(
//                         child: Text(
//                           name,
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(36.r),
//                           color: Colors.white,
//                           border: Border.all(color: Colors.white, width: 0),
//                         ),
//                         child: Switch(
//                           value: isVisible,
//                           activeColor: Colors.white,
//                           activeTrackColor: const Color(0xFF820DFF),
//                           inactiveTrackColor: Colors.grey.shade200,
//                           inactiveThumbColor: Colors.white,
//                           trackOutlineColor: WidgetStateProperty.all(
//                             Colors.transparent,
//                           ),
//                           onChanged: (value) {
//                             activityNotifier.toggleVisibility(name, value);
//                           },
//                         ),
//                       ),
//                       // Switch(
//                       //   value: isVisible,
//                       //   activeColor: Colors.white,
//                       //   activeTrackColor: const Color(0xFF7B2CBF),
//                       //   inactiveThumbColor: Colors.white,
//                       //   inactiveTrackColor: Colors.grey.shade300,
//                       //   onChanged: (value) {
//                       //     activityNotifier.toggleVisibility(name, value);
//                       //   },
//                       // ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//
//   // Widget _buildActivityCard(Activity activity, int index) {
//   //   final DateTime effectiveDateTime = (activity.hasReminder &&
//   //       activity.reminderDateTime != null)
//   //       ? activity.reminderDateTime!
//   //       : activity.dateTime;
//   //   final String activityName = activity.name.toLowerCase();
//   //
//   //   final bool isDrink = activityName == 'drink';
//   //
//   //   final bool isEat = activityName == 'eat';
//   //   final bool isTreat = activityName == 'treat';
//   //   final bool isGrooming = activityName == 'grooming';
//   //   final bool isMedication = activityName == 'medication';
//   //   final bool isVaccination = activityName == 'vaccination';
//   //   final bool isWeight = activityName == 'weight';
//   //   final bool isHeight = activityName == 'height';
//   //   final bool isTemperature = activityName == 'temperature';
//   //   final bool isHealth = activityName == 'health condition';
//   //   final bool isAccident = activityName == 'accident';
//   //   final bool isJournal = activityName == 'journal';
//   //   final bool isCleaning = activityName == 'cleaning';
//   //
//   //   final bool isWalk = activityName == 'walk';
//   //   final bool isPlay = activityName == 'play';
//   //   final bool isCrate = activityName == 'crate';
//   //   final bool isTraining = activityName == 'training';
//   //   final bool isSleep = activityName == 'sleep';
//   //   final bool isTimerActivity =
//   //       isWalk || isPlay || isCrate || isTraining || isSleep;
//   //
//   //   final bool hasNote = activity.note != null && activity.note!.isNotEmpty;
//   //
//   //   String distanceText = '';
//   //   String durationText = '';
//   //   String displayName = activity.name;
//   //   if (isTimerActivity) {
//   //     if (isWalk && activity.food != null && activity.food!.isNotEmpty) {
//   //       distanceText = activity.food!;
//   //     }
//   //
//   //     durationText = activity.displayDuration;
//   //   } else if (isDrink && activity.food != null && activity.food!.isNotEmpty) {
//   //     String food = activity.food!;
//   //     final RegExp quantityRegex = RegExp(r'^(\d+(?:\.\d+)?\s*[a-zA-Z]+)(.*)$');
//   //     final match = quantityRegex.firstMatch(food);
//   //
//   //     if (match != null) {
//   //       distanceText = match.group(1)?.trim() ?? '';
//   //       String namePart = match.group(2)?.trim() ?? '';
//   //       if (namePart.isNotEmpty) {
//   //         displayName = namePart;
//   //       }
//   //     } else {
//   //       // If no quantity pattern found, treat the whole string as the name
//   //       displayName = food;
//   //     }
//   //   }
//   //
//   //   return Dismissible(
//   //     key: Key(
//   //       'activity_${activity.name}_${activity.dateTime.millisecondsSinceEpoch}',
//   //     ),
//   //     background: _buildSwipeBackground(isLeft: true),
//   //     secondaryBackground: _buildSwipeBackground(isLeft: false),
//   //     confirmDismiss: (direction) async {
//   //       if (direction == DismissDirection.endToStart) {
//   //         return await _showDeleteConfirmation(activity);
//   //       }
//   //       _editActivity(activity);
//   //       return false;
//   //     },
//   //     onDismissed: (direction) {
//   //       if (direction == DismissDirection.endToStart) {
//   //         final activityNotifier =
//   //         Provider.of<ActivityNotifier>(context, listen: false);
//   //         final reminderNotifier =
//   //         Provider.of<ReminderNotifier>(context, listen: false);
//   //
//   //         if (activity.reminderId != null) {
//   //           reminderNotifier.cancelReminder(activity.reminderId!);
//   //         }
//   //         activityNotifier.deleteActivity(activity);
//   //       }
//   //     },
//   //     child: Card(
//   //       margin: EdgeInsets.symmetric(vertical: 4.h),
//   //       elevation: 0,
//   //       shape: RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.circular(12.r),
//   //       ),
//   //       color: const Color(0xFFF4F7F6),
//   //       child: Container(
//   //         padding: EdgeInsets.all(10.w),
//   //         child: Column(
//   //           children: [
//   //             Row(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //
//   //               children: [
//   //                 Padding(
//   //                   padding: const EdgeInsets.symmetric(vertical: 10),
//   //                   child: Stack(
//   //                     clipBehavior: Clip.none,
//   //                     children: [
//   //                       Container(
//   //                         width: 70.w,
//   //                         height: 70.h,
//   //                         decoration: BoxDecoration(
//   //                           shape: BoxShape.circle,
//   //
//   //                           color: Colors.white,
//   //
//   //                           boxShadow: [
//   //                             BoxShadow(
//   //                               color: Colors.black.withOpacity(0.1),
//   //                               blurRadius: 4,
//   //                               offset: const Offset(0, 2),
//   //                             ),
//   //                           ],
//   //                         ),
//   //
//   //                         child: Center(
//   //                           child: ClipOval(
//   //                             child: Image.asset(
//   //                               activity.imagePath,
//   //
//   //                               fit: BoxFit.cover,
//   //
//   //                               width: 54.w,
//   //
//   //                               height: 54.h,
//   //
//   //                               errorBuilder: (_, __, ___) => Icon(
//   //                                 Icons.pets,
//   //                                 color: activity.color,
//   //                                 size: 28.w,
//   //                               ),
//   //                             ),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                       if (activity.hasReminder &&
//   //                           activity.reminderDateTime != null)
//   //                         Positioned(
//   //                           top: -2,
//   //                           right: -2,
//   //                           child: Container(
//   //                             width: 16.w,
//   //                             height: 16.h,
//   //                             decoration: BoxDecoration(
//   //                               color: Colors.orange,
//   //                               shape: BoxShape.circle,
//   //                               border: Border.all(
//   //                                 color: Colors.white,
//   //                                 width: 1.5,
//   //                               ),
//   //                             ),
//   //                             child: Center(
//   //                               child: Icon(
//   //                                 Icons.notifications,
//   //                                 size: 10.w,
//   //                                 color: Colors.white,
//   //                               ),
//   //                             ),
//   //                           ),
//   //                         ),
//   //                     ],
//   //                   ),
//   //                 ),
//   //
//   //                 SizedBox(width: 12.w),
//   //
//   //                 Expanded(
//   //                   child: Column(
//   //                     crossAxisAlignment: CrossAxisAlignment.start,
//   //
//   //                     children: [
//   //                       Row(
//   //                         crossAxisAlignment: CrossAxisAlignment.start,
//   //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                         children: [
//   //                           Expanded(
//   //                             child: Padding(
//   //                               padding: const EdgeInsets.symmetric(
//   //                                 vertical: 20,
//   //                               ),
//   //                               child: Column(
//   //                                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                                 children: [
//   //                                   if (isDrink && distanceText.isNotEmpty)
//   //                                     Column(
//   //                                       crossAxisAlignment:
//   //                                       CrossAxisAlignment.start,
//   //                                       children: [
//   //                                         Text(
//   //                                           activity.name,
//   //                                           style: TextStyle(
//   //                                             fontSize: 18.sp,
//   //                                             fontWeight: FontWeight.bold,
//   //                                           ),
//   //                                         ),
//   //                                         SizedBox(height: 4.h),
//   //                                         Text(
//   //                                           distanceText,
//   //                                           style: TextStyle(
//   //                                             fontSize: 14.sp,
//   //                                             fontWeight: FontWeight.bold,
//   //                                             color: const Color(0xFF7D7D7D),
//   //                                           ),
//   //                                         ),
//   //                                         SizedBox(height: 4.h),
//   //                                         Text(
//   //                                           displayName,
//   //                                           style: TextStyle(
//   //                                             fontSize: 14.sp,
//   //                                             fontWeight: FontWeight.bold,
//   //                                             color: const Color(0xFF7D7D7D),
//   //                                           ),
//   //                                         ),
//   //                                       ],
//   //                                     )
//   //                                   else ...[
//   //                                     Text(
//   //                                       displayName,
//   //                                       style: TextStyle(
//   //                                         fontSize: 18.sp,
//   //                                         fontWeight: FontWeight.bold,
//   //                                       ),
//   //                                     ),
//   //                                     SizedBox(height: 6.h),
//   //                                     if (isTimerActivity)
//   //                                       Row(
//   //                                         children: [
//   //                                           if (distanceText.isNotEmpty)
//   //                                             Row(
//   //                                               children: [
//   //                                                 Icon(
//   //                                                   Icons.directions_walk,
//   //                                                   size: 16.sp,
//   //                                                   color: const Color(
//   //                                                     0xFF7D7D7D,
//   //                                                   ),
//   //                                                 ),
//   //                                                 SizedBox(width: 4.w),
//   //                                                 Text(
//   //                                                   distanceText,
//   //                                                   style: TextStyle(
//   //                                                     fontSize: 14.sp,
//   //                                                     fontWeight:
//   //                                                     FontWeight.bold,
//   //                                                     color: const Color(
//   //                                                       0xFF7D7D7D,
//   //                                                     ),
//   //                                                   ),
//   //                                                 ),
//   //                                               ],
//   //                                             ),
//   //                                           SizedBox(width: 5.w),
//   //                                           if (durationText.isNotEmpty)
//   //                                             Text(
//   //                                               durationText,
//   //                                               style: TextStyle(
//   //                                                 fontSize: 14.sp,
//   //                                                 fontWeight: FontWeight.bold,
//   //                                                 color: const Color(
//   //                                                   0xFF7D7D7D,
//   //                                                 ),
//   //                                               ),
//   //                                             ),
//   //                                         ],
//   //                                       )
//   //                                     else if ((isEat ||
//   //                                         isTreat ||
//   //                                         isGrooming ||
//   //                                         isMedication ||
//   //                                         isVaccination ||
//   //                                         isWeight ||
//   //                                         isHeight ||
//   //                                         isTemperature ||
//   //                                         isHealth ||
//   //                                         isAccident ||
//   //                                         isJournal ||
//   //                                         isCleaning) &&
//   //                                         activity.food != null &&
//   //                                         activity.food!.isNotEmpty)
//   //                                       Text(
//   //                                         activity.food!,
//   //                                         style: TextStyle(
//   //                                           fontSize: 14.sp,
//   //                                           fontWeight: FontWeight.bold,
//   //                                           color: const Color(0xFF7D7D7D),
//   //                                         ),
//   //                                       ),
//   //                                   ],
//   //                                 ],
//   //                               ),
//   //                             ),
//   //                           ),
//   //
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 20),
//   //
//   //                             child: Column(
//   //                               crossAxisAlignment: CrossAxisAlignment.end,
//   //
//   //                               children: [
//   //                                 Text(
//   //                                   DateFormat(
//   //                                     'MMM dd, yyyy',
//   //                                   ).format(effectiveDateTime).toLowerCase(),
//   //
//   //                                   style: TextStyle(
//   //                                     fontSize: 12.sp,
//   //                                     color: activity.hasReminder ? Colors.orange : Colors.grey[700],
//   //                                   ),
//   //                                 ),
//   //
//   //                                 SizedBox(height: 5.h),
//   //
//   //                                 Row(
//   //                                   mainAxisSize: MainAxisSize.min,
//   //
//   //                                   children: [
//   //                                     Icon(
//   //                                       activity.hasReminder ? Icons.notifications_active : Icons.access_time,
//   //                                       size: 16.w,
//   //                                       color: activity.hasReminder ? Colors.orange : Colors.grey[600],
//   //                                     ),
//   //
//   //                                     SizedBox(width: 4.w),
//   //
//   //                                     Text(
//   //                                       DateFormat(
//   //                                         'hh:mm a',
//   //                                       ).format(effectiveDateTime),
//   //
//   //                                       style: TextStyle(
//   //                                         fontSize: 17.sp,
//   //                                         color: activity.hasReminder ? Colors.orange : Colors.grey[600],
//   //                                       ),
//   //                                     ),
//   //                                   ],
//   //                                 ),
//   //                               ],
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ],
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //
//   //             const Divider(thickness: 1, height: 1, color: Color(0xFFCBE4DC)),
//   //
//   //             SizedBox(height: 2.h),
//   //
//   //             if (hasNote)
//   //               Padding(
//   //                 padding: EdgeInsets.only(top: 8.h),
//   //
//   //                 child: Row(
//   //                   crossAxisAlignment: CrossAxisAlignment.start,
//   //
//   //                   children: [
//   //                     SizedBox(width: 8.w),
//   //
//   //                     Expanded(
//   //                       child: Row(
//   //                         crossAxisAlignment: CrossAxisAlignment.start,
//   //
//   //                         children: [
//   //                           Text(
//   //                             'Note:',
//   //                             style: TextStyle(
//   //                               fontSize: 16.sp,
//   //                               fontWeight: FontWeight.w600,
//   //                               color: Colors.grey[800],
//   //                             ),
//   //                           ),
//   //
//   //                           SizedBox(width: 5.w),
//   //
//   //                           Expanded(
//   //                             child: Text(
//   //                               activity.note!,
//   //                               style: TextStyle(
//   //                                 fontSize: 16.sp,
//   //                                 color: Colors.black87,
//   //                               ),
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//
//
//   Widget _buildActivityCard(Activity activity, int index) {
//     final DateTime effectiveDateTime = (activity.hasReminder && activity.reminderDateTime != null)
//         ? activity.reminderDateTime!
//         : activity.dateTime;
//
//     final String activityName = activity.name.toLowerCase();
//
//     final bool isDrink = activityName == 'drink';
//     final bool isEat = activityName == 'eat';
//     final bool isTreat = activityName == 'treat';
//     final bool isGrooming = activityName == 'grooming';
//     final bool isMedication = activityName == 'medication';
//     final bool isVaccination = activityName == 'vaccination';
//     final bool isWeight = activityName == 'weight';
//     final bool isHeight = activityName == 'height';
//     final bool isTemperature = activityName == 'temperature';
//     final bool isHealth = activityName == 'health condition';
//     final bool isAccident = activityName == 'accident';
//     final bool isJournal = activityName == 'journal';
//     final bool isCleaning = activityName == 'cleaning';
//
//     final bool isWalk = activityName == 'walk';
//     final bool isPlay = activityName == 'play';
//     final bool isCrate = activityName == 'crate';
//     final bool isTraining = activityName == 'training';
//     final bool isSleep = activityName == 'sleep';
//     final bool isTimerActivity = isWalk || isPlay || isCrate || isTraining || isSleep;
//
//     final bool hasNote = activity.note != null && activity.note!.isNotEmpty;
//
//     String distanceText = '';
//     String durationText = '';
//     String displayName = activity.name;
//
//     if (isTimerActivity) {
//       if (isWalk && activity.food != null && activity.food!.isNotEmpty) {
//         distanceText = activity.food!;
//       }
//       durationText = activity.displayDuration;
//     } else if (isDrink && activity.food != null && activity.food!.isNotEmpty) {
//       String food = activity.food!;
//       final RegExp quantityRegex = RegExp(r'^(\d+(?:\.\d+)?\s*[a-zA-Z]+)(.*)$');
//       final match = quantityRegex.firstMatch(food);
//
//       if (match != null) {
//         distanceText = match.group(1)?.trim() ?? '';
//         String namePart = match.group(2)?.trim() ?? '';
//         if (namePart.isNotEmpty) {
//           displayName = namePart;
//         }
//       } else {
//         displayName = food;
//       }
//     }
//
//     return Dismissible(
//       key: Key('activity_${activity.name}_${activity.dateTime.millisecondsSinceEpoch}'),
//       background: _buildSwipeBackground(isLeft: true),
//       secondaryBackground: _buildSwipeBackground(isLeft: false),
//       confirmDismiss: (direction) async {
//         if (direction == DismissDirection.endToStart) {
//           return await _showDeleteConfirmation(activity);
//         }
//         _editActivity(activity);
//         return false;
//       },
//       onDismissed: (direction) {
//         if (direction == DismissDirection.endToStart) {
//           final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
//           final reminderNotifier = Provider.of<ReminderNotifier>(context, listen: false);
//
//           if (activity.reminderId != null) {
//             reminderNotifier.cancelReminder(activity.reminderId!);
//           }
//           activityNotifier.deleteActivity(activity);
//         }
//       },
//       child: Card(
//         margin: EdgeInsets.symmetric(vertical: 4.h),
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         color: const Color(0xFFF4F7F6),
//         child: Container(
//           padding: EdgeInsets.all(10.w),
//           child: Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Container(
//                       width: 70.w,
//                       height: 70.h,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Center(
//                         child: ClipOval(
//                           child: Image.asset(
//                             activity.imagePath,
//                             fit: BoxFit.cover,
//                             width: 54.w,
//                             height: 54.h,
//                             errorBuilder: (_, __, ___) => Icon(
//                               Icons.pets,
//                               color: activity.color,
//                               size: 28.w,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 12.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 20),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     if (isDrink && distanceText.isNotEmpty)
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             activity.name,
//                                             style: TextStyle(
//                                               fontSize: 18.sp,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           SizedBox(height: 4.h),
//                                           Text(
//                                             distanceText,
//                                             style: TextStyle(
//                                               fontSize: 14.sp,
//                                               fontWeight: FontWeight.bold,
//                                               color: const Color(0xFF7D7D7D),
//                                             ),
//                                           ),
//                                           SizedBox(height: 4.h),
//                                           Text(
//                                             displayName,
//                                             style: TextStyle(
//                                               fontSize: 14.sp,
//                                               fontWeight: FontWeight.bold,
//                                               color: const Color(0xFF7D7D7D),
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     else ...[
//                                       Text(
//                                         displayName,
//                                         style: TextStyle(
//                                           fontSize: 18.sp,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(height: 6.h),
//                                       if (isTimerActivity)
//                                         Row(
//                                           children: [
//                                             if (distanceText.isNotEmpty)
//                                               Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.directions_walk,
//                                                     size: 16.sp,
//                                                     color: const Color(0xFF7D7D7D),
//                                                   ),
//                                                   SizedBox(width: 4.w),
//                                                   Text(
//                                                     distanceText,
//                                                     style: TextStyle(
//                                                       fontSize: 14.sp,
//                                                       fontWeight: FontWeight.bold,
//                                                       color: const Color(0xFF7D7D7D),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             SizedBox(width: 5.w),
//                                             if (durationText.isNotEmpty)
//                                               Text(
//                                                 durationText,
//                                                 style: TextStyle(
//                                                   fontSize: 14.sp,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: const Color(0xFF7D7D7D),
//                                                 ),
//                                               ),
//                                           ],
//                                         )
//                                       else if ((isEat ||
//                                           isTreat ||
//                                           isGrooming ||
//                                           isMedication ||
//                                           isVaccination ||
//                                           isWeight ||
//                                           isHeight ||
//                                           isTemperature ||
//                                           isHealth ||
//                                           isAccident ||
//                                           isJournal ||
//                                           isCleaning) &&
//                                           activity.food != null &&
//                                           activity.food!.isNotEmpty)
//                                         Text(
//                                           activity.food!,
//                                           style: TextStyle(
//                                             fontSize: 14.sp,
//                                             fontWeight: FontWeight.bold,
//                                             color: const Color(0xFF7D7D7D),
//                                           ),
//                                         ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 20),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     DateFormat('MMM dd, yyyy')
//                                         .format(effectiveDateTime)
//                                         .toLowerCase(),
//                                     style: TextStyle(
//                                       fontSize: 12.sp,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                   SizedBox(height: 5.h),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         Icons.access_time,
//                                         size: 16.w,
//                                         color: Colors.grey[600],
//                                       ),
//                                       SizedBox(width: 4.w),
//                                       Text(
//                                         DateFormat('hh:mm a')
//                                             .format(effectiveDateTime),
//                                         style: TextStyle(
//                                           fontSize: 17.sp,
//                                           color: Colors.grey[600],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(thickness: 1, height: 1, color: Color(0xFFCBE4DC)),
//               SizedBox(height: 2.h),
//               if (hasNote)
//                 Padding(
//                   padding: EdgeInsets.only(top: 8.h),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(width: 8.w),
//                       Expanded(
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Note:',
//                               style: TextStyle(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.grey[800],
//                               ),
//                             ),
//                             SizedBox(width: 5.w),
//                             Expanded(
//                               child: Text(
//                                 activity.note!,
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//
//
//
//
//
//
//
//   Widget _buildSwipeBackground({required bool isLeft}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isLeft ? const Color(0xFF820DFF) : Colors.red,
//
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//
//       child: Align(
//         alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
//
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//
//           child: Row(
//             mainAxisAlignment: isLeft
//                 ? MainAxisAlignment.start
//                 : MainAxisAlignment.end,
//
//             children: [
//               Icon(
//                 isLeft ? Icons.edit : Icons.delete,
//                 color: Colors.white,
//                 size: 24.w,
//               ),
//
//               SizedBox(width: 8.w),
//
//               Text(
//                 isLeft ? 'Edit' : 'Delete',
//
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _showDeleteConfirmation(Activity activity) async {
//     bool? result = await showDialog<bool>(
//       context: context,
//
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//
//         title: const Text('Delete Activity'),
//
//         content: Text('Are you sure you want to delete "${activity.name}"?'),
//
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//
//     return result ?? false;
//   }
//
//   void _editActivity(Activity activity) {
//     final petProvider = Provider.of<PetProvider>(context, listen: false);
//     final effectivePetId = _selectedPetId ?? (petProvider.hasPets ? petProvider.pets.first.id : null);
//
//     Navigator.push(
//       context,
//
//       MaterialPageRoute(
//         builder: (context) => Allactivityview(
//           selectedActivity: activity,
//           selectedPetId: effectivePetId,
//         ),
//       ),
//     ).then((edited) {
//       if (edited == true && mounted) setState(() {});
//     });
//   }
//
//   Widget _buildHeaderIcon(String path) {
//     return Container(
//       width: 40.w,
//
//       height: 40.h,
//
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//
//       child: Padding(
//         padding: EdgeInsets.all(8.w),
//         child: Image.asset(path, width: 24.w, height: 24.h),
//       ),
//     );
//   }
//
//   void _showNoPetsDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.12),
//               blurRadius: 20,
//               spreadRadius: 4,
//               offset: const Offset(0, -4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Actions Required',
//               style: TextStyle(
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF000000),
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 50.w),
//               child: Center(
//                 child: Text(
//                   'Add at least one pet to start adding activities and reminders.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 20.sp,
//                     color: const Color(0xFF000000),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 24.h),
//             RoundButton(
//               title: 'Got it',
//               height: 66.h,
//               borderRadius: 10.r,
//               isSelected: true,
//               backgroundColors: AppColors.vibrantPurple,
//               textColors: Colors.white,
//               onPress: () {
//                 Navigator.pop(context);
//                 Provider.of<HomeViewModel>(context, listen: false).selectedIndex = 2;
//                 showModalBottomSheet(
//                   context: context,
//                   isScrollControlled: true,
//                   useSafeArea: true,
//                   builder: (context) => const AddPetView(),
//                 );
//               },
//             ),
//             SizedBox(height: 16.h),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showAddActivitySheet(BuildContext context) {
//     final petProvider = Provider.of<PetProvider>(context, listen: false);
//     final effectivePetId = _selectedPetId ??
//         (petProvider.hasPets ? petProvider.pets.first.id : null);
//
//     // ──────────────────────────────────────────────────────────────
//     // If no pets exist → show nice "Add Pet" overlay/bottom sheet
//     // ──────────────────────────────────────────────────────────────
//     if (!petProvider.hasPets) {
//       _showNoPetsDialog(context);
//       return;
//     }
//
//     // ──────────────────────────────────────────────────────────────
//     // If pet exists → show normal Add Activity screen
//     // ──────────────────────────────────────────────────────────────
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => SizedBox(
//         height: MediaQuery.of(context).size.height * 0.92,
//         child: AddActivitiesView(
//           initialDate: _selectedDate,
//           selectedPetId: effectivePetId,
//         ),
//       ),
//     );
//   }
//
// }
//
//
//
//
//
//           selectedPetId: effectivePetId,
//         ),
//       ),
//     );
//   }
//
// }
//
//
//
//
//
