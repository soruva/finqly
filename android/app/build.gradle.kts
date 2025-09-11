// android/app/build.gradle.kts
import java.util.Properties
import kotlin.math.max

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.soruvalab.finqly"
    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_17.toString() }

    defaultConfig {
        applicationId = "com.soruvalab.finqly"
        minSdk = maxOf(21, flutter.minSdkVersion)
        targetSdk = 35

        versionCode = max(6, flutter.versionCode)
        versionName = flutter.versionName
    }

    // ---- Signing (Codemagic env or key.properties) ----
    val cmKeystore: String? = System.getenv("CM_KEYSTORE")
    val cmKeystorePass: String? = System.getenv("CM_KEYSTORE_PASSWORD")
    val cmKeyAlias: String? = System.getenv("CM_KEY_ALIAS")
    val cmKeyPass: String? = System.getenv("CM_KEY_PASSWORD")

    val keystoreProps = Properties().apply {
        val f = rootProject.file("android/key.properties")
        if (f.exists()) f.inputStream().use { this.load(it) }
    }

    fun hasEnvSigning() =
        !cmKeystore.isNullOrBlank() && !cmKeystorePass.isNullOrBlank() &&
        !cmKeyAlias.isNullOrBlank() && !cmKeyPass.isNullOrBlank()

    fun hasFileSigning() =
        keystoreProps.getProperty("storeFile")?.isNotBlank() == true &&
        keystoreProps.getProperty("storePassword")?.isNotBlank() == true &&
        keystoreProps.getProperty("keyAlias")?.isNotBlank() == true &&
        keystoreProps.getProperty("keyPassword")?.isNotBlank() == true

    println("[signing] CM vars? ${hasEnvSigning()} ; key.properties? ${hasFileSigning()}")

    signingConfigs {
        if (hasEnvSigning()) {
            create("release") {
                storeFile = file(cmKeystore!!)
                storePassword = cmKeystorePass
                keyAlias = cmKeyAlias
                keyPassword = cmKeyPass
            }
        } else if (hasFileSigning()) {
            create("release") {
                storeFile = file(keystoreProps.getProperty("storeFile"))
                storePassword = keystoreProps.getProperty("storePassword")
                keyAlias = keystoreProps.getProperty("keyAlias")
                keyPassword = keystoreProps.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        getByName("release") {
            val hasSigning = signingConfigs.findByName("release") != null
            if (!hasSigning) {
                throw GradleException("Release signing is NOT configured. Set CM_* envs or android/key.properties.")
            }
            signingConfig = signingConfigs.getByName("release")

            // ProGuard/R8
            // isMinifyEnabled = true
            // isShrinkResources = true
            // proguardFiles(
            //   getDefaultProguardFile("proguard-android-optimize.txt"),
            //   "proguard-rules.pro"
            // )
        }
        getByName("debug") { }
    }
}

flutter { source = "../.." }

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.2")
}
