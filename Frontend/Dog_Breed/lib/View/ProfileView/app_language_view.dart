import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dog_breed/Valid/AppColors.dart';

import '../../View_model/locale_notifier.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import '../../config/components/CommonApp.dart';

class AppLanguageView extends StatefulWidget {
  const AppLanguageView({super.key});

  @override
  State<AppLanguageView> createState() => _AppLanguageViewState();
}

class _AppLanguageViewState extends State<AppLanguageView> {

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

  String? _selectedLanguageCode;

  @override
  Widget build(BuildContext context) {
    final localeNotifier = context.watch<LocaleNotifier>();
    final currentCode = _selectedLanguageCode ?? localeNotifier.locale.languageCode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40.305.w,
                      height: 40.305.h,
                      padding: const EdgeInsets.all(8.96),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8.96),
                      ),
                      child: Icon(
                        CupertinoIcons.chevron_left,
                        size: 20.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),

                  // Center text
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.appLanguageTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w300,
                        fontSize: 29.75.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Invisible placeholder to balance
                  SizedBox(
                    width: 40.305.w,
                    height: 40.305.h,
                  ),
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
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    thickness: 0.4,
                    indent: 0,
                    endIndent: 0,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.vibrantPurple,
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
                                          color: AppColors.vibrantPurple,
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

