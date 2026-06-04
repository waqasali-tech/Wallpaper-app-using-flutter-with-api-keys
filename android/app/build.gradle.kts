plugins {
    id("com.android.application")
    id("kotlin-android")  
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}


android {
    namespace = "com.example.final_project"
    compileSdk = flutter.compileSdkVersion

    // Set required NDK version explicitly (fixes NDK mismatch)
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.final_project"

        // Increase minSdk to 23 as required by firebase_auth plugin
        minSdk = flutter.minSdkVersion
        
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            // Use debug signing config for release builds in development
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
  implementation("org.jetbrains.kotlin:kotlin-stdlib:2.1.0")



    // Firebase BoM (manages compatible Firebase library versions)
    implementation(platform("com.google.firebase:firebase-bom:33.14.0"))

    // Firebase services you need
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-storage")

    // Google Sign-In support
    implementation("com.google.android.gms:play-services-auth:21.0.0")
}

