import 'dart:io';
import 'dart:ui';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../config/components/CommonApp.dart';
import '../../config/components/AddressView.dart';
import '../../config/components/NameView.dart';
import '../../config/components/emailview.dart';
import '../../config/components/gender_view.dart';
import '../../config/components/lastNameview.dart';
import '../../config/components/locationView.dart';
import '../../config/components/phoneview.dart';
import '../../utils/routes/routes_name.dart';

class Ownerprofileview extends StatefulWidget {
  const Ownerprofileview({super.key});

  @override
  State<Ownerprofileview> createState() => _OwnerprofileviewState();
}

class _OwnerprofileviewState extends State<Ownerprofileview> {
  // Profile data
  String firstName = 'Muzammal';
  String lastName = '';
  String gender = '';
  String email = 'nazirmuzammal28@gmail.com';
  String phone = '';
  String country = 'Pakistan';
  String city = '';
  String address = '';

  File? _profileImageFile;
  final ImagePicker _picker = ImagePicker();

  // SharedPreferences keys
  static const String _keyFirstName = 'first_name';
  static const String _keyLastName = 'last_name';
  static const String _keyGender = 'gender';
  static const String _keyEmail = 'email';
  static const String _keyPhone = 'phone';
  static const String _keyCountry = 'country';
  static const String _keyCity = 'city';
  static const String _keyAddress = 'address';
  static const String _keyProfileImage = 'profile_image_path';

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  // Load all saved data
  Future<void> _loadAllData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      firstName = prefs.getString(_keyFirstName) ?? 'Muzammal';
      lastName = prefs.getString(_keyLastName) ?? '';
      gender = prefs.getString(_keyGender) ?? '';
      email = prefs.getString(_keyEmail) ?? 'anapplemuzammal@gmail.com';
      phone = prefs.getString(_keyPhone) ?? '';
      country = prefs.getString(_keyCountry) ?? 'Pakistan';
      city = prefs.getString(_keyCity) ?? '';
      address = prefs.getString(_keyAddress) ?? '';

      final savedPath = prefs.getString(_keyProfileImage);
      if (savedPath != null && File(savedPath).existsSync()) {
        _profileImageFile = File(savedPath);
      }
    });
  }

  // Save string data
  Future<void> _saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Save profile image path
  Future<void> _saveProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileImage, path);
  }

  Future<void> _pickProfileImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration:  BoxDecoration(
          color:  Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.chooseProfilePhoto,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPickerOption(
                    icon: Icons.camera_alt,
                    label: AppLocalizations.of(context)!.camera,
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  SizedBox(width: 60.w),
                  _buildPickerOption(
                    icon: Icons.photo_library,
                    label: AppLocalizations.of(context)!.gallery,
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(fontSize: 16.sp)),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 800,
    );
    if (picked != null) {
      setState(() => _profileImageFile = File(picked.path));
      await _saveProfileImagePath(picked.path);
    }
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40.sp, color: const Color(0xFF7C3AED)),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: isDark ? Border.all(color: Colors.white24) : null,
                          boxShadow: isDark ? null : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20.sp,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.ownersProfile,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(width: 44.w), // To balance the header
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: SizedBox(
                  width: 110.w,
                  height: 110.w,
                  child: Stack(
                    children: [
                      Container(
                        width: 110.w,
                        height: 110.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                          image: _profileImageFile != null
                              ? DecorationImage(
                                  image: FileImage(_profileImageFile!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _profileImageFile == null
                            ? Icon(
                                Icons.person,
                                size: 60.sp,
                                color: Colors.grey.shade600,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 50,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickProfileImage,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: const BoxDecoration(
                              color: Color(0xFF8B5CF6), // Purple color from screenshot
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.petOwner,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    // First Name
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NameView(initialName: firstName),
                          ),
                        );
                        if (result != null && result.isNotEmpty) {
                          setState(() => firstName = result);
                          await _saveString(_keyFirstName, result);
                        }
                      },
                      child: buildProfileInputField(
                        imagePath: 'assets/images/name.png',
                        label: AppLocalizations.of(context)!.labelName,
                        value: firstName,
                        isEmpty: firstName.isEmpty,
                      ),
                    ),

                    // Last Name
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Lastnameview( initialLastName: lastName,),
                          ),
                        );
                        if (result != null && result.isNotEmpty) {
                          setState(() => lastName = result);
                          await _saveString(_keyLastName, result);
                        }
                      },
                      child: buildProfileInputField(
                        imagePath: 'assets/images/name.png',
                        label: AppLocalizations.of(context)!.lastName,
                        value: lastName,
                        isEmpty: lastName.isEmpty,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Gender
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GenderView(currentGender: gender),
                          ),
                        );

                        if (result != null && result.isNotEmpty) {
                          setState(() {
                            gender = result;
                          });
                          await _saveString(_keyGender, result); // Save to SharedPreferences
                        }
                      },
                      child: buildProfileInputField(
                        imagePath: 'assets/images/gender.png',
                        label: AppLocalizations.of(context)!.labelGender,
                        value: gender,
                        isEmpty: gender.isEmpty,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    Text(
                      AppLocalizations.of(context)!.ownerContacts,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Email
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EmailView(initialEmail: email),
                          ),
                        );
                        if (result != null && result.isNotEmpty) {
                          setState(() => email = result);
                          await _saveString(_keyEmail, result);
                        }
                      },
                      child: buildProfileInputField(
                        imagePath: 'assets/images/email.png',
                        label: 'Email',
                        value: email,
                        isEmpty: email.isEmpty,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Phone
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PhoneView(initialPhone: phone),
                          ),
                        );
                        if (result != null && result.isNotEmpty) {
                          setState(() => phone = result);
                          await _saveString(_keyPhone, result);
                        }
                      },
                      child: buildProfileInputField(
                        icon: Icons.phone_outlined,
                        label: AppLocalizations.of(context)!.mainPhone,
                        value: phone,
                        isEmpty: phone.isEmpty,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Premium sections (unchanged)
                    _buildPremiumSection(
                      title: AppLocalizations.of(context)!.instantGpsAlerts,
                      description: AppLocalizations.of(context)!.gpsAlertsDescription,
                    ),
                    SizedBox(height: 22.h),
                    _buildPremiumSection(
                      title: AppLocalizations.of(context)!.emergencyContacts,
                      description: AppLocalizations.of(context)!.vetContactsDescription,
                    ),
                    SizedBox(height: 22.h),
                    _buildPremiumSection(
                      title: AppLocalizations.of(context)!.messenger,
                      description: AppLocalizations.of(context)!.messengerDescription,
                    ),
                    SizedBox(height: 30.h),

                    Text(
                      AppLocalizations.of(context)!.petsResidence,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Country & City
                    GestureDetector(
                      onTap: () async {
                        final result =
                            await Navigator.push<Map<String, String>>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationView(
                                  initialCountry: country,
                                  initialCity: city,
                                ),
                              ),
                            );
                        if (result != null) {
                          setState(() {
                            country = result['country'] ?? country;
                            city = result['city'] ?? city;
                          });
                          await _saveString(_keyCountry, country);
                          await _saveString(_keyCity, city);
                        }
                      },
                      child: Column(
                        children: [
                          buildProfileInputField(
                            imagePath: 'assets/images/country.png',
                            label: AppLocalizations.of(context)!.country,
                            value: country,
                            isEmpty: false,
                          ),
                          SizedBox(height: 12.h),
                          buildProfileInputField(
                            imagePath: 'assets/images/city.png',
                            label: AppLocalizations.of(context)!.city,
                            value: city,
                            isEmpty: city.isEmpty,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Address Section
                    Text(
                      AppLocalizations.of(context)!.address,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    if (address.isEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.vibrantPurple,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: CustomPaint(
                            painter: DashedBorderPainter(
                              color: Colors.white.withOpacity(0.5),
                              strokeWidth: 1.5,
                              dashWidth: 6,
                              dashSpace: 4,
                              radius: 12.r,
                            ),
                            child: TextButton(
                              onPressed: () async {
                                final updatedAddress = await Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddressView(initialAddress: address),
                                  ),
                                );

                                if (updatedAddress != null && updatedAddress.isNotEmpty) {
                                  setState(() {
                                    address = updatedAddress;
                                  });
                                  await _saveString(_keyAddress, updatedAddress);
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.addAddress,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () async {
                          final updatedAddress = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressView(initialAddress: address),
                            ),
                          );

                          if (updatedAddress != null && updatedAddress.isNotEmpty) {
                            setState(() {
                              address = updatedAddress;
                            });
                            await _saveString(_keyAddress, updatedAddress);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).colorScheme.surfaceContainerHighest
                                : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Icon(
                                Icons.edit_outlined, // or Icons.edit, Icons.mode_edit_outline
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 22.sp,
                              ),
                            ],
                          ),
                        ),
                      ),



                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileInputField({
    IconData? icon,
    String? imagePath,
    required String label,
    required String value,
    required bool isEmpty,
  }) {
    return Container(
      height: 64.h,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surfaceContainerHighest : const Color(0xFFF4F7F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: imagePath != null
                ? Image.asset(
                    imagePath,
                    width: 24.sp,
                    height: 24.sp,
                    color: AppColors.vibrantPurple,
                  )
                : Icon(icon, color: AppColors.vibrantPurple, size: 24.sp),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 9.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isEmpty ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    isEmpty ? AppLocalizations.of(context)!.labelAdd : value,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: isEmpty
                          ? AppColors.vibrantPurple
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSection({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        RoundButton(
          title: AppLocalizations.of(context)!.getPremium,
          isSelected: true,
          height: 50.h,
          backgroundColors: AppColors.vibrantPurple,
          textColors: Colors.white,
          onPress: () => Navigator.pushNamed(context, RoutesName.pro),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 22.w),
          child: Text(
            description,
            style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.radius = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth),
        Radius.circular(radius),
      ));

    final Path dashedPath = _createDashedPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, double dashWidth, double dashSpace) {
    final Path path = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        path.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.radius != radius;
  }
}

// import 'dart:io';
//
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../config/components/NameView.dart';
// import '../../config/components/emailview.dart';
// import '../../config/components/gender_view.dart';
// import '../../config/components/locationView.dart';
// import '../../config/components/phoneview.dart';
// import '../../utils/routes/routes_name.dart';
//
// class Ownerprofileview extends StatefulWidget {
//   const Ownerprofileview({super.key});
//
//   @override
//   State<Ownerprofileview> createState() => _OwnerprofileviewState();
// }
//
// class _OwnerprofileviewState extends State<Ownerprofileview> {
//   // Profile data
//   String firstName = 'Tehseen Khan';
//   String lastName = '';
//   String gender = '';
//   String email = 'tehseenkhan@gmail.com';
//   String phone = '';
//   String country = 'Pakistan';
//   String city = '';
//   String address = '';
//
//   // Controllers
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _genderController;
//   late TextEditingController _phoneController;
//   late TextEditingController _cityController;
//   late TextEditingController _addressController;
//
//   @override
//   void initState() {
//     super.initState();
//     _firstNameController = TextEditingController(text: firstName);
//     _lastNameController = TextEditingController(text: lastName);
//     _genderController = TextEditingController(text: gender);
//     _phoneController = TextEditingController(text: phone);
//     _cityController = TextEditingController(text: city);
//     _addressController = TextEditingController(text: address);
//     _loadSavedProfileImage();
//   }
//
//   Future<void> _loadSavedProfileImage() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedPath = prefs.getString(_profileImageKey);
//
//     if (savedPath != null && File(savedPath).existsSync()) {
//       setState(() {
//         _profileImageFile = File(savedPath);
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _genderController.dispose();
//     _phoneController.dispose();
//     _cityController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }
//
//   String profileImageUrl =
//       ''; // Now starts empty (will store local path or URL)
//   File? _profileImageFile; // For local picked image
//   final ImagePicker _picker = ImagePicker();
//   static const String _profileImageKey = 'profile_image_path';
//
//   Future<void> _showEditDialog({
//     required String title,
//     required TextEditingController controller,
//     required VoidCallback onSave,
//   }) async {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Edit $title'),
//         content: TextField(
//           controller: controller,
//           decoration: InputDecoration(hintText: 'Enter $title'),
//           textCapitalization: TextCapitalization.words,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               onSave();
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF7C3AED),
//             ),
//             child: const Text('Save', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _pickProfileImage() async {
//     final ImageSource? source = await showModalBottomSheet<ImageSource>(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(24.w),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Choose Profile Photo',
//                 style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 30.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildPickerOption(
//                     icon: Icons.camera_alt,
//                     label: 'Camera',
//                     onTap: () => Navigator.pop(context, ImageSource.camera),
//                   ),
//                   SizedBox(width: 60.w),
//                   _buildPickerOption(
//                     icon: Icons.photo_library,
//                     label: 'Gallery',
//                     onTap: () => Navigator.pop(context, ImageSource.gallery),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20.h),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('Cancel', style: TextStyle(fontSize: 16.sp)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     if (source == null) return;
//
//     final XFile? pickedImage = await _picker.pickImage(
//       source: source,
//       imageQuality: 85,
//       maxWidth: 800,
//     );
//
//     if (pickedImage != null) {
//       setState(() {
//         _profileImageFile = File(pickedImage.path);
//       });
//       // Save the path permanently
//       await _saveProfileImagePath(pickedImage.path);
//     }
//   }
//
//   Future<void> _saveProfileImagePath(String path) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_profileImageKey, path);
//   }
//
//   // Remove saved image (optional - for "Remove Photo" feature later)
//   Future<void> _removeProfileImage() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_profileImageKey);
//   }
//
//   Widget _buildPickerOption({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(20.w),
//             decoration: BoxDecoration(
//               color: const Color(0xFF7C3AED).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, size: 40.sp, color: const Color(0xFF7C3AED)),
//           ),
//           SizedBox(height: 12.h),
//           Text(
//             label,
//             style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 5.h),
//               Container(
//                 height: 223.h,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(
//                     color: const Color(0xFFB9B9B9),
//                     width: 1.0,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 4.0,
//                       spreadRadius: 1.0,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16.w),
//                       height: 60.h,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(
//                               Icons.arrow_back_ios,
//                               color: Colors.black,
//                               size: 20,
//                             ),
//                             onPressed: () => Navigator.pop(context),
//                           ),
//                           const Expanded(
//                             child: Center(
//                               child: Text(
//                                 "Owner's Profile",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 48.w), // Balance the row
//                         ],
//                       ),
//                     ),
//
//                     SizedBox(height: 20.h),
//
//                     // Profile Image Stack
//                     Center(
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           CircleAvatar(
//                             radius: 50.r,
//                             backgroundColor: Colors.grey.shade200,
//                             backgroundImage: _profileImageFile != null
//                                 ? FileImage(_profileImageFile!)
//                                 : null,
//                             child: _profileImageFile == null
//                                 ? Icon(
//                               Icons.person,
//                               size: 60.r,
//                               color: Colors.grey[400],
//                             )
//                                 : null,
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             right: 100.w - 50.r, // Position relative to center
//                             child: GestureDetector(
//                               onTap: _pickProfileImage,
//                               child: Container(
//                                 padding: EdgeInsets.all(8.w),
//                                 decoration: const BoxDecoration(
//                                   color: Color(0xFF7C3AED),
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black26,
//                                       blurRadius: 6,
//                                       offset: Offset(0, 3),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Icon(
//                                   Icons.camera_alt,
//                                   color: Colors.white,
//                                   size: 20.sp,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               const Center(
//                 child: Text(
//                   'Pet Owner',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 32.h),
//
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         final updatedName = await Navigator.push<String>(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => NameView(initialName: firstName),
//                           ),
//                         );
//
//                         if (updatedName != null && updatedName.isNotEmpty) {
//                           setState(() {
//                             firstName = updatedName;
//                           });
//                         }
//                       },
//                       child: buildProfileInputField(
//                         icon: Icons.person_outline,
//                         label: 'Name',
//                         value: firstName,
//                         isEmpty: firstName.isEmpty,
//                       ),
//                     ),
//
//                     GestureDetector(
//                       onTap: () async {
//                         final updatedName = await Navigator.push<String>(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => NameView(initialName: lastName),
//                           ),
//                         );
//
//                         if (updatedName != null && updatedName.isNotEmpty) {
//                           setState(() {
//                             lastName = updatedName;
//                           });
//                         }
//                       },
//                       child: buildProfileInputField(
//                         icon: Icons.person_outline,
//                         label: 'LastName',
//                         value: lastName,
//                         isEmpty: lastName.isEmpty,
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//                     GestureDetector(
//                       onTap: () async {
//                         final selectedGender = await showModalBottomSheet<String>(
//                           context: context,
//                           backgroundColor: Colors.transparent,
//                           isScrollControlled: true,
//                           builder: (context) => GenderView(currentGender: gender),
//                         );
//
//                         if (selectedGender != null && selectedGender != gender) {
//                           setState(() {
//                             gender = selectedGender;
//                           });
//                         }
//                       },
//                       child: buildProfileInputField(
//                         icon: Icons.wc_outlined,
//                         label: 'Gender',
//                         value: gender,
//                         isEmpty: gender.isEmpty,
//                       ),
//                     ),
//                     // buildProfileInputField(
//                     //   icon: Icons.wc_outlined,
//                     //   label: 'Gender',
//                     //   value: gender,
//                     //   isEmpty: gender.isEmpty,
//                     // ),
//                     SizedBox(height: 32.h),
//
//                     // Owner Contacts Section
//                     const Text(
//                       'Owner Contacts',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//                     GestureDetector(
//                       onTap: () async {
//                         final updatedEmail = await Navigator.push<String>(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => EmailView(initialEmail: email),
//                           ),
//                         );
//
//                         if (updatedEmail != null && updatedEmail.isNotEmpty) {
//                           setState(() {
//                             email = updatedEmail;
//                           });
//                         }
//                       },
//                       child: buildProfileInputField(
//                         icon: Icons.email_outlined,
//                         label: 'Email',
//                         value: email,
//                         isEmpty: email.isEmpty,
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//                     GestureDetector(
//                       onTap: () async {
//                         final updatedPhone = await Navigator.push<String>(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PhoneView(initialPhone: phone),
//                           ),
//                         );
//
//                         if (updatedPhone != null && updatedPhone.isNotEmpty) {
//                           setState(() {
//                             phone = updatedPhone;
//                           });
//                         }
//                       },
//                       child: buildProfileInputField(
//                         icon: Icons.phone_outlined,
//                         label: 'Main Phone',
//                         value: phone,
//                         isEmpty: phone.isEmpty,
//                       ),
//                     ),
//                     SizedBox(height: 30.h),
//
//                     // Premium Sections
//                     _buildPremiumSection(
//                       title: 'Instant Gps Alerts Upon Tag Scan',
//                       description:
//                       'Get instant pet location updates, avoiding the \n hassle, avoiding the hassle of traditional emails',
//                     ),
//                     SizedBox(height: 22.h),
//                     _buildPremiumSection(
//                       title: 'Emergency Contacts',
//                       description:
//                       'Contacts of the vet, co-owner, and caretaker in \n case  the main phone isn’t available',
//                     ),
//                     SizedBox(height: 22.h),
//                     _buildPremiumSection(
//                       title: 'Messenger',
//                       description:
//                       'An alternative way to cotact the owner if it is \nimpossible to call them ',
//                     ),
//                     SizedBox(height: 30.h),
//                     const Text(
//                       'Pets Place of Residence',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//
//                     GestureDetector(
//                       onTap: () async {
//                         final result = await Navigator.push<Map<String, String>>(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => LocationView(
//                               initialCountry: country,
//                               initialCity: city,
//                             ),
//                           ),
//                         );
//
//                         if (result != null) {
//                           setState(() {
//                             country = result['country'] ?? country;
//                             city = result['city'] ?? city;
//                           });
//                         }
//                       },
//                       child: Column(
//                         children: [
//                           buildProfileInputField(
//                             icon: Icons.public,
//                             label: 'Country',
//                             value: country,
//                             isEmpty: false,
//                           ),
//                           SizedBox(height: 12.h),
//                           buildProfileInputField(
//                             icon: Icons.location_city_outlined,
//                             label: 'City',
//                             value: city,
//                             isEmpty: city.isEmpty,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 32.h),
//
//                     // Address Add Button
//                     const Text(
//                       'Address',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () => _showEditDialog(
//                           title: 'Address',
//                           controller: _addressController,
//                           onSave: () => setState(
//                                 () => address = _addressController.text.trim(),
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF7C3AED),
//                           padding: EdgeInsets.symmetric(vertical: 16.h),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.r),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: Text(
//                           address.isEmpty ? 'Add' : 'Edit Address',
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Reusable Profile Field
//   Widget buildProfileInputField({
//     required IconData icon,
//     required String label,
//     required String value,
//     required bool isEmpty,
//   }) {
//     return Container(
//       height: 64.h,
//       margin: EdgeInsets.symmetric(vertical: 4.h),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF4F7F6),
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Icon(icon, color: const Color(0xFF7C3AED), size: 24.sp),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     label,
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       color: isEmpty
//                           ? const Color(0xFFFF1500)
//                           : const Color(0xFF000000),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     isEmpty ? 'Add' : value,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       color: isEmpty
//                           ? const Color(0xFF9838FF)
//                           : const Color(0xFF676767),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Premium Section
//   Widget _buildPremiumSection({
//     required String title,
//     required String description,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Center(
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF371B34),
//             ),
//           ),
//         ),
//         SizedBox(height: 12.h),
//         RoundButton(
//           title: "GET PREMIUM",
//           isSelected: true,
//           height: 50.h,
//           backgroundColors: AppColors.vibrantPurple,
//           textColors: Colors.white,
//           onPress: () {
//             Navigator.pushNamed(context, RoutesName.pro);
//           },
//         ),
//         SizedBox(height: 10.h),
//         Padding(
//           padding:  EdgeInsets.symmetric(vertical: 10.h,horizontal: 22.w),
//           child: Text(
//             description,
//             style: TextStyle(fontSize: 16.sp, color: Color(0xFF877084)),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
//
//
//
//
// // import 'dart:io';
// //
// // import 'package:dog_breed/Valid/AppColors.dart';
// // import 'package:dog_breed/config/components/roundButton.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import '../../config/components/NameView.dart';
// // import '../../utils/routes/routes_name.dart';
// //
// // class Ownerprofileview extends StatefulWidget {
// //   const Ownerprofileview({super.key});
// //
// //   @override
// //   State<Ownerprofileview> createState() => _OwnerprofileviewState();
// // }
// //
// // class _OwnerprofileviewState extends State<Ownerprofileview> {
// //   // Profile data
// //   String firstName = 'Tehseen Khan';
// //   String lastName = '';
// //   String gender = '';
// //   String email = 'tehseenkhan@gmail.com';
// //   String phone = '';
// //   String country = 'Pakistan';
// //   String city = '';
// //   String address = '';
// //
// //   // Controllers
// //   late TextEditingController _firstNameController;
// //   late TextEditingController _lastNameController;
// //   late TextEditingController _genderController;
// //   late TextEditingController _phoneController;
// //   late TextEditingController _cityController;
// //   late TextEditingController _addressController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _firstNameController = TextEditingController(text: firstName);
// //     _lastNameController = TextEditingController(text: lastName);
// //     _genderController = TextEditingController(text: gender);
// //     _phoneController = TextEditingController(text: phone);
// //     _cityController = TextEditingController(text: city);
// //     _addressController = TextEditingController(text: address);
// //     _loadSavedProfileImage();
// //   }
// //
// //   Future<void> _loadSavedProfileImage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final savedPath = prefs.getString(_profileImageKey);
// //
// //     if (savedPath != null && File(savedPath).existsSync()) {
// //       setState(() {
// //         _profileImageFile = File(savedPath);
// //       });
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     _firstNameController.dispose();
// //     _lastNameController.dispose();
// //     _genderController.dispose();
// //     _phoneController.dispose();
// //     _cityController.dispose();
// //     _addressController.dispose();
// //     super.dispose();
// //   }
// //
// //   String profileImageUrl =
// //       ''; // Now starts empty (will store local path or URL)
// //   File? _profileImageFile; // For local picked image
// //   final ImagePicker _picker = ImagePicker();
// //   static const String _profileImageKey = 'profile_image_path';
// //
// //   Future<void> _showEditDialog({
// //     required String title,
// //     required TextEditingController controller,
// //     required VoidCallback onSave,
// //   }) async {
// //     return showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text('Edit $title'),
// //         content: TextField(
// //           controller: controller,
// //           decoration: InputDecoration(hintText: 'Enter $title'),
// //           textCapitalization: TextCapitalization.words,
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Cancel'),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               onSave();
// //               Navigator.pop(context);
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: const Color(0xFF7C3AED),
// //             ),
// //             child: const Text('Save', style: TextStyle(color: Colors.white)),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Future<void> _pickProfileImage() async {
// //     final ImageSource? source = await showModalBottomSheet<ImageSource>(
// //       context: context,
// //       backgroundColor: Colors.transparent,
// //       builder: (context) => Container(
// //         decoration: const BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //         ),
// //         child: Padding(
// //           padding: EdgeInsets.all(24.w),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text(
// //                 'Choose Profile Photo',
// //                 style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
// //               ),
// //               SizedBox(height: 30.h),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   _buildPickerOption(
// //                     icon: Icons.camera_alt,
// //                     label: 'Camera',
// //                     onTap: () => Navigator.pop(context, ImageSource.camera),
// //                   ),
// //                   SizedBox(width: 60.w),
// //                   _buildPickerOption(
// //                     icon: Icons.photo_library,
// //                     label: 'Gallery',
// //                     onTap: () => Navigator.pop(context, ImageSource.gallery),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 20.h),
// //               TextButton(
// //                 onPressed: () => Navigator.pop(context),
// //                 child: Text('Cancel', style: TextStyle(fontSize: 16.sp)),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //
// //     if (source == null) return;
// //
// //     final XFile? pickedImage = await _picker.pickImage(
// //       source: source,
// //       imageQuality: 85,
// //       maxWidth: 800,
// //     );
// //
// //     if (pickedImage != null) {
// //       setState(() {
// //         _profileImageFile = File(pickedImage.path);
// //       });
// //       // Save the path permanently
// //       await _saveProfileImagePath(pickedImage.path);
// //     }
// //   }
// //
// //   Future<void> _saveProfileImagePath(String path) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString(_profileImageKey, path);
// //   }
// //
// //   // Remove saved image (optional - for "Remove Photo" feature later)
// //   Future<void> _removeProfileImage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.remove(_profileImageKey);
// //   }
// //
// //   Widget _buildPickerOption({
// //     required IconData icon,
// //     required String label,
// //     required VoidCallback onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Column(
// //         children: [
// //           Container(
// //             padding: EdgeInsets.all(20.w),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF7C3AED).withOpacity(0.1),
// //               shape: BoxShape.circle,
// //             ),
// //             child: Icon(icon, size: 40.sp, color: const Color(0xFF7C3AED)),
// //           ),
// //           SizedBox(height: 12.h),
// //           Text(
// //             label,
// //             style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               SizedBox(height: 5.h),
// //               Container(
// //                 height: 223.h,
// //                 width: double.infinity,
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   border: Border.all(
// //                     color: const Color(0xFFB9B9B9),
// //                     width: 1.0,
// //                   ),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withOpacity(0.1),
// //                       blurRadius: 4.0,
// //                       spreadRadius: 1.0,
// //                       offset: const Offset(0, 2),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Column(
// //                   children: [
// //                     Container(
// //                       padding: EdgeInsets.symmetric(horizontal: 16.w),
// //                       height: 60.h,
// //                       child: Row(
// //                         children: [
// //                           IconButton(
// //                             icon: const Icon(
// //                               Icons.arrow_back_ios,
// //                               color: Colors.black,
// //                               size: 20,
// //                             ),
// //                             onPressed: () => Navigator.pop(context),
// //                           ),
// //                           Expanded(
// //                             child: Center(
// //                               child: const Text(
// //                                 "Owner's Profile",
// //                                 style: TextStyle(
// //                                   color: Colors.black,
// //                                   fontSize: 18,
// //                                   fontWeight: FontWeight.w600,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                           SizedBox(width: 48.w), // Balance the row
// //                         ],
// //                       ),
// //                     ),
// //
// //                     SizedBox(height: 20.h),
// //
// //                     // Profile Image Stack
// //                     Center(
// //                       child: Stack(
// //                         alignment: Alignment.center,
// //                         children: [
// //                           CircleAvatar(
// //                             radius: 50.r,
// //                             backgroundColor: Colors.grey.shade200,
// //                             backgroundImage: _profileImageFile != null
// //                                 ? FileImage(_profileImageFile!)
// //                                 : null,
// //                             child: _profileImageFile == null
// //                                 ? Icon(
// //                                     Icons.person,
// //                                     size: 60.r,
// //                                     color: Colors.grey[400],
// //                                   )
// //                                 : null,
// //                           ),
// //                           Positioned(
// //                             bottom: 0,
// //                             right: 100.w - 50.r, // Position relative to center
// //                             child: GestureDetector(
// //                               onTap: _pickProfileImage,
// //                               child: Container(
// //                                 padding: EdgeInsets.all(8.w),
// //                                 decoration: const BoxDecoration(
// //                                   color: Color(0xFF7C3AED),
// //                                   shape: BoxShape.circle,
// //                                   boxShadow: [
// //                                     BoxShadow(
// //                                       color: Colors.black26,
// //                                       blurRadius: 6,
// //                                       offset: Offset(0, 3),
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 child: Icon(
// //                                   Icons.camera_alt,
// //                                   color: Colors.white,
// //                                   size: 20.sp,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 16.h),
// //               const Center(
// //                 child: Text(
// //                   'Pet Owner',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.black87,
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 32.h),
// //
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 16.w),
// //                 child: Column(
// //                   children: [
// //                     GestureDetector(
// //                       onTap: () async {
// //                         final result = await Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => NameView(initialName: firstName),
// //                           ),
// //                         );
// //                         if (result != null && result is String) {
// //                           setState(() {
// //                             firstName = result.trim();
// //                           });
// //                         }
// //                       },
// //                       child: buildProfileInputField(
// //                         icon: Icons.person_outline,
// //                         label: 'Name',
// //                         value: firstName,
// //                         isEmpty: firstName.isEmpty,
// //                       ),
// //                     ),
// //                     buildProfileInputField(
// //                       icon: Icons.person_outline,
// //                       label: 'Name',
// //                       value: firstName,
// //                       isEmpty: firstName.isEmpty,
// //
// //                     ),
// //                     SizedBox(height: 12.h),
// //                     buildProfileInputField(
// //                       icon: Icons.person_outline,
// //                       label: 'Last Name',
// //                       value: lastName,
// //                       isEmpty: lastName.isEmpty,
// //
// //                     ),
// //                     SizedBox(height: 12.h),
// //                     buildProfileInputField(
// //                       icon: Icons.wc_outlined,
// //                       label: 'Gender',
// //                       value: gender,
// //                       isEmpty: gender.isEmpty,
// //
// //                     ),
// //                     SizedBox(height: 32.h),
// //
// //                     // Owner Contacts Section
// //                     const Text(
// //                       'Owner Contacts',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.black87,
// //                       ),
// //                     ),
// //                     SizedBox(height: 16.h),
// //
// //                     buildProfileInputField(
// //                       icon: Icons.email_outlined,
// //                       label: 'Email',
// //                       value: email,
// //                       isEmpty: false,
// //                     ),
// //                     SizedBox(height: 12.h),
// //                     buildProfileInputField(
// //                       icon: Icons.phone_outlined,
// //                       label: 'Main Phone',
// //                       value: phone,
// //                       isEmpty: phone.isEmpty,
// //
// //                     ),
// //                     SizedBox(height: 30.h),
// //
// //                     // Premium Sections
// //                     _buildPremiumSection(
// //                       title: 'Instant Gps Alerts Upon Tag Scan',
// //                       description:
// //                           'Get instant pet location updates, avoiding the \n hassle, avoiding the hassle of traditional emails',
// //                     ),
// //                     SizedBox(height: 22.h),
// //                     _buildPremiumSection(
// //                       title: 'Emergency Contacts',
// //                       description:
// //                           'Contacts of the vet, co-owner, and caretaker in \n case  the main phone isn’t available',
// //                     ),
// //                     SizedBox(height: 22.h),
// //                     _buildPremiumSection(
// //                       title: 'Messenger',
// //                       description:
// //                           'An alternative way to cotact the owner if it is \nimpossible to call them ',
// //                     ),
// //                     SizedBox(height: 30.h),
// //                     const Text(
// //                       'Pets Place of Residence',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.black87,
// //                       ),
// //                     ),
// //                     SizedBox(height: 16.h),
// //
// //                     buildProfileInputField(
// //                       icon: Icons.public,
// //                       label: 'Country',
// //                       value: country,
// //                       isEmpty: false,
// //
// //                     ),
// //                     SizedBox(height: 12.h),
// //                     buildProfileInputField(
// //                       icon: Icons.location_city_outlined,
// //                       label: 'City',
// //                       value: city,
// //                       isEmpty: city.isEmpty,
// //
// //                     ),
// //                     SizedBox(height: 32.h),
// //
// //                     // Address Add Button
// //                     const Text(
// //                       'Address',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.black87,
// //                       ),
// //                     ),
// //                     SizedBox(height: 12.h),
// //                     SizedBox(
// //                       width: double.infinity,
// //                       child: ElevatedButton(
// //                         onPressed: () => _showEditDialog(
// //                           title: 'Address',
// //                           controller: _addressController,
// //                           onSave: () => setState(
// //                             () => address = _addressController.text.trim(),
// //                           ),
// //                         ),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: const Color(0xFF7C3AED),
// //                           padding: EdgeInsets.symmetric(vertical: 16.h),
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(12.r),
// //                           ),
// //                           elevation: 0,
// //                         ),
// //                         child: Text(
// //                           address.isEmpty ? 'Add' : 'Edit Address',
// //                           style: TextStyle(
// //                             fontSize: 16.sp,
// //                             fontWeight: FontWeight.w600,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // Reusable Profile Field
// //   Widget buildProfileInputField({
// //     required IconData icon,
// //     required String label,
// //     required String value,
// //     required bool isEmpty,
// //   }) {
// //     return Container(
// //       height: 64.h,
// //       margin: EdgeInsets.symmetric(vertical: 4.h),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFF4F7F6),
// //         borderRadius: BorderRadius.circular(12.r),
// //       ),
// //       child: Row(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Icon(icon, color: const Color(0xFF7C3AED), size: 24.sp),
// //           ),
// //           Expanded(
// //             child: Padding(
// //               padding: EdgeInsets.symmetric(horizontal: 16.w),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(
// //                     label,
// //                     style: TextStyle(
// //                       fontSize: 18.sp,
// //                       color: isEmpty
// //                           ? const Color(0xFFFF1500)
// //                           : const Color(0xFF000000),
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   Text(
// //                     isEmpty ? 'Add' : value,
// //                     style: TextStyle(
// //                       fontSize: 16.sp,
// //                       color: isEmpty
// //                           ? const Color(0xFF9838FF)
// //                           : const Color(0xFF676767),
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // Premium Section
// //   Widget _buildPremiumSection({
// //     required String title,
// //     required String description,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Center(
// //           child: Text(
// //             title,
// //             style: const TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: Color(0xFF371B34),
// //             ),
// //           ),
// //         ),
// //         SizedBox(height: 12.h),
// //         RoundButton(
// //           title: "GET PREMIUM",
// //           isSelected: true,
// //           height: 50.h,
// //           backgroundColors: AppColors.vibrantPurple,
// //           textColors: Colors.white,
// //           onPress: () {
// //             Navigator.pushNamed(context, RoutesName.pro);
// //           },
// //         ),
// //         SizedBox(height: 10.h),
// //         Padding(
// //           padding:  EdgeInsets.symmetric(vertical: 10.h,horizontal: 22.w),
// //           child: Text(
// //             description,
// //             style: TextStyle(fontSize: 16.sp, color: Color(0xFF877084)),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
