
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { fis ->
        keystoreProperties.load(fis)
    }
}

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.dog_breed"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.dog_breed"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            // Use debug signing for now
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

//    buildTypes {
//        release {
//            isMinifyEnabled = false
//            isShrinkResources = false
//            if (keystoreProperties.isNotEmpty()) {
//                signingConfig = signingConfigs.getByName("release")
//            }
//            proguardFiles(
//                getDefaultProguardFile("proguard-android-optimize.txt"),
//                "proguard-rules.pro"
//            )
//        }
//    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}


//
//import com.android.build.api.dsl.ApplicationBuildType
//        import java.util.Properties
//        import java.io.FileInputStream
//
//        plugins {
//            id("com.android.application")
//            id("org.jetbrains.kotlin.android")
//            id("dev.flutter.flutter-gradle-plugin")
//        }
//
//// Read keystore properties
//val keystorePropertiesFile = rootProject.file("key.properties")
//val keystoreProperties = Properties()
//if (keystorePropertiesFile.exists()) {
//    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
//}
//
//android {
//    namespace = "com.example.dog_breed"
//    compileSdk = 34
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_11
//        targetCompatibility = JavaVersion.VERSION_11
//        isCoreLibraryDesugaringEnabled = true
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_11.toString()
//    }
//
//    defaultConfig {
//        applicationId = "com.example.dog_breed"
//        minSdk = 24
//        targetSdk = 34
//        versionCode = 1
//        versionName = "1.0"
//    }
//
//    signingConfigs {
//        create("release") {
//            keyAlias = keystoreProperties.getProperty("keyAlias") ?: ""
//            keyPassword = keystoreProperties.getProperty("keyPassword") ?: ""
//            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) } ?: file("")
//            storePassword = keystoreProperties.getProperty("storePassword") ?: ""
//        }
//
//        getByName("debug") {
//            // Debug keystore
//            storeFile = file("debug.keystore")
//            storePassword = "android"
//            keyAlias = "androiddebugkey"
//            keyPassword = "android"
//        }
//    }
//
//    buildTypes {
//        getByName("debug") {
//            signingConfig = signingConfigs.getByName("debug")
//        }
//
//        getByName("release") {
//            isMinifyEnabled = false
//            isShrinkResources = false
//            signingConfig = signingConfigs.getByName("release")
//            proguardFiles(
//                getDefaultProguardFile("proguard-android-optimize.txt"),
//                "proguard-rules.pro"
//            )
//        }
//    }
//}
//
//dependencies {
//    implementation("androidx.core:core-ktx:1.12.0")
//    implementation("androidx.appcompat:appcompat:1.6.1")
//    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
//}
//
//flutter {
//    source = "../.."
//}