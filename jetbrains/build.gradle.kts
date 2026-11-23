import org.jetbrains.intellij.platform.gradle.IntelliJPlatformType
import org.jetbrains.intellij.platform.gradle.TestFrameworkType

plugins {
    kotlin("jvm") version "2.4.21"
    id("org.jetbrains.intellij.platform") version "2.19.0"
}

group = "org.basaltmc"
version = providers.gradleProperty("pluginVersion").getOrElse("26.3.0")

kotlin {
    jvmToolchain(25)
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
    compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21)
}

tasks.withType<JavaCompile>().configureEach {
    options.release.set(21)
}

repositories {
    mavenCentral()
    intellijPlatform {
        defaultRepositories()
    }
}

dependencies {
    intellijPlatform {
        intellijIdea("2025.3")
        testFramework(TestFrameworkType.Platform)
    }
    testImplementation("junit:junit:4.13.2")
}

intellijPlatform {
    pluginVerification {
        ides {
            current()
            create(IntelliJPlatformType.CLion, "2025.3")
            create(IntelliJPlatformType.RustRover, "2025.3")
            create(IntelliJPlatformType.WebStorm, "2025.3")
        }
    }
    pluginConfiguration {
        name = "Basalt DevTools"
        ideaVersion {
            sinceBuild = "253"
        }
    }
}
