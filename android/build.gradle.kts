buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Plugin Google Services untuk Firebase 
        classpath("com.google.gms:google-services:4.4.1")
        // Tambahkan ini jika Anda menggunakan Kotlin terbaru
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Konfigurasi path build (tetap sama, ini sudah benar)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}