import java.io.File

// ----------------------------
// Load .env file
// ----------------------------
fun loadDotEnv(): Map<String, String> {
    val envFile = File(rootDir, ".env")
    if (!envFile.exists()) return emptyMap()

    return envFile.readLines()
        .map { it.trim() }
        .filter { it.isNotEmpty() && !it.startsWith("#") }
        .mapNotNull { line ->
            val i = line.indexOf('=')
            if (i == -1) null else {
                val key = line.substring(0, i).trim()
                var value = line.substring(i + 1).trim()
                if ((value.startsWith("\"") && value.endsWith("\"")) ||
                    (value.startsWith("'") && value.endsWith("'"))) {
                    value = value.substring(1, value.length - 1)
                }
                key to value
            }
        }
        .toMap()
}

val env: Map<String, String> = loadDotEnv()
val googleServicesJsonPaths = listOf(
    file("google-services.json"),
    file("src/debug/google-services.json"),
    file("src/main/google-services.json"),
    file("src/release/google-services.json"),
)
val hasGoogleServicesJson = googleServicesJsonPaths.any { it.exists() }
val releaseKeystoreFile = file("release-key.jks")
val hasReleaseKeystore = releaseKeystoreFile.exists()

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

if (hasGoogleServicesJson) {
    apply(plugin = "com.google.gms.google-services")
} else {
    logger.lifecycle("google-services.json not found; skipping Google Services plugin.")
}

android {
    namespace = "com.example.yannyamba"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.yannyamba"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = 2
        versionName = "1.0.1"

        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = env["MAPS_API_KEY"] ?: ""
    }

    // ----------------------------
    // Signing configurations
    // ----------------------------
    signingConfigs {
        create("release") {
            if (hasReleaseKeystore) {
                storeFile = releaseKeystoreFile
                storePassword = "yannapp"
                keyAlias = "release"
                keyPassword = "yannapp"
            }
        }
    }

    // ----------------------------
    // Build Types
    // ----------------------------
    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                logger.lifecycle(
                    "release-key.jks not found; using debug signing for release build."
                )
                signingConfigs.getByName("debug")
            }
        }
        getByName("debug") {
            // default debug signing
        }
    }
}

flutter {
    source = "../.."
}
