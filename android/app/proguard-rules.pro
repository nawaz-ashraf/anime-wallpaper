# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# AdMob
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# Hive
-keep class io.hive.** { *; }
-keep class * extends io.hive.TypeAdapter

# GSON/JSON mapping if used
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }

# Play Core (Missing classes referenced by Flutter)
-dontwarn com.google.android.play.core.**

