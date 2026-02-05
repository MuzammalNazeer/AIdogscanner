import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/l10n/app_localizations.dart';

class DrinkCalculatorWidget extends StatefulWidget {
  const DrinkCalculatorWidget({super.key});

  @override
  State<DrinkCalculatorWidget> createState() => _DrinkCalculatorWidgetState();
}

class _DrinkCalculatorWidgetState extends State<DrinkCalculatorWidget> {
  String _activityLevel = 'Moderate';
  String _weightUnit = 'Pounds';
  String _resultUnit = 'Milliliters';
  final TextEditingController _weightController = TextEditingController(text: '20');

  bool _isActivityDropdownOpen = false;
  bool _isWeightDropdownOpen = false;

  double _calculateDailyWaterML() {
    final input = _weightController.text.trim();
    if (input.isEmpty) return 0;

    final weight = double.tryParse(input) ?? 0;
    if (weight <= 0) return 0;

    double weightInKg = switch (_weightUnit) {
      'Kilograms' => weight,
      'Pounds' => weight * 0.453592,
      'Ounces' => weight * 0.0283495,
      'Grams' => weight / 1000,
      _ => weight,
    };

    double baseML = weightInKg * 70;

    double multiplier = switch (_activityLevel) {
      'Low' => 0.79,
      'Moderate' => 1.16,
      'High' => 1.57,
      _ => 1.16,
    };

    return baseML * multiplier;
  }

  String _formatResult(double ml, AppLocalizations l10n) {
    if (ml <= 0) return '0 ${l10n.unitSymbolMl}';

    final roundedML = ml.roundToDouble();

    return switch (_resultUnit) {
      'Milliliters' => '${roundedML.toStringAsFixed(roundedML % 1 == 0 ? 0 : 1)} ${l10n.unitSymbolMl}',
      'Centiliters' => '${(ml / 10).toStringAsFixed(1)} ${l10n.unitSymbolCl}',
      'Liters' => '${(ml / 1000).toStringAsFixed(2)} ${l10n.unitSymbolL}',
      'US Fluid Ounces' => '${(ml / 29.5735).toStringAsFixed(1)} ${l10n.unitSymbolUsFlOz}',
      'UK Fluid Ounces' => '${(ml / 28.4131).toStringAsFixed(1)} ${l10n.unitSymbolUkFlOz}',
      _ => '${roundedML.toStringAsFixed(roundedML % 1 == 0 ? 0 : 1)} ${l10n.unitSymbolMl}',
    };
  }
  
  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dailyML = _calculateDailyWaterML();
    final resultValue = _formatResult(dailyML, l10n);
    final resultParts = resultValue.split(' ');

    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surfaceContainerHighest : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              l10n.drinkCalcDescription,
              style: TextStyle(
                fontSize: 16.sp,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: 32.h),
          _buildActivityLevelSection(l10n),
          SizedBox(height: 24.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.currentWeight,
                      style: TextStyle(fontSize: 14.sp, color: Theme.of(context).hintColor),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 56.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surfaceContainerHighest : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFECEEED), width: 2),
                      ),
                      child: Center(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: l10n.hintWeight,
                            hintStyle: TextStyle(color: Theme.of(context).hintColor, fontSize: 18.sp),
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              _buildWeightDropdown(l10n),
            ],
          ),
          SizedBox(height: 40.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.yourDogWillNeed,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontSize: 16.sp),
                ),

                SizedBox(height: 16.h),
                SingleChildScrollView(
                  scrollDirection:Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        resultParts.isEmpty ? '0' : resultParts.first,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 48.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        resultParts.length > 1 ? '${resultParts.sublist(1).join(' ')} ${l10n.perDay}' : l10n.perDay,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontSize: 16.sp),
                      ),
                      SizedBox(width: 40.w),
                      SizedBox(
                        width: 150.w,  // ← adjust this value (140–180.w usually looks good)
                        child: _buildResultUnitDropdown(l10n),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLevelSection(AppLocalizations l10n) {
    final Map<String, String> activityLevels = {
      'Low': l10n.levelLow,
      'Moderate': l10n.moderate,
      'High': l10n.levelHigh,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isActivityDropdownOpen = !_isActivityDropdownOpen;
              if (_isActivityDropdownOpen) {
                _isWeightDropdownOpen = false;
              }
            });
          },
          child: Container(
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF820DFF),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.r),
                bottom: _isActivityDropdownOpen ? Radius.zero : Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    activityLevels[_activityLevel] ?? _activityLevel,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  _isActivityDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 28.w,
                ),
              ],
            ),
          ),
        ),

        // Options List
        if (_isActivityDropdownOpen)
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 100.h,
              width: 170.w,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 8.r, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: ['Low', 'Moderate', 'High'].map((level) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _activityLevel = level;
                        _isActivityDropdownOpen = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              activityLevels[level] ?? level,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: _activityLevel == level ? FontWeight.bold : FontWeight.normal,
                                color: _activityLevel == level ? const Color(0xFF820DFF) : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (_activityLevel == level)
                            Icon(Icons.check, color: const Color(0xFF820DFF), size: 24.w),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWeightDropdown(AppLocalizations l10n) {
    final Map<String, String> weightUnits = {
      'Ounces': l10n.unitOunces,
      'Pounds': l10n.unitPounds,
      'Grams': l10n.unitGrams,
      'Kilograms': l10n.unitKilograms,
    };
    final items = ['Ounces', 'Pounds', 'Grams', 'Kilograms'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isWeightDropdownOpen = !_isWeightDropdownOpen;
              if (_isWeightDropdownOpen) {
                _isActivityDropdownOpen = false; // Close other dropdown if open
              }
            });
          },
          child: Container(
            width: 230.w,
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF820DFF),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.r),
                bottom: _isWeightDropdownOpen ? Radius.zero : Radius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  weightUnits[_weightUnit] ?? _weightUnit,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  _isWeightDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 28.w,
                ),
              ],
            ),
          ),
        ),
        if (_isWeightDropdownOpen)
          Container(
            width: 230.w,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 8.r, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: items.map((item) {
                final isSelected = _weightUnit == item;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _weightUnit = item;
                      _isWeightDropdownOpen = false;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).highlightColor : Colors.transparent,
                    ),
                    child: Text(
                      weightUnits[item] ?? item,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildResultUnitDropdown(AppLocalizations l10n) {
    final Map<String, String> resultUnits = {
      'Milliliters': l10n.unitMilliliters,
      'Centiliters': l10n.unitCentiliters,
      'Liters': l10n.unitLiters,
      'US Fluid Ounces': l10n.unitUSFluidOunces,
      'UK Fluid Ounces': l10n.unitUKFluidOunces,
    };
    
    return _buildPurpleDropdown(
      value: _resultUnit,
      items: const [
        'Milliliters',
        'Centiliters',
        'Liters',
        'US Fluid Ounces',
        'UK Fluid Ounces',
      ],
      localizedItems: resultUnits,
      onChanged: (value) => setState(() => _resultUnit = value!),
    );
  }

  Widget _buildPurpleDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required Map<String, String> localizedItems,
    double width = double.infinity,
    String? label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Theme.of(context).hintColor),
          ),
        if (label != null) SizedBox(height: 8.h),
        Container(
          width: width,
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF820DFF),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28.w),
              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
              dropdownColor: const Color(0xFF820DFF),
              items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(localizedItems[item] ?? item))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class DrinkCalculatorWidget extends StatefulWidget {
//   const DrinkCalculatorWidget({super.key});
//
//   @override
//   State<DrinkCalculatorWidget> createState() => _DrinkCalculatorWidgetState();
// }
//
// class _DrinkCalculatorWidgetState extends State<DrinkCalculatorWidget> {
//   String _activityLevel = 'Moderate';
//   String _weightUnit = 'Pounds';
//   String _resultUnit = 'Milliliters';
//   final TextEditingController _weightController = TextEditingController(text: '1');
//   double _calculateDailyWaterML() {
//     final input = _weightController.text.trim();
//     if (input.isEmpty) return 0;
//
//     final weight = double.tryParse(input) ?? 0;
//     if (weight <= 0) return 0;
//
//     // Convert to kg
//     double weightInKg = switch (_weightUnit) {
//       'Kilograms' => weight,
//       'Pounds' => weight * 0.453592,
//       'Ounces' => weight * 0.0283495,
//       'Grams' => weight / 1000,
//       _ => weight,
//     };
//
//     double baseML = weightInKg * 70;
//
//     double multiplier = switch (_activityLevel) {
//       'Low' => 0.79,
//       'Moderate' => 1.16,
//       'High' => 1.57,
//       _ => 1.16,
//     };
//
//     return baseML * multiplier;
//   }
//
//   String _formatResult(double ml) {
//
//     final roundedML = double.parse(ml.toStringAsFixed(1));
//
//     return switch (_resultUnit) {
//       'Milliliters' => '${roundedML.toStringAsFixed(roundedML % 1 == 0 ? 0 : 1)} mL',
//       'Centiliters' => '${(ml / 10).toStringAsFixed(1)} cL',
//       'Liters' => '${(ml / 1000).toStringAsFixed(2)} L',
//       'US Fluid Ounces' => '${(ml / 29.5735).toStringAsFixed(1)} US fl oz',
//       'UK Fluid Ounces' => '${(ml / 28.4131).toStringAsFixed(1)} UK fl oz',
//       _ => '${roundedML.toStringAsFixed(roundedML % 1 == 0 ? 0 : 1)} mL',
//     };
//   }
//
//   @override
//   void dispose() {
//     _weightController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dailyML = _calculateDailyWaterML();
//     final resultValue = _formatResult(dailyML);
//     final resultParts = resultValue.split(' ');
//
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 120.h,
//             width: 410.w,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Calculate daily water intake your dog needs\n according to weight and activity level for\n healthy hydration every day',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   color: Colors.black87,
//                   height: 1.5,
//                 ),
//               ),
//             ),
//           ),
//
//
//           SizedBox(height: 32.h),
//           _buildActivityLevelSection(),
//           _buildPurpleDropdown(
//             label: 'Activity level',
//             value: _activityLevel,
//             items: const ['Low', 'Moderate', 'High'],
//             onChanged: (value) => setState(() => _activityLevel = value!),
//           ),
//
//           SizedBox(height: 16.h),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               // Weight Input Field
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Current Weight',
//                       style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
//                     ),
//                     SizedBox(height: 8.h),
//                     Container(
//                       height: 56.h,
//                       width: 154.w,// Match dropdown height exactly
//                       padding: EdgeInsets.symmetric(horizontal: 16.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12.r),
//                         border: Border.all(color: const Color(0xFF820DFF), width: 2),
//                       ),
//                       child: Center( // Vertically center the text field
//                         child: TextField(
//                           controller: _weightController,
//                           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                           style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
//                           textAlignVertical: TextAlignVertical.center,
//                           decoration: InputDecoration(
//                             isDense: true, // Reduces internal padding
//                             border: InputBorder.none,
//                             hintText: 'Enter weight',
//                             hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18.sp),
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                           onChanged: (_) => setState(() {}),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               SizedBox(width: 12.w),
//
//               // Unit Dropdown (already 111.h)
//               _buildPurpleDropdown(
//                 value: _weightUnit,
//                 items: const ['Pounds', 'Kilograms', 'Ounces', 'Grams'],
//                 onChanged: (value) => setState(() => _weightUnit = value!),
//                 width: 230.w,
//               ),
//             ],
//           ),
//           SizedBox(height: 40.h),
//
//           // Result Card
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
//             decoration: BoxDecoration(
//               color: Colors.black87,
//               borderRadius: BorderRadius.circular(20.r),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Daily Water Intake',
//                   style: TextStyle(color: Colors.white70, fontSize: 16.sp),
//                 ),
//
//                 SizedBox(height: 16.h),
//
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.baseline,
//                   textBaseline: TextBaseline.alphabetic,
//                   children: [
//                     Text(
//                       resultParts.first,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 48.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(width: 8.w),
//                     Text(
//                       '${resultParts.sublist(1).join(' ')} / day',
//                       style: TextStyle(color: Colors.white70, fontSize: 16.sp),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 24.h),
//
//                 // Result Unit Dropdown
//                 _buildResultUnitDropdown(),
//               ],
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   bool _isActivityDropdownOpen = false;
//
//   Widget _buildActivityLevelSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Clickable Header (matches your screenshot exactly)
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               _isActivityDropdownOpen = !_isActivityDropdownOpen;
//             });
//           },
//           child: Container(
//             height: 56.h,
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             decoration: BoxDecoration(
//               color: const Color(0xFF820DFF),
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'Activity level',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   _isActivityDropdownOpen
//                       ? Icons.keyboard_arrow_up
//                       : Icons.keyboard_arrow_down,
//                   color: Colors.white,
//                   size: 28.w,
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         // Dropdown Options (shown only when open)
//         if (_isActivityDropdownOpen)
//           Container(
//             margin: EdgeInsets.only(top: 8.h),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 8.r,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: ['Low', 'Moderate', 'High'].map((level) {
//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       _activityLevel = level;
//                       _isActivityDropdownOpen = false; // Close after selection
//                     });
//                   },
//                   borderRadius: BorderRadius.circular(12.r),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             level,
//                             style: TextStyle(
//                               fontSize: 18.sp,
//                               fontWeight: _activityLevel == level
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                               color: _activityLevel == level
//                                   ? const Color(0xFF820DFF)
//                                   : Colors.black87,
//                             ),
//                           ),
//                         ),
//                         if (_activityLevel == level)
//                           Icon(
//                             Icons.check,
//                             color: const Color(0xFF820DFF),
//                             size: 24.w,
//                           ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//
//         SizedBox(height: 24.h),
//       ],
//     );
//   }
//
//   Widget _buildResultUnitDropdown() {
//     return _buildPurpleDropdown(
//       value: _resultUnit,
//       items: const [
//         'Milliliters',
//         'Centiliters',
//         'Liters',
//         'US Fluid Ounces',
//         'UK Fluid Ounces',
//       ],
//       onChanged: (value) => setState(() => _resultUnit = value!),
//     );
//   }
//
//   Widget _buildPurpleDropdown({
//     required String value,
//     required List<String> items,
//     required void Function(String?) onChanged,
//     double width = double.infinity,
//     String? label,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label != null)
//           Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.black)),
//         if (label != null) SizedBox(height: 8.h),
//         Container(
//           width: width,
//           height: 56.h,
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           decoration: BoxDecoration(
//             color: const Color(0xFF820DFF),
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: value,
//               isExpanded: true,
//               icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28.w),
//               style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
//               dropdownColor: const Color(0xFF820DFF),
//               items: items.map((item) {
//                 return DropdownMenuItem<String>(   value: item, child: Text(item));
//               }).toList(),
//               onChanged: onChanged,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// //
// // class DrinkCalculatorWidget extends StatefulWidget {
// //   const DrinkCalculatorWidget({super.key});
// //
// //   @override
// //   State<DrinkCalculatorWidget> createState() => _DrinkCalculatorWidgetState();
// // }
// //
// // class _DrinkCalculatorWidgetState extends State<DrinkCalculatorWidget> {
// //   String _activityLevel = 'Low';
// //   String _weightUnit = 'Pounds';
// //   String _resultUnit = 'Milliliters';
// //   final TextEditingController _weightController = TextEditingController(text: '50');
// //
// //   // Accurate calculation: 70 mL/kg base + activity adjustment
// //   double _calculateDailyWaterML() {
// //     final input = _weightController.text.trim();
// //     if (input.isEmpty) return 0;
// //
// //     final weight = double.tryParse(input) ?? 0;
// //     if (weight <= 0) return 0;
// //
// //     // Convert to kg
// //     double weightInKg = switch (_weightUnit) {
// //       'Kilograms' => weight,
// //       'Pounds' => weight * 0.453592,
// //       'Ounces' => weight * 0.0283495,
// //       'Grams' => weight / 1000,
// //       _ => weight,
// //     };
// //
// //     double baseML = weightInKg * 70; // Standard veterinary average
// //
// //     double multiplier = switch (_activityLevel) {
// //       'Low' => 0.85,
// //       'High' => 1.3,
// //       'Very High' => 1.5,
// //       _ => 1.0,
// //     };
// //
// //     return baseML * multiplier;
// //   }
// //
// //   String _formatResult(double ml) {
// //     // Handle very small values - show at least 2 decimal places for values < 1
// //     if (ml < 1 && ml > 0) {
// //       return switch (_resultUnit) {
// //         'Milliliters' => '${ml.toStringAsFixed(2)} mL',
// //         'Centiliters' => '${(ml / 10).toStringAsFixed(3)} cL',
// //         'Liters' => '${(ml / 1000).toStringAsFixed(4)} L',
// //         'US Fluid Ounces' => '${(ml / 29.5735).toStringAsFixed(3)} fl oz (US)',
// //         'UK Fluid Ounces' => '${(ml / 28.4131).toStringAsFixed(3)} fl oz (UK)',
// //         _ => '${ml.toStringAsFixed(2)} mL',
// //       };
// //     } else {
// //       return switch (_resultUnit) {
// //         'Milliliters' => '${ml.toStringAsFixed(1)} mL',
// //         'Centiliters' => '${(ml / 10).toStringAsFixed(1)} cL',
// //         'Liters' => '${(ml / 1000).toStringAsFixed(2)} L',
// //         'US Fluid Ounces' => '${(ml / 29.5735).toStringAsFixed(1)} fl oz (US)',
// //         'UK Fluid Ounces' => '${(ml / 28.4131).toStringAsFixed(1)} fl oz (UK)',
// //         _ => '${ml.toStringAsFixed(1)} mL',
// //       };
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     _weightController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final dailyML = _calculateDailyWaterML();
// //     final resultValue = _formatResult(dailyML);
// //     final resultParts = resultValue.split(' ');
// //
// //     return Padding(
// //       padding: EdgeInsets.all(16.w),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Description
// //           Text(
// //             'Calculate daily water intake your dog needs according to weight and activity level for healthy hydration every day',
// //             style: TextStyle(fontSize: 16.sp, color: Colors.black87, height: 1.5),
// //           ),
// //
// //           SizedBox(height: 32.h),
// //
// //           // Activity Level
// //           _buildPurpleDropdown(
// //             label: 'Activity level',
// //             value: _activityLevel,
// //             items: const ['Low', 'Moderate', 'High', 'Very High'],
// //             onChanged: (value) => setState(() => _activityLevel = value!),
// //           ),
// //
// //           SizedBox(height: 16.h),
// //
// //           // Weight Input + Unit
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text('Current Weight', style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
// //                     SizedBox(height: 8.h),
// //                     Container(
// //                       height: 56.h,
// //                       padding: EdgeInsets.symmetric(horizontal: 16.w),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(12.r),
// //                         border: Border.all(color: const Color(0xFF820DFF), width: 2),
// //                       ),
// //                       child: TextField(
// //                         controller: _weightController,
// //                         keyboardType: TextInputType.numberWithOptions(decimal: true),
// //                         style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
// //                         decoration: InputDecoration(
// //                           border: InputBorder.none,
// //                           hintText: 'Weight',
// //                           hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18.sp),
// //                         ),
// //                         onChanged: (_) => setState(() {}),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //
// //               SizedBox(width: 12.w),
// //
// //               _buildPurpleDropdown(
// //                 value: _weightUnit,
// //                 items: const ['Pounds', 'Kilograms', 'Ounces', 'Grams'],
// //                 onChanged: (value) => setState(() => _weightUnit = value!),
// //                 width: 140.w,
// //               ),
// //             ],
// //           ),
// //
// //           SizedBox(height: 40.h),
// //
// //           // Result Card - Always visible, live update
// //           Container(
// //             width: double.infinity,
// //             padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
// //             decoration: BoxDecoration(
// //               color: Colors.black87,
// //               borderRadius: BorderRadius.circular(20.r),
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   'Your dog will need',
// //                   style: TextStyle(color: Colors.white70, fontSize: 16.sp),
// //                 ),
// //
// //                 SizedBox(height: 16.h),
// //
// //                 Row(
// //                   crossAxisAlignment: CrossAxisAlignment.baseline,
// //                   textBaseline: TextBaseline.alphabetic,
// //                   children: [
// //                     Text(
// //                       resultParts.first,
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 48.sp,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     SizedBox(width: 8.w),
// //                     Text(
// //                       '${resultParts.sublist(1).join(' ')} / day',
// //                       style: TextStyle(color: Colors.white70, fontSize: 16.sp),
// //                     ),
// //                   ],
// //                 ),
// //
// //                 SizedBox(height: 24.h),
// //
// //                 // Result Unit Dropdown
// //                 _buildResultUnitDropdown(),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildResultUnitDropdown() {
// //     return _buildPurpleDropdown(
// //       value: _resultUnit,
// //       items: const [
// //         'Milliliters',
// //         'Centiliters',
// //         'Liters',
// //         'US Fluid Ounces',
// //         'UK Fluid Ounces',
// //       ],
// //       onChanged: (value) => setState(() => _resultUnit = value!),
// //     );
// //   }
// //
// //   Widget _buildPurpleDropdown({
// //     required String value,
// //     required List<String> items,
// //     required void Function(String?) onChanged,
// //     double width = double.infinity,
// //     String? label,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         if (label != null)
// //           Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
// //         if (label != null) SizedBox(height: 8.h),
// //         Container(
// //           width: width,
// //           height: 56.h,
// //           padding: EdgeInsets.symmetric(horizontal: 16.w),
// //           decoration: BoxDecoration(
// //             color: const Color(0xFF820DFF),
// //             borderRadius: BorderRadius.circular(12.r),
// //           ),
// //           child: DropdownButtonHideUnderline(
// //             child: DropdownButton<String>(
// //               value: value,
// //               isExpanded: true,
// //               icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28.w),
// //               style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
// //               dropdownColor: const Color(0xFF820DFF),
// //               items: items.map((item) {
// //                 return DropdownMenuItem<String>(value: item, child: Text(item));
// //               }).toList(),
// //               onChanged: onChanged,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // //
// // // class DrinkCalculatorWidget extends StatefulWidget {
// // //   const DrinkCalculatorWidget({super.key});
// // //
// // //   @override
// // //   State<DrinkCalculatorWidget> createState() => _DrinkCalculatorWidgetState();
// // // }
// // //
// // // class _DrinkCalculatorWidgetState extends State<DrinkCalculatorWidget> {
// // //   String _activityLevel = 'Low';
// // //   String _weightUnit = 'Pounds';
// // //   final TextEditingController _weightController = TextEditingController(text: '50');
// // //
// // //   // Accurate calculation based on veterinary standards
// // //   double _calculateDailyWaterML() {
// // //     final String input = _weightController.text.trim();
// // //     if (input.isEmpty) return 0;
// // //
// // //     final double? weight = double.tryParse(input);
// // //     if (weight == null || weight <= 0) return 0;
// // //
// // //     // Convert weight to kilograms
// // //     double weightInKg = switch (_weightUnit) {
// // //       'Kilograms' => weight,
// // //       'Pounds' => weight * 0.453592,     // 1 lb = 0.453592 kg
// // //       'Ounces' => weight * 0.0283495,    // 1 oz = 0.0283495 kg
// // //       'Grams' => weight / 1000,          // 1000 g = 1 kg
// // //       _ => weight,
// // //     };
// // //
// // //     // Base: 70 mL per kg per day (average healthy adult dog)
// // //     double baseML = weightInKg * 70;
// // //
// // //     // Activity level multiplier
// // //     double multiplier = switch (_activityLevel) {
// // //       'Low' => 0.85,
// // //       'High' => 1.3,
// // //       'Very High' => 1.5,
// // //       _ => 1.0,
// // //     };
// // //
// // //     return baseML * multiplier;
// // //   }
// // //
// // //   String _formatResult(double ml) {
// // //     final oz = (ml / 29.5735).toStringAsFixed(1);
// // //     return '${ml.toStringAsFixed(0)} mL\n($oz oz) per day';
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _weightController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final double dailyWaterML = _calculateDailyWaterML();
// // //
// // //     return Padding(
// // //       padding: EdgeInsets.all(16.w),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           // Description
// // //           Text(
// // //             'Calculate daily water intake your dog needs according to weight and activity level for healthy hydration every day',
// // //             style: TextStyle(
// // //               fontSize: 16.sp,
// // //               color: Colors.black87,
// // //               height: 1.5,
// // //             ),
// // //           ),
// // //
// // //           SizedBox(height: 32.h),
// // //
// // //           // Activity Level Dropdown
// // //           _buildPurpleDropdown(
// // //             label: 'Activity level',
// // //             value: _activityLevel,
// // //             items: const ['Low', 'Moderate', 'High', 'Very High'],
// // //             onChanged: (value) => setState(() => _activityLevel = value!),
// // //           ),
// // //
// // //           SizedBox(height: 16.h),
// // //
// // //           // Weight Input + Unit Dropdown
// // //           Row(
// // //             children: [
// // //               // Weight Input
// // //               Expanded(
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text(
// // //                       'Current Weight',
// // //                       style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
// // //                     ),
// // //                     SizedBox(height: 8.h),
// // //                     Container(
// // //                       height: 56.h,
// // //                       padding: EdgeInsets.symmetric(horizontal: 16.w),
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.white,
// // //                         borderRadius: BorderRadius.circular(12.r),
// // //                         border: Border.all(color: const Color(0xFF820DFF), width: 2),
// // //                       ),
// // //                       child: TextField(
// // //                         controller: _weightController,
// // //                         keyboardType: TextInputType.number,
// // //                         style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
// // //                         decoration: InputDecoration(
// // //                           border: InputBorder.none,
// // //                           hintText: 'Weight',
// // //                           hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18.sp),
// // //                         ),
// // //                         onChanged: (_) => setState(() {}),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //
// // //               SizedBox(width: 12.w),
// // //
// // //               // Unit Dropdown
// // //               _buildPurpleDropdown(
// // //                 value: _weightUnit,
// // //                 items: const ['Ounces', 'Grams', 'Pounds', 'Kilograms'],
// // //                 onChanged: (value) => setState(() => _weightUnit = value!),
// // //                 width: 140.w,
// // //               ),
// // //             ],
// // //           ),
// // //
// // //           SizedBox(height: 40.h),
// // //
// // //           // Result Card (always visible, updates live)
// // //           Container(
// // //             width: double.infinity,
// // //             padding: EdgeInsets.all(24.w),
// // //             decoration: BoxDecoration(
// // //               color: const Color(0xFFF8F4FF),
// // //               borderRadius: BorderRadius.circular(16.r),
// // //               border: Border.all(color: const Color(0xFF820DFF), width: 2),
// // //             ),
// // //             child: Column(
// // //               children: [
// // //                 Icon(Icons.water_drop_outlined, color: const Color(0xFF820DFF), size: 56.w),
// // //                 SizedBox(height: 16.h),
// // //                 Text(
// // //                   'Recommended Daily Water Intake',
// // //                   textAlign: TextAlign.center,
// // //                   style: TextStyle(
// // //                     fontSize: 18.sp,
// // //                     fontWeight: FontWeight.bold,
// // //                     color: Colors.black87,
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 16.h),
// // //                 Text(
// // //                   dailyWaterML > 0 ? _formatResult(dailyWaterML) : 'Enter weight to calculate',
// // //                   textAlign: TextAlign.center,
// // //                   style: TextStyle(
// // //                     fontSize: 22.sp,
// // //                     fontWeight: FontWeight.w600,
// // //                     color: const Color(0xFF820DFF),
// // //                     height: 1.5,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //
// // //           SizedBox(height: 32.h),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   // Reusable Purple Dropdown
// // //   Widget _buildPurpleDropdown({
// // //     required String value,
// // //     required List<String> items,
// // //     required void Function(String?) onChanged,
// // //     double width = double.infinity,
// // //     String? label,
// // //   }) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         if (label != null)
// // //           Text(
// // //             label,
// // //             style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
// // //           ),
// // //         if (label != null) SizedBox(height: 8.h),
// // //         Container(
// // //           width: width,
// // //           height: 56.h,
// // //           padding: EdgeInsets.symmetric(horizontal: 16.w),
// // //           decoration: BoxDecoration(
// // //             color: const Color(0xFF820DFF),
// // //             borderRadius: BorderRadius.circular(12.r),
// // //           ),
// // //           child: DropdownButtonHideUnderline(
// // //             child: DropdownButton<String>(
// // //               value: value,
// // //               isExpanded: true,
// // //               icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28.w),
// // //               style: TextStyle(
// // //                 color: Colors.white,
// // //                 fontSize: 18.sp,
// // //                 fontWeight: FontWeight.w600,
// // //               ),
// // //               dropdownColor: const Color(0xFF820DFF),
// // //               items: items.map((item) {
// // //                 return DropdownMenuItem<String>(
// // //                   value: item,
// // //                   child: Text(item),
// // //                 );
// // //               }).toList(),
// // //               onChanged: onChanged,
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }
// // //
// // //



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class DrinkCalculatorWidget extends StatefulWidget {
//   const DrinkCalculatorWidget({super.key});
//
//   @override
//   State<DrinkCalculatorWidget> createState() => _DrinkCalculatorWidgetState();
// }
//
// class _DrinkCalculatorWidgetState extends State<DrinkCalculatorWidget> {
//   String _activityLevel = 'Moderate';
//   String _weightUnit = 'Pounds';
//   String _resultUnit = 'Milliliters';
//   final TextEditingController _weightController = TextEditingController(text: '20');
//
//   bool _isActivityDropdownOpen = false;
//
//   double _calculateDailyWaterML() {
//     final input = _weightController.text.trim();
//     if (input.isEmpty) return 0;
//
//     final weight = double.tryParse(input) ?? 0;
//     if (weight <= 0) return 0;
//
//     double weightInKg = switch (_weightUnit) {
//       'Kilograms' => weight,
//       'Pounds' => weight * 0.453592,
//       'Ounces' => weight * 0.0283495,
//       'Grams' => weight / 1000,
//       _ => weight,
//     };
//
//     double baseML = weightInKg * 70;
//
//     double multiplier = switch (_activityLevel) {
//       'Low' => 0.79,
//       'Moderate' => 1.16,
//       'High' => 1.57,
//       _ => 1.16,
//     };
//
//     return baseML * multiplier;
//   }
//
//   String _formatResult(double ml) {
//     if (ml <= 0) return '0 mL';
//
//     final roundedML = ml.roundToDouble();
//
//     return switch (_resultUnit) {
//       'Milliliters' => '${roundedML.toStringAsFixed(roundedML % 1 == 0 ? 0 : 1)} mL',
//       'Centiliters' => '${(ml / 10).toStringAsFixed(1)} cL',
//       'Liters' => '${(ml / 1000).toStringAsFixed(2)} L',
//       'US Fluid Ounces' => '${(ml / 29.5735).toStringAsFixed(1)} US fl oz',
//       'UK Fluid Ounces' => '${(ml / 28.4131).toStringAsFixed(1)} UK fl oz',
//       _ => '${roundedML.toStringAsFixed(roundedML % 1 == 0 ? 0 : 1)} mL',
//     };
//   }
//   @override
//   void dispose() {
//     _weightController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dailyML = _calculateDailyWaterML();
//     final resultValue = _formatResult(dailyML);
//     final resultParts = resultValue.split(' ');
//
//     return Padding(
//       padding: EdgeInsets.all(6.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.all(20.w),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Text(
//               'Calculate daily water intake your dog needs\naccording to weight and activity level for\nhealthy hydration every day',
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 color: Colors.black87,
//                 height: 1.5,
//               ),
//             ),
//           ),
//
//           SizedBox(height: 32.h),
//           _buildActivityLevelSection(),
//           SizedBox(height: 24.h),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Current Weight',
//                       style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
//                     ),
//                     SizedBox(height: 8.h),
//                     Container(
//                       height: 56.h,
//                       padding: EdgeInsets.symmetric(horizontal: 16.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12.r),
//                         border: Border.all(color: const Color(0xFFECEEED), width: 2),
//                       ),
//                       child: Center(
//                         child: TextField(
//                           controller: _weightController,
//                           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                           style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
//                           textAlignVertical: TextAlignVertical.center,
//                           decoration: InputDecoration(
//                             isDense: true,
//                             border: InputBorder.none,
//                             hintText: 'Weight',
//                             hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18.sp),
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                           onChanged: (_) => setState(() {}),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               _buildPurpleDropdown(
//                 value: _weightUnit,
//                 items: const ['Pounds', 'Kilograms', 'Ounces', 'Grams'],
//                 onChanged: (value) => setState(() => _weightUnit = value!),
//                 width: 230.w,
//               ),
//             ],
//           ),
//           SizedBox(height: 40.h),
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade400,
//               borderRadius: BorderRadius.circular(20.r),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Your Dog will need',
//                   style: TextStyle(color: Colors.white70, fontSize: 16.sp),
//                 ),
//
//                 SizedBox(height: 16.h),
//                 SingleChildScrollView(
//                   scrollDirection:Axis.horizontal,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.baseline,
//                     textBaseline: TextBaseline.alphabetic,
//                     children: [
//                       Text(
//                         resultParts.isEmpty ? '0' : resultParts.first,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 48.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       Text(
//                         resultParts.length > 1 ? '${resultParts.sublist(1).join(' ')} / day' : '/ day',
//                         style: TextStyle(color: Colors.white70, fontSize: 16.sp),
//                       ),
//                       SizedBox(width: 40.w),
//                       SizedBox(
//                         width: 150.w,  // ← adjust this value (140–180.w usually looks good)
//                         child: _buildResultUnitDropdown(),
//                       ),
//
//                     ],
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActivityLevelSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               _isActivityDropdownOpen = !_isActivityDropdownOpen;
//             });
//           },
//           child: Container(
//             height: 56.h,
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             decoration: BoxDecoration(
//               color: const Color(0xFF820DFF),
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(12.r),
//                 bottom: _isActivityDropdownOpen ? Radius.zero : Radius.circular(12.r),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     _activityLevel,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   _isActivityDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                   color: Colors.white,
//                   size: 28.w,
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         // Options List
//         if (_isActivityDropdownOpen)
//           Align(
//             alignment: Alignment.bottomRight,
//             child: Container(
//               height: 100.h,
//               width: 170.w,
//               decoration: BoxDecoration(
//                 color: Color(0xFFE6E6E6),
//                 borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black12, blurRadius: 8.r, offset: Offset(0, 4)),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: ['Low', 'Moderate', 'High'].map((level) {
//                   return InkWell(
//                     onTap: () {
//                       setState(() {
//                         _activityLevel = level;
//                         _isActivityDropdownOpen = false;
//                       });
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               level,
//                               style: TextStyle(
//                                 fontSize: 18.sp,
//                                 fontWeight: _activityLevel == level ? FontWeight.bold : FontWeight.normal,
//                                 color: _activityLevel == level ? const Color(0xFF000000) : Colors.black87,
//                               ),
//                             ),
//                           ),
//                           if (_activityLevel == level)
//                             Icon(Icons.check, color: const Color(0xFF820DFF), size: 24.w),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildResultUnitDropdown() {
//     return _buildPurpleDropdown(
//       value: _resultUnit,
//       items: const [
//         'Milliliters',
//         'Centiliters',
//         'Liters',
//         'US Fluid Ounces',
//         'UK Fluid Ounces',
//       ],
//       onChanged: (value) => setState(() => _resultUnit = value!),
//     );
//   }
//
//   Widget _buildPurpleDropdown({
//     required String value,
//     required List<String> items,
//     required void Function(String?) onChanged,
//     double width = double.infinity,
//     String? label,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label != null)
//           Text(
//             label,
//             style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
//           ),
//         if (label != null) SizedBox(height: 8.h),
//         Container(
//           width: width,
//           height: 56.h,
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           decoration: BoxDecoration(
//             color: const Color(0xFF820DFF),
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: value,
//               isExpanded: true,
//               icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28.w),
//               style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
//               dropdownColor: const Color(0xFF820DFF),
//               items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
//               onChanged: onChanged,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// //
// // class DrinkCalculatorWidget extends StatefulWidget {
// //   const DrinkCalculatorWidget({super.key});
// //
// //   @override
// //   State<DrinkCalculatorWidget> createState() => _DrinkCalculatorWidgetState();
// // }
// //
// // class _DrinkCalculatorWidgetState extends State<DrinkCalculatorWidget> {
// //   String _activityLevel = 'Moderate';
// //   String _weightUnit = 'Pounds';
// //   String _resultUnit = 'Milliliters';
// //   final TextEditingController _weightController = TextEditingController(text: '1');
// //   double _calculateDailyWaterML() {
// //     final input = _weightController.text.trim();
// //     if (input.isEmpty) return 0;
// //
// //     final weight = double.tryParse(input) ?? 0;
// //     if (weight <= 0) return 0;
// //
// //     // Convert to kg
// //     double weightInKg = switch (_weightUnit) {
// //       'Kilograms' => weight,
// //       'Pounds' => weight * 0.453592,
// //       'Ounces' => weight * 0.0283495,
// //       'Grams' => weight / 1000,
// //       _ => weight,
// //     };
// //
// //     double baseML = weightInKg * 70;
// //
// //     double multiplier = switch (_activityLevel) {
// //       'Low' => 0.79,
// //       'Moderate' => 1.16,
// //       'High' => 1.57,
// //       _ => 1.16,
// //     };
// //
// //     return baseML * multiplier;
// //   }
// //
// //   String _formatResult(double ml) {
// //
// //     final roundedML = double.parse(ml.toStringAsFixed(1));
// //
// //     return switch (_resultUnit) {
// //       'Milliliters' => '${roundedML.toStringAsFixed(roundedML % 1 == 0 ? 0 : 1)} mL',
// //       'Centiliters' => '${(ml / 10).toStringAsFixed(1)} cL',
// //       'Liters' => '${(ml / 1000).toStringAsFixed(2)} L',
// //       'US Fluid Ounces' => '${(ml / 29.5735).toStringAsFixed(1)} US fl oz',
// //       'UK Fluid Ounces' => '${(ml / 28.4131).toStringAsFixed(1)} UK fl oz',
// //       _ => '${roundedML.toStringAsFixed(roundedML % 1 == 0 ? 0 : 1)} mL',
// //     };
// //   }
// //
// //   @override
// //   void dispose() {
// //     _weightController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final dailyML = _calculateDailyWaterML();
// //     final resultValue = _formatResult(dailyML);
// //     final resultParts = resultValue.split(' ');
// //
// //     return Padding(
// //       padding: const EdgeInsets.all(8),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             height: 120.h,
// //             width: 410.w,
// //             decoration: BoxDecoration(
// //               color: Colors.grey.shade200,
// //               borderRadius: BorderRadius.circular(12.r),
// //             ),
// //             child: Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: Text(
// //                 'Calculate daily water intake your dog needs\n according to weight and activity level for\n healthy hydration every day',
// //                 style: TextStyle(
// //                   fontSize: 16.sp,
// //                   color: Colors.black87,
// //                   height: 1.5,
// //                 ),
// //               ),
// //             ),
// //           ),
// //
// //
// //           SizedBox(height: 32.h),
// //           _buildActivityLevelSection(),
// //           _buildPurpleDropdown(
// //             label: 'Activity level',
// //             value: _activityLevel,
// //             items: const ['Low', 'Moderate', 'High'],
// //             onChanged: (value) => setState(() => _activityLevel = value!),
// //           ),
// //
// //           SizedBox(height: 16.h),
// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.end,
// //             children: [
// //               // Weight Input Field
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       'Current Weight',
// //                       style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
// //                     ),
// //                     SizedBox(height: 8.h),
// //                     Container(
// //                       height: 56.h,
// //                       width: 154.w,// Match dropdown height exactly
// //                       padding: EdgeInsets.symmetric(horizontal: 16.w),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(12.r),
// //                         border: Border.all(color: const Color(0xFF820DFF), width: 2),
// //                       ),
// //                       child: Center( // Vertically center the text field
// //                         child: TextField(
// //                           controller: _weightController,
// //                           keyboardType: const TextInputType.numberWithOptions(decimal: true),
// //                           style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
// //                           textAlignVertical: TextAlignVertical.center,
// //                           decoration: InputDecoration(
// //                             isDense: true, // Reduces internal padding
// //                             border: InputBorder.none,
// //                             hintText: 'Enter weight',
// //                             hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18.sp),
// //                             contentPadding: EdgeInsets.zero,
// //                           ),
// //                           onChanged: (_) => setState(() {}),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //
// //               SizedBox(width: 12.w),
// //
// //               // Unit Dropdown (already 111.h)
// //               _buildPurpleDropdown(
// //                 value: _weightUnit,
// //                 items: const ['Pounds', 'Kilograms', 'Ounces', 'Grams'],
// //                 onChanged: (value) => setState(() => _weightUnit = value!),
// //                 width: 230.w,
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 40.h),
// //
// //           // Result Card
// //           Container(
// //             width: double.infinity,
// //             padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
// //             decoration: BoxDecoration(
// //               color: Colors.black87,
// //               borderRadius: BorderRadius.circular(20.r),
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   'Daily Water Intake',
// //                   style: TextStyle(color: Colors.white70, fontSize: 16.sp),
// //                 ),
// //
// //                 SizedBox(height: 16.h),
// //
// //                 Row(
// //                   crossAxisAlignment: CrossAxisAlignment.baseline,
// //                   textBaseline: TextBaseline.alphabetic,
// //                   children: [
// //                     Text(
// //                       resultParts.first,
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 48.sp,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     SizedBox(width: 8.w),
// //                     Text(
// //                       '${resultParts.sublist(1).join(' ')} / day',
// //                       style: TextStyle(color: Colors.white70, fontSize: 16.sp),
// //                     ),
// //                   ],
// //                 ),
// //
// //                 SizedBox(height: 24.h),
// //
// //                 // Result Unit Dropdown
// //                 _buildResultUnitDropdown(),
// //               ],
// //             ),
// //           ),
// //
// //         ],
// //       ),
// //     );
// //   }
// //
// //   bool _isActivityDropdownOpen = false;
// //
// //   Widget _buildActivityLevelSection() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         // Clickable Header (matches your screenshot exactly)
// //         GestureDetector(
// //           onTap: () {
// //             setState(() {
// //               _isActivityDropdownOpen = !_isActivityDropdownOpen;
// //             });
// //           },
// //           child: Container(
// //             height: 56.h,
// //             padding: EdgeInsets.symmetric(horizontal: 16.w),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF820DFF),
// //               borderRadius: BorderRadius.circular(12.r),
// //             ),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: Text(
// //                     'Activity level',
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 18.sp,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //                 Icon(
// //                   _isActivityDropdownOpen
// //                       ? Icons.keyboard_arrow_up
// //                       : Icons.keyboard_arrow_down,
// //                   color: Colors.white,
// //                   size: 28.w,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //
// //         // Dropdown Options (shown only when open)
// //         if (_isActivityDropdownOpen)
// //           Container(
// //             margin: EdgeInsets.only(top: 8.h),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(12.r),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black12,
// //                   blurRadius: 8.r,
// //                   offset: Offset(0, 4),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               children: ['Low', 'Moderate', 'High'].map((level) {
// //                 return InkWell(
// //                   onTap: () {
// //                     setState(() {
// //                       _activityLevel = level;
// //                       _isActivityDropdownOpen = false; // Close after selection
// //                     });
// //                   },
// //                   borderRadius: BorderRadius.circular(12.r),
// //                   child: Container(
// //                     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
// //                     child: Row(
// //                       children: [
// //                         Expanded(
// //                           child: Text(
// //                             level,
// //                             style: TextStyle(
// //                               fontSize: 18.sp,
// //                               fontWeight: _activityLevel == level
// //                                   ? FontWeight.bold
// //                                   : FontWeight.normal,
// //                               color: _activityLevel == level
// //                                   ? const Color(0xFF820DFF)
// //                                   : Colors.black87,
// //                             ),
// //                           ),
// //                         ),
// //                         if (_activityLevel == level)
// //                           Icon(
// //                             Icons.check,
// //                             color: const Color(0xFF820DFF),
// //                             size: 24.w,
// //                           ),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               }).toList(),
// //             ),
// //           ),
// //
// //         SizedBox(height: 24.h),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildResultUnitDropdown() {
// //     return _buildPurpleDropdown(
// //       value: _resultUnit,
// //       items: const [
// //         'Milliliters',
// //         'Centiliters',
// //         'Liters',
// //         'US Fluid Ounces',
// //         'UK Fluid Ounces',
// //       ],
// //       onChanged: (value) => setState(() => _resultUnit = value!),
// //     );
// //   }
// //
// //   Widget _buildPurpleDropdown({
// //     required String value,
// //     required List<String> items,
// //     required void Function(String?) onChanged,
// //     double width = double.infinity,
// //     String? label,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         if (label != null)
// //           Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.black)),
// //         if (label != null) SizedBox(height: 8.h),
// //         Container(
// //           width: width,
// //           height: 56.h,
// //           padding: EdgeInsets.symmetric(horizontal: 16.w),
// //           decoration: BoxDecoration(
// //             color: const Color(0xFF820DFF),
// //             borderRadius: BorderRadius.circular(12.r),
// //           ),
// //           child: DropdownButtonHideUnderline(
// //             child: DropdownButton<String>(
// //               value: value,
// //               isExpanded: true,
// //               icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28.w),
// //               style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
// //               dropdownColor: const Color(0xFF820DFF),
// //               items: items.map((item) {
// //                 return DropdownMenuItem<String>(   value: item, child: Text(item));
// //               }).toList(),
// //               onChanged: onChanged,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// //
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // //
// // // class DrinkCalculatorWidget extends StatefulWidget {
// // //   const DrinkCalculatorWidget({super.key});
// // //
// // //   @override
// // //   State<DrinkCalculatorWidget> createState() => _DrinkCalculatorWidgetState();
// // // }
// // //
// // // class _DrinkCalculatorWidgetState extends State<DrinkCalculatorWidget> {
// // //   String _activityLevel = 'Low';
// // //   String _weightUnit = 'Pounds';
// // //   String _resultUnit = 'Milliliters';
// // //   final TextEditingController _weightController = TextEditingController(text: '50');
// // //
// // //   // Accurate calculation: 70 mL/kg base + activity adjustment
// // //   double _calculateDailyWaterML() {
// // //     final input = _weightController.text.trim();
// // //     if (input.isEmpty) return 0;
// // //
// // //     final weight = double.tryParse(input) ?? 0;
// // //     if (weight <= 0) return 0;
// // //
// // //     // Convert to kg
// // //     double weightInKg = switch (_weightUnit) {
// // //       'Kilograms' => weight,
// // //       'Pounds' => weight * 0.453592,
// // //       'Ounces' => weight * 0.0283495,
// // //       'Grams' => weight / 1000,
// // //       _ => weight,
// // //     };
// // //
// // //     double baseML = weightInKg * 70; // Standard veterinary average
// // //
// // //     double multiplier = switch (_activityLevel) {
// // //       'Low' => 0.85,
// // //       'High' => 1.3,
// // //       'Very High' => 1.5,
// // //       _ => 1.0,
// // //     };
// // //
// // //     return baseML * multiplier;
// // //   }
// // //
// // //   String _formatResult(double ml) {
// // //     // Handle very small values - show at least 2 decimal places for values < 1
// // //     if (ml < 1 && ml > 0) {
// // //       return switch (_resultUnit) {
// // //         'Milliliters' => '${ml.toStringAsFixed(2)} mL',
// // //         'Centiliters' => '${(ml / 10).toStringAsFixed(3)} cL',
// // //         'Liters' => '${(ml / 1000).toStringAsFixed(4)} L',
// // //         'US Fluid Ounces' => '${(ml / 29.5735).toStringAsFixed(3)} fl oz (US)',
// // //         'UK Fluid Ounces' => '${(ml / 28.4131).toStringAsFixed(3)} fl oz (UK)',
// // //         _ => '${ml.toStringAsFixed(2)} mL',
// // //       };
// // //     } else {
// // //       return switch (_resultUnit) {
// // //         'Milliliters' => '${ml.toStringAsFixed(1)} mL',
// // //         'Centiliters' => '${(ml / 10).toStringAsFixed(1)} cL',
// // //         'Liters' => '${(ml / 1000).toStringAsFixed(2)} L',
// // //         'US Fluid Ounces' => '${(ml / 29.5735).toStringAsFixed(1)} fl oz (US)',
// // //         'UK Fluid Ounces' => '${(ml / 28.4131).toStringAsFixed(1)} fl oz (UK)',
// // //         _ => '${ml.toStringAsFixed(1)} mL',
// // //       };
// // //     }
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _weightController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final dailyML = _calculateDailyWaterML();
// // //     final resultValue = _formatResult(dailyML);
// // //     final resultParts = resultValue.split(' ');
// // //
// // //     return Padding(
// // //       padding: EdgeInsets.all(16.w),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           // Description
// // //           Text(
// // //             'Calculate daily water intake your dog needs according to weight and activity level for healthy hydration every day',
// // //             style: TextStyle(fontSize: 16.sp, color: Colors.black87, height: 1.5),
// // //           ),
// // //
// // //           SizedBox(height: 32.h),
// // //
// // //           // Activity Level
// // //           _buildPurpleDropdown(
// // //             label: 'Activity level',
// // //             value: _activityLevel,
// // //             items: const ['Low', 'Moderate', 'High', 'Very High'],
// // //             onChanged: (value) => setState(() => _activityLevel = value!),
// // //           ),
// // //
// // //           SizedBox(height: 16.h),
// // //
// // //           // Weight Input + Unit
// // //           Row(
// // //             children: [
// // //               Expanded(
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text('Current Weight', style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
// // //                     SizedBox(height: 8.h),
// // //                     Container(
// // //                       height: 56.h,
// // //                       padding: EdgeInsets.symmetric(horizontal: 16.w),
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.white,
// // //                         borderRadius: BorderRadius.circular(12.r),
// // //                         border: Border.all(color: const Color(0xFF820DFF), width: 2),
// // //                       ),
// // //                       child: TextField(
// // //                         controller: _weightController,
// // //                         keyboardType: TextInputType.numberWithOptions(decimal: true),
// // //                         style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
// // //                         decoration: InputDecoration(
// // //                           border: InputBorder.none,
// // //                           hintText: 'Weight',
// // //                           hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18.sp),
// // //                         ),
// // //                         onChanged: (_) => setState(() {}),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //
// // //               SizedBox(width: 12.w),
// // //
// // //               _buildPurpleDropdown(
// // //                 value: _weightUnit,
// // //                 items: const ['Pounds', 'Kilograms', 'Ounces', 'Grams'],
// // //                 onChanged: (value) => setState(() => _weightUnit = value!),
// // //                 width: 140.w,
// // //               ),
// // //             ],
// // //           ),
// // //
// // //           SizedBox(height: 40.h),
// // //
// // //           // Result Card - Always visible, live update
// // //           Container(
// // //             width: double.infinity,
// // //             padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
// // //             decoration: BoxDecoration(
// // //               color: Colors.black87,
// // //               borderRadius: BorderRadius.circular(20.r),
// // //             ),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   'Your dog will need',
// // //                   style: TextStyle(color: Colors.white70, fontSize: 16.sp),
// // //                 ),
// // //
// // //                 SizedBox(height: 16.h),
// // //
// // //                 Row(
// // //                   crossAxisAlignment: CrossAxisAlignment.baseline,
// // //                   textBaseline: TextBaseline.alphabetic,
// // //                   children: [
// // //                     Text(
// // //                       resultParts.first,
// // //                       style: TextStyle(
// // //                         color: Colors.white,
// // //                         fontSize: 48.sp,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),
// // //                     SizedBox(width: 8.w),
// // //                     Text(
// // //                       '${resultParts.sublist(1).join(' ')} / day',
// // //                       style: TextStyle(color: Colors.white70, fontSize: 16.sp),
// // //                     ),
// // //                   ],
// // //                 ),
// // //
// // //                 SizedBox(height: 24.h),
// // //
// // //                 // Result Unit Dropdown
// // //                 _buildResultUnitDropdown(),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildResultUnitDropdown() {
// // //     return _buildPurpleDropdown(
// // //       value: _resultUnit,
// // //       items: const [
// // //         'Milliliters',
// // //         'Centiliters',
// // //         'Liters',
// // //         'US Fluid Ounces',
// // //         'UK Fluid Ounces',
// // //       ],
// // //       onChanged: (value) => setState(() => _resultUnit = value!),
// // //     );
// // //   }
// // //
// // //   Widget _buildPurpleDropdown({
// // //     required String value,
// // //     required List<String> items,
// // //     required void Function(String?) onChanged,
// // //     double width = double.infinity,
// // //     String? label,
// // //   }) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         if (label != null)
// // //           Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
// // //         if (label != null) SizedBox(height: 8.h),
// // //         Container(
// // //           width: width,
// // //           height: 56.h,
// // //           padding: EdgeInsets.symmetric(horizontal: 16.w),
// // //           decoration: BoxDecoration(
// // //             color: const Color(0xFF820DFF),
// // //             borderRadius: BorderRadius.circular(12.r),
// // //           ),
// // //           child: DropdownButtonHideUnderline(
// // //             child: DropdownButton<String>(
// // //               value: value,
// // //               isExpanded: true,
// // //               icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28.w),
// // //               style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
// // //               dropdownColor: const Color(0xFF820DFF),
// // //               items: items.map((item) {
// // //                 return DropdownMenuItem<String>(value: item, child: Text(item));
// // //               }).toList(),
// // //               onChanged: onChanged,
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }
// // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // //
// // // // class DrinkCalculatorWidget extends StatefulWidget {
// // // //   const DrinkCalculatorWidget({super.key});
// // // //
// // // //   @override
// // // //   State<DrinkCalculatorWidget> createState() => _DrinkCalculatorWidgetState();
// // // // }
// // // //
// // // // class _DrinkCalculatorWidgetState extends State<DrinkCalculatorWidget> {
// // // //   String _activityLevel = 'Low';
// // // //   String _weightUnit = 'Pounds';
// // // //   final TextEditingController _weightController = TextEditingController(text: '50');
// // // //
// // // //   // Accurate calculation based on veterinary standards
// // // //   double _calculateDailyWaterML() {
// // // //     final String input = _weightController.text.trim();
// // // //     if (input.isEmpty) return 0;
// // // //
// // // //     final double? weight = double.tryParse(input);
// // // //     if (weight == null || weight <= 0) return 0;
// // // //
// // // //     // Convert weight to kilograms
// // // //     double weightInKg = switch (_weightUnit) {
// // // //       'Kilograms' => weight,
// // // //       'Pounds' => weight * 0.453592,     // 1 lb = 0.453592 kg
// // // //       'Ounces' => weight * 0.0283495,    // 1 oz = 0.0283495 kg
// // // //       'Grams' => weight / 1000,          // 1000 g = 1 kg
// // // //       _ => weight,
// // // //     };
// // // //
// // // //     // Base: 70 mL per kg per day (average healthy adult dog)
// // // //     double baseML = weightInKg * 70;
// // // //
// // // //     // Activity level multiplier
// // // //     double multiplier = switch (_activityLevel) {
// // // //       'Low' => 0.85,
// // // //       'High' => 1.3,
// // // //       'Very High' => 1.5,
// // // //       _ => 1.0,
// // // //     };
// // // //
// // // //     return baseML * multiplier;
// // // //   }
// // // //
// // // //   String _formatResult(double ml) {
// // // //     final oz = (ml / 29.5735).toStringAsFixed(1);
// // // //     return '${ml.toStringAsFixed(0)} mL\n($oz oz) per day';
// // // //   }
// // // //
// // // //   @override
// // // //   void dispose() {
// // // //     _weightController.dispose();
// // // //     super.dispose();
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final double dailyWaterML = _calculateDailyWaterML();
// // // //
// // // //     return Padding(
// // // //       padding: EdgeInsets.all(16.w),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           // Description
// // // //           Text(
// // // //             'Calculate daily water intake your dog needs according to weight and activity level for healthy hydration every day',
// // // //             style: TextStyle(
// // // //               fontSize: 16.sp,
// // // //               color: Colors.black87,
// // // //               height: 1.5,
// // // //             ),
// // // //           ),
// // // //
// // // //           SizedBox(height: 32.h),
// // // //
// // // //           // Activity Level Dropdown
// // // //           _buildPurpleDropdown(
// // // //             label: 'Activity level',
// // // //             value: _activityLevel,
// // // //             items: const ['Low', 'Moderate', 'High', 'Very High'],
// // // //             onChanged: (value) => setState(() => _activityLevel = value!),
// // // //           ),
// // // //
// // // //           SizedBox(height: 16.h),
// // // //
// // // //           // Weight Input + Unit Dropdown
// // // //           Row(
// // // //             children: [
// // // //               // Weight Input
// // // //               Expanded(
// // // //                 child: Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     Text(
// // // //                       'Current Weight',
// // // //                       style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
// // // //                     ),
// // // //                     SizedBox(height: 8.h),
// // // //                     Container(
// // // //                       height: 56.h,
// // // //                       padding: EdgeInsets.symmetric(horizontal: 16.w),
// // // //                       decoration: BoxDecoration(
// // // //                         color: Colors.white,
// // // //                         borderRadius: BorderRadius.circular(12.r),
// // // //                         border: Border.all(color: const Color(0xFF820DFF), width: 2),
// // // //                       ),
// // // //                       child: TextField(
// // // //                         controller: _weightController,
// // // //                         keyboardType: TextInputType.number,
// // // //                         style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
// // // //                         decoration: InputDecoration(
// // // //                           border: InputBorder.none,
// // // //                           hintText: 'Weight',
// // // //                           hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18.sp),
// // // //                         ),
// // // //                         onChanged: (_) => setState(() {}),
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //
// // // //               SizedBox(width: 12.w),
// // // //
// // // //               // Unit Dropdown
// // // //               _buildPurpleDropdown(
// // // //                 value: _weightUnit,
// // // //                 items: const ['Ounces', 'Grams', 'Pounds', 'Kilograms'],
// // // //                 onChanged: (value) => setState(() => _weightUnit = value!),
// // // //                 width: 140.w,
// // // //               ),
// // // //             ],
// // // //           ),
// // // //
// // // //           SizedBox(height: 40.h),
// // // //
// // // //           // Result Card (always visible, updates live)
// // // //           Container(
// // // //             width: double.infinity,
// // // //             padding: EdgeInsets.all(24.w),
// // // //             decoration: BoxDecoration(
// // // //               color: const Color(0xFFF8F4FF),
// // // //               borderRadius: BorderRadius.circular(16.r),
// // // //               border: Border.all(color: const Color(0xFF820DFF), width: 2),
// // // //             ),
// // // //             child: Column(
// // // //               children: [
// // // //                 Icon(Icons.water_drop_outlined, color: const Color(0xFF820DFF), size: 56.w),
// // // //                 SizedBox(height: 16.h),
// // // //                 Text(
// // // //                   'Recommended Daily Water Intake',
// // // //                   textAlign: TextAlign.center,
// // // //                   style: TextStyle(
// // // //                     fontSize: 18.sp,
// // // //                     fontWeight: FontWeight.bold,
// // // //                     color: Colors.black87,
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(height: 16.h),
// // // //                 Text(
// // // //                   dailyWaterML > 0 ? _formatResult(dailyWaterML) : 'Enter weight to calculate',
// // // //                   textAlign: TextAlign.center,
// // // //                   style: TextStyle(
// // // //                     fontSize: 22.sp,
// // // //                     fontWeight: FontWeight.w600,
// // // //                     color: const Color(0xFF820DFF),
// // // //                     height: 1.5,
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //
// // // //           SizedBox(height: 32.h),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   // Reusable Purple Dropdown
// // // //   Widget _buildPurpleDropdown({
// // // //     required String value,
// // // //     required List<String> items,
// // // //     required void Function(String?) onChanged,
// // // //     double width = double.infinity,
// // // //     String? label,
// // // //   }) {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         if (label != null)
// // // //           Text(
// // // //             label,
// // // //             style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
// // // //           ),
// // // //         if (label != null) SizedBox(height: 8.h),
// // // //         Container(
// // // //           width: width,
// // // //           height: 56.h,
// // // //           padding: EdgeInsets.symmetric(horizontal: 16.w),
// // // //           decoration: BoxDecoration(
// // // //             color: const Color(0xFF820DFF),
// // // //             borderRadius: BorderRadius.circular(12.r),
// // // //           ),
// // // //           child: DropdownButtonHideUnderline(
// // // //             child: DropdownButton<String>(
// // // //               value: value,
// // // //               isExpanded: true,
// // // //               icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28.w),
// // // //               style: TextStyle(
// // // //                 color: Colors.white,
// // // //                 fontSize: 18.sp,
// // // //                 fontWeight: FontWeight.w600,
// // // //               ),
// // // //               dropdownColor: const Color(0xFF820DFF),
// // // //               items: items.map((item) {
// // // //                 return DropdownMenuItem<String>(
// // // //                   value: item,
// // // //                   child: Text(item),
// // // //                 );
// // // //               }).toList(),
// // // //               onChanged: onChanged,
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // // }
// // // //
// // // //
