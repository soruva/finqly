// android/app/build.gradle.kts

import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.soruvalab.finqly"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_17.toString() }

    defaultConfig {
        applicationId = "com.soruvalab.finqly"
        minSdk = maxOf(21, flutter.minSdkVersion)
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        val cmKeystore: String? = System.getenv("CM_KEYSTORE")
        val cmKeystorePass: String? = System.getenv("CM_KEYSTORE_PASSWORD")
        val cmKeyAlias: String? = System.getenv("CM_KEY_ALIAS")
        val cmKeyPass: String? = System.getenv("CM_KEY_PASSWORD")

        // key.properties
        val props = Properties()
        val propsFile = rootProject.file("android/key.properties")
        if (propsFile.exists()) {
            propsFile.inputStream().use { props.load(it) }
        }

        if (!cmKeystore.isNullOrBlank()
            && !cmKeystorePass.isNullOrBlank()
            && !cmKeyAlias.isNullOrBlank()
            && !cmKeyPass.isNullOrBlank()
        ) {
            create("release") {
                storeFile = file(cmKeystore)
                storePassword = cmKeystorePass
                keyAlias = cmKeyAlias
                keyPassword = cmKeyPass
            }
        } else if (props.getProperty("storeFile") != null) {
            create("release") {
                storeFile = file(props.getProperty("storeFile"))
                storePassword = props.getProperty("storePassword")
                keyAlias = props.getProperty("keyAlias")
                keyPassword = props.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        getByName("release") {
            if (signingConfigs.findByName("release") != null) {
                signingConfig = signingConfigs.getByName("release")
            }
            // isMinifyEnabled = true
            // isShrinkResources = true
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro"
            // )
        }
        getByName("debug") { }
    }
}

flutter { source = "../.." }
