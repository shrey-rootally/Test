package com.rootallyai.allycarebl

import kotlinx.datetime.Clock
import kotlin.math.*
object ExerciseUtility {

    fun reset(exMutable: ExMutable): ExMutable {
        /**
        Function used to reset all holding time calculation section
        exMutable: ExMutable data class
        Return : Updated ExMutable data class
        the function internally resets the variable value
         */
        exMutable.flags.holdTime = false
        exMutable.holdingTime.count = 0
        exMutable.holdingTime.time = 0f
        exMutable.holdingTime.startTime = Clock.System.now().toEpochMilliseconds()
        exMutable.flags.isSit = false
        exMutable.holdingTime.countSit = 0
        exMutable.holdingTime.timeStanding = 0f
        exMutable.flags.startTime = false
        return exMutable
    }

    fun isInside(circleX: Float, circleY: Float, radius: Float, x: Float, y: Float): Boolean {
        /** Function is used to check current x,y value is within the circle.
        circleX,circleY : center of the circle with its x and y coordinate value
        x,y: Coordinates of the data point
        Return : Boolean variable true if point lies inside te circle else false
         */
        if ((x - circleX) * (x - circleX) + (y - circleY) * (y - circleY) <= radius * radius) {
            return true
        }
        return false
    }

    fun unsuccessfullRepCount(exMutable: ExMutable): ExMutable {
        /**
        Function used to count unsuccessful rep
        exMutable: ExMutable data class
        Return : Updated ExMutable data class
        The function internally updates the unsuccessful rep count
        unsuccessHold : A list which holds all unsuccessfull holding time for one cycle of rep.
         */
        if (exMutable.holdingTime.unsuccessHold.size != 0) {
            exMutable.reps.unsucessRep += 1
        }
        exMutable.holdingTime.unsuccessHold.clear()
        exMutable.flags.rep = false
        exMutable.flags.baseCondition = true
        exMutable.flags.feedbackFlagBaseCondition = 0

        return exMutable
    }

    fun countHoldTime(exMutable: ExMutable, counter: RepetitionCounter, fastTrack: Boolean = false, prompt: String = " ", message: String = " ", repeatTimeThreshold: Float = ExConstants.holdingTime.minRepeatTime): ExMutable { // function to initiate holding time count
        /**
        Function is used to count holding time
        counter : RepetitionCounter class used to run onRep function
        fastTrack : Boolean variable used to allow fast tracking ( speed movement detection)
        prompt  : String used for standard prompt
        message : string used to provide real time feedback
        repeatTimeThreshold : Time limit to detect fast tracking
        exMutable: ExMutable data class
        Return : Updated ExMutable data class
         */

        var tempexMutable = exMutable

        tempexMutable.constants.isFluctuation = false
        if (!tempexMutable.flags.startTime) {
            tempexMutable.holdingTime.startTime = Clock.System.now().toEpochMilliseconds()
            tempexMutable.flags.startTime = true
        }
        tempexMutable.holdingTime.presentTime = Clock.System.now().toEpochMilliseconds()

        if ((abs(tempexMutable.holdingTime.presentTime - tempexMutable.holdingTime.previousTime).toFloat() / 1000) <repeatTimeThreshold && tempexMutable.flags.feedbackRepeat == 0 && fastTrack) {
            tempexMutable = counter.onRep(tempexMutable, ExConstants.feedbacks.msgRepeat)
            tempexMutable.flags.baseCondition = true
            tempexMutable.flags.feedbackRepeat = 1
            tempexMutable.flags.rep = true
            tempexMutable.flags.stand = false
            tempexMutable.flags.isSit = false
        } else if ((abs(tempexMutable.holdingTime.presentTime - tempexMutable.holdingTime.previousTime).toFloat() / 1000) >= repeatTimeThreshold || !fastTrack) {
            if (tempexMutable.holdingTime.count > 0) {
                tempexMutable = resetFeedback(tempexMutable)
            }
            tempexMutable = resetFeedback(tempexMutable)
            if (tempexMutable.holdingTime.time >= ExConstants.holdingTime.firstMsgMinTime && !tempexMutable.flags.firstMsg) {
                tempexMutable = counter.onRep(tempexMutable, prompt + message + tempexMutable.holdingTime.minimumHoldTime.toString() + " seconds", Feedback = false)
                tempexMutable.flags.firstMsg = true
            }
            tempexMutable.flags.holdTime = true // counting the holding time
            val endTime = Clock.System.now().toEpochMilliseconds()
            val elapsedTime: Float = ((endTime.minus(exMutable.holdingTime.startTime)) / 1000).toFloat()
            tempexMutable.holdingTime.time = elapsedTime
            tempexMutable.holdingTime.count = tempexMutable.holdingTime.time.toInt()
//            ExConstants.holdingTime.startTime = endTime
            tempexMutable.flags.isSit = false
        }
        return tempexMutable
    }

    fun unsuccessfullTimeCount(exMutable: ExMutable): ExMutable {
        /**
        Function used to append holding times to list for one cycle of rep.
        It adds all holding times to a mutable list
        exMutable: ExMutable data class
        Return : Updated ExMutable data class
         */
        if (exMutable.holdingTime.count > exMutable.holdingTime.unsuccessTime && !exMutable.flags.rep) {
            exMutable.holdingTime.unsuccessHold.add(exMutable.holdingTime.count)
        }
        return exMutable
    }

    fun BaseConditionTimeInterval(exMutable: ExMutable, isRep: Boolean, time: Long): ExMutable {
        /**
        Function used to calculate the time interval between 2 successive base condition satisfaction frames.
        isRep: Boolean variable true indicates successful rep
        time: Current time
        exMutable: ExMutable data class
        Return : Updated ExMutable data class
        If the time between 2 frames satisfying the base condition is more than 5 secs and isRep is false then consider the rep as unsucccesful rep
         */
        if (time - Clock.System.now().toEpochMilliseconds() > ExConstants.holdingTime.unsuccessfullrepLimit && !isRep && exMutable.reps.successRep> 0) {
            exMutable.holdingTime.unsuccessHold.add(ExConstants.limits.isUnsucessfulTime)
        }
        return exMutable
    }

    fun isRightSide(rightHip: Float, leftHip: Float): Boolean {
        /*
        Function to check which side the user is performing the exercise (right/ left side)
        rightHip: z value of right hip
        leftHip : z value of left hip
        return: Boolean value true indicates the user is in right side.
         */
        return rightHip < leftHip
    }

    fun timeCalculation(exMutable: ExMutable): ExMutable {
        /*
        Function used to actuate the time, and based on this time the feedbacks are triggred
        exMutable: ExMutable data class
        Return : Updated ExMutable data class
       Used to avoid the conflict of triggering of both feedbacks simultaneously.
         */

        if (exMutable.limits.limit == 1) {
            exMutable.holdingTime.beginTime = Clock.System.now().toEpochMilliseconds()
        } else if (exMutable.limits.limit > 1) {
            exMutable.holdingTime.totalTime = (Clock.System.now().toEpochMilliseconds() - (exMutable.holdingTime.beginTime)).toFloat() / 1000
        }
        return exMutable
    }

    fun timeCountFluctuationRemoval(exMutable: ExMutable): ExMutable {
        /*
        Function used to create a lag of 0.6 seconds
        exMutable: ExMutable data class
        Return : Updated ExMutable data class
        Used to avoid unnecessary feedback trigger due to fluctuation
         */

        if (!exMutable.constants.isFluctuation) {
            exMutable.holdingTime.BeginCounting = Clock.System.now().toEpochMilliseconds()
            exMutable.constants.isFluctuation = true
        }
        val totTime: Float = (Clock.System.now().toEpochMilliseconds() - exMutable.holdingTime.BeginCounting).toFloat() / 1000
        exMutable.holdingTime.flucTotTime = totTime
        return exMutable
    }

    fun successfullRepCount(exMutable: ExMutable, counter: RepetitionCounter, count: Int, base: Boolean = true): ExMutable {
        /*
        Function used  to count successful rep count
        counter: RepetitionCounter class
        count: Holding time count
        base : Boolean variable used in rep count for sit to stand exercise
        exMutable: ExMutable data class
        Return : Updated ExMutable data class
        After successful rep count, all the variables related to holding time gets reset.
         */
        var tempexMutable = exMutable
        if ((tempexMutable.reps.successRep + tempexMutable.reps.unsucessRep) == ExConstants.limits.firstRep && !tempexMutable.flags.secondRepMsg) {
            tempexMutable = counter.onRep(tempexMutable, ExConstants.feedbacks.msgRepeatEx, Feedback = false)
            tempexMutable.flags.secondRepMsg = true
        }
        if ((count >= tempexMutable.holdingTime.minimumHoldTime) && !tempexMutable.flags.rep && base) {
            print("successfullRepCount count :" + count)
            tempexMutable.reps.successRep += 1
            tempexMutable = counter.onRep(tempexMutable, tempexMutable.reps.successRep.toString(), Feedback = false)
            tempexMutable.flags.holdTime = false
            tempexMutable = reset(tempexMutable)
            tempexMutable.holdingTime.unsuccessHold.clear()
            tempexMutable = resetFeedback(tempexMutable)
            tempexMutable.flags.rep = true
            tempexMutable.flags.stand = false
        } else if (!base) {
            tempexMutable.reps.successRep += 1
            tempexMutable = counter.onRep(tempexMutable, tempexMutable.reps.successRep.toString())
            tempexMutable.flags.holdTime = false
            tempexMutable.flags.rep = true
            tempexMutable.flags.stand = false
            tempexMutable.flags.isSit = false
        }
        return tempexMutable
    }

    fun resetFeedback(exMutable: ExMutable): ExMutable {
        /*
        Function to reset all feedback flag variable
        exMutable: ExMutable data class
        Return : Updated ExMutable data class
        Internally resets all feedback related variables
        */
        exMutable.flags.feedbackFlag = 0
        exMutable.flags.feedbackFlag1 = 0
        exMutable.flags.feedbackFlag2 = 0
        exMutable.flags.feedbackFlag3 = 0
//        ExConstants.flags.feedbackFlag4 = 0
        exMutable.flags.feedbackRepeat = 0
        return exMutable
    }

    fun resetVar(exMutable: ExMutable): ExMutable {
        /*
        Function to reset all variables before starting the exercise
        exMutable: ExMutable data class
        Return : Updated ExMutable data class
        Internally resets all mutable variables before starting exercise
         */
        exMutable.flags.feedbackFlag = 0
        exMutable.flags.feedbackFlag1 = 0
        exMutable.flags.feedbackFlag2 = 0
        exMutable.flags.feedbackFlag3 = 0
        exMutable.flags.feedbackFlag4 = 0
        exMutable.flags.feedbackRepeat = 0
        exMutable.flags.feedbackFlagBaseCondition = 0
        exMutable.flags.flags = false
        exMutable.flags.handExtension = false
        exMutable.flags.optiRange = false
        exMutable.flags.rep = true
        exMutable.flags.holdTime = false
        exMutable.flags.baseCondition = true
        exMutable.limits.lowerRange = 0f
        exMutable.limits.frame = 0
        exMutable.limits.limit = 0
        exMutable.limits.distBwtHands = 0f
        exMutable.limits.distBwtHandsExtension = 0f
        exMutable.limits.exerciseType = ""
        exMutable.limits.legLength = 0f
        exMutable.limits.radius = 0f
        exMutable.limits.bodyRange = 0f
        exMutable.holdingTime.count = 0 // variable to count holding time
        exMutable.holdingTime.countStanding = 0 // variable to count standing time
        exMutable.holdingTime.currentTime = 0f
        exMutable.holdingTime.sitRightLeg = 0f // variable to hold the length of thigh while sitting(hip-knee)
        exMutable.holdingTime.sitLeftLeg = 0f
        exMutable.holdingTime.startTime = Clock.System.now().toEpochMilliseconds()
        exMutable.holdingTime.BeginCounting = Clock.System.now().toEpochMilliseconds()
        exMutable.holdingTime.baseConditionTime = Clock.System.now().toEpochMilliseconds()
        exMutable.holdingTime.time = 0f // variables  to hold time between 2 frames
        exMutable.flags.startTime = false
        exMutable.holdingTime.timeStanding = 0f
        exMutable.holdingTime.unsuccessHold = arrayListOf()
        exMutable.holdingTime.speed = arrayListOf()
        exMutable.reps.successRep = 0 // variable to hold successful rep
        exMutable.reps.unsucessRep = 0
        exMutable.constants.lift = arrayListOf()
        exMutable.constants.elbowLeft = arrayListOf()
        exMutable.constants.elbowRight = arrayListOf()
        exMutable.constants.currentExercise = ""
        exMutable.constants.majorChange = 0
        exMutable.constants.rightHipValueX = 0f
        exMutable.constants.leftHipValueX = 0f
        exMutable.limits.topValue = 1f
        exMutable.limits.upperRangeY = 0f
        exMutable.limits.topValue = 1f
        exMutable.limits.limitCalib = 0
        exMutable.holdingTime.msgCount = 1
        exMutable.flags.isSit = false
        exMutable.flags.stand = false
        exMutable.holdingTime.countSit = 0
        exMutable.holdingTime.totalTime = 0f
        exMutable.holdingTime.beginTime = 0
        exMutable.flags.firstMsg = false
        exMutable.flags.firstSitMsg = false
        exMutable.flags.firstStandMsg = false
        exMutable.flags.firstStageMsg = false
        exMutable.constants.lowestRange = 0
        exMutable.constants.highestRange = 0
        exMutable.constants.averageRange = 0
        exMutable.constants.frameCount = 0
        exMutable.constants.dataSum = 0
        exMutable.constants.anklePoint = 0f
        exMutable.constants.prevFeedbackmsg = ""
        exMutable.constants.shoulderPoint = 0f
        exMutable.constants.TTStext = ""
        exMutable.constants.isFeedback = false
        exMutable.constants.isFluctuation = false
        exMutable.flags.legLift = false
        exMutable.flags.legliftBase = false
        exMutable.flags.secondRepMsg = false
        return exMutable
    }


    fun hipCoordinates(idxToCoordinates: MutableMap<Int, HashMap<String, Float>>): HashMap<String, HashMap<String, Float>> {
        /**
        Function to extract/filter only hip coordinate values
        idxToCoordinates : A filtered hashmap with body indices (Int) as key and its corresponding coordinate value as values
        ex : idxToCoordinates= {1:{x:0.2,y:0.3,z:0.97},2:[x:0.6,y:0.97,z:0.44],3:[x:0.87,y:0.88,z:0.66].........}
        Return :  {RightHip:{x,y,z},LeftHip:{x,y,z}}
         */

        val hipLdMarks: HashMap<String, HashMap<String, Float>> = HashMap()
        hipLdMarks.put("RightHip", HashMap())
        hipLdMarks.put("LeftHip", HashMap())

        if (ExConstants.landmarksBody.hipRight in idxToCoordinates.keys && ExConstants.landmarksBody.hipLeft in idxToCoordinates.keys) {
            hipLdMarks.put("RightHip", idxToCoordinates[ExConstants.landmarksBody.hipRight]!!)
            hipLdMarks.put("LeftHip", idxToCoordinates[ExConstants.landmarksBody.hipLeft]!!)
        }
        return hipLdMarks
    }

    fun legCoordinates(idxToCoordinates: MutableMap<Int, HashMap<String, Float>>): HashMap<String, HashMap<String, HashMap<String, Float>>> {
        /**
        Function to extract/filter only hip coordinate values
        idxToCoordinates : A filtered hashmap with body indices (Int) as key and its corresponding coordinate value as values
        ex : idxToCoordinates {1:{x:0.2,y:0.3,z:0.97},2:[x:0.6,y:0.97,z:0.44],3:[x:0.87,y:0.88,z:0.66].........}
        Return :  {RightLeg:{Hip,Knee,Ankle},LeftLeg:{Hip,Knee,Ankle}}
        Hip: {x:0.3,y,0.9,z:0.2}
         */
        val x: HashMap<String, HashMap<String, HashMap<String, Float>>> = HashMap()
        x.put("RightLeg", HashMap())
        x.put("LeftLeg", HashMap())
        if (ExConstants.landmarksBody.hipRight in idxToCoordinates.keys && ExConstants.landmarksBody.kneeRight in idxToCoordinates.keys && ExConstants.landmarksBody.ankleRight in idxToCoordinates.keys) {
            x["RightLeg"]?.put("Hip", idxToCoordinates[ExConstants.landmarksBody.hipRight]!!)
            x["RightLeg"]?.put("Knee", idxToCoordinates[ExConstants.landmarksBody.kneeRight]!!)
            x["RightLeg"]?.put("Ankle", idxToCoordinates[ExConstants.landmarksBody.ankleRight]!!)
        }
        if (ExConstants.landmarksBody.hipLeft in idxToCoordinates.keys && ExConstants.landmarksBody.kneeLeft in idxToCoordinates.keys && ExConstants.landmarksBody.ankleLeft in idxToCoordinates.keys) {
            x["LeftLeg"]?.put("Hip", idxToCoordinates[ExConstants.landmarksBody.hipLeft]!!)
            x["LeftLeg"]?.put("Knee", idxToCoordinates[ExConstants.landmarksBody.kneeLeft]!!)
            x["LeftLeg"]?.put("Ankle", idxToCoordinates[ExConstants.landmarksBody.ankleLeft]!!)
        }
        return x
    }

    fun shoulderCoordinates(idxToCoordinates: MutableMap<Int, HashMap<String, Float>>): HashMap<String, HashMap<String, HashMap<String, Float>>> {
        /**
        Function to find shoulder closeness. For example consider front shoulder(closer to camera for sideways capturing) as Front hand and rear side as RearHand
        idxToCoordinates : A filtered hashmap with body indices (Int) as key and its corresponding coordinate value as values
        Example : idxToCoordinates= {1:{x:0.2,y:0.3,z:0.97},2:[x:0.6,y:0.97,z:0.44],3:[x:0.87,y:0.88,z:0.66].........}
        Return : {FrontHand: {shoulder,elbow,wrist},RearHand: {shoulder,elbow,wrist}}
        shoulder: {x:0.3,y,0.9,z:0.2}
         */

        val x: HashMap<String, HashMap<String, HashMap<String, Float>>> = HashMap()
        x.put("FrontHand", HashMap())
        x.put("RearHand", HashMap())
        x.put("Hip", HashMap())

        if (ExConstants.landmarksBody.shoulderLeft in idxToCoordinates.keys && ExConstants.landmarksBody.shoulderRight in idxToCoordinates.keys) {
            val rightShoulder = idxToCoordinates[ExConstants.landmarksBody.shoulderRight]!!["z"]
            val leftShoulder = idxToCoordinates[ExConstants.landmarksBody.shoulderLeft]!!["z"]
            if (rightShoulder != null) {
                if (rightShoulder < leftShoulder!!) {
                    x["FrontHand"]?.put("Shoulder", idxToCoordinates[ExConstants.landmarksBody.shoulderRight]!!)
                    x["RearHand"]?.put("Shoulder", idxToCoordinates[ExConstants.landmarksBody.shoulderLeft]!!)

                    if (ExConstants.landmarksBody.elbowRight in idxToCoordinates.keys && ExConstants.landmarksBody.wristRight in idxToCoordinates.keys) {
                        x["FrontHand"]?.put("Elbow", idxToCoordinates[ExConstants.landmarksBody.elbowRight]!!)
                        x["FrontHand"]?.put("Wrist", idxToCoordinates[ExConstants.landmarksBody.wristRight]!!)
                    }
                    if (ExConstants.landmarksBody.elbowLeft in idxToCoordinates.keys && ExConstants.landmarksBody.wristLeft in idxToCoordinates.keys) {
                        x["RearHand"]?.put("Elbow", idxToCoordinates[ExConstants.landmarksBody.elbowLeft]!!)
                        x["RearHand"]?.put("Wrist", idxToCoordinates[ExConstants.landmarksBody.wristLeft]!!)
                    }
                    if (ExConstants.landmarksBody.hipRight in idxToCoordinates.keys && ExConstants.landmarksBody.hipLeft in idxToCoordinates.keys) {
                        x["Hip"]?.put("FrontHip", idxToCoordinates[ExConstants.landmarksBody.hipRight]!!)
                        x["Hip"]?.put("RearHip", idxToCoordinates[ExConstants.landmarksBody.hipLeft]!!)
                    }
                } else if (leftShoulder < rightShoulder) {

                    x["FrontHand"]?.put("Shoulder", idxToCoordinates[ExConstants.landmarksBody.shoulderLeft]!!)
                    x["RearHand"]?.put("Shoulder", idxToCoordinates[ExConstants.landmarksBody.shoulderRight]!!)
                    if (ExConstants.landmarksBody.elbowRight in idxToCoordinates.keys && ExConstants.landmarksBody.wristRight in idxToCoordinates.keys) {
                        x["RearHand"]?.put("Elbow", idxToCoordinates[ExConstants.landmarksBody.elbowRight]!!)
                        x["RearHand"]?.put("Wrist", idxToCoordinates[ExConstants.landmarksBody.wristRight]!!)
                    }
                    if (ExConstants.landmarksBody.kneeLeft in idxToCoordinates.keys && ExConstants.landmarksBody.wristLeft in idxToCoordinates.keys) {
                        x["FrontHand"]?.put("Elbow", idxToCoordinates[ExConstants.landmarksBody.elbowLeft]!!)
                        x["FrontHand"]?.put("Wrist", idxToCoordinates[ExConstants.landmarksBody.wristLeft]!!)
                    }
                    if (ExConstants.landmarksBody.hipRight in idxToCoordinates.keys && ExConstants.landmarksBody.hipLeft in idxToCoordinates.keys) {
                        x["Hip"]?.put("FrontHip", idxToCoordinates[ExConstants.landmarksBody.hipLeft]!!)
                        x["Hip"]?.put("RearHip", idxToCoordinates[ExConstants.landmarksBody.hipRight]!!)
                    }
                }
            }
        }
        return x
    }

    fun checkRequiredCoordinates(exMutable: ExMutable, counter: RepetitionCounter, inputConditions: List<Boolean>, message: String): ExMutable {
        /**
        Function to check whether all required body coordinates are present or not..
        counter : Inputting repetition class to call onRep function (to trigger feedbacks)
        inputConditions : list with boolean values where each value represent the condition satisfication ( all leg coordinates length ==3 then the value will be true else false)
        exMutable: ExMutable a data class
        return: Updated data class (internally triggers feedback)
         */
        var tempvar = exMutable
        if (inputConditions.contains(true)) {
            tempvar.limits.limit = 0
            tempvar.limits.frame += 1
//            ExConstants.holdingTime.startTime = SystemClock.elapsedRealtime()
            if (tempvar.limits.frame > ExConstants.limits.frameThresh) {
                tempvar.limits.frame = 0
                tempvar = counter.onRep(tempvar, text = message)
                tempvar = reset(tempvar)
            }
        }
        return tempvar
    }

    fun shoulderLandmarks(idxToCoordinates: MutableMap<Int, HashMap<String, Float>>): HashMap<String, HashMap<String, HashMap<String, Float>>> {
        /**
        Function to extract/filter only hip,face and both hands coordinate values
        idxToCoordinates : A filtered hashmap with body indices (Int) as key and its corresponding coordinate value as values
        ex : idxToCoordinates= {1:{x:0.2,y:0.3,z:0.97},2:[x:0.6,y:0.97,z:0.44],3:[x:0.87,y:0.88,z:0.66].........}
        Return :  {RightHand:{shoulder,elbow,wrist},LeftHand:{shoulder,elbow,wrist},Hip:{hipRight,hipLeft},Face:{earRight,earLeft}}
        shoulderRight:[x,y,z] (x,y and z values)
         */
        val x: HashMap<String, HashMap<String, HashMap<String, Float>>> = HashMap()
        x.put("RightHand", HashMap())
        x.put("LeftHand", HashMap())
        x.put("Hip", HashMap())
        x.put("Face", HashMap())
        if (ExConstants.landmarksBody.shoulderRight in idxToCoordinates.keys && ExConstants.landmarksBody.elbowRight in idxToCoordinates.keys && ExConstants.landmarksBody.wristRight in idxToCoordinates.keys) {
            x["RightHand"]?.put("Shoulder", idxToCoordinates[ExConstants.landmarksBody.shoulderRight]!!)
            x["RightHand"]?.put("Elbow", idxToCoordinates[ExConstants.landmarksBody.elbowRight]!!)
            x["RightHand"]?.put("Wrist", idxToCoordinates[ExConstants.landmarksBody.wristRight]!!)
        }
        if (ExConstants.landmarksBody.shoulderLeft in idxToCoordinates.keys && ExConstants.landmarksBody.elbowLeft in idxToCoordinates.keys && ExConstants.landmarksBody.wristLeft in idxToCoordinates.keys) {
            x["LeftHand"]?.put("Shoulder", idxToCoordinates[ExConstants.landmarksBody.shoulderLeft]!!)
            x["LeftHand"]?.put("Elbow", idxToCoordinates[ExConstants.landmarksBody.elbowLeft]!!)
            x["LeftHand"]?.put("Wrist", idxToCoordinates[ExConstants.landmarksBody.wristLeft]!!)
        }
        if (ExConstants.landmarksBody.hipRight in idxToCoordinates.keys && ExConstants.landmarksBody.hipLeft in idxToCoordinates.keys) {
            x["Hip"]?.put("RightHip", idxToCoordinates[ExConstants.landmarksBody.hipRight]!!)
            x["Hip"]?.put("LeftHip", idxToCoordinates[ExConstants.landmarksBody.hipLeft]!!)
        }
        if (ExConstants.landmarksBody.earRight in idxToCoordinates.keys && ExConstants.landmarksBody.earLeft in idxToCoordinates.keys) {
            x["Face"]?.put("RightEar", idxToCoordinates[ExConstants.landmarksBody.earRight]!!)
            x["Face"]?.put("LeftEar", idxToCoordinates[ExConstants.landmarksBody.earLeft]!!)
        }

        return x
    }

    fun legClossness(idxToCoordinates: MutableMap<Int, HashMap<String, Float>>): HashMap<String, HashMap<String, HashMap<String, Float>>> {
        /**
        Function to find leg closeness. For example consider front leg(closer to camera for sideways capturing) as FrontLeg and rear leg as RearLeg
        idxToCoordinates : A filtered hashmap with body indices (Int) as key and its corresponding coordinate value as values
        Example : idxToCoordinates= {1:{x:0.2,y:0.3,z:0.97},2:[x:0.6,y:0.97,z:0.44],3:[x:0.87,y:0.88,z:0.66].........}
        Return : {frontLeg: {Hip,Knee,Ankle},RearLeg: {Hip,Knee,Ankle}}
        Hip: {x:0.3,y,0.9,z:0.2}
         */
        val x: HashMap<String, HashMap<String, HashMap<String, Float>>> = HashMap<String, HashMap<String, HashMap<String, Float>>>()
        x.put("FrontLeg", HashMap())
        x.put("RearLeg", HashMap())
        if (ExConstants.landmarksBody.hipLeft in idxToCoordinates.keys && ExConstants.landmarksBody.hipRight in idxToCoordinates.keys) {
            val rightHip = idxToCoordinates[ExConstants.landmarksBody.hipRight]!!["z"]
            val leftHip = idxToCoordinates[ExConstants.landmarksBody.hipLeft]!!["z"]
            if (rightHip != null) {
                if (rightHip < leftHip!!) {
                    x["FrontLeg"]?.put("Hip", idxToCoordinates[ExConstants.landmarksBody.hipRight]!!)
                    x["RearLeg"]?.put("Hip", idxToCoordinates[ExConstants.landmarksBody.hipLeft]!!)
                    if (ExConstants.landmarksBody.kneeRight in idxToCoordinates.keys && ExConstants.landmarksBody.ankleRight in idxToCoordinates.keys) {
                        x["FrontLeg"]?.put("Knee", idxToCoordinates[ExConstants.landmarksBody.kneeRight]!!)
                        x["FrontLeg"]?.put("Ankle", idxToCoordinates[ExConstants.landmarksBody.ankleRight]!!)
                    }
                    if (ExConstants.landmarksBody.kneeLeft in idxToCoordinates.keys && ExConstants.landmarksBody.ankleLeft in idxToCoordinates.keys) {
                        x["RearLeg"]?.put("Knee", idxToCoordinates[ExConstants.landmarksBody.kneeLeft]!!)
                        x["RearLeg"]?.put("Ankle", idxToCoordinates[ExConstants.landmarksBody.ankleLeft]!!)
                    }
                } else if (leftHip < rightHip) {

                    x["FrontLeg"]?.put("Hip", idxToCoordinates[ExConstants.landmarksBody.hipLeft]!!)
                    x["RearLeg"]?.put("Hip", idxToCoordinates[ExConstants.landmarksBody.hipRight]!!)
                    if (ExConstants.landmarksBody.kneeRight in idxToCoordinates.keys && ExConstants.landmarksBody.ankleRight in idxToCoordinates.keys) {
                        x["RearLeg"]?.put("Knee", idxToCoordinates[ExConstants.landmarksBody.kneeRight]!!)
                        x["RearLeg"]?.put("Ankle", idxToCoordinates[ExConstants.landmarksBody.ankleRight]!!)
                    }
                    if (ExConstants.landmarksBody.kneeLeft in idxToCoordinates.keys && ExConstants.landmarksBody.ankleLeft in idxToCoordinates.keys) {
                        x["FrontLeg"]?.put("Knee", idxToCoordinates[ExConstants.landmarksBody.kneeLeft]!!)
                        x["FrontLeg"]?.put("Ankle", idxToCoordinates[ExConstants.landmarksBody.ankleLeft]!!)
                    }
                }
            }
        }
        return x
    }

    fun bodyCoordinates(idxToCoordinates: MutableMap<Int, HashMap<String, Float>>): HashMap<String, HashMap<String, Float>> {
        /**
        Function to filter/extract only shoulder and nose keypoint
        idxToCoordinates : A filtered hashmap with body indices (Int) as key and its corresponding coordinate value as values
        Example : idxToCoordinates= {1:{x:0.2,y:0.3,z:0.97},2:[x:0.6,y:0.97,z:0.44],3:[x:0.87,y:0.88,z:0.66].........}
        Return : {frontShoulder,RearShoulder,Nose}
        frontShoulder : {x:0.3,y,0.9,z:0.2}
         */
        val ldMarks: HashMap<String, HashMap<String, Float>> = HashMap<String, HashMap<String, Float>>()
        ldMarks.put("FrontShoulder", HashMap())
        ldMarks.put("RearShoulder", HashMap())
        ldMarks.put("Nose", HashMap())
        if (ExConstants.landmarksBody.shoulderRight in idxToCoordinates.keys && ExConstants.landmarksBody.shoulderLeft in idxToCoordinates.keys && ExConstants.landmarksBody.nose in idxToCoordinates.keys) {
            val rightShoulder = idxToCoordinates[ExConstants.landmarksBody.shoulderRight]!!["z"]
            val leftShoulder = idxToCoordinates[ExConstants.landmarksBody.shoulderLeft]!!["z"]
            if (rightShoulder != null) {
                if (rightShoulder > leftShoulder!!) {
                    ldMarks.put("FrontShoulder", idxToCoordinates[ExConstants.landmarksBody.shoulderLeft]!!)
                    ldMarks.put("RearShoulder", idxToCoordinates[ExConstants.landmarksBody.shoulderRight]!!)
                } else {
                    ldMarks.put("FrontShoulder", idxToCoordinates[ExConstants.landmarksBody.shoulderRight]!!)
                    ldMarks.put("RearShoulder", idxToCoordinates[ExConstants.landmarksBody.shoulderLeft]!!)
                }
            }
            ldMarks.put("Nose", idxToCoordinates[ExConstants.landmarksBody.nose]!!)
        }
        return ldMarks
    }

    fun angle3D(lists: List<List<Float>>): Int {
        /**
        Function to calculate angle between 3 keypoints with 3 coordinates (x and y and z)
        a: A hash map with x,y and z value of particular data point 1
        b: A hash map with x,y and z value of particular data point 2
        c: A hash map with x,y and z value of particular data point 3
        return:  angle value
         */
        val a1 = arrayOf(lists[0][0], lists[0][1], lists[0][2])
        val b1 = arrayOf(lists[1][0], lists[1][1], lists[1][2])
        val c1 = arrayOf(lists[2][0], lists[2][1], lists[2][2])
        val ba1 = arrayOf(a1[0] - b1[0], a1[1] - b1[1], a1[2] - b1[2])
        val bc1 = arrayOf(c1[0] - b1[0], c1[1] - b1[1], c1[2] - b1[2])
        val dot = ba1[0] * bc1[0] + ba1[1] * bc1[1]
        val norm = sqrt(ba1[0].pow(2) + ba1[1].pow(2) + ba1[2].pow(2)) * sqrt(bc1[0].pow(2) + bc1[1].pow(2) + bc1[2].pow(2))
        val cosineAngle = acos(dot / norm) * (180.0 / PI)
        return cosineAngle.toInt()
    }

    fun angle2D(a: HashMap<String, Float>, b: HashMap<String, Float>, c: HashMap<String, Float>): Int {
        /**
        Function to calculate angle between 3 keypoints with 2 coordinates (x and y)
        a: A hash map with x,y and z value of particular data point 1
        b: A hash map with x,y and z value of particular data point 2
        c: A hash map with x,y and z value of particular data point 3
        return:  angle value
         */
        val a1 = arrayOf(a["x"], a["y"])
        val b1 = arrayOf(b["x"], b["y"])
        val c1 = arrayOf(c["x"], c["y"])
        val ba1 = arrayOf(a1[0]?.minus(b1[0]!!), a1[1]?.minus(b1[1]!!))
        val bc1 = arrayOf(c1[0]?.minus(b1[0]!!), c1[1]?.minus(b1[1]!!))
        val dot = ba1[0]!! * bc1[0]!! + ba1[1] !! * bc1[1]!!
        val norm = sqrt(ba1[0]!!.pow(2) + ba1[1]!!.pow(2)) * sqrt(bc1[0]!!.pow(2) + bc1[1]!!.pow(2))
        val cosineAngle = acos(dot / norm) * (180.0 / PI)
        return cosineAngle.toInt()
    }

    fun duplicateLandmark():HashMap<String, HashMap<String, HashMap<String, Float>>>{
        val x: HashMap<String, HashMap<String, HashMap<String, Float>>> = HashMap<String, HashMap<String, HashMap<String, Float>>>()
        x.put("FrontLeg", HashMap())
        x.put("RearLeg", HashMap())
        val dataPoint: HashMap<String, Float> = HashMap()
        dataPoint.put("x", 0f)
        dataPoint.put("y", 0f)
        dataPoint.put("z", 0f)
        x["FrontLeg"]!!.put("Hip", dataPoint)
        x["FrontLeg"]!!.put("Knee",dataPoint)
        x["FrontLeg"]!!.put("Ankle", dataPoint)
        x["RearLeg"]!!.put("Hip",dataPoint)
        x["RearLeg"]!!.put("Knee", dataPoint)
        x["RearLeg"]!!.put("Ankle",dataPoint)
        return x
    }

    fun angleRangeCalculation(exMutable: ExMutable, ROMangle: Int): ExMutable {
        /**
        Function to calculate angle range values
        angle : Body keypoint angle ex-(HKA angle, HES angle etc)
        exMutable : ExMutable data class with all mutable variables
        return: Updated data class .This function is used to internally update the variable values(range of motion values)
         */
        val angle = ROMangle
        if (exMutable.constants.lowestRange == 0) {
            exMutable.constants.lowestRange = angle
        }
        exMutable.constants.lowestRange = minOf(exMutable.constants.lowestRange, angle)
        exMutable.constants.highestRange = maxOf(exMutable.constants.highestRange, angle)
        exMutable.constants.frameCount += 1
        exMutable.constants.dataSum += angle
        exMutable.constants.averageRange = exMutable.constants.dataSum / exMutable.constants.frameCount
        return exMutable
    }
}