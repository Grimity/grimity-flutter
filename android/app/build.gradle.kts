import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    // id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// 앱 서명 파일 불러오기.
val keystoreProps = Properties().apply {
    val keystorePropsFile = rootProject.file("key.properties")
    if (keystorePropsFile.exists()) {
        load(FileInputStream(keystorePropsFile))
    } else {
        throw Exception("/android 폴더에 'key.properties'와 'keystore.jks' 파일을 추가하세요.")
    }
}

android {
    namespace = "com.example.grimity"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.grimity"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("keystore") {
            keyAlias = keystoreProps.getProperty("keyAlias")
            keyPassword = keystoreProps.getProperty("keyPassword")
            storeFile = file("../keystore.jks")
            storePassword = keystoreProps.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            // `flutter run --release`으로 빌드 할 때는 릴리스 키로 서명됩니다.
            signingConfig = signingConfigs.getByName("keystore")
        }

        debug {
            // `flutter run --debug`으로 빌드 할 때는 릴리스 키로 서명됩니다.
            signingConfig = signingConfigs.getByName("keystore")
        }
    }

    flavorDimensions += "build-type"
    productFlavors {
        create("dev") {
            dimension = "build-type"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Grimity(dev)")
        }
        create("prod") {
            dimension = "build-type"
            resValue("string", "app_name", "Grimity")
        }
    }
}

flutter {
    source = "../.."
}
