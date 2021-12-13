package com.rootallyai.allycarebl

import platform.Foundation.NSLog
import platform.UIKit.UIDevice

actual class Platform actual constructor() {
    actual val platform: String = UIDevice.currentDevice.systemName() + " " + UIDevice.currentDevice.systemVersion
    actual fun logMessage(msg: String) {
        NSLog(msg);
    }
}

