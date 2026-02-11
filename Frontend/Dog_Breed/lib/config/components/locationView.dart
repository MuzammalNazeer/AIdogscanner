import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/Valid/AppColors.dart';

import '../../l10n/app_localizations.dart';
import 'CommonApp.dart';

class LocationView extends StatefulWidget {
  final String initialCountry;
  final String initialCity;

  const LocationView({
    super.key,
    required this.initialCountry,
    required this.initialCity,
  });

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  late String _selectedCountry;
  late TextEditingController _cityController;
  late final FocusNode _cityFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
    _cityController = TextEditingController(text: widget.initialCity);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _cityFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration:  BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(9)
                  ),
                  child: Center(
                    child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface, size: 20.sp),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // Country Field
              Text(
                AppLocalizations.of(context)!.country,
                style: TextStyle(fontSize: 18.sp, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    countryListTheme: CountryListThemeData(
                      borderRadius: BorderRadius.circular(16.r),
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      bottomSheetHeight: 600.h,
                      inputDecoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Theme.of(context).hintColor),
                        prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).dividerColor),
                        ),
                      ),
                    ),
                    onSelect: (Country country) {
                      setState(() {
                        _selectedCountry = country.name;
                      });
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surfaceContainerHighest : Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedCountry,
                        style: TextStyle(fontSize: 18.sp, color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const Spacer(),
                      Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // City Field
              Text(
                AppLocalizations.of(context)!.city,
                style: TextStyle(fontSize: 18.sp, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),

              TextField(
                controller: _cityController,
                focusNode: _cityFocus,
                style: TextStyle(fontSize: 18.sp, color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.hintEnterCity,
                  hintStyle: TextStyle(fontSize: 18.sp, color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surfaceContainerHighest : Theme.of(context).colorScheme.secondaryContainer,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.vibrantPurple, width: 2),
                  ),
                ),
              ),

              const Spacer(),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    final city = _cityController.text.trim();
                    if (city.isNotEmpty) {
                      Navigator.pop(context, {
                        'country': _selectedCountry,
                        'city': city,
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.errorEnterCity)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vibrantPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.save,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}