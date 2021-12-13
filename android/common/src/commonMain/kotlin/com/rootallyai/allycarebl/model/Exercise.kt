package com.rootallyai.allycarebl.model

data class Exercise(
    val name: String? = null,
    val hold_time: Int = 0,
    val rep_count: Int = 0,
    val video: String = "/practice/Knee Bend with Towel.mp4",
    val practice: String = "/practice/Knee Bend with Towel.mp4",
    val id: Int = 0,
    var repetition: Int = 1
)