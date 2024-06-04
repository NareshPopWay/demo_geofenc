package com.example.demo_geofenc  // Ensure this matches your package structure

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.demo_geofenc/location"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startLocationService") {
                val intent = Intent(this, LocationService::class.java)
                startService(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
