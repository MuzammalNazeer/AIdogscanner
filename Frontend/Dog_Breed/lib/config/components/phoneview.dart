import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import 'CommonApp.dart';

class PhoneView extends StatefulWidget {
  final String initialPhone;

  const PhoneView({super.key, required this.initialPhone});

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  late TextEditingController _phoneController;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'PK'); // Default Pakistan

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhone);

    // If there's an initial phone, try to parse it
    if (widget.initialPhone.isNotEmpty) {
      PhoneNumber.getRegionInfoFromPhoneNumber(widget.initialPhone).then((number) {
        setState(() {
          _phoneNumber = number;
          _phoneController.text = number.phoneNumber?.split(' ')?.last ?? '';
        });
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                      color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surfaceContainerHighest : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(9)
                  ),
                  child: Center(
                    child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface, size: 20.sp),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              Text(l10n.mainPhone, style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),

              // Phone Input with Country Picker
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  _phoneNumber = number;
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  showFlags: true,
                  useEmoji: true,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18.sp),
                textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18.sp),
                textFieldController: _phoneController,
                formatInput: true,
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                inputDecoration: InputDecoration(
                  hintText: 'Main Phone',
                  hintStyle: TextStyle(fontSize: 18.sp, color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surfaceContainerHighest : const Color(0xFFF5F5F5),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.vibrantPurple, width: 2),
                  ),
                ),
                initialValue: _phoneNumber,
                countries: const ['PK', 'US', 'GB', 'IN', 'AE', 'SA'], // Optional: limit countries
              ),

              const Spacer(),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    final phone = _phoneNumber.phoneNumber?.trim();
                    if (phone != null && phone.length >= 10) {
                      Navigator.pop(context, phone);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid phone number')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vibrantPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.save,
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