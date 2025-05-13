allprojects {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven { url=uri("https://maven.aliyun.com/repository/google") }
        maven { url=uri("https://maven.aliyun.com/repository/jcenter") }
        maven { url=uri("https://maven.aliyun.com/nexus/content/groups/public") }
        maven { url=uri("https://storage.googleapis.com/download.flutter.io") }
        maven { url=uri("https://jitpack.io") }
        maven { url=uri("https://developer.hihonor.com/repo") }
        maven { url=uri("https://developer.huawei.com/repo") }
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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
