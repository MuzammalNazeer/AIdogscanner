import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendarview extends StatefulWidget {
  const Calendarview({super.key});

  @override
  _CalendarviewState createState() => _CalendarviewState();
}

class _CalendarviewState extends State<Calendarview> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime(2025, 12, 25); // December 25, 2025
  DateTime? _selectedDay;

  // Sample activities data
  final Map<DateTime, List<Activity>> _activities = {
    DateTime(2025, 12, 25): [
      Activity(
        title: 'Team Meeting',
        time: '10:00 AM',
        color: Colors.blue[400]!,
      ),
      Activity(
        title: 'Client Presentation',
        time: '2:00 PM',
        color: Colors.green[400]!,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Manage',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          _buildTopButton('Activities', 0),
          _buildTopButton('Reminders', 1),
          _buildTopButton('Progress', 2),
          _buildTopButton('Documents', 3),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Month header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'December 2025',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Month',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Calendar
          _buildCalendar(),

          // Selected day header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getFormattedDate(_selectedDay ?? _focusedDay),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddActivityDialog();
                  },
                  icon: Icon(Icons.add, size: 20),
                  label: Text('Add Activity'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Activities list
          Expanded(
            child: _buildActivitiesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopButton(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TableCalendar(
        firstDay: DateTime(2025, 12, 1),
        lastDay: DateTime(2025, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          defaultDecoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          weekendTextStyle: TextStyle(color: Colors.black),
        ),
        headerVisible: false,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          weekendStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        rowHeight: 45,
        daysOfWeekHeight: 30,
      ),
    );
  }

  Widget _buildActivitiesList() {
    final selectedDate = _selectedDay ?? _focusedDay;
    final activities = _activities[DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    )];

    if (activities == null || activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: Colors.grey[300],
            ),
            SizedBox(height: 16),
            Text(
              'No Activity Logged',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              _getDayOfWeek(selectedDate),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return _buildActivityItem(activities[index]);
      },
    );
  }

  Widget _buildActivityItem(Activity activity) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: activity.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  activity.time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.more_vert,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
    final day = date.day;
    String suffix = 'th';
    if (day % 10 == 1 && day != 11) suffix = 'st';
    if (day % 10 == 2 && day != 12) suffix = 'nd';
    if (day % 10 == 3 && day != 13) suffix = 'rd';

    final daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    return '${daysOfWeek[date.weekday % 7]}, ${day}$suffix';
  }

  String _getDayOfWeek(DateTime date) {
    final daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return daysOfWeek[date.weekday % 7];
  }

  void _showAddActivityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Activity Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Time (e.g., 2:00 PM)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add activity logic here
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Activity {
  final String title;
  final String time;
  final Color color;

  Activity({
    required this.title,
    required this.time,
    required this.color,
  });
}