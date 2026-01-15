import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/View/Calendar/AddReminderView.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../View_model/ReminderNotifier.dart';
import '../../View_model/activity_provider.dart';
import '../../View_model/PetProvider.dart';
import '../../View_model/home/Pet.dart';
import '../../activity_model.dart';
import '../../config/components/DocumentsScreen.dart';
import '../../config/components/DrinkScreen.dart';
import '../../config/components/OtherCalculatorWidget.dart';
import '../../utils/routes/routes_name.dart';

import 'add_activities_View.dart';

import 'allactivityview.dart';

class Calendarview extends StatefulWidget {
  final void Function(String message)? onShowSnackBar;

  const Calendarview({super.key, this.onShowSnackBar});

  @override
  State<Calendarview> createState() => _CalendarviewState();
}

class _CalendarviewState extends State<Calendarview> {
  int _selectedTab = 0;
  int _selectedProgressTab = 0; // 0: Calendar, 1: Chart, 2: Compare

  DateTime _selectedDate = DateTime.now();

  DateTime _currentMonth = DateTime.now();
  String? _selectedPetId;
  final List<String> tabs = [
    'Activities',
    'Reminders',
    'Progress',
    'Documents',
    'Settings',
  ];

  final List<Map<String, dynamic>> _allActivityTypes = [
    {
      'name': 'Veterinary',
      'image': 'assets/images/61.png',
      'color': const Color(0xFFB9E6FF),
    },
    {
      'name': 'Pee',
      'image': 'assets/images/62.png',
      'color': const Color(0xFFFFD6C9),
    },
    {
      'name': 'Eat',
      'image': 'assets/images/63.png',
      'color': const Color(0xFFFFE3B9),
    },
    {
      'name': 'Drink',
      'image': 'assets/images/64.png',
      'color': const Color(0xFFB9DFFF),
    },
    {
      'name': 'Play',
      'image': 'assets/images/65.png',
      'color': const Color(0xFFC5F9FF),
    },
    {
      'name': 'Poop',
      'image': 'assets/images/66.png',
      'color': const Color(0xFFFFDEC5),
    },
    {
      'name': 'Walk',
      'image': 'assets/images/67.png',
      'color': const Color(0xFFF2F2F2),
    },
    {
      'name': 'Crate',
      'image': 'assets/images/68.png',
      'color': const Color(0xFFFFCFC7),
    },
    {
      'name': 'Sleep',
      'image': 'assets/images/69.png',
      'color': const Color(0xFFFFDDC2),
    },
    {
      'name': 'Training',
      'image': 'assets/images/70.png',
      'color': const Color(0xFFFFF1C2),
    },
    {
      'name': 'Treat',
      'image': 'assets/images/71.png',
      'color': const Color(0xFFFFEBD3),
    },
    {
      'name': 'Grooming',
      'image': 'assets/images/72.png',
      'color': const Color(0xFFD0FAFF),
    },
    {
      'name': 'Cleaning',
      'image': 'assets/images/73.png',
      'color': const Color(0xFFFFCFD5),
    },
    {
      'name': 'Medication',
      'image': 'assets/images/74.png',
      'color': const Color(0xFFFFEBEE),
    },
    {
      'name': 'Vaccination',
      'image': 'assets/images/75.png',
      'color': const Color(0xFFFFEAE3),
    },
    {
      'name': 'Weight',
      'image': 'assets/images/76.png',
      'color': const Color(0xFFD2F3FF),
    },
    {
      'name': 'Height',
      'image': 'assets/images/77.png',
      'color': const Color(0xFFEAD8D5),
    },
    {
      'name': 'Temperature',
      'image': 'assets/images/78.png',
      'color': const Color(0xFFE0EEFF),
    },
    {
      'name': 'Health Condition',
      'image': 'assets/images/79.png',
      'color': const Color(0xFFFFE7C0),
    },
    {
      'name': 'Accident',
      'image': 'assets/images/80.png',
      'color': const Color(0xFFFDFFD9),
    },
    {
      'name': 'Journal',
      'image': 'assets/images/81.png',
      'color': const Color(0xFFFFD5CA),
    },
  ];

  bool isDefault = false;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _loadSelectedProgressTab();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

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
    final double offset = targetOffset.clamp(0.0, maxScrollExtent) as double;
    _scrollController!.animateTo(
      offset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final days = <DateTime>[];
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    return days;
  }

  bool get _shouldShowCalendar => _selectedTab == 0 || _selectedTab == 1;

  @override
  Widget build(BuildContext context) {
    final activityNotifier = Provider.of<ActivityNotifier>(context);
    final petProvider = Provider.of<PetProvider>(context);
    final effectivePetId = _selectedPetId ?? (petProvider.hasPets ? petProvider.pets.first.id : null);

    final activities = activityNotifier.activities;

    final filteredActivities = activities.where((activity) {
      // final isVisible = activityNotifier.isActivityVisible(activity.name);
      final isSameDay = activity.dateTime.year == _selectedDate.year &&
          activity.dateTime.month == _selectedDate.month &&
          activity.dateTime.day == _selectedDate.day;
      
      final isSamePet = effectivePetId == null || activity.petId == effectivePetId;

      return isSameDay && isSamePet;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                'Manage',
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
                  final isSelected = _selectedTab == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedTab = index);
                      if (_shouldShowCalendar) {
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
            if (_selectedTab == 0) ...[
              _buildSelectedPetHeader(),
              SizedBox(height: 12.h),
            ],
            // Calendar Header + Horizontal Date Picker – ONLY for Activities
            if (_shouldShowCalendar) ...[
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
                        DateFormat('MMMM yyyy').format(_currentMonth),
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
                          'Month',
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
                                  DateFormat('MMM').format(date),

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
                                  DateFormat('EEE').format(date),

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
            Expanded(child: _buildTabContent(filteredActivities)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(List<Activity> filteredActivities) {
    final petProvider = Provider.of<PetProvider>(context);
    final effectivePetId = _selectedPetId ?? (petProvider.hasPets ? petProvider.pets.first.id : null);

    switch (_selectedTab) {
      case 0: // Activities

        return _buildActivitiesList(filteredActivities);

      case 1:
        return AddReminderView(selectedPetId: effectivePetId);
      case 2: // Progress

        return _buildProgressList(filteredActivities);

      case 3: // Documents

        return const DocumentsScreen();

      case 4: // Settings

        return _buildSettingList();

      default:
        return const Center(child: Text('Coming soon...'));
    }
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
              _buildProgressTabItem("Calendar", 0),
              _buildProgressTabItem("Chart", 1),
              _buildProgressTabItem("Compare", 2),
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

            // Divider that appears only for selected tab
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isSelected ? 3.h : 0,
              width: 42.w, // Fixed width
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
      {'title': 'Eat', 'icon': 'assets/images/63.png'},
      {'title': 'Pee', 'icon': 'assets/images/62.png'},
      {'title': 'Drink', 'icon': 'assets/images/64.png'},
      {'title': 'Poop', 'icon': 'assets/images/66.png'},
      {'title': 'Walk', 'icon': 'assets/images/65.png'},
      {'title': 'Play', 'icon': 'assets/images/65.png'},
      {'title': 'Crate', 'icon': 'assets/images/68.png'},
      {'title': 'Sleep', 'icon': 'assets/images/69.png'},
      {'title': 'Training', 'icon': 'assets/images/70.png'},
      {'title': 'Treat', 'icon': 'assets/images/71.png'},
      {'title': 'Grooming', 'icon': 'assets/images/72.png'},
      {'title': 'Cleaning', 'icon': 'assets/images/73.png'},
      {'title': 'Medication', 'icon': 'assets/images/74.png'},
      {'title': 'Vaccination', 'icon': 'assets/images/75.png'},
      {'title': 'Weight', 'icon': 'assets/images/77.png'},
      {'title': 'Height', 'icon': 'assets/images/76.png'},
      {'title': 'Temperature', 'icon': 'assets/images/78.png'},
      {'title': 'Health Condition', 'icon': 'assets/images/79.png'},
      {'title': 'Accident', 'icon': 'assets/images/80.png'},
      {'title': 'Journal', 'icon': 'assets/images/81.png'},
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
                final String iconPath = item['icon'];

                final int count = dailyActivities
                    .where((a) => a.name.toLowerCase() == title.toLowerCase())
                    .length;

                return GestureDetector(
                  onTap: () {
                    final petProvider = Provider.of<PetProvider>(context, listen: false);
                    final effectivePetId = _selectedPetId ?? (petProvider.hasPets ? petProvider.pets.first.id : null);

                    if (title.toLowerCase() == 'drink') {
                      // Open DrinkScreen directly on Drink Calculator tab (index 2)
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
                            activityTitle: title, // Pass the title
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
                        // Icon + Title
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
                                title,
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
                        // Count + Arrow
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
    final weekDays = List.generate(
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
                DateFormat('MMMM d, y').format(_selectedDate),
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
                final timeString = DateFormat('h a').format(time).toLowerCase();

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
                                  (activity) =>
                                  _buildTimelineActivityItem(activity),
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



  // Widget _buildSelectedPetHeader() {
  //   final petProvider = Provider.of<PetProvider>(context);
  //   final hasPets = petProvider.hasPets;
  //   final pets = petProvider.pets;
  //
  //   Pet? pet;
  //   if (hasPets) {
  //     if (_selectedPetId != null) {
  //       try {
  //         pet = pets.firstWhere((p) => p.id == _selectedPetId);
  //       } catch (_) {
  //         pet = pets.first;
  //       }
  //     } else {
  //       pet = pets.first;
  //     }
  //   }
  //
  //   return GestureDetector(
  //     onTap: hasPets ? () => _showPetPicker(petProvider) : null,
  //     child: Container(
  //       height: 66.h,
  //       margin: EdgeInsets.symmetric(horizontal: 8.w),
  //       decoration: BoxDecoration(
  //         color: const Color(0xFFF4F7F6),
  //         borderRadius: BorderRadius.circular(16.r),
  //       ),
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16.w),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 Container(
  //                   width: 40.w,
  //                   height: 40.h,
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     border: Border.all(
  //                       color: const Color(0xFF820DFF),
  //                       width: 3,
  //                     ),
  //                   ),
  //                   child: ClipOval(
  //                     child: pet != null && pet.imageBytes != null
  //                         ? Image.memory(
  //                       pet.imageBytes!,
  //                       fit: BoxFit.cover,
  //                     )
  //                         : Image.asset(
  //                       'assets/images/a2.png',
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(width: 12.w),
  //                 Text(
  //                   pet?.name ?? 'My Lovely Tomy',
  //                   style: TextStyle(
  //                     fontSize: 18.sp,
  //                     fontWeight: FontWeight.w600,
  //                     color: const Color(0xFF301934),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const Icon(
  //               Icons.keyboard_arrow_down,
  //               size: 24,
  //               color: Colors.black,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }


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
              activity.name,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            DateFormat('h:mm a').format(activity.dateTime),
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
    ); // Strip time

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

    final dateRangeText =
        "${DateFormat('MMMM d, y').format(startOfWeek)} - ${DateFormat('MMMM d, y').format(endOfWeek)}";

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
                            text = const Text('Mon', style: style);
                            break;
                          case 2:
                            text = const Text('Tue', style: style);
                            break;
                          case 3:
                            text = const Text('Wed', style: style);
                            break;
                          case 4:
                            text = const Text('Thu', style: style);
                            break;
                          case 5:
                            text = const Text('Fri', style: style);
                            break;
                          case 6:
                            text = const Text('Sat', style: style);
                            break;
                          case 7:
                            text = const Text('Sun', style: style);
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
        SizedBox(height: 16.h),
        Container(
          height: 66.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF820DFF),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 20),
              SizedBox(width: 8.w),
              Text(
                dateRangeText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8.w),
              const Icon(Icons.edit, color: Colors.white, size: 20),
            ],
          ),
        ),
        SizedBox(height: 80.h),
      ],
    );
  }

  Widget _buildSelectedPetHeader() {
    final petProvider = Provider.of<PetProvider>(context);
    final hasPets = petProvider.hasPets;
    final pets = petProvider.pets;

    Pet? pet;
    if (hasPets) {
      if (_selectedPetId != null) {
        try {
          pet = pets.firstWhere((p) => p.id == _selectedPetId);
        } catch (_) {
          pet = pets.first;
        }
      } else {
        pet = pets.first;
      }
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
                      border: Border.all(
                        color: const Color(0xFF820DFF),
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: pet != null && pet.imageBytes != null
                          ? Image.memory(
                              pet.imageBytes!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/a2.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    pet?.name ?? 'My Lovely Tomy',
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300.h,
          child: ListView.separated(
            itemCount: petProvider.pets.length,
            separatorBuilder: (_, __) => Divider(height: 1.h),
            itemBuilder: (context, index) {
              final pet = petProvider.pets[index];
              return ListTile(
                leading: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF820DFF),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: pet.imageBytes != null
                        ? Image.memory(
                            pet.imageBytes!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/a2.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                title: Text(pet.name),
                subtitle: Text(pet.breed),
                onTap: () {
                  setState(() {
                    _selectedPetId = pet.id;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildActivitiesList(List<Activity> activities) {
    final hasActivities = activities.isNotEmpty;

    final formattedDate = DateFormat('EEEE, MMMM d').format(_selectedDate);

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
                    SizedBox(width: 6.w),
                    _buildHeaderIcon('assets/images/62.png'),
                    SizedBox(width: 6.w),
                    _buildHeaderIcon('assets/images/63.png'),
                    SizedBox(width: 6.w),
                    SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: Image.asset('assets/images/a2.png')
                    ),
                  ],
                ),
                SizedBox(width: 6.w),
                GestureDetector(
                  onTap: () => _showAddActivitySheet(context),
                  child: const Text(
                    'Add Activity',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

        if (hasActivities)
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,

              itemBuilder: (context, index) =>
                  _buildActivityCard(activities[index], index),
            ),
          )
        else
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Image.asset(
                    'assets/images/images136.png',
                    width: 100.w,
                    height: 110.h,
                  ),

                  SizedBox(height: 20.h),

                  const Text(
                    'No Activity Logged',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSettingList() {
    final activityNotifier = Provider.of<ActivityNotifier>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 101.h,
            width: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFFF4F7F6)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Set As Default',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'Open Meow automatically when you \nlaunch the app',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Switch(
                    value: isDefault,
                    onChanged: (value) {
                      setState(() {
                        isDefault = value;
                      });
                    },
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF820DFF),
                    inactiveTrackColor: Colors.white,
                    inactiveThumbColor: Colors.grey.shade400,

                    trackOutlineColor: WidgetStateProperty.all(
                      Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 160.h,
            width: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFFF4F7F6)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Center(
                      child: Text(
                        'Select the activities you\'d like to use. Drag the activities to change the order',

                        style: TextStyle(
                          fontSize: 18.sp,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  RoundButton(
                    title: '+ Add new Activity',

                    isSelected: true,

                    textColors: Colors.white,

                    backgroundColors: AppColors.vibrantPurple,

                    onPress: () {
                      _showAddActivitySheet(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
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
                final String name = activityType['name'];
                final String imagePath = activityType['image'];
                final Color color = activityType['color'];
                final bool isVisible = activityNotifier.isActivityVisible(name);

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
                            activityNotifier.toggleVisibility(name, value);
                          },
                        ),
                      ),
                      // Switch(
                      //   value: isVisible,
                      //   activeColor: Colors.white,
                      //   activeTrackColor: const Color(0xFF7B2CBF),
                      //   inactiveThumbColor: Colors.white,
                      //   inactiveTrackColor: Colors.grey.shade300,
                      //   onChanged: (value) {
                      //     activityNotifier.toggleVisibility(name, value);
                      //   },
                      // ),
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

  Widget _buildActivityCard(Activity activity, int index) {
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
    final bool isTimerActivity =
        isWalk || isPlay || isCrate || isTraining || isSleep;

    final bool hasNote = activity.note != null && activity.note!.isNotEmpty;

    String distanceText = '';
    String durationText = '';
    String displayName = activity.name;
    if (isTimerActivity) {
      if (isWalk && activity.food != null && activity.food!.isNotEmpty) {
        distanceText = activity.food!;
      }

      durationText = activity.displayDuration;
    } else if (isDrink && activity.food != null && activity.food!.isNotEmpty) {
      String food = activity.food!;
      final RegExp quantityRegex = RegExp(r'^(\d+(?:\.\d+)?\s*[a-zA-Z]+)(.*)$');
      final match = quantityRegex.firstMatch(food);

      if (match != null) {
        distanceText = match.group(1)?.trim() ?? '';
        String namePart = match.group(2)?.trim() ?? '';
        if (namePart.isNotEmpty) {
          displayName = namePart;
        }
      } else {
        // If no quantity pattern found, treat the whole string as the name
        displayName = food;
      }
    }

    return Dismissible(
      key: Key(
        'activity_${activity.name}_${activity.dateTime.millisecondsSinceEpoch}',
      ),

      background: _buildSwipeBackground(isLeft: true),

      secondaryBackground: _buildSwipeBackground(isLeft: false),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(activity);
        }

        // _editActivity(activity);

        return false;
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
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
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
                        if (activity.hasReminder &&
                            activity.reminderDateTime != null)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 16.w,
                              height: 16.h,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.notifications,
                                  size: 10.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isDrink && distanceText.isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            activity.name,
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
                                                    color: const Color(
                                                      0xFF7D7D7D,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    distanceText,
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: const Color(
                                                        0xFF7D7D7D,
                                                      ),
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
                                                  color: const Color(
                                                    0xFF7D7D7D,
                                                  ),
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
                                          activity.food!,
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
                                    DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(activity.dateTime).toLowerCase(),

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
                                        DateFormat(
                                          'hh:mm a',
                                        ).format(activity.dateTime),

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
                              'Note:',
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
                isLeft ? 'Edit' : 'Delete',

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

        title: const Text('Delete Activity'),

        content: Text('Are you sure you want to delete "${activity.name}"?'),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),

          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // void _editActivity(Activity activity) {
  //   final petProvider = Provider.of<PetProvider>(context, listen: false);
  //   final effectivePetId = _selectedPetId ?? (petProvider.hasPets ? petProvider.pets.first.id : null);
  //
  //   Navigator.push(
  //     context,
  //
  //     MaterialPageRoute(
  //       builder: (context) => Allactivityview(
  //         selectedActivity: activity,
  //         selectedPetId: effectivePetId,
  //       ),
  //     ),
  //   ).then((edited) {
  //     if (edited == true && mounted) setState(() {});
  //   });
  // }

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

  void _showAddActivitySheet(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final effectivePetId = _selectedPetId ?? (petProvider.hasPets ? petProvider.pets.first.id : null);

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








// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/View/Calendar/AddReminderView.dart';
// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../View_model/ReminderNotifier.dart';
// import '../../View_model/activity_provider.dart';
// import '../../activity_model.dart';
// import '../../config/components/DocumentsScreen.dart';
// import '../../config/components/DrinkScreen.dart';
// import '../../config/components/OtherCalculatorWidget.dart';
// import '../../utils/routes/routes_name.dart';
//
// import 'add_activities_View.dart';
//
// import 'allactivityview.dart';
//
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
//   int _selectedTab = 0;
//   int _selectedProgressTab = 0; // 0: Calendar, 1: Chart, 2: Compare
//
//   DateTime _selectedDate = DateTime.now();
//
//   DateTime _currentMonth = DateTime.now();
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
//       'image': 'assets/images/61.png',
//       'color': const Color(0xFFB9E6FF),
//     },
//     {
//       'name': 'Pee',
//       'image': 'assets/images/62.png',
//       'color': const Color(0xFFFFD6C9),
//     },
//     {
//       'name': 'Eat',
//       'image': 'assets/images/63.png',
//       'color': const Color(0xFFFFE3B9),
//     },
//     {
//       'name': 'Drink',
//       'image': 'assets/images/64.png',
//       'color': const Color(0xFFB9DFFF),
//     },
//     {
//       'name': 'Play',
//       'image': 'assets/images/65.png',
//       'color': const Color(0xFFC5F9FF),
//     },
//     {
//       'name': 'Poop',
//       'image': 'assets/images/66.png',
//       'color': const Color(0xFFFFDEC5),
//     },
//     {
//       'name': 'Walk',
//       'image': 'assets/images/67.png',
//       'color': const Color(0xFFF2F2F2),
//     },
//     {
//       'name': 'Crate',
//       'image': 'assets/images/68.png',
//       'color': const Color(0xFFFFCFC7),
//     },
//     {
//       'name': 'Sleep',
//       'image': 'assets/images/69.png',
//       'color': const Color(0xFFFFDDC2),
//     },
//     {
//       'name': 'Training',
//       'image': 'assets/images/70.png',
//       'color': const Color(0xFFFFF1C2),
//     },
//     {
//       'name': 'Treat',
//       'image': 'assets/images/71.png',
//       'color': const Color(0xFFFFEBD3),
//     },
//     {
//       'name': 'Grooming',
//       'image': 'assets/images/72.png',
//       'color': const Color(0xFFD0FAFF),
//     },
//     {
//       'name': 'Cleaning',
//       'image': 'assets/images/73.png',
//       'color': const Color(0xFFFFCFD5),
//     },
//     {
//       'name': 'Medication',
//       'image': 'assets/images/74.png',
//       'color': const Color(0xFFFFEBEE),
//     },
//     {
//       'name': 'Vaccination',
//       'image': 'assets/images/75.png',
//       'color': const Color(0xFFFFEAE3),
//     },
//     {
//       'name': 'Weight',
//       'image': 'assets/images/76.png',
//       'color': const Color(0xFFD2F3FF),
//     },
//     {
//       'name': 'Height',
//       'image': 'assets/images/77.png',
//       'color': const Color(0xFFEAD8D5),
//     },
//     {
//       'name': 'Temperature',
//       'image': 'assets/images/78.png',
//       'color': const Color(0xFFE0EEFF),
//     },
//     {
//       'name': 'Health Condition',
//       'image': 'assets/images/79.png',
//       'color': const Color(0xFFFFE7C0),
//     },
//     {
//       'name': 'Accident',
//       'image': 'assets/images/80.png',
//       'color': const Color(0xFFFDFFD9),
//     },
//     {
//       'name': 'Journal',
//       'image': 'assets/images/81.png',
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
//     _scrollController = ScrollController();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollToSelectedDate();
//     });
//   }
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
//       (date) =>
//           date.year == _selectedDate.year &&
//           date.month == _selectedDate.month &&
//           date.day == _selectedDate.day,
//     );
//     if (selectedIndex == -1) return;
//     final double itemWidth = 70.w + 12.w;
//     final double viewportWidth = MediaQuery.of(context).size.width - 16.w;
//     final double targetOffset =
//         selectedIndex * itemWidth - (viewportWidth - itemWidth) / 2;
//     final double maxScrollExtent = _scrollController!.position.maxScrollExtent;
//     final double offset = targetOffset.clamp(0.0, maxScrollExtent) as double;
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
//   // Show calendar only in Activities (0) and Reminders (1) tabs
//
//   bool get _shouldShowCalendar => _selectedTab == 0 || _selectedTab == 1;
//
//   @override
//   Widget build(BuildContext context) {
//     final activityNotifier = Provider.of<ActivityNotifier>(context);
//
//     final activities = activityNotifier.activities;
//
//     final filteredActivities = activities.where((activity) {
//       // final isVisible = activityNotifier.isActivityVisible(activity.name);
//       return /*isVisible &&*/ activity.dateTime.year == _selectedDate.year &&
//           activity.dateTime.month == _selectedDate.month &&
//           activity.dateTime.day == _selectedDate.day;
//     }).toList();
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
//                       setState(() => _selectedTab = index);
//                       if (_shouldShowCalendar) {
//                         WidgetsBinding.instance.addPostFrameCallback(
//                           (_) => _scrollToSelectedDate(),
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
//             // Calendar Header + Horizontal Date Picker – ONLY for Activities & Reminders
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
//                         date.month == _selectedDate.month &&
//                         date.day == _selectedDate.day;
//                     return GestureDetector(
//                       onTap: () {
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
//                                   .getRemindersCountForDate(date);
//
//                               if (count > 0) {
//                                 return Positioned(
//                                   top: -1.h,
//
//                                   right: 0,
//
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
//             Expanded(child: _buildTabContent(filteredActivities)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabContent(List<Activity> filteredActivities) {
//     switch (_selectedTab) {
//       case 0: // Activities
//
//         return _buildActivitiesList(filteredActivities);
//
//       case 1:
//         return const AddReminderView();
//       case 2: // Progress
//
//         return _buildProgressList(filteredActivities);
//
//       case 3: // Documents
//
//         return const DocumentsScreen();
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
//       {'title': 'Eat', 'icon': 'assets/images/63.png'},
//       {'title': 'Pee', 'icon': 'assets/images/62.png'},
//       {'title': 'Drink', 'icon': 'assets/images/64.png'},
//       {'title': 'Poop', 'icon': 'assets/images/66.png'},
//       {'title': 'Walk', 'icon': 'assets/images/65.png'},
//       {'title': 'Play', 'icon': 'assets/images/65.png'},
//       {'title': 'Crate', 'icon': 'assets/images/68.png'},
//       {'title': 'Sleep', 'icon': 'assets/images/69.png'},
//       {'title': 'Training', 'icon': 'assets/images/70.png'},
//       {'title': 'Treat', 'icon': 'assets/images/71.png'},
//       {'title': 'Grooming', 'icon': 'assets/images/72.png'},
//       {'title': 'Cleaning', 'icon': 'assets/images/73.png'},
//       {'title': 'Medication', 'icon': 'assets/images/74.png'},
//       {'title': 'Vaccination', 'icon': 'assets/images/75.png'},
//       {'title': 'Weight', 'icon': 'assets/images/77.png'},
//       {'title': 'Height', 'icon': 'assets/images/76.png'},
//       {'title': 'Temperature', 'icon': 'assets/images/78.png'},
//       {'title': 'Health Condition', 'icon': 'assets/images/79.png'},
//       {'title': 'Accident', 'icon': 'assets/images/80.png'},
//       {'title': 'Journal', 'icon': 'assets/images/81.png'},
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
//                     if (title.toLowerCase() == 'drink') {
//                       // Open DrinkScreen directly on Drink Calculator tab (index 2)
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               const DrinkScreen(initialTab: 2),
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
//       (index) => startOfWeek.add(Duration(days: index)),
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
//                                       _buildTimelineActivityItem(activity),
//                                 )
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
//             startOfWeek.subtract(const Duration(seconds: 1)),
//           ) &&
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
//         SizedBox(height: 16.h),
//         Container(
//           height: 66.h,
//           margin: EdgeInsets.symmetric(horizontal: 16.w),
//           decoration: BoxDecoration(
//             color: const Color(0xFF820DFF),
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.calendar_today, color: Colors.white, size: 20),
//               SizedBox(width: 8.w),
//               Text(
//                 dateRangeText,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               const Icon(Icons.edit, color: Colors.white, size: 20),
//             ],
//           ),
//         ),
//         SizedBox(height: 80.h),
//       ],
//     );
//   }
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
//                   const Text(
//                     'No Activity Logged',
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//
//                   SizedBox(height: 8.h),
//
//                   Text(
//                     formattedDate,
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildSettingList() {
//     final activityNotifier = Provider.of<ActivityNotifier>(context);
//
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 101.h,
//             width: double.infinity,
//             decoration: const BoxDecoration(color: Color(0xFFF4F7F6)),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Set As Default',
//                           style: TextStyle(
//                             fontSize: 24.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         SizedBox(height: 3.h),
//                         Text(
//                           'Open Meow automatically when you \nlaunch the app',
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: const Color(0xFF000000),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   Switch(
//                     value: isDefault,
//                     onChanged: (value) {
//                       setState(() {
//                         isDefault = value;
//                       });
//                     },
//                     activeColor: Colors.white,
//                     activeTrackColor: const Color(0xFF820DFF),
//                     inactiveTrackColor: Colors.white,
//                     inactiveThumbColor: Colors.grey.shade400,
//
//                     trackOutlineColor: WidgetStateProperty.all(
//                       Colors.transparent,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 160.h,
//             width: double.infinity,
//             decoration: const BoxDecoration(color: Color(0xFFF4F7F6)),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   SizedBox(height: 8.h),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 15),
//                     child: Center(
//                       child: Text(
//                         'Select the activities you\'d like to use. Drag the activities to change the order',
//
//                         style: TextStyle(
//                           fontSize: 18.sp,
//                           color: const Color(0xFF000000),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 14.h),
//                   RoundButton(
//                     title: '+ Add new Activity',
//
//                     isSelected: true,
//
//                     textColors: Colors.white,
//
//                     backgroundColors: AppColors.vibrantPurple,
//
//                     onPress: () {
//                       _showAddActivitySheet(context);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
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
//   Widget _buildActivityCard(Activity activity, int index) {
//     final String activityName = activity.name.toLowerCase();
//
//     final bool isDrink = activityName == 'drink';
//
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
//     final bool isTimerActivity =
//         isWalk || isPlay || isCrate || isTraining || isSleep;
//
//     final bool hasNote = activity.note != null && activity.note!.isNotEmpty;
//
//     String distanceText = '';
//     String durationText = '';
//     String displayName = activity.name;
//     if (isTimerActivity) {
//       if (isWalk && activity.food != null && activity.food!.isNotEmpty) {
//         distanceText = activity.food!;
//       }
//
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
//         // If no quantity pattern found, treat the whole string as the name
//         displayName = food;
//       }
//     }
//
//     return Dismissible(
//       key: Key(
//         'activity_${activity.name}_${activity.dateTime.millisecondsSinceEpoch}',
//       ),
//
//       background: _buildSwipeBackground(isLeft: true),
//
//       secondaryBackground: _buildSwipeBackground(isLeft: false),
//
//       confirmDismiss: (direction) async {
//         if (direction == DismissDirection.endToStart) {
//           return await _showDeleteConfirmation(activity);
//         }
//
//         _editActivity(activity);
//
//         return false;
//       },
//
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
//
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Container(
//                           width: 70.w,
//                           height: 70.h,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//
//                             color: Colors.white,
//
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 4,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//
//                           child: Center(
//                             child: ClipOval(
//                               child: Image.asset(
//                                 activity.imagePath,
//
//                                 fit: BoxFit.cover,
//
//                                 width: 54.w,
//
//                                 height: 54.h,
//
//                                 errorBuilder: (_, __, ___) => Icon(
//                                   Icons.pets,
//                                   color: activity.color,
//                                   size: 28.w,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         if (activity.hasReminder &&
//                             activity.reminderDateTime != null)
//                           Positioned(
//                             top: -2,
//                             right: -2,
//                             child: Container(
//                               width: 16.w,
//                               height: 16.h,
//                               decoration: BoxDecoration(
//                                 color: Colors.orange,
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: Colors.white,
//                                   width: 1.5,
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.notifications,
//                                   size: 10.w,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(width: 12.w),
//
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 20,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     if (isDrink && distanceText.isNotEmpty)
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
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
//                                                     color: const Color(
//                                                       0xFF7D7D7D,
//                                                     ),
//                                                   ),
//                                                   SizedBox(width: 4.w),
//                                                   Text(
//                                                     distanceText,
//                                                     style: TextStyle(
//                                                       fontSize: 14.sp,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       color: const Color(
//                                                         0xFF7D7D7D,
//                                                       ),
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
//                                                   color: const Color(
//                                                     0xFF7D7D7D,
//                                                   ),
//                                                 ),
//                                               ),
//                                           ],
//                                         )
//                                       else if ((isEat ||
//                                               isTreat ||
//                                               isGrooming ||
//                                               isMedication ||
//                                               isVaccination ||
//                                               isWeight ||
//                                               isHeight ||
//                                               isTemperature ||
//                                               isHealth ||
//                                               isAccident ||
//                                               isJournal ||
//                                               isCleaning) &&
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
//
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 20),
//
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//
//                                 children: [
//                                   Text(
//                                     DateFormat(
//                                       'MMM dd, yyyy',
//                                     ).format(activity.dateTime).toLowerCase(),
//
//                                     style: TextStyle(
//                                       fontSize: 12.sp,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//
//                                   SizedBox(height: 5.h),
//
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//
//                                     children: [
//                                       Icon(
//                                         Icons.access_time,
//                                         size: 16.w,
//                                         color: Colors.grey[600],
//                                       ),
//
//                                       SizedBox(width: 4.w),
//
//                                       Text(
//                                         DateFormat(
//                                           'hh:mm a',
//                                         ).format(activity.dateTime),
//
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
//
//               const Divider(thickness: 1, height: 1, color: Color(0xFFCBE4DC)),
//
//               SizedBox(height: 2.h),
//
//               if (hasNote)
//                 Padding(
//                   padding: EdgeInsets.only(top: 8.h),
//
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//
//                     children: [
//                       SizedBox(width: 8.w),
//
//                       Expanded(
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//
//                           children: [
//                             Text(
//                               'Note:',
//                               style: TextStyle(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.grey[800],
//                               ),
//                             ),
//
//                             SizedBox(width: 5.w),
//
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
//     Navigator.push(
//       context,
//
//       MaterialPageRoute(
//         builder: (context) => Allactivityview(selectedActivity: activity),
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
//   void _showAddActivitySheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => SizedBox(
//         height: MediaQuery.of(context).size.height * 0.92,
//         child: AddActivitiesView(initialDate: _selectedDate),
//       ),
//     );
//   }
// }
//
