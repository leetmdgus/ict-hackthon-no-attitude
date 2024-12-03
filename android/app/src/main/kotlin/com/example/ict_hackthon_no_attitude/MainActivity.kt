package com.example.ict_hackthon_no_attitude


import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.ict_hackthon_no_attitude/launch"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "launchApp") {
                val intent: Intent? = packageManager.getLaunchIntentForPackage("com.hallym.ac.kr.ict")
                if (intent != null) {
                    startActivity(intent)
                    result.success("App launched")
                } else {
                    result.error("APP_NOT_FOUND", "App not installed", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
