import 'package:camera/camera.dart';
import 'package:dog_breed/View_model/ScanProvider.dart';
import 'package:dog_breed/View_model/home/home_view_model.dart';
import 'package:dog_breed/utils/routes/routes.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:edge_to_edge/edge_to_edge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Valid/AppTheme.dart';
import 'View_model/DocumentViewModel.dart';
import 'View_model/PetProvider.dart';
import 'View_model/ProfileProvider.dart';
import 'View_model/ReminderNotifier.dart';
import 'View_model/ThemeNotifier.dart';
import 'View_model/locale_notifier.dart';
import 'View_model/activity_provider.dart';
import 'View_model/dogvaluesviewmodel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'dart:io';
import 'package:video_player_win/video_player_win_plugin.dart';

List<CameraDescription> cameras = [];
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && Platform.isWindows) {
    WindowsVideoPlayer.registerWith();
  }

  // Timezone init
  tzdata.initializeTimeZones();

  // Filter noisy logs
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null && !message.contains('component name')) {
      print(message);
    }
  };

  // Notifications init
  const AndroidInitializationSettings androidInit =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    defaultPresentAlert: true,
    defaultPresentBadge: true,
    defaultPresentSound: true,
  );

  const LinuxInitializationSettings linuxInit =
  LinuxInitializationSettings(defaultActionName: 'Open');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
    iOS: iosInit,
    linux: linuxInit,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.requestExactAlarmsPermission();

  const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
    'dog_breed_reminders_v2',
    'High Importance Notifications',
    description: 'Dog Breed app notifications with sound and alert',
    importance: Importance.high,
    playSound: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(defaultChannel);

  // Camera init
  try {
    cameras = await availableCameras();
  } catch (e) {
    if (kDebugMode) {
      print("Camera init error: $e");
    }
    cameras = [];
  }

  await SharedPreferences.getInstance();

  final scanProvider = ScanProvider();
  await scanProvider.initialize();

  // Edge-to-edge UI
  EdgeToEdge.configure(
    statusBarColor: Colors.transparent,
    navigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    navigationBarIconBrightness: Brightness.dark,
    enableTop: true,
    enableBottom: true,
  );

  runApp(
    ChangeNotifierProvider.value(
      value: scanProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => LocaleNotifier()),
        ChangeNotifierProvider(create: (_) => DogValuesViewModel()),
        ChangeNotifierProvider(create: (_) => ActivityNotifier()),
        ChangeNotifierProvider<PetProvider>(
          create: (_) => PetProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => ReminderNotifier()),
        ChangeNotifierProvider(create: (_) => DocumentViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(440, 956),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer2<ThemeNotifier, LocaleNotifier>(
            builder: (context, themeProvider, localeNotifier, _) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: MediaQuery.of(context)
                      .textScaleFactor
                      .clamp(1.0, 1.5),
                ),
                child: MaterialApp(
                  title: 'Dog Breed',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeProvider.themeMode,
                  locale: localeNotifier.locale,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  initialRoute: RoutesName.splash,
                  onGenerateRoute: Routes.generateRoute,
                ),
              );
            },
          );
        },
      ),
    );
  }
}



// import 'package:camera/camera.dart';
// import 'package:dog_breed/View_model/ScanProvider.dart';
// import 'package:dog_breed/View_model/home/home_view_model.dart';
// import 'package:dog_breed/utils/routes/routes.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:edge_to_edge/edge_to_edge.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:dog_breed/l10n/app_localizations.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'Valid/AppTheme.dart';
// import 'View_model/DocumentViewModel.dart';
// import 'View_model/PetProvider.dart';
// import 'View_model/ProfileProvider.dart';
// import 'View_model/ReminderNotifier.dart';
// import 'View_model/ThemeNotifier.dart';
// import 'View_model/locale_notifier.dart';
// import 'View_model/activity_provider.dart';
// import 'View_model/dogvaluesviewmodel.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tzdata;
//
// List<CameraDescription> cameras = [];
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Initialize timezone database for zoned scheduling
//   tzdata.initializeTimeZones();
//   debugPrint = (String? message, {int? wrapWidth}) {
//     if (message != null && !message.contains('component name')) {
//       print(message);
//     }
//   };
//   // Initialize local notifications and channel 'pCKgw'
//   const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//   const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
//     requestAlertPermission: true,
//     requestBadgePermission: true,
//     requestSoundPermission: true,
//     defaultPresentAlert: true,
//     defaultPresentBadge: true,
//     defaultPresentSound: true,
//   );
//   const LinuxInitializationSettings linuxInit = LinuxInitializationSettings(defaultActionName: 'Open');
//   const InitializationSettings initSettings = InitializationSettings(
//     android: androidInit,
//     iOS: iosInit,
//     linux: linuxInit,
//   );
//   await flutterLocalNotificationsPlugin.initialize(initSettings);
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.requestNotificationsPermission();
//   const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
//     'dog_breed_reminders_v2',
//     'High Importance Notifications',
//     description: 'Dog Breed app notifications with sound and alert',
//     importance: Importance.high,
//     playSound: true,
//   );
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(defaultChannel);
//
//   try {
//     cameras = await availableCameras();
//   } catch (e) {
//     if (kDebugMode) {
//       print("Error initializing cameras: $e");
//     }
//     cameras = [];
//   }
//   await SharedPreferences.getInstance();
//   final scanProvider = ScanProvider();
//   await scanProvider.initialize();
//   EdgeToEdge.configure(
//     statusBarColor: Colors.transparent,
//     navigationBarColor: Colors.transparent,
//     statusBarIconBrightness: Brightness.dark,
//     navigationBarIconBrightness: Brightness.dark,
//     enableTop: true,
//     enableBottom: true,
//   );
//   runApp(
//     ChangeNotifierProvider.value(
//       value: scanProvider,
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => HomeViewModel()),
//         ChangeNotifierProvider(create: (_) => ThemeNotifier()),
//         ChangeNotifierProvider(create: (_) => LocaleNotifier()),
//         ChangeNotifierProvider(create: (_) => DogValuesViewModel()),
//         ChangeNotifierProvider(create: (_) => ActivityNotifier()),
//         ChangeNotifierProvider<PetProvider>(
//           create: (_) => PetProvider(),
//           lazy: false,
//         ),
//         ChangeNotifierProvider(create: (_) => ReminderNotifier()),
//         ChangeNotifierProvider(create: (_) => DocumentViewModel()),
//         ChangeNotifierProvider(create: (_) => ProfileProvider()),
//       ],
//       child: ScreenUtilInit(
//         designSize:  Size(440.w, 956.h),
//         minTextAdapt: true,
//         splitScreenMode: true,
//         builder: (context, child) {
//           return Consumer2<ThemeNotifier, LocaleNotifier>(
//             builder: (context, themeProvider, localeNotifier, child) {
//               return MaterialApp(
//                 title: 'Dog Breed',
//                 debugShowCheckedModeBanner: false,
//                 theme: AppTheme.lightTheme,
//                 darkTheme: AppTheme.darkTheme,
//                 themeMode: themeProvider.themeMode,
//                 locale: localeNotifier.locale,
//                 supportedLocales: AppLocalizations.supportedLocales,
//                 localizationsDelegates: const [
//                   AppLocalizations.delegate,
//                   GlobalMaterialLocalizations.delegate,
//                   GlobalWidgetsLocalizations.delegate,
//                   GlobalCupertinoLocalizations.delegate,
//                 ],
//                 initialRoute: RoutesName.splash,
//                 onGenerateRoute: Routes.generateRoute,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
//
