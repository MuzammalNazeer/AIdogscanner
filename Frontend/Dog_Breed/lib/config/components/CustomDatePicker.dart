import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// -------- SELECT DATE (CENTER)
            const Text(
              "Select Date",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            /// -------- DATE + EDIT ICON
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat("MMM dd, yyyy").format(selectedDate),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.edit, size: 20),
              ],
            ),

            const SizedBox(height: 16),

            /// -------- MONTH NAVIGATION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      currentMonth =
                          DateTime(currentMonth.year, currentMonth.month - 1);
                    });
                  },
                ),
                Text(
                  DateFormat("MMMM yyyy").format(currentMonth),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
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
              children: const [
                Text("Mon"), Text("Tue"), Text("Wed"),
                Text("Thu"), Text("Fri"), Text("Sat"), Text("Sun"),
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
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Color(0xFF820DFF), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(115.r),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF820DFF),
                  ),
                  onPressed:() async {
                    // This will show the text input date picker
                    await _selectDate();

                    // Then you can close the dialog with the selected date
                    if (context.mounted) {
                      Navigator.pop(context, selectedDate);
                    }
                  },
                  child: const Text("OK",style: TextStyle(
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
  // Future<void> _selectDate() async {
  //   DateTime tempSelectedDate = selectedDate;
  //   TextEditingController dateController = TextEditingController(
  //     text: DateFormat('MM/dd/yyyy').format(selectedDate),
  //   );
  //
  //   await showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (context) {
  //       return Dialog(
  //         backgroundColor: Colors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16.0),
  //         ),
  //         child: Container(
  //           padding: const EdgeInsets.all(20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Title
  //               const Center(
  //                 child: Text(
  //                   "Select Date",
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //
  //               // Current Date Display
  //               Center(
  //                 child: Text(
  //                   DateFormat('MMM dd, yyyy').format(tempSelectedDate),
  //                   style:  TextStyle(
  //                     fontSize: 39.sp,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 24),
  //
  //               // Enter Date Label
  //               const Text(
  //                 "Enter Date",
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //
  //               // Date Input Field
  //               TextFormField(
  //                 controller: dateController,
  //                 decoration: InputDecoration(
  //                   hintText: "MM/DD/YYYY",
  //                   filled: true,
  //                   fillColor: Colors.grey[50],
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                     borderSide: BorderSide.none,
  //                   ),
  //                   contentPadding: const EdgeInsets.symmetric(
  //                     horizontal: 16,
  //                     vertical: 14,
  //                   ),
  //                   suffixIcon: IconButton(
  //                     icon: const Icon(
  //                       Icons.calendar_today,
  //                       color: Color(0xFF820DFF),
  //                     ),
  //                     onPressed: () async {
  //                       // Show standard date picker when calendar icon is clicked
  //                       final DateTime? picked = await showDatePicker(
  //                         context: context,
  //                         initialDate: tempSelectedDate,
  //                         firstDate: DateTime(2020),
  //                         lastDate: DateTime(2030),
  //                         builder: (context, child) {
  //                           return Theme(
  //                             data: Theme.of(context).copyWith(
  //                               colorScheme: const ColorScheme.light(
  //                                 primary: Color(0xFF820DFF),
  //                                 onPrimary: Colors.white,
  //                               ),
  //                             ),
  //                             child: child!,
  //                           );
  //                         },
  //                       );
  //
  //                       if (picked != null) {
  //                         setState(() {
  //                           tempSelectedDate = picked;
  //                           dateController.text = DateFormat('MM/dd/yyyy').format(picked);
  //                         });
  //                       }
  //                     },
  //                   ),
  //                 ),
  //                 keyboardType: TextInputType.datetime,
  //                 onChanged: (value) {
  //                   try {
  //                     // Parse MM/dd/yyyy format
  //                     final parts = value.split('/');
  //                     if (parts.length == 3) {
  //                       final month = int.parse(parts[0]);
  //                       final day = int.parse(parts[1]);
  //                       final year = int.parse(parts[2]);
  //                       final newDate = DateTime(year, month, day);
  //                       if (newDate.isAfter(DateTime(2019)) && newDate.isBefore(DateTime(2031))) {
  //                         setState(() {
  //                           tempSelectedDate = newDate;
  //                         });
  //                       }
  //                     }
  //                   } catch (e) {
  //                     // Invalid date format, keep previous date
  //                   }
  //                 },
  //               ),
  //               const SizedBox(height: 24),
  //
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   TextButton(
  //                     onPressed: () => Navigator.pop(context),
  //                     style: TextButton.styleFrom(
  //                       foregroundColor: Colors.black,
  //                       backgroundColor: Colors.transparent,
  //                       side: const BorderSide(color: Color(0xFF820DFF), width: 1.5),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(115.r),
  //                       ),
  //                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  //                     ),
  //                     child: const Text(
  //                       "Cancel",
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: const Color(0xFF820DFF),
  //                     ),
  //                     onPressed:() async {
  //                       // // This will show the text input date picker
  //                       // await _selectDate();
  //                       //
  //                       // // Then you can close the dialog with the selected date
  //                       // if (context.mounted) {
  //                       //   Navigator.pop(context, selectedDate);
  //                       // }
  //                     },
  //                     child: const Text("OK",style: TextStyle(
  //                         color: Colors.white
  //                     ),),
  //                   ),
  //                 ],
  //               ),
  //
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


  Future<void> _selectDate() async {
    DateTime tempSelectedDate = selectedDate;
    TextEditingController dateController = TextEditingController(
      text: DateFormat('MM/dd/yyyy').format(selectedDate),
    );

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Center(
                  child: Text(
                    "Select Date",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Current Date Display
                Center(
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(tempSelectedDate),
                    style: TextStyle(
                      fontSize: 39.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Enter Date Label
                const Text(
                  "Enter Date",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Date Input Field
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    hintText: "MM/DD/YYYY",
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF820DFF),
                      ),
                      onPressed: () async {
                        // Show standard date picker when calendar icon is clicked
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: tempSelectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF820DFF),
                                  onPrimary: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          setState(() {
                            tempSelectedDate = picked;
                            dateController.text = DateFormat('MM/dd/yyyy').format(picked);
                          });
                        }
                      },
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  onChanged: (value) {
                    try {
                      // Parse MM/dd/yyyy format
                      final parts = value.split('/');
                      if (parts.length == 3) {
                        final month = int.parse(parts[0]);
                        final day = int.parse(parts[1]);
                        final year = int.parse(parts[2]);
                        final newDate = DateTime(year, month, day);
                        if (newDate.isAfter(DateTime(2019)) && newDate.isBefore(DateTime(2031))) {
                          setState(() {
                            tempSelectedDate = newDate;
                          });
                        }
                      }
                    } catch (e) {
                      // Invalid date format, keep previous date
                    }
                  },
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: Color(0xFF820DFF), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(115.r),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF820DFF),
                      ),
                      onPressed: () {
                        try {
                          // Try to parse the date from the text field
                          final parts = dateController.text.split('/');
                          if (parts.length == 3) {
                            final month = int.parse(parts[0]);
                            final day = int.parse(parts[1]);
                            final year = int.parse(parts[2]);
                            final newDate = DateTime(year, month, day);

                            if (newDate.isAfter(DateTime(2019)) && newDate.isBefore(DateTime(2031))) {
                              // Update the state with the new date
                              setState(() {
                                selectedDate = newDate;
                              });

                              // Close the dialog
                              Navigator.pop(context);
                            } else {
                              // Show error for out of range date
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter a date between 2020-2030"),
                                ),
                              );
                            }
                          } else {
                            // If text field is empty or invalid, use tempSelectedDate
                            setState(() {
                              selectedDate = tempSelectedDate;
                            });
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          // If parsing fails, use tempSelectedDate
                          setState(() {
                            selectedDate = tempSelectedDate;
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// -------- CALENDAR GRID
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
              color: isSelected ? const Color(0xFF820DFF) : null,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "$day",
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
