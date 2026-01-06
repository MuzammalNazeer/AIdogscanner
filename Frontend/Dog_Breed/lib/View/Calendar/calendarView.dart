import 'dart:ffi';

import 'dart:io';

import 'package:dog_breed/Valid/AppColors.dart';

import 'package:dog_breed/View/Calendar/AddReminderView.dart';

import 'package:dog_breed/config/components/roundButton.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';


import '../../View_model/ReminderNotifier.dart';
import '../../View_model/activity_provider.dart';

import '../../activity_model.dart';


import '../../config/components/DocumentsScreen.dart';
import '../../utils/routes/routes_name.dart';

import 'add_activities_View.dart';

import 'allactivityview.dart';

class Calendarview extends StatefulWidget {
  const Calendarview({super.key});

  @override
  State<Calendarview> createState() => _CalendarviewState();
}

class _CalendarviewState extends State<Calendarview> {
  int _selectedTab = 0;

  DateTime _selectedDate = DateTime.now();

  DateTime _currentMonth = DateTime.now();
  final List<String> tabs = [
    'Activities',
    'Reminders',
    'Progress',
    'Documents',
    'Settings',
  ];
  final Map<String, String> _docCategoryByTitle = {
    'Vaccination Records': 'Medical & Care',
    'Pet Insurance Policy': 'Coverage & Finance',
    'Adoption Certificate': 'Legal & Licensing',
    'Training Certificate': 'Learning & Behavior',
  };
  bool isDefault = false;
  ScrollController? _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
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
    final itemWidth = 70.w + 12.w;
    final screenWidth = MediaQuery.of(context).size.width;
    final offset =
        selectedIndex * itemWidth - (screenWidth / 2) + (itemWidth / 2);
    final maxOffset = _scrollController!.position.maxScrollExtent;
    _scrollController!.animateTo(
      offset.clamp(0.0, maxOffset),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // Only current month days (no previous/next month padding)

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final days = <DateTime>[];
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    return days;
  }

  // Show calendar only in Activities (0) and Reminders (1) tabs

  bool get _shouldShowCalendar => _selectedTab == 0 || _selectedTab == 1;

  @override
  Widget build(BuildContext context) {
    final activityNotifier = Provider.of<ActivityNotifier>(context);

    final activities = activityNotifier.activities;

    final filteredActivities = activities.where((activity) {
      return activity.dateTime.year == _selectedDate.year &&
          activity.dateTime.month == _selectedDate.month &&
          activity.dateTime.day == _selectedDate.day;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),

        child: Column(
          children: [
            // Title
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
                    onTap: () => setState(() => _selectedTab = index),
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
            // Calendar Header + Horizontal Date Picker – ONLY for Activities & Reminders
            if (_shouldShowCalendar) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 32),
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

                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 32),
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
                ],
              ),

              SizedBox(height: 12.h),

              SizedBox(
                height: 100.h,

                child: ListView.builder(
                  controller: _scrollController,

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

                                SizedBox(height: 4.h),

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

                                SizedBox(height: 4.h),

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
                                  .getRemindersCountForDate(date);

                              if (count > 0) {
                                return Positioned(
                                  top: -5.h,

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
    switch (_selectedTab) {
      case 0: // Activities

        return _buildActivitiesList(filteredActivities);

      case 1: // Reminders

        return const AddReminderView();

      case 2: // Progress

        return const Center(
          child: Text(
            'Progress - Coming soon...',

            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        );

      case 3: // Documents

        return const DocumentsScreen();

      case 4: // Settings

        return _buildSettingList();

      default:
        return const Center(child: Text('Coming soon...'));
    }
  }

  Widget _buildSettingList() {
    // List of activities with their icons and default toggle state

    final List<Map<String, dynamic>> activities = [
      {'title': 'Eat', 'icon': 'assets/images/63.png', 'enabled': true},

      {'title': 'Pee', 'icon': 'assets/images/62.png', 'enabled': true},

      {'title': 'Drink', 'icon': 'assets/images/64.png', 'enabled': true},

      {'title': 'Poop', 'icon': 'assets/images/66.png', 'enabled': true},

      {'title': 'Walk', 'icon': 'assets/images/65.png', 'enabled': true},

      {'title': 'Play', 'icon': 'assets/images/65.png', 'enabled': true},

      {'title': 'Crate', 'icon': 'assets/images/68.png', 'enabled': true},

      {'title': 'Sleep', 'icon': 'assets/images/69.png', 'enabled': true},

      {'title': 'Training', 'icon': 'assets/images/70.png', 'enabled': true},

      {'title': 'Treat', 'icon': 'assets/images/71.png', 'enabled': true},

      {'title': 'Grooming', 'icon': 'assets/images/72.png', 'enabled': true},

      {'title': 'Bathing', 'icon': 'assets/images/73.png', 'enabled': true},

      {'title': 'Medication', 'icon': 'assets/images/74.png', 'enabled': true},

      {'title': 'Vaccination', 'icon': 'assets/images/75.png', 'enabled': true},

      {'title': 'Weight', 'icon': 'assets/images/77.png', 'enabled': true},

      {'title': 'Temperature', 'icon': 'assets/images/78.png', 'enabled': true},

      {
        'title': 'Health Condition',
        'icon': 'assets/images/79.png',
        'enabled': true,
      },

      {'title': 'Accident', 'icon': 'assets/images/80.png', 'enabled': true},

      {'title': 'Journal', 'icon': 'assets/images/81.png', 'enabled': true},
    ];

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 89.h,
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xFFF4F7F6)),
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

                          SizedBox(height: 8.h),

                          Text(
                            'Open Meow automatically when you launch the app',

                            style: TextStyle(
                              fontSize: 14.sp,

                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Switch(
                      value: isDefault,

                      onChanged: (value) {

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 160.h,
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xFFF4F7F6)),
                child: Column(
                  children: [
                    SizedBox(height: 8.h),

                    Text(
                      'Select the activities you\'d like to use. Drag the activities to change the order',

                      style: TextStyle(
                        fontSize: 14.sp,

                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: 24.h),

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
            SizedBox(height: 32.h),
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;

                    final item = activities.removeAt(oldIndex);

                    activities.insert(newIndex, item);
                  });
                },

                children: activities.asMap().entries.map((entry) {
                  int index = entry.key;

                  Map<String, dynamic> activity = entry.value;

                  return Container(
                    key: ValueKey(activity['title']),
                    // Required for ReorderableListView
                    height: 80.h,
                    width: double.infinity,

                    decoration:  BoxDecoration(color: Color(0xFFF4F7F6)),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),

                      padding: EdgeInsets.all(6.w),

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

                      child: Row(
                        children: [
                          Container(
                            width: 48.w,
                            height: 48.h,
                            decoration:  BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r), // Slight rounding for the image
                                child: Image.asset(
                                  activity['icon'],
                                  width: 30.w,
                                  height: 30.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.pets,
                                    color: Colors.grey[600],
                                    size: 28.w,
                                  ),
                                ),
                              ),
                            ),
                          ),                          // Activity Icon
                          // Image.asset(
                          //     activity['icon'],
                          //     width: 48.w,
                          //     height: 48.h,
                          //     errorBuilder: (_, __, ___) => Container(
                          //       width: 48.w,
                          //       height: 48.h,
                          //       decoration: BoxDecoration(
                          //         color: Colors.grey,
                          //         borderRadius: BorderRadius.circular(12.r),
                          //       ),
                          //       child: Icon(
                          //         Icons.pets,
                          //         color: Colors.grey[200],
                          //         size: 28.w,
                          //       ),
                          //     ),
                          //   ),

                          SizedBox(width: 16.w),

                          // Activity Title
                          Expanded(
                            child: Text(
                              activity['title'],

                              style: TextStyle(
                                fontSize: 18.sp,

                                fontWeight: FontWeight.w600,

                                color: Colors.black87,
                              ),
                            ),
                          ),

                          Switch(
                            value: activity['enabled'] ?? true,
                            activeColor: Colors.white,
                            activeTrackColor: const Color(0xFF820DFF),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.red,
                            thumbColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                              return Colors.white;
                            }),
                            trackOutlineColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                              return states.contains(MaterialState.selected)
                                  ? const Color(0xFF820DFF)
                                  : Colors.red;
                            }),
                            onChanged: (bool value) async {
                              if (!value) {
                                // Turning OFF - show confirmation
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text('Delete Activity'),
                                    content: Text(
                                      'Turn off and delete all "${activity['title']}" activities and reminders?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (shouldDelete == true) {
                                  // STEP 1: First show the switch as OFF (red)
                                  setState(() {
                                    activity['enabled'] = false;
                                  });

                                  // STEP 2: Wait briefly to show the red state
                                  await Future.delayed(const Duration(milliseconds: 500));

                                  // STEP 3: Now delete from database
                                  final title = activity['title'] as String;

                                  final activityNotifier = Provider.of<ActivityNotifier>(
                                    context,
                                    listen: false,
                                  );

                                  final reminderNotifier = Provider.of<ReminderNotifier>(
                                    context,
                                    listen: false,
                                  );

                                  activityNotifier.deleteActivitiesByName(title);
                                  await reminderNotifier.cancelRemindersForActivity(title);

                                  // STEP 4: Remove from list
                                  setState(() {
                                    activities.removeAt(index);
                                  });
                                } else {
                                  // User cancelled - keep enabled
                                  setState(() {
                                    activity['enabled'] = true;
                                  });
                                }
                              } else {
                                // Turning ON
                                setState(() {
                                  activity['enabled'] = true;
                                });
                              }
                            },
                          ),

                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
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

                    SizedBox(width: 8.w),

                    _buildHeaderIcon('assets/images/62.png'),

                    SizedBox(width: 8.w),

                    _buildHeaderIcon('assets/images/63.png'),
                  ],
                ),

                const Text(
                  'Add Activity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildActivityCard(Activity activity, int index) {
    final String activityName = activity.name.toLowerCase();

    final bool isDrink = activityName == 'drink';

    final bool isWalk = activityName == 'walk';

    final bool hasNote = activity.note != null && activity.note!.isNotEmpty;

    String distanceText = '';

    String durationText = '';

    if (isWalk) {
      if (activity.food != null && activity.food!.isNotEmpty)
        distanceText = activity.food!;

      if (activity.formattedDuration != null &&
          activity.formattedDuration!.isNotEmpty) {
        durationText = activity.formattedDuration!;
      } else if (activity.duration != null) {
        final hours = activity.duration!.inHours;

        final minutes = activity.duration!.inMinutes.remainder(60);

        durationText = hours > 0
            ? '$hours hr ${minutes > 0 ? '$minutes min' : ''}'.trim()
            : '$minutes min';
      }
    } else if (isDrink && activity.food != null && activity.food!.isNotEmpty) {
      distanceText = activity.food!;
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

        _editActivity(activity);

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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      activity.name,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 6.h),

                                    if (isWalk)
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
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(
                                                      0xFF7D7D7D,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                          SizedBox(width: 5.w),

                                          if (durationText.isNotEmpty)
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.timer,
                                                  size: 16.sp,
                                                  color: const Color(
                                                    0xFF7D7D7D,
                                                  ),
                                                ),

                                                SizedBox(width: 4.w),

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
                                            ),
                                        ],
                                      ),

                                    if (isDrink && distanceText.isNotEmpty)
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

              SizedBox(height: 12.h),

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

  void _editActivity(Activity activity) {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) => Allactivityview(selectedActivity: activity),
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

  void _showAddActivitySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.92,

        child: const AddActivitiesView(),
      ),
    );
  }
}





// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/activity_provider.dart'; // Your provider file
// import '../../activity_model.dart'; // Your Activity model
// import 'add_activities_View.dart';
// import 'allactivityview.dart'; // Your add activity screen
//
// class Calendarview extends StatefulWidget {
//   const Calendarview({super.key});
//
//   @override
//   State<Calendarview> createState() => _CalendarviewState();
// }
//
// class _CalendarviewState extends State<Calendarview> {
//   int _selectedTab = 0;
//   DateTime _selectedDate = DateTime.now();
//   DateTime _currentMonth = DateTime.now();
//
//   final List<String> tabs = ['Activities', 'Reminders', 'Progress', 'Documents', 'Settings'];
//   ScrollController? _scrollController;
//   int _selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollToSelectedDate();
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController?.dispose();
//     super.dispose();
//   }
//
// // Update the scrollToSelectedDate function to handle null controller
//   void _scrollToSelectedDate() {
//     if (_scrollController == null) return;
//
//     final days = _getDaysInMonth(_currentMonth);
//     final selectedIndex = days.indexWhere((date) =>
//     date.year == _selectedDate.year &&
//         date.month == _selectedDate.month &&
//         date.day == _selectedDate.day
//     );
//
//     if (selectedIndex != -1) {
//       _selectedIndex = selectedIndex;
//
//       // Calculate the position to scroll to (center of the list)
//       final itemWidth = 70.w + 12.w; // 70.w + horizontal margin (6.w * 2)
//       final screenWidth = MediaQuery.of(context).size.width;
//       final offset = (selectedIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
//
//       _scrollController!.animateTo(
//         offset.clamp(0.0, _scrollController!.position.maxScrollExtent),
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     // Listen to activities from provider
//     final activityNotifier = Provider.of<ActivityNotifier>(context);
//     final activities = activityNotifier.activities;
//
//     // Filter for selected date
//     final filteredActivities = activities.where((activity) {
//       return activity.dateTime.year == _selectedDate.year &&
//           activity.dateTime.month == _selectedDate.month &&
//           activity.dateTime.day == _selectedDate.day;
//     }).toList();
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 8.w),
//         child: Column(
//           children: [
//             // Title
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
//                     onTap: () => setState(() => _selectedTab = index),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           tabs[index],
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                             color: isSelected ? Colors.black : Colors.grey,
//                           ),
//                         ),
//                         if (isSelected)
//                           Container(
//                             width: 41.w,
//                             height: 3.h,
//                             margin: EdgeInsets.only(top: 4.h),
//                             decoration: const BoxDecoration(color: Color(0xFF820DFF)),
//                           ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             SizedBox(height: 16.h),
//
//             // Calendar Header (Month + Year + Arrows)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.chevron_left, size: 32),
//                   onPressed: () {
//                     setState(() {
//                       _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
//                     });
//                   },
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       DateFormat('MMMM yyyy').format(_currentMonth),
//                       style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(width: 16.w),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Text(
//                         'Month',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: const Color(0xFF820DFF),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.chevron_right, size: 32),
//                   onPressed: () {
//                     setState(() {
//                       _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
//                     });
//                   },
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 12.h),
//             SizedBox(
//               height: 100.h,
//               child: ListView.builder(
//                 controller: _scrollController, // This can be null initially
//                 scrollDirection: Axis.horizontal,
//                 itemCount: _getDaysInMonth(_currentMonth).length,
//                 itemBuilder: (context, index) {
//                   final date = _getDaysInMonth(_currentMonth)[index];
//                   final isSelected = date.year == _selectedDate.year &&
//                       date.month == _selectedDate.month &&
//                       date.day == _selectedDate.day;
//
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedDate = date;
//                       });
//                       // Scroll to the selected date after a small delay
//                       Future.delayed(const Duration(milliseconds: 50), () {
//                         if (_scrollController != null) {
//                           _scrollToSelectedDate();
//                         }
//                       });
//                     },
//                     child: Container(
//                       width: 70.w,
//                       margin: EdgeInsets.symmetric(horizontal: 6.w),
//                       padding: EdgeInsets.symmetric(vertical: 8.h),
//                       decoration: BoxDecoration(
//                         color: isSelected ? const Color(0xFF820DFF) : const Color(0xFFF4F7F6),
//                         borderRadius: BorderRadius.circular(16.r),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             DateFormat('MMM').format(date),
//                             style: TextStyle(
//                                 fontSize: 12.sp,
//                                 color: isSelected ? Colors.white : Colors.black54
//                             ),
//                           ),
//                           SizedBox(height: 4.h),
//                           Text(
//                             date.day.toString(),
//                             style: TextStyle(
//                               fontSize: 22.sp,
//                               fontWeight: FontWeight.bold,
//                               color: isSelected ? Colors.white : Colors.black,
//                             ),
//                           ),
//                           SizedBox(height: 4.h),
//                           Text(
//                             DateFormat('EEE').format(date),
//                             style: TextStyle(
//                                 fontSize: 12.sp,
//                                 color: isSelected ? Colors.white : Colors.black54
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // // Horizontal Days List
//             // SizedBox(
//             //   height: 100.h,
//             //   child: ListView.builder(
//             //     scrollDirection: Axis.horizontal,
//             //     itemCount: _getDaysInMonth(_currentMonth).length,
//             //     itemBuilder: (context, index) {
//             //       final date = _getDaysInMonth(_currentMonth)[index];
//             //       final isSelected = date.year == _selectedDate.year &&
//             //           date.month == _selectedDate.month &&
//             //           date.day == _selectedDate.day;
//             //
//             //       return GestureDetector(
//             //         onTap: () => setState(() => _selectedDate = date),
//             //         child: Container(
//             //           width: 70.w,
//             //           margin: EdgeInsets.symmetric(horizontal: 6.w),
//             //           padding: EdgeInsets.symmetric(vertical: 8.h),
//             //           decoration: BoxDecoration(
//             //             color: isSelected ? const Color(0xFF820DFF) : const Color(0xFFF4F7F6),
//             //             borderRadius: BorderRadius.circular(16.r),
//             //           ),
//             //           child: Column(
//             //             mainAxisAlignment: MainAxisAlignment.center,
//             //             children: [
//             //               Text(
//             //                 DateFormat('MMM').format(date),
//             //                 style: TextStyle(fontSize: 12.sp, color: isSelected ? Colors.white : Colors.black54),
//             //               ),
//             //               SizedBox(height: 4.h),
//             //               Text(
//             //                 date.day.toString(),
//             //                 style: TextStyle(
//             //                   fontSize: 22.sp,
//             //                   fontWeight: FontWeight.bold,
//             //                   color: isSelected ? Colors.white : Colors.black,
//             //                 ),
//             //               ),
//             //               SizedBox(height: 4.h),
//             //               Text(
//             //                 DateFormat('EEE').format(date),
//             //                 style: TextStyle(fontSize: 12.sp, color: isSelected ? Colors.white : Colors.black54),
//             //               ),
//             //             ],
//             //           ),
//             //         ),
//             //       );
//             //     },
//             //   ),
//             // ),
//
//             SizedBox(height: 20.h),
//
//             // Tab Content
//             Expanded(
//               child: _buildTabContent(filteredActivities),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabContent(List<Activity> filteredActivities) {
//     switch (_selectedTab) {
//       case 0:
//         return _buildActivitiesList(filteredActivities);
//     // Add other tabs later
//       default:
//         return const Center(child: Text('Coming soon...'));
//     }
//   }
//
//   Widget _buildActivitiesList(List<Activity> activities) {
//     final hasActivities = activities.isNotEmpty;
//     final formattedDate = DateFormat('EEEE, MMMM d').format(_selectedDate);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Add Activity Header
//         Container(
//           height: 70.h,
//           margin: EdgeInsets.symmetric(horizontal: 8.w),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF4F7F6),
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     _buildHeaderIcon('assets/images/dog788.svg'),
//                     SizedBox(width: 8.w),
//                     _buildHeaderIcon('assets/images/dog788.svg'),
//                     SizedBox(width: 8.w),
//                     _buildHeaderIcon('assets/images/dog788.svg'),
//                   ],
//                 ),
//                 const Text(
//                   'Add Activity',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Container(
//                   width: 50.w,
//                   height: 50.h,
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
//                     onPressed: () => _showAddActivitySheet(context),
//                   ),
//                 )
//
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
//               padding: EdgeInsets.symmetric(horizontal: 8.w),
//               itemCount: activities.length,
//               itemBuilder: (context, index) {
//                 return _buildActivityCard(activities[index]);
//               },
//             ),
//           )
//         else
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/images136.png',
//                     width: 100.w,
//                     height: 110.h,
//                   ),
//                   SizedBox(height: 20.h),
//                   const Text(
//                     'No Activity Logged',
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8.h),
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
//
//
//   Widget _buildActivityCard(Activity activity) {
//     final String activityName = activity.name.toLowerCase();
//     final bool isDrink = activityName == 'drink';
//     final bool isWalk = activityName == 'walk';
//     final String? amount = activity.food;
//
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 4.h),
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
//       color: const Color(0xFFF4F7F6),
//       child: Container(
//         padding: EdgeInsets.all(10.w),
//
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: Container(
//                     width: 70.w,
//                     height: 70.h,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: ClipOval(
//                         child: Image.asset(
//                           activity.imagePath ?? 'assets/images/dog_default.png',
//                           fit: BoxFit.cover,
//                           width: 54.w,
//                           height: 54.h,
//                           errorBuilder: (_, __, ___) => Icon(
//                             Icons.pets,
//                             color: activity.color ?? Colors.brown,
//                             size: 28.w,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // Left: Name + Amount (Drink or Walk)
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 20),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     activity.name,
//                                     style: TextStyle(
//                                       fontSize: 18.sp,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   // Show amount for Drink or Walk
//                                   if ((isDrink || isWalk) && amount != null && amount.isNotEmpty)
//                                     Padding(
//                                       padding: EdgeInsets.only(top: 6.h),
//                                       child: Text(
//                                         amount,
//                                         style: TextStyle(
//                                           fontSize: 14.sp,
//                                           fontWeight: FontWeight.bold,
//                                           color: const Color(0xFF7D7D7D), // Purple accent like Drink
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           // Right: Date & Time
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 20),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   activity.formattedDate.toLowerCase(),
//                                   style: TextStyle(
//                                     fontSize: 12.sp,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                                 SizedBox(height: 5.h),
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       Icons.access_time,
//                                       size: 16.w,
//                                       color: Colors.grey[600],
//                                     ),
//                                     SizedBox(width: 4.w),
//                                     Text(
//                                       activity.formattedTime,
//                                       style: TextStyle(
//                                         fontSize: 17.sp,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(
//               thickness: 1,
//               height: 1,
//               color: Color(0xFFCBE4DC),
//             ),
//             SizedBox(height: 12.h),
//             if (activity.note != null && activity.note!.isNotEmpty)
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Notes:',
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[800],
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   Expanded(
//                     child: Text(
//                       activity.note!,
//                       style: TextStyle(fontSize: 16.sp, color: Colors.black87),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//
//   Widget _buildHeaderIcon(String path) {
//     return Container(
//       width: 40.w,
//       height: 40.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(8.w),
//         child: SvgPicture.asset(path, width: 24.w, height: 24.h),
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
//         child: const AddActivitiesView(),
//       ),
//     );
//   }
//
//   List<DateTime> _getDaysInMonth(DateTime month) {
//     final firstDay = DateTime(month.year, month.month, 1);
//     final lastDay = DateTime(month.year, month.month + 1, 0);
//     final days = <DateTime>[];
//
//     // Previous month padding
//     for (int i = firstDay.weekday - 1; i > 0; i--) {
//       days.add(firstDay.subtract(Duration(days: i)));
//     }
//
//     // Current month
//     for (int i = 1; i <= lastDay.day; i++) {
//       days.add(DateTime(month.year, month.month, i));
//     }
//
//     // Next month padding
//     while (days.length < 42) {
//       days.add(days.last.add(const Duration(days: 1)));
//     }
//
//     return days;
//   }
// }
//
//
//
