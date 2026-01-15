import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../activity_model.dart';
import '../../View_model/activity_provider.dart';

class Othercalculatorwidget extends StatefulWidget {
  final int initialTab;
  final String activityTitle;
  final int activityCount;
  final String? selectedPetId;

  const Othercalculatorwidget({
    super.key,
    this.initialTab = 0,
    required this.activityTitle,
    required this.activityCount,
    this.selectedPetId,
  });

  @override
  State<Othercalculatorwidget> createState() => _OthercalculatorwidgetState();
}

class _OthercalculatorwidgetState extends State<Othercalculatorwidget> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with dynamic title
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.activityTitle,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Optional: Show count in header
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Text(
                      '${widget.activityCount}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            _buildTabBar(),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedTab == 0) ...[
                      _buildInfoSection(),
                      SizedBox(height: 10.h),
                      _buildCompareDropdown(),
                      SizedBox(height: 10.h),
                      _buildDateRangeSelector(),
                      SizedBox(height: 16.h),
                    ],
                    _buildTabContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab Bar ────────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      height: 56.h,
      color: const Color(0xFF6A00FF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem("Heatmap", 0),
          _buildTabItem("Timeline", 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isSelected ? 3.h : 0,
              width: 64.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab Content Switch ─────────────────────────────────────────────────────
  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildHeatmapSection();
      case 1:
        return _buildTimelineSection();
      default:
        return _buildHeatmapSection();
    }
  }

  // ── Heatmap Tab ────────────────────────────────────────────────────────────
  Widget _buildHeatmapSection() {
    try {
      final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
      final allActivities = activityNotifier.activities;

      // Use dynamic activity title for filtering
      final filteredActivities = allActivities.where((a) {
        final matchesName = a.name.toLowerCase().contains(widget.activityTitle.toLowerCase());
        final matchesPet = widget.selectedPetId == null || a.petId == widget.selectedPetId;
        return matchesName && matchesPet;
      }).toList();

      final Map<int, Map<int, int>> heatmapData = {};

      for (int day = 0; day < 7; day++) {
        heatmapData[day] = {};
        for (int hour = 0; hour < 24; hour++) {
          heatmapData[day]![hour] = 0;
        }
      }

      for (var activity in filteredActivities) {
        final weekday = activity.dateTime.weekday;
        final hour = activity.dateTime.hour;
        final dayIndex = weekday % 7;

        int intensity = 1;
        if (activity.food != null && activity.food!.isNotEmpty) {
          final numStr = activity.food!.replaceAll(RegExp(r'[^0-9.]'), '');
          final num = double.tryParse(numStr) ?? 0;
          intensity = (num / 200).ceil().clamp(1, 5);
        }

        heatmapData[dayIndex]![hour] = heatmapData[dayIndex]![hour]! + intensity;
      }

      int maxIntensity = 1;
      for (int day = 0; day < 7; day++) {
        for (int hour = 0; hour < 24; hour++) {
          if (heatmapData[day]![hour]! > maxIntensity) {
            maxIntensity = heatmapData[day]![hour]!;
          }
        }
      }

      final double cellHeight = 16.h;
      final double cellMargin = 2.h;
      final double totalCellHeight = cellHeight + (cellMargin * 2);
      final double timeLabelWidth = 50.w;

      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildHeatmapGrid(
                  cellHeight,
                  cellMargin,
                  heatmapData,
                  maxIntensity,
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: timeLabelWidth,
                child: _buildTimeLabels(totalCellHeight),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          _buildDayLabels(),
          SizedBox(height: 16.h),
          _buildHeatmapLegend(),
        ],
      );
    } catch (e) {
      if (kDebugMode) print('Heatmap error: $e');
      return Center(
        child: Text(
          'Error loading heatmap',
          style: TextStyle(color: Colors.red, fontSize: 14.sp),
        ),
      );
    }
  }

  Widget _buildHeatmapGrid(
      double cellHeight,
      double cellMargin,
      Map<int, Map<int, int>> heatmapData,
      int maxIntensity,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (dayIndex) {
        return Expanded(
          child: Column(
            children: List.generate(24, (hourIndex) {
              final intensity = heatmapData[dayIndex]![hourIndex]!;
              Color cellColor = intensity == 0
                  ? Colors.grey.shade100
                  : intensity == 1
                  ? const Color(0xFFC9B3FF)
                  : intensity == 2
                  ? const Color(0xFFA280FF)
                  : intensity == 3
                  ? const Color(0xFF7B4DFF)
                  : intensity == 4
                  ? const Color(0xFF6438FF)
                  : const Color(0xFF4D21FF);

              final now = DateTime.now();
              final currentDayIndex = now.weekday % 7;
              final currentHour = now.hour;

              final isNow = dayIndex == currentDayIndex && hourIndex == currentHour;

              return Container(
                height: cellHeight,
                margin: EdgeInsets.symmetric(vertical: cellMargin, horizontal: cellMargin),
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: BorderRadius.circular(4.r),
                  border: isNow ? Border.all(color: Colors.red, width: 2.w) : null,
                ),
                child: Center(
                  child: Text(
                    intensity > 0 ? intensity.toString() : '',
                    style: TextStyle(
                      color: intensity > 2 ? Colors.white : Colors.black,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildTimeLabels(double totalCellHeight) {
    final hours = [
      '12 AM', '1 AM', '2 AM', '3 AM', '4 AM', '5 AM', '6 AM', '7 AM',
      '8 AM', '9 AM', '10 AM', '11 AM', '12 PM', '1 PM', '2 PM', '3 PM',
      '4 PM', '5 PM', '6 PM', '7 PM', '8 PM', '9 PM', '10 PM', '11 PM'
    ];

    final now = DateTime.now();
    bool isCurrentHour(int i) => i == now.hour;

    return Column(
      children: List.generate(
        24,
            (i) => Container(
          height: totalCellHeight,
          alignment: Alignment.center,
          child: Text(
            hours[i],
            style: TextStyle(
              fontSize: 12.sp,
              color: isCurrentHour(i) ? Colors.red : Colors.grey.shade600,
              fontWeight: isCurrentHour(i) ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayLabels() {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final now = DateTime.now();
    final currentDayIndex = now.weekday % 7;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(7, (i) {
        final isToday = i == currentDayIndex;
        final label = Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: isToday ? Colors.red.withOpacity(0.1) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.r),
            border: isToday ? Border.all(color: Colors.red, width: 1.w) : null,
          ),
          child: Text(
            days[i],
            style: TextStyle(
              color: isToday ? Colors.red : Colors.black54,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              fontSize: 12.sp,
            ),
          ),
        );

        if (i < 6) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              label,
              SizedBox(width: 10.w),
            ],
          );
        }

        return label;
      }),
    );
  }

  Widget _buildHeatmapLegend() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Intensity',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem('None', Colors.grey.shade100),
              _buildLegendItem('Low', const Color(0xFFC9B3FF)),
              _buildLegendItem('Medium', const Color(0xFF7B4DFF)),
              _buildLegendItem('High', const Color(0xFF4D21FF)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: Colors.red, width: 2.w),
                ),
                child: Text(
                  'Now',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: 4.w),
        Text(label, style: TextStyle(fontSize: 10.sp, color: Colors.black54)),
      ],
    );
  }

  // ── Timeline Tab ───────────────────────────────────────────────────────────
  Widget _buildTimelineSection() {
    final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
    final allActivities = activityNotifier.activities;

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final cleanStart = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final endOfWeek = cleanStart.add(const Duration(days: 6));

    // Use dynamic activity title for filtering
    final filteredActivities = allActivities.where((a) {
      return a.name.toLowerCase().contains(widget.activityTitle.toLowerCase()) &&
          a.dateTime.isAfter(cleanStart.subtract(const Duration(seconds: 1))) &&
          a.dateTime.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();

    final Map<int, List<Activity>> grouped = {1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: []};
    for (var act in filteredActivities) {
      grouped[act.dateTime.weekday]?.add(act);
    }

    final List<double> amountData = [];
    final List<double> frequencyData = [];
    double maxAmount = 1;
    double maxFrequency = 0;

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (int i = 1; i <= 7; i++) {
      final dayActs = grouped[i]!;
      frequencyData.add(dayActs.length.toDouble());
      if (dayActs.length > maxFrequency) maxFrequency = dayActs.length.toDouble();

      double totalML = 0;
      for (var act in dayActs) {
        if (act.food != null && act.food!.isNotEmpty) {
          final numStr = act.food!.replaceAll(RegExp(r'[^0-9.]'), '');
          final num = double.tryParse(numStr) ?? 0;
          totalML += act.food!.toLowerCase().contains('l') ? num * 1000 : num;
        }
      }
      amountData.add(totalML);
      if (totalML > maxAmount) maxAmount = totalML;
    }

    final dateRangeText =
        "${DateFormat('MMMM d, y').format(cleanStart)} - ${DateFormat('MMMM d, y').format(endOfWeek)}";

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (kDebugMode) print('Edit date range tapped');
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF820DFF),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white, size: 22),
                    SizedBox(width: 12.w),
                    Text(
                      dateRangeText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.edit, color: Colors.white, size: 22),
              ],
            ),
          ),
        ),
        SizedBox(height: 32.h),
        _buildLineChartCard(
          title: 'Amount in mL',
          rawData: amountData,
          maxValue: maxAmount,
          days: days,
        ),
        SizedBox(height: 32.h),
        _buildLineChartCard(
          title: 'Frequency',
          rawData: frequencyData,
          maxValue: maxFrequency,
          days: days,
        ),
      ],
    );
  }

  Widget _buildLineChartCard({
    required String title,
    required List<double> rawData,
    required double maxValue,
    required List<String> days,
  }) {
    List<double> normalized = rawData.map((v) => (v as num) / maxValue).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                height: 35.h,
                width: 96.w,
                decoration: BoxDecoration(color: const Color(0xFFF4F7F6)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share, color: const Color(0xFF820DFF), size: 20.w),
                      SizedBox(width: 6.w),
                      Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF820DFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            height: 240.h,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 0.2,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey[300], strokeWidth: 1),
                  getDrawingVerticalLine: (_) => FlLine(color: Colors.grey[300], strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36.h,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= days.length) return const Text('');
                        return Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Text(
                            days[index],
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 0.2,
                      reservedSize: 50.w,
                      getTitlesWidget: (value, meta) {
                        final labels = ['0', '0.2', '0.4', '0.6', '0.8', '1'];
                        final index = (value * 5).round();
                        if (index >= 0 && index < labels.length) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Text(
                              labels[index],
                              style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 1.0,
                lineBarsData: [
                  LineChartBarData(
                    spots: normalized.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                    isCurved: true,
                    color: const Color(0xFF820DFF),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                        radius: 6.r,
                        color: Colors.white,
                        strokeWidth: 3,
                        strokeColor: const Color(0xFF820DFF),
                      ),
                    ),
                  ),
                ],
                lineTouchData: const LineTouchData(enabled: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Additional UI Helpers ──────────────────────────────────────────────────
  Widget _buildInfoSection() {
    // You might want to calculate these based on the filtered activities
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoRow('Most Active Day', '')),
            SizedBox(width: 20.w),
            Expanded(child: _buildInfoRow('', 'Wednesday')),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(child: _buildInfoRow('Most Active Time', '')),
            SizedBox(width: 20.w),
            Expanded(child: _buildInfoRow('', '9 PM')),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      height: 35.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareDropdown() {
    return GestureDetector(
      onTap: () {
        if (kDebugMode) print('Compare With Similar Activities');
      },
      child: Container(
        height: 66.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF6A00FF),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Compare With Similar Activities',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));

    return GestureDetector(
      onTap: () {
        if (kDebugMode) print('Edit date range');
      },
      child: Container(
        height: 66.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFF6A00FF),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white),
                SizedBox(width: 10.w),
                Text(
                  '${DateFormat('MMMM d, y').format(lastWeek)} - ${DateFormat('MMMM d, y').format(now)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            const Icon(Icons.edit, color: Colors.white),
          ],
        ),
      ),
    );
  }
}



// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../activity_model.dart';
// import '../../View_model/activity_provider.dart';
// import 'DrinkCalculatorWidget.dart';
//
// class Othercalculatorwidget extends StatefulWidget {
//   final int initialTab;
//
//   const Othercalculatorwidget({super.key, this.initialTab = 0});
//
//   @override
//   State<Othercalculatorwidget> createState() => _DrinkScreenState();
// }
//
// class _DrinkScreenState extends State<Othercalculatorwidget> {
//   late int _selectedTab;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedTab = widget.initialTab;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 12.h),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: Text(
//                         'Drink',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 20.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 48.w),
//                 ],
//               ),
//             ),
//
//             // Tabs
//             _buildTabBar(),
//
//             // Main Content
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (_selectedTab == 0) ...[
//                       _buildInfoSection(),
//                       SizedBox(height: 10.h),
//                       _buildCompareDropdown(),
//                       SizedBox(height: 10.h),
//                       _buildDateRangeSelector(),
//                       SizedBox(height: 16.h),
//                     ],
//                     _buildTabContent(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── Tab Bar ────────────────────────────────────────────────────────────────
//   Widget _buildTabBar() {
//     return Container(
//       height: 56.h,
//       color: const Color(0xFF6A00FF),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildTabItem("Heatmap", 0),
//           _buildTabItem("Timeline", 1),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabItem(String title, int index) {
//     final bool isSelected = _selectedTab == index;
//     return GestureDetector(
//       onTap: () => setState(() => _selectedTab = index),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 15.sp,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 8.h),
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               height: isSelected ? 3.h : 0,
//               width: 64.w,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(2.r),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── Tab Content Switch ─────────────────────────────────────────────────────
//   Widget _buildTabContent() {
//     switch (_selectedTab) {
//       case 0:
//         return _buildHeatmapSection();
//       case 1:
//         return _buildTimelineSection();
//       default:
//         return _buildHeatmapSection();
//     }
//   }
//
//   // ── Heatmap Tab ────────────────────────────────────────────────────────────
//   Widget _buildHeatmapSection() {
//     try {
//       final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
//       final allActivities = activityNotifier.activities;
//
//       final drinkActivities = allActivities.where((a) {
//         return a.name.toLowerCase().contains('drink');
//       }).toList();
//
//       final Map<int, Map<int, int>> heatmapData = {};
//
//       for (int day = 0; day < 7; day++) {
//         heatmapData[day] = {};
//         for (int hour = 0; hour < 24; hour++) {
//           heatmapData[day]![hour] = 0;
//         }
//       }
//
//       for (var activity in drinkActivities) {
//         final weekday = activity.dateTime.weekday; // 1 = Monday ... 7 = Sunday
//         final hour = activity.dateTime.hour;
//
//         final dayIndex = weekday % 7; // 0=Sun, 1=Mon ... 6=Sat
//
//         int intensity = 1;
//         if (activity.food != null && activity.food!.isNotEmpty) {
//           final numStr = activity.food!.replaceAll(RegExp(r'[^0-9.]'), '');
//           final num = double.tryParse(numStr) ?? 0;
//           intensity = (num / 200).ceil().clamp(1, 5);
//         }
//
//         heatmapData[dayIndex]![hour] = heatmapData[dayIndex]![hour]! + intensity;
//       }
//
//       int maxIntensity = 1;
//       for (int day = 0; day < 7; day++) {
//         for (int hour = 0; hour < 24; hour++) {
//           if (heatmapData[day]![hour]! > maxIntensity) {
//             maxIntensity = heatmapData[day]![hour]!;
//           }
//         }
//       }
//
//       final double cellHeight = 16.h;
//       final double cellMargin = 2.h;
//       final double totalCellHeight = cellHeight + (cellMargin * 2);
//       final double timeLabelWidth = 50.w;
//
//       return Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildHeatmapGrid(
//                   cellHeight,
//                   cellMargin,
//                   heatmapData,
//                   maxIntensity,
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               SizedBox(
//                 width: timeLabelWidth,
//                 child: _buildTimeLabels(totalCellHeight),
//               ),
//             ],
//           ),
//           SizedBox(height: 6.h),
//           _buildDayLabels(),
//           SizedBox(height: 16.h),
//           _buildHeatmapLegend(),
//         ],
//       );
//     } catch (e) {
//       print('Heatmap error: $e');
//       return Center(
//         child: Text(
//           'Error loading heatmap',
//           style: TextStyle(color: Colors.red, fontSize: 14.sp),
//         ),
//       );
//     }
//   }
//
//   Widget _buildHeatmapGrid(
//       double cellHeight,
//       double cellMargin,
//       Map<int, Map<int, int>> heatmapData,
//       int maxIntensity,
//       ) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: List.generate(7, (dayIndex) {
//         return Expanded(
//           child: Column(
//             children: List.generate(24, (hourIndex) {
//               final intensity = heatmapData[dayIndex]![hourIndex]!;
//               Color cellColor = intensity == 0
//                   ? Colors.grey.shade100
//                   : intensity == 1
//                   ? const Color(0xFFC9B3FF)
//                   : intensity == 2
//                   ? const Color(0xFFA280FF)
//                   : intensity == 3
//                   ? const Color(0xFF7B4DFF)
//                   : intensity == 4
//                   ? const Color(0xFF6438FF)
//                   : const Color(0xFF4D21FF);
//
//               final now = DateTime.now();
//               final currentDayIndex = now.weekday % 7;
//               final currentHour = now.hour;
//
//               final isNow = dayIndex == currentDayIndex && hourIndex == currentHour;
//
//               return Container(
//                 height: cellHeight,
//                 margin: EdgeInsets.symmetric(vertical: cellMargin, horizontal: cellMargin),
//                 decoration: BoxDecoration(
//                   color: cellColor,
//                   borderRadius: BorderRadius.circular(4.r),
//                   border: isNow ? Border.all(color: Colors.red, width: 2.w) : null,
//                 ),
//                 child: Center(
//                   child: Text(
//                     intensity > 0 ? intensity.toString() : '',
//                     style: TextStyle(
//                       color: intensity > 2 ? Colors.white : Colors.black,
//                       fontSize: 10.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildTimeLabels(double totalCellHeight) {
//     final hours = [
//       '12 AM', '1 AM', '2 AM', '3 AM', '4 AM', '5 AM', '6 AM', '7 AM',
//       '8 AM', '9 AM', '10 AM', '11 AM', '12 PM', '1 PM', '2 PM', '3 PM',
//       '4 PM', '5 PM', '6 PM', '7 PM', '8 PM', '9 PM', '10 PM', '11 PM'
//     ];
//
//     final now = DateTime.now();
//     bool isCurrentHour(i) => i == now.hour;
//
//     return Column(
//       children: List.generate(24, (i) => Container(
//         height: totalCellHeight,
//         alignment: Alignment.center,
//         child: Text(
//           hours[i],
//           style: TextStyle(
//             fontSize: 12.sp,
//             color: isCurrentHour(i) ? Colors.red : Colors.grey.shade600,
//             fontWeight: isCurrentHour(i) ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       )),
//     );
//   }
//   Widget _buildDayLabels() {
//     final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
//     final now = DateTime.now();
//     final currentDayIndex = now.weekday % 7; // 1=Mon → 0=Sun, 2=Tue → 1, etc.
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start, // or .center / .spaceBetween
//       children: List.generate(7, (i) {
//         final isToday = i == currentDayIndex;
//         final label = Container(
//           padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
//           decoration: BoxDecoration(
//             color: isToday ? Colors.red.withOpacity(0.1) : Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(8.r),
//             border: isToday ? Border.all(color: Colors.red, width: 1.w) : null,
//           ),
//           child: Text(
//             days[i],
//             style: TextStyle(
//               color: isToday ? Colors.red : Colors.black54,
//               fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
//               fontSize: 12.sp,
//             ),
//           ),
//         );
//
//         // Add spacing after every label except the last one
//         if (i < 6) {
//           return Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               label,
//               SizedBox(width: 10.w),
//             ],
//           );
//         }
//
//         return label;
//       }),
//     );
//   }
//
//
//   // Widget _buildDayLabels() {
//   //   final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
//   //   final now = DateTime.now();
//   //   final currentDayIndex = now.weekday % 7;
//   //
//   //   return Row(
//   //     mainAxisAlignment: MainAxisAlignment.start,
//   //     children: List.generate(7, (i) {
//   //       final isToday = i == currentDayIndex;
//   //       return Container(
//   //         padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
//   //         decoration: BoxDecoration(
//   //           color: isToday ? Colors.red.withOpacity(0.1) : Colors.grey.shade100,
//   //           borderRadius: BorderRadius.circular(8.r),
//   //           border: isToday ? Border.all(color: Colors.red, width: 1.w) : null,
//   //         ),
//   //         child: Text(
//   //           days[i],
//   //           style: TextStyle(
//   //             color: isToday ? Colors.red : Colors.black54,
//   //             fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
//   //             fontSize: 12.sp,
//   //           ),
//   //         ),
//   //       );
//   //     }),
//   //   );
//   // }
//
//   Widget _buildHeatmapLegend() {
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Activity Intensity',
//             style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
//           ),
//           SizedBox(height: 8.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildLegendItem('None', Colors.grey.shade100),
//               _buildLegendItem('Low', const Color(0xFFC9B3FF)),
//               _buildLegendItem('Medium', const Color(0xFF7B4DFF)),
//               _buildLegendItem('High', const Color(0xFF4D21FF)),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(4.r),
//                   border: Border.all(color: Colors.red, width: 2.w),
//                 ),
//                 child: Text(
//                   'Now',
//                   style: TextStyle(
//                     fontSize: 10.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLegendItem(String label, Color color) {
//     return Row(
//       children: [
//         Container(
//           width: 16.w,
//           height: 16.h,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(3.r),
//           ),
//         ),
//         SizedBox(width: 4.w),
//         Text(label, style: TextStyle(fontSize: 10.sp, color: Colors.black54)),
//       ],
//     );
//   }
//
//   // ── Timeline Tab ───────────────────────────────────────────────────────────
//   Widget _buildTimelineSection() {
//     final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
//     final allActivities = activityNotifier.activities;
//
//     final now = DateTime.now();
//     final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//     final cleanStart = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
//     final endOfWeek = cleanStart.add(const Duration(days: 6));
//
//     final drinkActivities = allActivities.where((a) {
//       return a.name.toLowerCase().contains('drink') &&
//           a.dateTime.isAfter(cleanStart.subtract(const Duration(seconds: 1))) &&
//           a.dateTime.isBefore(endOfWeek.add(const Duration(days: 1)));
//     }).toList();
//
//     final Map<int, List<Activity>> grouped = {1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: []};
//     for (var act in drinkActivities) {
//       grouped[act.dateTime.weekday]?.add(act);
//     }
//
//     final List<double> amountData = [];
//     final List<double> frequencyData = [];
//     double maxAmount = 1;
//     double maxFrequency = 0;
//
//     final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//
//     for (int i = 1; i <= 7; i++) {
//       final dayActs = grouped[i]!;
//       frequencyData.add(dayActs.length.toDouble());
//       if (dayActs.length > maxFrequency) maxFrequency = dayActs.length.toDouble();
//
//       double totalML = 0;
//       for (var act in dayActs) {
//         if (act.food != null && act.food!.isNotEmpty) {
//           final numStr = act.food!.replaceAll(RegExp(r'[^0-9.]'), '');
//           final num = double.tryParse(numStr) ?? 0;
//           totalML += act.food!.toLowerCase().contains('l') ? num * 1000 : num;
//         }
//       }
//       amountData.add(totalML);
//       if (totalML > maxAmount) maxAmount = totalML;
//     }
//
//     final dateRangeText =
//         "${DateFormat('MMMM d, y').format(cleanStart)} - ${DateFormat('MMMM d, y').format(endOfWeek)}";
//
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             if (kDebugMode) print('Edit date range tapped');
//           },
//           child: Container(
//             margin: EdgeInsets.symmetric(horizontal: 16.w),
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//             decoration: BoxDecoration(
//               color: const Color(0xFF820DFF),
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.calendar_today, color: Colors.white, size: 22),
//                     SizedBox(width: 12.w),
//                     Text(
//                       dateRangeText,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Icon(Icons.edit, color: Colors.white, size: 22),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 32.h),
//         _buildLineChartCard(
//           title: 'Amount in mL',
//           rawData: amountData,
//           maxValue: maxAmount,
//           days: days,
//         ),
//         SizedBox(height: 32.h),
//         _buildLineChartCard(
//           title: 'Frequency',
//           rawData: frequencyData,
//           maxValue: maxFrequency,
//           days: days,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLineChartCard({
//     required String title,
//     required List<double> rawData,
//     required double maxValue,
//     required List<String> days,
//   }) {
//     List<double> normalized = rawData.map((v) => (v as num) / maxValue).toList();
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               Container(
//                 height: 35.h,
//                 width: 96.w,
//                 decoration: BoxDecoration(color: const Color(0xFFF4F7F6)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.share, color: const Color(0xFF820DFF), size: 20.w),
//                       SizedBox(width: 6.w),
//                       Text(
//                         'Share',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: const Color(0xFF820DFF),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),
//           Container(
//             height: 240.h,
//             padding: EdgeInsets.all(16.w),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10.r,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: true,
//                   drawHorizontalLine: true,
//                   horizontalInterval: 0.2,
//                   verticalInterval: 1,
//                   getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey[300], strokeWidth: 1),
//                   getDrawingVerticalLine: (_) => FlLine(color: Colors.grey[300], strokeWidth: 1),
//                 ),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 36.h,
//                       interval: 1,
//                       getTitlesWidget: (value, meta) {
//                         final index = value.toInt();
//                         if (index < 0 || index >= days.length) return const Text('');
//                         return Padding(
//                           padding: EdgeInsets.only(top: 10.h),
//                           child: Text(
//                             days[index],
//                             style: TextStyle(
//                               color: Colors.grey[700],
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       interval: 0.2,
//                       reservedSize: 50.w,
//                       getTitlesWidget: (value, meta) {
//                         final labels = ['0', '0.2', '0.4', '0.6', '0.8', '1'];
//                         final index = (value * 5).round();
//                         if (index >= 0 && index < labels.length) {
//                           return Padding(
//                             padding: EdgeInsets.only(right: 8.w),
//                             child: Text(
//                               labels[index],
//                               style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
//                             ),
//                           );
//                         }
//                         return const Text('');
//                       },
//                     ),
//                   ),
//                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 minX: 0,
//                 maxX: 6,
//                 minY: 0,
//                 maxY: 1.0,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: normalized.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
//                     isCurved: true,
//                     color: const Color(0xFF820DFF),
//                     barWidth: 3,
//                     isStrokeCapRound: true,
//                     dotData: FlDotData(
//                       show: true,
//                       getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
//                         radius: 6.r,
//                         color: Colors.white,
//                         strokeWidth: 3,
//                         strokeColor: const Color(0xFF820DFF),
//                       ),
//                     ),
//                   ),
//                 ],
//                 lineTouchData: const LineTouchData(enabled: true),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Additional UI Helpers ──────────────────────────────────────────────────
//   Widget _buildInfoSection() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(child: _buildInfoRow('Most Active Day', '')),
//             SizedBox(width: 20.w),
//             Expanded(child: _buildInfoRow('', 'Wednesday')),
//           ],
//         ),
//         SizedBox(height: 8.h),
//         Row(
//           children: [
//             Expanded(child: _buildInfoRow('Most Active Time', '')),
//             SizedBox(width: 20.w),
//             Expanded(child: _buildInfoRow('', '9 PM')),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Container(
//       height: 35.h,
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.black54,
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCompareDropdown() {
//     return GestureDetector(
//       onTap: () {
//         if (kDebugMode) print('Compare With Similar Activities');
//       },
//       child: Container(
//         height: 66.h,
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//         decoration: BoxDecoration(
//           color: const Color(0xFF6A00FF),
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Compare With Similar Activities',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16.sp,
//               ),
//             ),
//             const Icon(Icons.keyboard_arrow_down, color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateRangeSelector() {
//     final now = DateTime.now();
//     final lastWeek = now.subtract(const Duration(days: 7));
//
//     return GestureDetector(
//       onTap: () {
//         if (kDebugMode) print('Edit date range');
//       },
//       child: Container(
//         height: 66.h,
//         padding: EdgeInsets.all(12.w),
//         decoration: BoxDecoration(
//           color: const Color(0xFF6A00FF),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.calendar_today, color: Colors.white),
//                 SizedBox(width: 10.w),
//                 Text(
//                   '${DateFormat('MMMM d, y').format(lastWeek)} - ${DateFormat('MMMM d, y').format(now)}',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14.sp,
//                   ),
//                 ),
//               ],
//             ),
//             const Icon(Icons.edit, color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
// }
