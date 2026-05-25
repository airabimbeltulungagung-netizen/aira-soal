// buildscript digunakan untuk mendefinisikan plugin yang dipakai di level project
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Plugin Google Services untuk Firebase (Wajib untuk Login Google)
        classpath("com.google.gms:google-services:4.4.1")
    }
}

// allprojects untuk mendefinisikan repositori yang digunakan semua modul
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Konfigurasi path build agar rapi
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Task untuk membersihkan folder build
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}