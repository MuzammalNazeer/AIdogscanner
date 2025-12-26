import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Calendarview extends StatefulWidget {
  const Calendarview({super.key});

  @override
  State<Calendarview> createState() => _CalendarviewState();
}

class _CalendarviewState extends State<Calendarview> {
  int _selectedTab = 0;
  late DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  List<String> tabs = [
    'Activities',
    'Reminders',
    'Progress',
    'Documents',
    'Settings',
  ];

  // Sample data for different tabs
  List<Activity> activities = [
    Activity(
      title: 'Eat',
      date: 'Tue Dec 16',
      time: '10:00 AM',
      notes: 'Feed 1 cup of dry food only',
      isCompleted: false,
    ),
    Activity(
      title: 'Pee',
      date: 'Tue Dec 16',
      time: '10:00 AM',
      notes: 'Same place as morning walk.',
      isCompleted: false,
    ),
    Activity(
      title: 'Drink',
      date: 'Tue Dec 16',
      time: '10:00 AM',
      additionalInfo: '3.0mls',
      notes: 'Same place as morning walk.',
      isCompleted: false,
    ),
  ];

  List<Reminder> reminders = [
    Reminder(title: 'Vet Appointment', date: 'Dec 20, 2025', time: '2:00 PM'),
    Reminder(title: 'Buy Pet Food', date: 'Dec 22, 2025', time: '5:00 PM'),
  ];

  Map<String, double> progressData = {
    'Eating': 85.0,
    'Exercise': 65.0,
    'Hydration': 90.0,
    'Training': 45.0,
  };

  List<Document> documents = [
    Document(
      name: 'Vaccination Records.pdf',
      date: 'Nov 15, 2025',
      size: '2.4 MB',
    ),
    Document(
      name: 'Health Certificate.pdf',
      date: 'Oct 30, 2025',
      size: '1.8 MB',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Text(
                  'Manage',
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              height: 50.h,
              padding:  EdgeInsets.symmetric(horizontal: 12.w),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                separatorBuilder: (context, index) =>  SizedBox(width: 24.w),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = index;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tabs[index],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: _selectedTab == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _selectedTab == index
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (_selectedTab == index)
                          Container(
                            width: 41.w,
                            height: 3.h,
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
            SizedBox(height: 10.h),
            _buildCalendarSection1(),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection1() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 2),
      child: Column(
        children: [
          _buildCalendarSection(),
          SizedBox(height: 10.h),
          _buildCalendarDays(),
        ],
      ),
    );
  }

  Widget _buildCalendarDays() {
    final days = _getDaysInMonth(_currentMonth);

    return SizedBox(
      height: 130.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          return _buildDayItem(days[index]);
        },
      ),
    );
  }

  Widget _buildDayItem(DateTime date) {
    final bool isSelected =
        date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        width: 84.w,
        height: 74.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        padding: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : const Color(0xFFF4F7F6),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('MMM').format(date),
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              DateFormat('EEE').format(date),
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton.filledTonal(
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(
                      _currentMonth.year,
                      _currentMonth.month - 1,
                    );
                  });
                },
                icon:  Icon(Icons.chevron_left, size: 34.sp),
                style: IconButton.styleFrom(
                  fixedSize: Size(40.w, 40.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              SizedBox(width: 10.w,),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(_currentMonth),
                        style:  TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                       SizedBox(width: 24.w),
                      Container(
                        height: 40.h,
                        width: 87.w,
                        padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h,),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Center(
                          child: Text(
                            'Month',
                            style: TextStyle(fontSize: 14.sp, color: Color(0xFF820DFF),fontWeight: FontWeight.bold,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton.filledTonal(
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(
                      _currentMonth.year,
                      _currentMonth.month + 1,
                    );
                  });
                },
                icon: const Icon(Icons.chevron_left, size: 24),
                style: IconButton.styleFrom(
                  fixedSize: Size(40.w, 40.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesList() {
    const bool hasActivities = false;

    DateTime selectedDate = DateTime.now();
    String formattedDate = DateFormat('EEEE, d\'th\' MMMM').format(selectedDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            height: 74.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _buildHeaderIcon('assets/images/dog788.svg'),
                      SizedBox(width: 7.w),
                      _buildHeaderIcon('assets/images/dog788.svg'),
                      SizedBox(width: 7.w),
                      _buildHeaderIcon('assets/images/dog788.svg'),
                    ],
                  ),
                ),
                SizedBox(width: 78.w),
                Text(
                  "Add Activity",
                  style: TextStyle(
                    color: const Color(0xFF000000),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IconButton.filledTonal(
                    onPressed: () {
                      print("object");
                    },
                    style: IconButton.styleFrom(
                      fixedSize: Size(40.w, 42.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      overlayColor: Colors.grey[400],
                      elevation: 2,
                      surfaceTintColor: Colors.transparent,
                    ),
                    icon: SvgPicture.asset(
                      'assets/images/add.svg',
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 30.h,),
        hasActivities
            ? ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: 0, // replace with actual length
                itemBuilder: (context, index) {
                  // Your activity card code here (from previous version)
                  return Container(); // placeholder
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/images136.png',
                        width: 90.w,
                        height: 95.h,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No Activity Logged',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildHeaderIcon(String imagePath) {
    return Container(
      width: 44.w,
      height: 50.h,
      decoration:   BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(9)),
      child: Padding(
        padding: EdgeInsets.all(6.sp),
        child: SvgPicture.asset(
          imagePath,
          width: 24.w,
          height: 24.h,
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0: // Activities
        return _buildActivitiesList();
      case 1: // Reminders
        return _buildRemindersList();
      case 2: // Progress
        return _buildProgressView();
      case 3: // Documents
        return _buildDocumentsList();
      case 4: // Settings
        return _buildSettingsView();
      default:
        return _buildActivitiesList();
    }
  }

  Widget _buildRemindersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.notifications, color: Colors.orange),
            title: Text(reminders[index].title),
            subtitle: Text(
              '${reminders[index].date} at ${reminders[index].time}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  reminders.removeAt(index);
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        for (var entry in progressData.entries)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: entry.value / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      entry.value > 80
                          ? Colors.green
                          : entry.value > 60
                          ? Colors.blue
                          : entry.value > 40
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.value.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDocumentsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.insert_drive_file, color: Colors.blue),
            title: Text(documents[index].name),
            subtitle: Text(
              '${documents[index].date} • ${documents[index].size}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.download, color: Colors.green),
              onPressed: () {
                // Download functionality
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Appearance'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;

    List<DateTime> days = [];

    // Add previous month's trailing days
    for (int i = firstWeekday - 1; i > 0; i--) {
      days.add(firstDayOfMonth.subtract(Duration(days: i)));
    }

    // Add current month's days
    for (int i = 0; i < lastDayOfMonth.day; i++) {
      days.add(DateTime(month.year, month.month, i + 1));
    }

    // Add next month's leading days to complete the grid (6 rows × 7 columns)
    final totalCells = 42; // 6 weeks * 7 days
    while (days.length < totalCells) {
      days.add(days.last.add(const Duration(days: 1)));
    }

    return days;
  }
}

class Activity {
  String title;
  String date;
  String time;
  String notes;
  String? additionalInfo;
  bool isCompleted;

  Activity({
    required this.title,
    required this.date,
    required this.time,
    required this.notes,
    this.additionalInfo,
    required this.isCompleted,
  });
}

class Reminder {
  final String title;
  final String date;
  final String time;

  Reminder({required this.title, required this.date, required this.time});
}

class Document {
  final String name;
  final String date;
  final String size;

  Document({required this.name, required this.date, required this.size});
}
