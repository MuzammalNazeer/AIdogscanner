import 'package:camera/camera.dart';
import 'package:dog_breed/View/MyPetsView/cameraView.dart';
import 'package:dog_breed/View_model/ScanProvider.dart';
import 'package:dog_breed/View_model/home/home_view_model.dart';
import 'package:dog_breed/View_model/pet.dart';
import 'package:dog_breed/utils/routes/routes.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:edge_to_edge/edge_to_edge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Valid/AppTheme.dart';
import 'View_model/ThemeNotifier.dart';
import 'View_model/dogvaluesviewmodel.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch (e) {
    if (kDebugMode) {
      print("Error initializing cameras: $e");
    }
    cameras = [];
  }
  await SharedPreferences.getInstance();
  final scanProvider = ScanProvider();
  await scanProvider.initialize();
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
        ChangeNotifierProvider(create: (_) => PetProvid()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => DogValuesViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(440, 956),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<ThemeNotifier>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                title: 'Dog Breed',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode,
                initialRoute: RoutesName.splash,
                onGenerateRoute: Routes.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}



// import 'package:camera/camera.dart';
// import 'package:dog_breed/View/MyPetsView/cameraView.dart';
// import 'package:dog_breed/View_model/ScanProvider.dart';
// import 'package:dog_breed/View_model/home/home_view_model.dart';
// import 'package:dog_breed/View_model/pet.dart';
// import 'package:dog_breed/utils/routes/routes.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:provider/provider.dart';
//
// import 'View_model/ThemeNotifier.dart';
//
// Future<void> main() async {
//   await Hive.initFlutter();
//   WidgetsFlutterBinding.ensureInitialized();
//
//   cameras = await availableCameras();
//   runApp(const MyApp());
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
//         ChangeNotifierProvider(
//           create: (_) => PetProvid(),
//         ),
//         ChangeNotifierProvider(create: (_) => ScanProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeNotifier()),
//
//       ],
//       child: ScreenUtilInit(
//         designSize:  const Size(440, 956),
//         minTextAdapt: true,
//         splitScreenMode: true,
//         builder: (context, child) {
//           return MaterialApp(
//             title: 'Dog Breed',
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//               useMaterial3: true,
//               colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//               fontFamily: 'Sora',
//             ),
//               initialRoute: RoutesName.splash,
//            onGenerateRoute: Routes.generateRoute,
//
//           );
//         },
//       ),
//     );
//   }
// }
//
