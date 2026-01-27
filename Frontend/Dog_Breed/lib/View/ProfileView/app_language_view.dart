import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../View_model/locale_notifier.dart';
import 'package:dog_breed/l10n/app_localizations.dart';

class AppLanguageView extends StatefulWidget {
  const AppLanguageView({super.key});

  @override
  State<AppLanguageView> createState() => _AppLanguageViewState();
}

class _AppLanguageViewState extends State<AppLanguageView> {
  final List<String> _regions = const [
    'English',
    'Deutsch',
    'Espanol',
  ];

  final Map<String, Locale> _languages = const {
    'English': Locale('en'),
    'Deutsch': Locale('de'),
    'Espanol': Locale('es'),
    'Francias': Locale('fr'),
    'Indonesia': Locale('id'),
    'Italiano': Locale('it'),
    'Nederlands': Locale('nl'),
    'Portugues': Locale('pt'),
    'Turkish': Locale('tr'),
    'Greek': Locale('el'),
    'Sweedish': Locale('sv'),
    'Danish': Locale('da'),
    'Czech': Locale('cs'),
    'Polish': Locale('pl'),
    'Finnish': Locale('fi'),
  };

  String _selectedRegion = 'English';
  String? _selectedLanguageCode;

  @override
  Widget build(BuildContext context) {
    final localeNotifier = context.watch<LocaleNotifier>();
    final currentCode = _selectedLanguageCode ?? localeNotifier.locale.languageCode;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 41.w,
                    height: 41.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF686868).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.appLanguageTitle,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 41.w),
                ],
              ),
              // SizedBox(height: 20.h),
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.symmetric(horizontal: 16.w),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12.r),
              //   ),
              //   child: DropdownButtonHideUnderline(
              //     child: DropdownButton<String>(
              //       value: _selectedRegion,
              //       items: _regions
              //           .map(
              //             (region) => DropdownMenuItem(
              //               value: region,
              //               child: Text(
              //                 region,
              //                 style: TextStyle(
              //                   fontSize: 16.sp,
              //                   fontWeight: FontWeight.w500,
              //                 ),
              //               ),
              //             ),
              //           )
              //           .toList(),
              //       onChanged: (value) {
              //         if (value == null) return;
              //         setState(() {
              //           _selectedRegion = value;
              //         });
              //       },
              //       icon: const Icon(Icons.keyboard_arrow_down_rounded),
              //     ),
              //   ),
              // ),
              SizedBox(height: 33.h),
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    thickness: 0.4,
                    indent: 0,
                    endIndent: 0,
                    color: Color(0xFFD5D5D5),
                  ),
                  itemBuilder: (context, index) {
                    final entry = _languages.entries.elementAt(index);
                    final name = entry.key;
                    final locale = entry.value;
                    final isSelected = currentCode == locale.languageCode;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLanguageCode = locale.languageCode;
                        });
                        localeNotifier.setLocale(locale);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF8A2BE2),
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 10.w,
                                        height: 10.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF8A2BE2),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

