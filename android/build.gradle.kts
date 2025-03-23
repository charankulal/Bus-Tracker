allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
buildscript {
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.1")
        classpath("com.google.gms:google-services:4.3.15")
    }
}
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}
plugins{
    id("com.google.gms.google-services") version "4.4.2" apply false
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
