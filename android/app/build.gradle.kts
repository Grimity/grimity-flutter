import org.jetbrains.kotlin.util.profile
import java.util.Properties

plugins {
    id("com.android.application")

    // android/app/google-services.json을 Android 리소스로 변환.
    id("com.google.gms.google-services")

    // Flutter 플러그인은 Android 플러그인 뒤에 해야함.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreFile = rootProject.file("keystore.jks")
val keystorePropertiesFile = rootProject.file("key.properties")

// 필수 키 스토어 파일들이 존재하는지 확인.
check(keystoreFile.isFile && keystorePropertiesFile.isFile) {
    "앱 서명 파일이 없습니다. 프로젝트 루트에서 'dart run git_config fetch'를 실행하세요."
}

// 키 스토어 파일 불러오기.
val keystoreProperties = Properties().apply {
    keystorePropertiesFile.inputStream().use { load(it) }
}

android {
    namespace = "com.grimity.flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.grimity.flutter"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 기존 앱과 동일한 키스토어로 서명.
    signingConfigs {
        create("keystore") {
            storeFile = keystoreFile
            storePassword = keystoreProperties.getProperty("storePassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
        }
    }

    // 모든 빌드 모드에서 동일한 서명 인증서와 소셜 로그인 키 해시를 사용.
    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("keystore")
        }
        getByName("profile") {
            signingConfig = signingConfigs.getByName("keystore")
        }
        release {
            signingConfig = signingConfigs.getByName("keystore")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
