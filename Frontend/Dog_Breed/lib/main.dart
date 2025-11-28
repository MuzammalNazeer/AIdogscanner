// lib/main.dart
import 'package:camera/camera.dart';
import 'package:dog_breed/View/MyPetsView/cameraView.dart';
import 'package:dog_breed/View_model/home/home_view_model.dart';
import 'package:dog_breed/View_model/pet.dart';
import 'package:dog_breed/utils/routes/routes.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(
          create: (_) => PetProvid(),
        ),
      ],
      child: ScreenUtilInit(
        designSize:  const Size(440, 956),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Dog Breed',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              fontFamily: 'Sora',
            ),
              initialRoute: RoutesName.splash,
           onGenerateRoute: Routes.generateRoute,

          );
        },
      ),
    );
  }
}

