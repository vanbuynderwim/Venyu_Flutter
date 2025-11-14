package com.getvenyu.app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterActivity() {
    private val REGION_CHANNEL = "com.getvenyu.app/region"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Setup region detection method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, REGION_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getRegion") {
                    // Get region code from Android system settings
                    val regionCode = getRegionCode()
                    result.success(regionCode)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun getRegionCode(): String {
        return try {
            // Get region from system configuration
            val locale = resources.configuration.locales[0]
            locale.country.ifEmpty { "NL" }
        } catch (e: Exception) {
            // Fallback to default locale
            Locale.getDefault().country.ifEmpty { "NL" }
        }
    }
}