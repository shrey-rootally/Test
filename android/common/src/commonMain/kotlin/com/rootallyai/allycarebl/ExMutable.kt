package com.rootallyai.allycarebl

import kotlinx.datetime.Clock

data class ExMutable(
    val angle: Angle,
    val flags: Flags,
    val limits: Limits,
    val holdingTime: HoldingTime,
    val reps: Reps,
    val constants: Constants
) {
    data class Angle(
        var layDownAngle: Int = 250 // lay down on floor angle (hip to shoulder line should be parallel to floor).So 25 degree is allowed
    )
    data class Flags(
        var feedbackFlag: Int = 0, // These flag variables are used for feedback system
        var feedbackFlag1: Int = 0,
        var feedbackFlag2: Int = 0,
        var feedbackFlag3: Int = 0,
        var feedbackFlag4: Int = 0,
        var feedbackFlagBaseCondition: Int = 0,
        var feedbackRepeat: Int = 0, // These feedback variable is used for repeating the exercise if exercise was done fast( momentum))
        var flags: Boolean = false, // These are feedback flags to print feedbacks only once for every rep
        var handExtension: Boolean = false, // This is boolean variable to check whether both hands are pulled outwards during shoulder flex external rotation task
        var optiRange: Boolean = false, // Boolean variable for approving the calibration screen
        var rep: Boolean = true, // Boolean variable to check rep calculation
        var holdTime: Boolean = false, // Boolean variable to start holding time section in android app UI
        var isSit: Boolean = false, // variable to confirm user has sat for 3 seconds or not in sit2stand exercies
        var stand: Boolean = false, // variable to store
        var firstMsg: Boolean = false, // boolean variable used to trigger feedback (print message) for first time when user starts exercise
        var firstSitMsg: Boolean = false,
        var firstStandMsg: Boolean = false,
        var firstStageMsg: Boolean = false, // boolean variable used to trigger feedback (print message) for first stage when user starts exercise(shoulder external raise with band exercise)
        var baseCondition: Boolean = false,
        var startTime: Boolean = false,
        var legLift: Boolean = false,
        var legliftBase: Boolean = false,
        var secondRepMsg: Boolean = false
    )
    data class Limits(

        var lowerRange: Float = 0f, // lowerRange is used in calibration section to get optimum range of values (user range of body coordinates) , neither too far nor too close to camera
        var upperRange: Float = 0f, // upperRange is used in calibration section to get optimum range of values (user range of body coordinates) , neither too far nor too close to camera
        var limit: Int = 0, //
        var frame: Int = 0, // variable to count number of frames
        var distBwtHands: Float = 0f, // variable to store horizontal distance between both wrist (shoulder ex rotation both)
        var distBwtHandsExtension: Float = 0f, // variable to store horizontal distance between both wrist when both the hands are pulled outwards (flex external raise with band)
        var exerciseType: String = "", // variable to store exerciseType  from -["LayDownOnFloor","StandOnFloor","sitOnFloor","UpperBody"]
        var legLength: Float = 0f, // variable to store 30% of length of thigh ie hip - knee height(y axis). Used in squat to check whether hip is below (knee+ legLength), for initiating the holding time calculation.
        var radius: Float = 0f, // variable which stores 30% of horizontal distance between two shoulder points. THe value is taken as radius in radius based overlap detection  ie For Ex: in shoulder external rotation, the hand is to be kept bent at 90 degree such that elbow point overlaps the wrist point.
        var bodyRange: Float = 0f, // variable used to store the range of predefined body coordinates like For ex: nose to ankle height for squat exercise, hip to shoulder height for shoulder exercises etc
        var upperRangeY: Float = 0f, // this variable is used to store upper limit value for y coordinate. Used in calibration screen to make user body coordinates should lie below this limit. This helps in  avoiding the detection failure while performing exercise in which hands or leg are supposed to lift above head.
        var topValue: Float = 1f, // this variable is used to store the top value( ie top most body landmark) for current frame
        var limitCalib: Int = 0 // to store number of frames coming under particular condition. Helps in counting frame

    )
    data class HoldingTime(
        var count: Int = 0, // variable to count holding time
        var countStanding: Int = 0, // variable to count standing time for sit to stand
        var countSit: Int = 0,
        var currentTime: Float = 0f, // variable to store current time
        var minimumHoldTime: Int = 0, // minimum holding time for every exercise (it gets changed for every exercise)
        var sitRightLeg: Float = 0f, // variable to hold the length of thigh while sitting(hip to knee)
        var sitLeftLeg: Float = 0f, // variable to hold the length of thigh while sitting(hip to knee)
        var startTime: Long = Clock.System.now().toEpochMilliseconds(), // to start time counting
        var presentTime: Long = Clock.System.now().toEpochMilliseconds(),
        var previousTime: Long = Clock.System.now().toEpochMilliseconds(),
        var presentTimeSit: Long = Clock.System.now().toEpochMilliseconds(),
        var previousTimeSit: Long = Clock.System.now().toEpochMilliseconds(),
        var baseConditionTime: Long = Clock.System.now().toEpochMilliseconds(),
        var time: Float = 0f, // variables  to hold time between 2 frames
        var timeStanding: Float = 0f, // variable used in sit stand exercise to count time b/w 2 frames
        val unsuccessTime: Int = (minimumHoldTime * 0.3).toInt(), // unsuccessful rep is considered only if the holding time is more than 30% for minimum hold time but fail to reach minimum hold time.
        var unsuccessHold: ArrayList<Int> = arrayListOf(), // to hold the unsuccessful holding times
        var speed: ArrayList<Float> = arrayListOf(),
        var msgCount: Int = 1, // used to print/give feedback for every 1 sec of holding time completion
        var beginTime: Long = 0L,
        var startCountingFeedbackTime: Long = 0L,
        var totalTime: Float = 0f,
        var BeginCounting: Long = Clock.System.now().toEpochMilliseconds(),
        var flucTotTime: Float = 0f
    )
    data class Reps(
        var successRep: Int = 0, // variable to hold successful rep
        var unsucessRep: Int = 0
    )
    data class Constants(
        var lift: ArrayList<Float> = arrayListOf(),
        var elbowLeft: ArrayList<Float> = arrayListOf(), // list to store left elbow x and y values
        var elbowRight: ArrayList<Float> = arrayListOf(), // list to store right elbow x and y values
        var currentExercise: String = "", // Stores the name of current exercise
        var currentExerciseID: Int = 0,
        var majorChange: Int = 0,
        var rightHipValueX: Float = 0f, // variable to store current right hip x value
        var leftHipValueX: Float = 0f, // variable to store current left hip x value
        var lowestRange: Int = 0,
        var highestRange: Int = 0,
        var averageRange: Int = 0,
        var frameCount: Int = 0,
        var dataSum: Int = 0,
        var anklePoint: Float = 0f,
        var isLeftSide: Boolean = true,
        var isFluctuation: Boolean = false,
        var isRightSide: Boolean = false,
        var prevFeedbackmsg: String = "",
        var shoulderPoint: Float = 0f,
        var TTStext: String = "",
        var isFeedback: Boolean = false,
        var backAngle: Float = 180f,
        var backAngleLeanForward: Float = 180f
    )
}