# GoKwik SDK ProGuard rules

# Keep all GoKwik classes
-keep class com.gokwik.** { *; }
-dontwarn com.gokwik.**

# Keep Snowplow tracker classes
-keep class com.snowplowanalytics.** { *; }
-dontwarn com.snowplowanalytics.**

# Keep OkHttp optional dependencies
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**

# Keep Install Referrer optional dependency
-dontwarn com.android.installreferrer.**

# Keep Google Play Core optional dependencies (for Flutter dynamic features)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Keep WebView classes
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(android.webkit.WebView, java.lang.String, android.graphics.Bitmap);
    public boolean *(android.webkit.WebView, java.lang.String);
}
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(android.webkit.WebView, jav.lang.String);
}

# Keep JavaScript interface for WebView
-keepattributes JavascriptInterface
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

