package com.rootallyai.allycarebl

import android.util.Log

actual class Platform actual constructor() {
    actual val platform: String = "Android ${android.os.Build.VERSION.SDK_INT}"
    actual fun logMessage(msg: String) {
        Log.d("AndroidApp", msg) // log the message to logcat
    }
}