allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// No global Android compileOptions configuration here to avoid finalization conflicts.
// Each module (e.g., :app) defines its own Java/Kotlin compatibility.

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
// End of file