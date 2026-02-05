import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import 'package:dog_breed/Valid/AppColors.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;

  const CustomDatePicker({super.key, required this.initialDate});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime selectedDate;
  late DateTime currentMonth;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    currentMonth = DateTime(selectedDate.year, selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// -------- SELECT DATE (CENTER)
            Text(
              AppLocalizations.of(context)!.selectDateTitle,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
            ),

            const SizedBox(height: 8),

            /// -------- DATE + EDIT ICON
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat("MMM dd, yyyy").format(selectedDate),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// -------- MONTH NAVIGATION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.onSurface),
                  onPressed: () {
                    setState(() {
                      currentMonth =
                          DateTime(currentMonth.year, currentMonth.month - 1);
                    });
                  },
                ),
                Text(
                  DateFormat("MMMM yyyy").format(currentMonth),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface),
                  onPressed: () {
                    setState(() {
                      currentMonth =
                          DateTime(currentMonth.year, currentMonth.month + 1);
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// -------- WEEK DAYS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.dayMon, style: TextStyle(color: Theme.of(context).hintColor)),
                Text(AppLocalizations.of(context)!.dayTue, style: TextStyle(color: Theme.of(context).hintColor)),
                Text(AppLocalizations.of(context)!.dayWed, style: TextStyle(color: Theme.of(context).hintColor)),
                Text(AppLocalizations.of(context)!.dayThu, style: TextStyle(color: Theme.of(context).hintColor)),
                Text(AppLocalizations.of(context)!.dayFri, style: TextStyle(color: Theme.of(context).hintColor)),
                Text(AppLocalizations.of(context)!.daySat, style: TextStyle(color: Theme.of(context).hintColor)),
                Text(AppLocalizations.of(context)!.daySun, style: TextStyle(color: Theme.of(context).hintColor)),
              ],
            ),

            const SizedBox(height: 8),

            /// -------- DAYS GRID
            _buildCalendar(),

            const SizedBox(height: 12),

            /// -------- ACTION BUTTONS (RIGHT SIDE)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).hintColor,
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: AppColors.vibrantPurple, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(115.r),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vibrantPurple,
                  ),
                  onPressed:() {
                    Navigator.pop(context, selectedDate);
                  },
                  child: Text(AppLocalizations.of(context)!.okAction,style: const TextStyle(
                      color: Colors.white
                  ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCalendar() {
    final daysInMonth =
    DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);
    final firstDayWeekday =
        DateTime(currentMonth.year, currentMonth.month, 1).weekday - 1;

    return GridView.builder(
      shrinkWrap: true,
      itemCount: daysInMonth + firstDayWeekday,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        if (index < firstDayWeekday) return const SizedBox();

        final day = index - firstDayWeekday + 1;
        final date =
        DateTime(currentMonth.year, currentMonth.month, day);

        final isSelected = DateUtils.isSameDay(date, selectedDate);

        return GestureDetector(
          onTap: () => setState(() => selectedDate = date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.vibrantPurple : null,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "$day",
              style: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        );
      },
    );
  }
}
