package com.rootallyai.allycarebl

object Calibration {
    fun getExerciseType(exMutable: ExMutable): ExMutable {
        /*
        Function is used to find type of  exercise
        No input
        Internally finds type of exercise based on exercise name
        Totally 4 types based on the task it is to be done.
        "LayDownOnFloor" - performing task laying on the floor
        "StandOnFloor" - performing task standing on the floor
        "sitOnFloor"- performing task sitting on the floor
         "UpperBody" -performing task in such a way that only upper body landmarks are  sufficient .
         */

        if (ExConstants.constants.exerciseTypes["LayDownOnFloor"]?.contains(exMutable.constants.currentExercise) == true) {
            exMutable.limits.exerciseType = "LayDownOnFloor"
        }
        if (ExConstants.constants.exerciseTypes["StandOnFloor"]?.contains(exMutable.constants.currentExercise) == true) {
            exMutable.limits.exerciseType = "StandOnFloor"
        }
        if (ExConstants.constants.exerciseTypes["sitOnFloor"]?.contains(exMutable.constants.currentExercise) == true) {
            exMutable.limits.exerciseType = "sitOnFloor"
        }
        if (ExConstants.constants.exerciseTypes["UpperBody"]?.contains(exMutable.constants.currentExercise) == true) {
            exMutable.limits.exerciseType = "UpperBody"
        }
        return exMutable
    }

    fun range(exMutable: ExMutable): ExMutable {
        /*
        Function used to accept the calibration section/screen after certain number of frames gets satisfied the respective condition
         */
        exMutable.limits.limitCalib += 1
        if (exMutable.limits.limitCalib > ExConstants.limits.frameThreshCalib) {
            exMutable.flags.optiRange = true
            exMutable.limits.limitCalib = 0
        }
        return exMutable
    }
}