package com.rootallyai.allycarebl.model

data class ExerciseItem(
    val name: String = "",
    var correct_reps: Int = 0,
    var total_reps: Int = 0,
    val setList: MutableList<SetItem> = mutableListOf()
)
