package com.utd.uas // Sesuaikan dengan package Anda

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.utd.uas/nim_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "reverseNim") {
                val nim = call.argument<String>("nim") ?: ""
                // Logika membalikkan NIM
                val reversed = nim.reversed() 
                result.success(reversed)
            } else {
                result.notImplemented()
            }
        }
    }
}