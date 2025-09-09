// android/settings.gradle.kts

pluginManagement {
    val flutterSdkPath = run {
        val props = java.util.Properties()
        val local = file("local.properties")
        val envFlutter = System.getenv("FLUTTER_ROOT")
        if (local.exists()) {
            local.inputStream().use { props.load(it) }
            props.getProperty("flutter.sdk") ?: envFlutter
        } else {
            envFlutter
        }
    } ?: error("Flutter SDK path not found. Set flutter.sdk in local.properties or FLUTTER_ROOT env")

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}

include(":app")
