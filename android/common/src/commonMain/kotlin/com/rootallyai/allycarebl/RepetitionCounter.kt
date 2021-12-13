package com.rootallyai.allycarebl

import kotlinx.datetime.Clock
import com.rootallyai.allycarebl.ExMutable.Angle
import com.rootallyai.allycarebl.ExMutable.Flags
import com.rootallyai.allycarebl.ExMutable.Limits
import com.rootallyai.allycarebl.ExMutable.HoldingTime
import com.rootallyai.allycarebl.ExMutable.Reps
import com.rootallyai.allycarebl.ExMutable.Constants
import com.rootallyai.allycarebl.model.Exercise

class RepetitionCounter(exercise: Exercise) {
    var exercise: Exercise
    var feedback: String
    private var restarts: Boolean = false
    var exMutable:ExMutable

    init {
        this.exercise = exercise
        feedback = ""
        exMutable = ExMutable(Angle(),Flags(), Limits(), HoldingTime(minimumHoldTime = exercise.hold_time), Reps(),Constants())
    }

    fun OnFrame(poseLandmarks: MutableMap<Int, HashMap<String, Float>>): Int {
        return when (exercise.id) {
//            ExConstants.exerciseID.kneeBendTowel -> kneeBends(poseLandmarks)
//            ExConstants.exerciseID.isometricQuad -> isometricQuads(poseLandmarks)
//            ExConstants.exerciseID.innerRangeQuad -> innerRangeQuads(poseLandmarks)
            ExConstants.exerciseID.straighLegRaise -> straightLegRaise(poseLandmarks)
//            ExConstants.exerciseID.hamstringStretch -> hamstringStretch(poseLandmarks)
//            ExConstants.exerciseID.seatedKneeExtension -> seatedKneeExtension(poseLandmarks)
//            ExConstants.exerciseID.sit2Stand -> sitToStand(poseLandmarks)
//            ExConstants.exerciseID.shoulderExRotation -> shoulderExRotation(poseLandmarks)
//            ExConstants.exerciseID.shoulderExRotationBoth -> shoulderExRotationBoth(poseLandmarks)
//            ExConstants.exerciseID.shoulderInternalRotation -> shoulderInterRotation(poseLandmarks)
//            ExConstants.exerciseID.shoulderAbduction -> shoulderAbduction(poseLandmarks)
//            ExConstants.exerciseID.shoulderFlexAnteriorRaise -> shoulderFlexAnteriorRaise(poseLandmarks)
//            ExConstants.exerciseID.shoulderFlexExRotation -> shoulderFlexExternal(poseLandmarks)
//            ExConstants.exerciseID.uprightRowBand -> uprightRowBand(poseLandmarks)
//            ExConstants.exerciseID.squat -> squat(poseLandmarks)
//            ExConstants.exerciseID.staticlunge -> staticLunge(poseLandmarks)
//            ExConstants.exerciseID.lowRow -> lowBandRow(poseLandmarks)
//            ExConstants.exerciseID.shoulderPress -> shoulderPress(poseLandmarks)
//            ExConstants.exerciseID.shoulderAbduction90Bend -> shoulder90Abduction(poseLandmarks)
            else -> {
                -1
            }
        }
    }

    fun reset(exercise: Exercise) {
        this.exercise = exercise
        exMutable = ExMutable(Angle(),Flags(), Limits(), HoldingTime(minimumHoldTime = exercise.hold_time), Reps(),Constants())
    }

    infix fun optimumRange(poseLandmarks: MutableMap<Int, HashMap<String, Float>>) {
        /*
        Function is used to find  optimum range for approval of calibration screen
        poseLandmarks: Normalized pose landmarks
        Initially this function resets all variable before starting the calib section
         Based on exercise type 4 different conditions are written  to check all required landmarks are visible, if not throw feedback to user (like body coordinates are not visible)
         */
        if (!restarts) {
            exMutable= ExerciseUtility.resetVar(exMutable)
            restarts = true
        }
//        val idxToCoordinates = ExerciseUtility.threshLandmarks1(poseLandmarks) // filtering the landmarks
        val leg = ExerciseUtility.legClossness(poseLandmarks) // leg landmarks hip,knee and ankle landmarks of both legs
        val shoulder = ExerciseUtility.bodyCoordinates(poseLandmarks) // key points of shoulder and nose
        val upperBody = ExerciseUtility.shoulderLandmarks(poseLandmarks) // upper body keypoints namely shoulder,elbow,hand hip and ears
        if (exMutable.limits.exerciseType == "") {
            exMutable= Calibration.getExerciseType(exMutable)
        }
        if (exMutable.limits.exerciseType == ExConstants.exercises.exTypeLaydown) {
            exMutable = ExerciseUtility.checkRequiredCoordinates(exMutable,this, listOf(leg["FrontLeg"]!!.size != ExConstants.limits.legLandmark, false), ExConstants.feedbacks.msg)
            if (leg["FrontLeg"]!!.size == ExConstants.limits.legLandmark) {
                exMutable = Calibration.range(exMutable)
            }
        }
        if (exMutable.limits.exerciseType == ExConstants.exercises.exTypeStand) {
            exMutable =ExerciseUtility.checkRequiredCoordinates(exMutable,this, listOf(leg["FrontLeg"]!!.size != ExConstants.limits.legLandmark, leg["RearLeg"]!!.size != ExConstants.limits.legLandmark, upperBody["RightHand"]!!.size != ExConstants.limits.shoulderPoints, upperBody["LeftHand"]!!.size != ExConstants.limits.shoulderPoints, upperBody["Hips"]!!.size != ExConstants.limits.hips), ExConstants.feedbacks.msgBody)
            if (upperBody["RightHand"]!!.size == ExConstants.limits.shoulderPoints && upperBody["LeftHand"]!!.size == ExConstants.limits.shoulderPoints && upperBody["Hips"]!!.size == ExConstants.limits.hips && leg["FrontLeg"]!!.size == ExConstants.limits.legLandmark && leg["RearLeg"]!!.size == ExConstants.limits.legLandmark) {
                exMutable = Calibration.range(exMutable)
            }
        }
        if (exMutable.limits.exerciseType == ExConstants.exercises.exTypeSit) {
            exMutable = ExerciseUtility.checkRequiredCoordinates(exMutable,this, listOf(leg["FrontLeg"]!!.size != ExConstants.limits.legLandmark, shoulder["FrontShoulder"]!!.size != ExConstants.limits.bodyLandmarks), ExConstants.feedbacks.msgBody)
            if (leg["FrontLeg"]!!.size == ExConstants.limits.legLandmark && shoulder["FrontShoulder"]!!.size == ExConstants.limits.bodyLandmarks) {
                exMutable = Calibration.range(exMutable)
            }
        }
        if (exMutable.limits.exerciseType == ExConstants.exercises.exTypeUpperBody) {
            exMutable =ExerciseUtility.checkRequiredCoordinates(exMutable ,this, listOf(upperBody["RightHand"]!!.size != ExConstants.limits.shoulderPoints, upperBody["LeftHand"]!!.size != ExConstants.limits.shoulderPoints), ExConstants.feedbacks.msgBody) //, upperBody["Hips"]!!.size != ExConstants.limits.hips
            if (upperBody["RightHand"]!!.size == ExConstants.limits.shoulderPoints && upperBody["LeftHand"]!!.size == ExConstants.limits.shoulderPoints && upperBody["Hips"]!!.size == ExConstants.limits.hips) {
                exMutable = Calibration.range(exMutable)
            }
        }
    }

    private fun straightLegRaise(poseLandmarks: MutableMap<Int, HashMap<String, Float>>): Int {
        /*
         Function to calculate straight leg raise exercise rep counts and provide real time feedback on bad posture
         poseLandmarks: Normalized pose landmarks
         return: Total rep count (successful and unsuccessful)
         */
        val leg = ExerciseUtility.legClossness(poseLandmarks)
        exMutable = ExerciseUtility.checkRequiredCoordinates(exMutable,this, listOf(leg["FrontLeg"]!!.size != ExConstants.limits.legLandmark, false), ExConstants.feedbacks.msg)
        exMutable = ExerciseUtility.successfullRepCount(exMutable,this, exMutable.holdingTime.count)
        if (leg["FrontLeg"]!!.size == ExConstants.limits.legLandmark) {
            val angle: Int = ExerciseUtility.angle2D(leg["FrontLeg"]!!["Hip"]!!, leg["FrontLeg"]!!["Knee"]!!, leg["FrontLeg"]!!["Ankle"]!!)
            val value: HashMap<String, Float> = HashMap()
            value.put("x", leg["FrontLeg"]!!["Ankle"]!!["x"]!!)
            value.put("y", leg["FrontLeg"]!!["Hip"]!!["y"]!!)
            val legLiftAngle = ExerciseUtility.angle2D(leg["FrontLeg"]!!["Ankle"]!!, leg["FrontLeg"]!!["Hip"]!!, value)
            if (angle >= ExConstants.angle.hkaAtraightLegRAise && (leg["FrontLeg"]!!["Hip"]!!["y"]!! > leg["FrontLeg"]!!["Ankle"]!!["y"]!!) && legLiftAngle> ExConstants.angle.legLiftLowerLimitAngle && legLiftAngle <ExConstants.angle.legLiftUpperLimitAngle && !exMutable.flags.rep) {
                exMutable =ExerciseUtility.angleRangeCalculation(exMutable,legLiftAngle)
                exMutable = ExerciseUtility.countHoldTime(exMutable,this, message = ExConstants.feedbacks.msgHoldPositionXsec, prompt = ExConstants.feedbacks.msgTighten + ExConstants.feedbacks.msgLiftLegBed) //   Counting time starts
                exMutable.limits.limit = 0
                //   Below are feedback conditions, if not above conditions then feedback are given
            } else {
                val fluctationTime = ExerciseUtility.timeCountFluctuationRemoval(exMutable).holdingTime.flucTotTime
                if (fluctationTime > ExConstants.holdingTime.fluctuationTime || exMutable.flags.rep) {
                    exMutable = ExerciseUtility.unsuccessfullTimeCount(exMutable)
                    if (exMutable.flags.rep && legLiftAngle <ExConstants.angle.legLiftBaseAngle && legLiftAngle > ExConstants.angle.legLiftMoreRange) {
                        exMutable.flags.baseCondition = false
                    }
                    if (angle < ExConstants.angle.hkaAtraightLegRAise &&
                        (leg["FrontLeg"]!!["Hip"]!!["y"]!! > leg["FrontLeg"]!!["Ankle"]!!["y"]!!) && (exMutable.flags.feedbackFlag1 == 0 || exMutable.holdingTime.count> 0) && legLiftAngle > ExConstants.angle.legLiftMoreRange && !exMutable.flags.rep
                    ) {
                        exMutable.flags.feedbackFlag1 = 1
                        exMutable = onRep(exMutable,ExConstants.feedbacks.msgKneeStraighten)
                        exMutable = ExerciseUtility.reset(exMutable)
                    }
                    if (legLiftAngle > ExConstants.angle.legLiftUpperLimitAngle && (exMutable.flags.feedbackFlag2 == 0 || exMutable.holdingTime.count> 0)) {
                        exMutable = onRep(exMutable, ExConstants.feedbacks.msgLowerLeg)
                        exMutable.flags.feedbackFlag2 = 1
                        exMutable= ExerciseUtility.reset(exMutable)
                    }
                    if (exMutable.holdingTime.count> 0) {
                        exMutable = onRep(exMutable,ExConstants.feedbacks.msgHoldPosition)
                    }
                    if (angle > ExConstants.angle.hkaAtraightLegRAise && legLiftAngle < ExConstants.angle.legLiftMoreRange) {
//                    ExConstants.limits.limit = 0
                        exMutable= ExerciseUtility.BaseConditionTimeInterval(exMutable,exMutable.flags.rep,exMutable.holdingTime.baseConditionTime)
                        exMutable.holdingTime.baseConditionTime = Clock.System.now().toEpochMilliseconds()
                        exMutable.flags.rep = false
//                    ExConstants.holdingTime.previousTime = SystemClock.elapsedRealtime()
                        exMutable = ExerciseUtility.unsuccessfullRepCount(exMutable)
                        exMutable = ExerciseUtility.resetFeedback(exMutable)
                    }
                    if (!exMutable.flags.baseCondition && exMutable.flags.rep && legLiftAngle> ExConstants.angle.legLiftLowerLimitAngle && legLiftAngle <ExConstants.angle.legLiftUpperLimitAngle && exMutable.flags.feedbackFlagBaseCondition == 0) {
                        exMutable.limits.limit += 1
                        exMutable = ExerciseUtility.timeCalculation(exMutable)
                        if (exMutable.holdingTime.totalTime > ExConstants.holdingTime.minFeedbackTime) {
                            exMutable.limits.limit = 0
                            exMutable = onRep(exMutable,ExConstants.feedbacks.msgBaseConditionLegLift)
                            exMutable.flags.feedbackFlagBaseCondition = 0
                            exMutable.flags.baseCondition = true
                            exMutable.holdingTime.totalTime = 0f
                            exMutable.holdingTime.beginTime = 0
                        }
                    }
                    exMutable = ExerciseUtility.reset(exMutable)
                }
            }
        }
        return exMutable.reps.successRep + exMutable.reps.unsucessRep
    }

    fun onRep(exMutable: ExMutable, text: String,Feedback:Boolean = true):ExMutable {
        var TTStext = ""
        if (exMutable.constants.prevFeedbackmsg.isEmpty()){
            exMutable.constants.prevFeedbackmsg=text
            exMutable.holdingTime.startCountingFeedbackTime = Clock.System.now().toEpochMilliseconds()
            TTStext = text
        }
        else if (text==exMutable.constants.prevFeedbackmsg){
            val timeInterval = (Clock.System.now().toEpochMilliseconds() - exMutable.holdingTime.startCountingFeedbackTime).toFloat() / 1000
            if (timeInterval>=ExConstants.holdingTime.feedbackMinTimeInterval){
                TTStext = text
                exMutable.holdingTime.startCountingFeedbackTime = Clock.System.now().toEpochMilliseconds()
                exMutable.constants.prevFeedbackmsg=text
            }
        }
        else if (text!=exMutable.constants.prevFeedbackmsg){
            TTStext = text
            exMutable.holdingTime.startCountingFeedbackTime = Clock.System.now().toEpochMilliseconds()
            exMutable.constants.prevFeedbackmsg = text
        }
        exMutable.constants.isFeedback = Feedback
        exMutable.constants.TTStext = TTStext
        //tts.speak(TTStext, QUEUE_ADD, null)

        return exMutable
    }


}