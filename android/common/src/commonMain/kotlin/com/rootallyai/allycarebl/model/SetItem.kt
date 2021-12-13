package com.rootallyai.allycarebl.model

data class SetItem(
    val correct_reps: Int = 0,
    val total_reps: Int = 0,
    val max_hold_time: Double = 0.0,
    val time: Int = 0,
    val knee_range: KneeRange = KneeRange(0, 0, 0)
)
