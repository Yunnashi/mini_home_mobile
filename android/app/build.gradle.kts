import java.io.File
import java.io.FileInputStream
import java.util.*
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val homeKeystoreProperties = Properties()
val homeKeystorePropertiesFile = rootProject.file("home_key.properties")
if (homeKeystorePropertiesFile.exists()) {
    homeKeystoreProperties.load(FileInputStream(homeKeystorePropertiesFile))
}

android {
    namespace = "com.example.minihome"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" //flutter.ndkVersion TODO: flutterのndkVersionが上がるまではベタ書き

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 28
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        ndk {
            abiFilters += listOf("x86_64", "arm64-v8a", "armeabi-v7a")
        }
    }

    signingConfigs {
        create("homeRelease") {
            keyAlias = homeKeystoreProperties["keyAlias"] as String
            keyPassword = homeKeystoreProperties["keyPassword"] as String
            storeFile = file(homeKeystoreProperties["storeFile"] as String)
            storePassword = homeKeystoreProperties["storePassword"] as String
        }
    }

    flavorDimensions += "flavor-type"
    productFlavors {
        create("homeStaging")  {
            dimension = "flavor-type"
            resValue ("string", "app_name", "【STG】miniHome")
            applicationId = "com.example.minihome.staging"
        }
        create("homeProduct")  {
            dimension = "flavor-type"
            resValue ("string", "app_name", "miniHome")
            applicationId = "com.example.minihome"
        }
    }

    buildTypes {
        release {
            isShrinkResources = true
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android.txt"),
                "proguard-rules.pro"
            )
            isDebuggable = false

            // productFlavors の signingConfig 設定
            productFlavors["homeProduct"].signingConfig = signingConfigs["homeRelease"]
        }

        debug {
            isDebuggable = true
        }
    }
}

flutter {
    source = "../.."
}
