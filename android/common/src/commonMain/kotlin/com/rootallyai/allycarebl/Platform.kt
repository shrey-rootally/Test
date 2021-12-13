package com.rootallyai.allycarebl

expect class Platform() {
    val platform: String
    fun logMessage(msg: String)
}
