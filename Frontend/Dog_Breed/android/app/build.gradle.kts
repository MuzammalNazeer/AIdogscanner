plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.dog_breed"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.dog_breed"
        minSdk = 24
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"

        // ✅ Correct Kotlin DSL for ABI filters
        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}


//
//plugins {
//    id("com.android.application")
//    id("org.jetbrains.kotlin.android")
//    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
//    id("dev.flutter.flutter-gradle-plugin")
//}
//
//android {
//    namespace = "com.example.animal3"
//    compileSdk = 36
//    ndkVersion = "27.0.12077973"
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_11
//        targetCompatibility = JavaVersion.VERSION_11
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_11.toString()
//    }
//
//    defaultConfig {
//        applicationId = "com.example.animal3"
//        minSdk = 24
//        targetSdk = 36
//        versionCode = 1
//        versionName = "1.0"
//    }
//
//    buildTypes {
//        release {
//            // Use debug keys temporarily so release builds still run
//            signingConfig = signingConfigs.getByName("debug")
//        }
//    }
//}
//
//flutter {
//    source = "../.."
//}
//
//
////plugins {
////    id("com.android.application")
////    id("kotlin-android")
////    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
////    id("dev.flutter.flutter-gradle-plugin")
////}
////
////android {
////    namespace = "com.example.animal3"
////    compileSdk = flutter.compileSdkVersion
////    ndkVersion = flutter.ndkVersion
////
////    compileOptions {
////        sourceCompatibility = JavaVersion.VERSION_11
////        targetCompatibility = JavaVersion.VERSION_11
////    }
////
////    kotlinOptions {
////        jvmTarget = JavaVersion.VERSION_11.toString()
////    }
////
////    defaultConfig {
////        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
////        applicationId = "com.example.animal3"
////        // You can update the following values to match your application needs.
////        // For more information, see: https://flutter.dev/to/review-gradle-config.
////        minSdk = flutter.minSdkVersion
////        targetSdk = flutter.targetSdkVersion
////        versionCode = flutter.versionCode
////        versionName = flutter.versionName
////    }
////
////    buildTypes {
////        release {
////            // TODO: Add your own signing config for the release build.
////            // Signing with the debug keys for now, so `flutter run --release` works.
////            signingConfig = signingConfigs.getByName("debug")
////        }
////    }
////}
////
////flutter {
////    source = "../.."
////}


//plugins {
//    id("com.android.application")
//    id("kotlin-android")
//    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
//    id("dev.flutter.flutter-gradle-plugin")
//}
//
//android {
//    namespace = "com.example.dog_breed"
//    compileSdk = flutter.compileSdkVersion
//    ndkVersion = flutter.ndkVersion
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_11
//        targetCompatibility = JavaVersion.VERSION_11
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_11.toString()
//    }
//
//    defaultConfig {
//        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//        applicationId = "com.example.dog_breed"
//        // You can update the following values to match your application needs.
//        // For more information, see: https://flutter.dev/to/review-gradle-config.
//        minSdk = flutter.minSdkVersion
//        targetSdk = flutter.targetSdkVersion
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName
//    }
//
//    buildTypes {
//        release {
//            // TODO: Add your own signing config for the release build.
//            // Signing with the debug keys for now, so `flutter run --release` works.
//            signingConfig = signingConfigs.getByName("debug")
//        }
//    }
//}
//
//flutter {
//    source = "../.."
//}
