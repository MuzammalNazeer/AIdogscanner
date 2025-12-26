

import 'dart:io';

import 'package:dog_breed/View/ActivitesView/ActivitesView.dart';
import 'package:dog_breed/View/Dashboardhome/Dashboard_home_view.dart';
import 'package:dog_breed/View/DogIdentifierApp.dart';
import 'package:dog_breed/View/HomeView/HomeView.dart';
import 'package:dog_breed/View/MyPetsView/DogIdentificationScreen.dart';
import 'package:dog_breed/View/MyPetsView/DogResultScreen.dart';
import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
import 'package:dog_breed/View/MyPetsView/addPetView.dart';
import 'package:dog_breed/View/MyPetsView/cameraView.dart';
import 'package:dog_breed/View/MyPetsView/cleaningView.dart';
import 'package:dog_breed/View/MyPetsView/hygieneView.dart';
import 'package:dog_breed/View/ProfileView/ProfileView.dart';
import 'package:dog_breed/View/Wizard/wizardView.dart';
import 'package:dog_breed/View/login/loginView.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../View/Calendar/calendarView.dart';
import '../../View/Favourites/favouritesView.dart';
import '../../View/Favourites/myFavouritesview.dart';
import '../../View/History/historyView.dart';
import '../../View/MyPetsView/dogtreslutsave.dart';
import '../../View/Splash/splashView.dart';
import '../../View/forget/confirmpasswordview.dart';
import '../../View/forget/forgotPasswordEmailView.dart';
import '../../View/forget/forgotcodeView.dart';
import '../../View/forget/newpasswordview.dart';
import '../../View/pro/proView.dart';
import '../../View/setting/FeedbackView.dart';
import '../../View/setting/settingView.dart';
import '../../View/shop/shopview.dart';
import '../../View/signup/signupview.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Splashview());
        case RoutesName.pro:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Proview());
        case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const LoginView());
        case RoutesName.signup:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Signupview());
        case RoutesName.forgetEmail:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Forgotpasswordemailview());
        case RoutesName.forgetCode:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Forgotcodeview());
        case RoutesName.confirm:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Confirmpasswordview());
        case RoutesName.newPassword:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Newpasswordview());
        case RoutesName.wizard:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Wizardview());
        case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Homeview());
        case RoutesName.myFavourites:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Myfavouritesview());
      case RoutesName.dashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) =>   DashboardHomeView());
        case RoutesName.setting:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Settingview());
      case RoutesName.favourites:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Favouritesview());
      case RoutesName.history:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Historyview());
        case RoutesName.activites:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Activitesview());
        case RoutesName.myPets:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Mypetsview());
        case RoutesName.calendar:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  Calendarview());
        case RoutesName.shop:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Shopview());
        case RoutesName.profile:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Profileview());
        case RoutesName.hygiene:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const HygieneView());
        case RoutesName.cleaning:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Cleaningview());
        case RoutesName.addPet:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const AddPetView());
        case RoutesName.feedback:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const FeedbackView());
        case RoutesName.dogSave:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Dogtreslutsave(), settings: settings, );
        case RoutesName.camera:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Cameraview());
      case RoutesName.dogIdentification:
        final args = ModalRoute.of(context as BuildContext)?.settings.arguments;
        final File imageFile = args is File
            ? args
            : File('');
        return MaterialPageRoute(
          builder: (_) => DogIdentificationScreen(imageFile: imageFile),
        );
        case RoutesName.dogResult:
        final args = ModalRoute.of(context as BuildContext)?.settings.arguments;
        final File imageFile = args is File
            ? args
            : File('');
        return MaterialPageRoute(
          builder: (_) => DogResultScreen(imageFile: imageFile),
        );
      // case RoutesName.dogIdentifier:
      // // Get the File that was passed as argument
      //   final args = ModalRoute.of(context as BuildContext)?.settings.arguments;
      //   final File imageFile = args is File
      //       ? args
      //       : File(''); // fallback (never used if you pass properly)
      //
      //   return MaterialPageRoute(
      //     builder: (_) => const DogIdentifierApp(),
      //   );

      // case RoutesName.dogIdentifier:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) =>  const DogIdentifierApp());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
