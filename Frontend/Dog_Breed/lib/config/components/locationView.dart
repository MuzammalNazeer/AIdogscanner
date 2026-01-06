import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/Valid/AppColors.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
    _cityController = TextEditingController(text: widget.initialCity);
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20.sp),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Country Field
              Text(
                'Country',
                style: TextStyle(fontSize: 18.sp, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    countryListTheme: CountryListThemeData(
                      borderRadius: BorderRadius.circular(16.r),
                      backgroundColor: Colors.white,
                      bottomSheetHeight: 600.h,
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
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedCountry,
                        style: TextStyle(fontSize: 18.sp, color: Colors.black87),
                      ),
                      const Spacer(),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // City Field
              Text(
                'City',
                style: TextStyle(fontSize: 18.sp, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _cityController,
                style: TextStyle(fontSize: 18.sp, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Enter your city',
                  hintStyle: TextStyle(fontSize: 18.sp, color: Colors.grey[400]),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.vibrantPurple, width: 2),
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
                        const SnackBar(content: Text('Please enter your city')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vibrantPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save',
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