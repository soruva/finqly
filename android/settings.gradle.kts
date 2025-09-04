// android/settings.gradle.kts

pluginManagement {
    val flutterSdkPath = run {
        val props = java.util.Properties()
        val local = file("local.properties")
        val envFlutter = System.getenv("FLUTTER_ROOT") // Codemagic 等のCI向けフォールバック
        if (local.exists()) {
            local.inputStream().use { props.load(it) }
            props.getProperty("flutter.sdk") ?: envFlutter
        } else {
            envFlutter
        } ?: error("flutter.sdk not set in local.properties and FLUTTER_ROOT not found")
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
    }
}
        
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.3" apply(false)
    id("org.jetbrains.kotlin.android") version "2.1.0" apply(false)
}

include(":app")
