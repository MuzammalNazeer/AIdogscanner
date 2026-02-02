import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import '../../activity_model.dart';
import '../../View_model/activity_provider.dart';
import 'DrinkCalculatorWidget.dart';

class DrinkScreen extends StatefulWidget {
  final int initialTab;
  final String? selectedPetId;

  const DrinkScreen({super.key, this.initialTab = 0, this.selectedPetId});

  @override
  State<DrinkScreen> createState() => _DrinkScreenState();
}

class _DrinkScreenState extends State<DrinkScreen> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                        l10n.activityDrink,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w),
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
                      // _buildCompareDropdown(),
                      // SizedBox(height: 10.h),
                      // _buildDateRangeSelector(),
                      // SizedBox(height: 16.h),
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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 56.h,
      color: const Color(0xFF6A00FF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(l10n.calendarHeatmapTab, 0),
          _buildTabItem(l10n.calendarTimelineTab, 1),
          _buildTabItem(l10n.drinkCalculator, 2),
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
      case 2:
        return const DrinkCalculatorWidget();
      default:
        return _buildHeatmapSection();
    }
  }

  // ── Heatmap Tab ────────────────────────────────────────────────────────────
  Widget _buildHeatmapSection() {
    try {
      final l10n = AppLocalizations.of(context)!;
      final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
      final allActivities = activityNotifier.activities;

      final drinkActivities = allActivities.where((a) {
        final matchesName = a.name.trim().toLowerCase().contains('drink') ||
            a.name.trim().toLowerCase().contains(l10n.activityDrink.trim().toLowerCase());
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

      for (var activity in drinkActivities) {
        final weekday = activity.dateTime.weekday; // 1 = Monday ... 7 = Sunday
        final hour = activity.dateTime.hour;

        final dayIndex = weekday % 7; // 0=Sun, 1=Mon ... 6=Sat

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
          SizedBox(height: 16.h),
          _buildDayLabels(),
          SizedBox(height: 16.h),
          _buildHeatmapLegend(),
        ],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Heatmap error: $e');
      }
      return Center(
        child: Text(
          AppLocalizations.of(context)!.calendarErrorLoadingHeatmap,
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
    // Localize time labels using DateFormat if possible, or simple generation
    // Since we need 12 AM, 1 AM etc, let's use DateFormat
    final now = DateTime.now();
    final isCurrentHour = (i) => i == now.hour;

    return Column(
      children: List.generate(24, (i) {
        // Construct a time for today at hour i
        final time = DateTime(now.year, now.month, now.day, i);
        final label = DateFormat.j().format(time); // e.g. "12 AM", "5 PM"
        
        return Container(
        height: totalCellHeight,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isCurrentHour(i) ? Colors.red : Colors.grey.shade600,
            fontWeight: isCurrentHour(i) ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
      }),
    );
  }

  Widget _buildDayLabels() {
    final l10n = AppLocalizations.of(context)!;
    final days = [l10n.daySun, l10n.dayMon, l10n.dayTue, l10n.dayWed, l10n.dayThu, l10n.dayFri, l10n.daySat];
    final now = DateTime.now();
    final currentDayIndex = now.weekday % 7;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final isToday = i == currentDayIndex;
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
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
              fontSize: 13.sp,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeatmapLegend() {
    final l10n = AppLocalizations.of(context)!;
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
            l10n.calendarActivityIntensity,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem(l10n.calendarLegendNone, Colors.grey.shade100),
              _buildLegendItem(l10n.calendarLegendLow, const Color(0xFFC9B3FF)),
              _buildLegendItem(l10n.calendarLegendMedium, const Color(0xFF7B4DFF)),
              _buildLegendItem(l10n.calendarLegendHigh, const Color(0xFF4D21FF)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: Colors.red, width: 2.w),
                ),
                child: Text(
                  l10n.calendarLegendNow,
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


  Widget _buildTimelineSection() {
    final l10n = AppLocalizations.of(context)!;
    final activityNotifier = Provider.of<ActivityNotifier>(context);
    final allActivities = activityNotifier.activities;

    // Current week: Monday → Sunday
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
    final cleanStart = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final endOfWeek = cleanStart.add(const Duration(days: 6)); // Sunday

    // Filter only drink activities (for selected pet or all)
    final drinkActivities = allActivities.where((a) {
      final isDrink = a.name.toLowerCase().contains('drink');
      final matchesPet = widget.selectedPetId == null || a.petId == widget.selectedPetId;
      final inRange = !a.dateTime.isBefore(cleanStart) && !a.dateTime.isAfter(endOfWeek);
      return isDrink && matchesPet && inRange;
    }).toList();

    // Group by weekday (1 = Monday ... 7 = Sunday)
    final Map<int, List<Activity>> groupedByDay = {
      1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [],
    };

    for (var act in drinkActivities) {
      final weekday = act.dateTime.weekday;
      groupedByDay[weekday]?.add(act);
    }

    // Calculate real data
    final List<double> amountData = [];     // total mL per day
    final List<double> frequencyData = [];  // number of drinks per day
    double maxAmount = 100.0;               // fallback minimum
    double maxFrequency = 1.0;

    final days = [l10n.dayMon, l10n.dayTue, l10n.dayWed, l10n.dayThu, l10n.dayFri, l10n.daySat, l10n.daySun];

    for (int weekday = 1; weekday <= 7; weekday++) {
      final dayActs = groupedByDay[weekday] ?? [];

      // Frequency = how many times they drank that day
      frequencyData.add(dayActs.length.toDouble());
      if (dayActs.length > maxFrequency) maxFrequency = dayActs.length.toDouble();

      // Amount in mL - smart parsing
      double totalML = 0.0;
      for (var act in dayActs) {
        if (act.food != null && act.food!.isNotEmpty) {
          String food = act.food!.toLowerCase().trim();
          // Extract number (e.g. "250ml" → 250, "1.5L" → 1.5, "300 ml" → 300)
          final numStr = food.replaceAll(RegExp(r'[^0-9.]'), '');
          double num = double.tryParse(numStr) ?? 0.0;

          // Handle units (l, liter, ml, etc.)
          if (food.contains('ml') || food.contains('milliliter') || food.contains('millilitre')) {
             totalML += num;
          } else if (food.contains('l') || food.contains('liter') || food.contains('litre')) {
            totalML += num * 1000; // liters → ml
          } else {
            totalML += num; // default: ml
          }
        }
      }

      amountData.add(totalML);
      if (totalML > maxAmount) maxAmount = totalML;
    }

    // Make sure we have nice round max values for chart
    maxAmount = (maxAmount * 1.2).ceilToDouble(); // add some headroom
    maxFrequency = (maxFrequency * 1.2).ceilToDouble();

    // Use localized date format
    final dateRangeText =
        "${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(cleanStart)} - ${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(endOfWeek)}";

    return Column(
      children: [
        // // Date range header
        // GestureDetector(
        //   onTap: () {
        //     if (kDebugMode) print('Edit date range tapped');
        //     // You can add date picker dialog here later
        //   },
        //   child: Container(
        //     margin: EdgeInsets.symmetric(horizontal: 16.w),
        //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        //     decoration: BoxDecoration(
        //       color: const Color(0xFF820DFF),
        //       borderRadius: BorderRadius.circular(12.r),
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Row(
        //           children: [
        //             const Icon(Icons.calendar_today, color: Colors.white, size: 22),
        //             SizedBox(width: 12.w),
        //             Text(
        //               dateRangeText,
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 16.sp,
        //                 fontWeight: FontWeight.w600,
        //               ),
        //             ),
        //           ],
        //         ),
        //         const Icon(Icons.edit, color: Colors.white, size: 22),
        //       ],
        //     ),
        //   ),
        // ),

        SizedBox(height: 32.h),

        // Amount in mL chart (real values)
        _buildLineChartCard(
          title: l10n.calendarChartAmount,
          rawData: amountData,
          maxValue: maxAmount,
          days: days,
        ),

        SizedBox(height: 32.h),

        // Frequency chart (real counts)
        _buildLineChartCard(
          title: l10n.drinkFrequencyChartTitle,
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
    // List<double> normalized = rawData.map((v) => (v as num) / maxValue).toList();
    // Dynamic interval based on maxValue
    final double interval = maxValue > 0 ? maxValue / 5 : 1.0;

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
                decoration: const BoxDecoration(color: Color(0xFFF4F7F6)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share, color: const Color(0xFF820DFF), size: 20.w),
                      SizedBox(width: 6.w),
                      Text(
                        AppLocalizations.of(context)!.calendarShare,
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
                  horizontalInterval: interval,
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
                      interval: interval,
                      reservedSize: 50.w,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value > maxValue * 1.05) {
                          return const SizedBox();
                        }
                        String text = value.toStringAsFixed(1);
                        if (text.endsWith('.0')) text = text.substring(0, text.length - 2);
                        if (text.endsWith('0') && text.contains('.')) text = text.substring(0, text.length - 1);

                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Text(
                            text,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
                          ),
                        );
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
                maxY: maxValue,
                lineBarsData: [
                  LineChartBarData(
                    spots: rawData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
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
    final l10n = AppLocalizations.of(context)!;
    final activityNotifier = Provider.of<ActivityNotifier>(context);
    final allActivities = activityNotifier.activities;

    final drinkActivities = allActivities.where((a) {
      final matchesName = a.name.trim().toLowerCase().contains('drink') ||
          a.name.trim().toLowerCase().contains(l10n.activityDrink.trim().toLowerCase());
      final matchesPet = widget.selectedPetId == null || a.petId == widget.selectedPetId;
      return matchesName && matchesPet;
    }).toList();

    String activeDay = '-';
    String activeTime = '-';

    if (drinkActivities.isNotEmpty) {
      final Map<int, int> dayCounts = {};
      final Map<int, int> hourCounts = {};

      for (var activity in drinkActivities) {
        final weekday = activity.dateTime.weekday;
        final hour = activity.dateTime.hour;

        dayCounts[weekday] = (dayCounts[weekday] ?? 0) + 1;
        hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
      }

      int maxDay = 1;
      int maxDayCount = -1;
      dayCounts.forEach((day, count) {
        if (count > maxDayCount) {
          maxDayCount = count;
          maxDay = day;
        }
      });

      int maxHour = 0;
      int maxHourCount = -1;
      hourCounts.forEach((hour, count) {
        if (count > maxHourCount) {
          maxHourCount = count;
          maxHour = hour;
        }
      });

      switch (maxDay) {
        case 1: activeDay = l10n.dayMon; break;
        case 2: activeDay = l10n.dayTue; break;
        case 3: activeDay = l10n.dayWed; break;
        case 4: activeDay = l10n.dayThu; break;
        case 5: activeDay = l10n.dayFri; break;
        case 6: activeDay = l10n.daySat; break;
        case 7: activeDay = l10n.daySun; break;
      }

      final now = DateTime.now();
      final time = DateTime(now.year, now.month, now.day, maxHour);
      activeTime = DateFormat.j(Localizations.localeOf(context).toString()).format(time);
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoRow(l10n.calendarMostActiveDay, '')),
            SizedBox(width: 20.w),
            Expanded(child: _buildInfoRow('', activeDay)),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(child: _buildInfoRow(l10n.calendarMostActiveTime, '')),
            SizedBox(width: 20.w),
            Expanded(child: _buildInfoRow('', activeTime)),
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

}



