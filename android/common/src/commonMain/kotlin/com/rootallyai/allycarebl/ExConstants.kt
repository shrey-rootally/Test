package com.rootallyai.allycarebl
import kotlinx.datetime.Clock

object ExConstants {
    object angle {
        val angleShoulderLower = 70 // Hip-shoulder-elbow angle lower limit
        val angleShoulderUpper = 130 // Hip-shoulder-elbow angle Upper limit
        val backAngleLowRange = 80 // back angle limit for low range exercise (for straight standing it should be 90 degree)
        val backAngleUpperRange = 110 // back angle limit for low range exercise
        val backAngleUpper = 90 // back angle shoulder point and hip point upper limit
        val backAngleLower = 60 // back angle shoulder point and hip point lower limit
        val backAngleLimitSquat = 60
        val seatedBackAngleUpper = 90 // back angle shoulder point and hip point upper limit
        val seatedBackAngleLower = 70 // back angle shoulder point and hip point lower limit
        val hkaStraight = 160 // hip knee angle angle while leg is straight
        val hkaStraightQuad = 165
        val sitAngle = 140 // angle used to make sure the user is in seated position (used to avoid algo fooling)
        val hkaBendTowel = 135 // hka bent angle for knee bend task
        val hka = 150 // hka angle for seated knee extension
        val hkaInnerQuad = 140
        val hkaAtraightLegRAise = 120
        val hkaSeatedStraightLeg = 120
        val hkabase = 140 // used in seated knee extension to satisfy base condition
        val hkaBend = 90 // hka bend angle for sit stand,seated knee,squat exercises
        val hkaBendFeedBack = 110
        val hkaSitBend = 120 // sit
        val sitBendAngle = 130
        val standBendAngle = 150
        val hkaStandAngle = 110
        val hkaKneeBend = 140
        val hkaStraightHamstring = 120
        val hkaSeatedBend = 120 // seated knee bend angle
        val hkaBendLunge = 100 // hka bend angle for static lunge angle
        val hesStraight = 150 // shoulder,elbow,wrist angle for straight hand
        val hesStraightHand = 140
        val hesBend = 100 // hes angle for bent elbow
        val hesBend90Abduction = 120
        val minhesBend = 75
        val layDownAngle = 25 // lay down on floor angle (hip to shoulder line should be parallel to floor).So 25 degree is allowed
        val minHESbend = 45 // minimum hes angle for shoulder external and internal exercise
        val minSSEbend = 70 // shoulder-shoulder-elbow angle limit
        val maxHesBendLift = 150 // max hes angle while lifiting the hands for shoulder flex external task.
        val sseStraight = 150
        val sseAbductionBase = 115
        val sseStraightAbduction = 120
        val sseAngleLower = 100
        val maxlungeAngle = 120 // lunge angle for static lunge exercise,  (front knee -front hip - rear knee angle)
        val sseBend = 110 // shoulder- shoulder - elbow bend angle range
        val sseBendLowerLimit = 85
        val sseShoulderPress = 130
        val sseBendFeedbackLimit = 110
        val legLiftLowerLimitAngle = 10 // these are lower and upper limit angle for leg raise task (hip-ankle line with respect to floor)
        val legLiftUpperLimitAngle = 70
        val legLiftBaseAngle = 30 // this angle was useed to trigger the base condition feedback
        val legLiftMoreRange = 10
        val legLiftKneeBend = 10
        val legLiftInnerQuad = 40
        val seatedRaiseAngle = 40
        val seatedRaiseHKAAngle = 45
        val seatedRaiseAngleLower = 20
        val seatedExLegBendUpper = 130
        val seatedExLegBendLower = 70
        val kneeBendMoreRange = 110
        val hamstringLegLiftAngle = 65
        val hipShoulderElbowAngle = 60
        val hipShoulderElbowAngleUpper = 120
        val hipShoulderElbowLowerAngle = 45
        val hipShoulderElbowBaseAngle = 10
        val hamstringBackAngleUpper = 85
        val hamstringBackAngleLower = 90
        val hamstringBackAngleBase = 130
        val shoulderLineAngleLower = 75
        val shoulderLineAngleUpper = 105
        val shoulderLineAngleLowerAbduction90 = 65
        val shoulderLineAngleUpperAbduction90 = 115
        val shoulderElbowAlignAngleLower = 60
        val shoulderElbowAlignAngleUpper = 120
    }
    object landmarksBody {
        val ankleRight = 28 // body landmark index for ankle
        val ankleLeft = 27 // body landmark index for ankle
        val hipLeft = 23 // //body landmark index for hip
        val hipRight = 24 // body landmark index for hip
        val kneeLeft = 25 // body landmark index for knee
        val kneeRight = 26 // body landmark index for knee
        val shoulderRight = 12 // body landmark index for shoulder
        val shoulderLeft = 11 // body landmark index for shoulder
        val nose = 0 // body landmark index for nose
        val elbowRight = 14 // body landmark index for elbow
        val elbowLeft = 13 // body landmark index for elbow
        val wristRight = 16 // body landmark index for wrist
        val wristLeft = 15 // body landmark index for wrist
        val earLeft = 7 // body landmark index for ear
        val earRight = 8 // body landmark index for ear
    }
    object prompts {
        val msgHoldPositionXsec = "Hold this position for "
    }

    object feedbacks { // All are feed back messages
        val msg = "Leg coordinates are not visible can you move a bit further away"
        val msgUpperBody = "Shoulder coordinates are not visible can you move a bit further away"
        val msgBody = "Body coordinates are not visible can you move a bit further away"
        val msgHka = "Keep your leg straight"
        val msgStraight = "Stand straight don't lean"
        val msgKneeBend = "Keep your knee straight"
        val msgHmstring = "Hold your leg"
        val msgLegRaise = "Don't move your leg hold it"
        val msgHoldPosition = "Hold the position"
        val msgHoldPositionXsec = "Hold this position for "
        val msgKneeStraighten = "Straighten your knee"
        val msgHoldLeg = "Hold this position for"
        val msgPullup = "Gently  pull  knee up  with towel until stretch  is felt at the front of the knee. "
        val msgTighten = "Tighten muscles at the front of  thigh        Straighten knee "
        val msgKneeStraight = "Keep your knee straight  "
        val msgLiftLegBed = "   Lift  leg off of bed "
        val msgStraightenKnee = "Straighten knee "
        val msgHamstringFirst = "Straighten your knee and lean forward until a stretch is felt at the back of the thigh "
        val msgStand = "Stand up straight"
        val msgSit = "Sit down on the chair"
        val msgRepeatEx = "Repeat the exercise "
        val msgHold = "Hold for"
        val msgHoldHand = "Hold your hand for"
        val msgBend = "Bend for "
        val msgLowerLeg = "Lower your leg slightly"
        val msgKeepKneeTowel = "Keep your knee on the towel"
        val msgKeepHeelDown = "Keep your heel down"
        val msgBackStraight = "Keep your back straight"
        val msgLieDown = "Lie down"
        val msgClose = "Come closer"
        val msgFar = "Go back"
        val msgDown = "Go down properly"
        val msgCloseHead = "Hold your hands close to ears"
        val msgHoldhand = "Hold the position"
        val msgHoldHandStraight = "Hold your hands straight"
        val msgHamstringHand = "Keep your hands on your thighs"
        val msgShoulder = "Shoulder's are at wrong position"
        val msgPullHand = "pull away with both hands"
        val msgPull = "Pull your hands more"
        val msgElbowCloser = "Keep your elbow closer to body"
        val msgHandBend = "Hold your hand at 90 degree"
        val msgHandShake = "Don't shake your hand"
        val msgLiftHand = "Hold your hands above your shoulders"
        val msgLegBend = "Bend your leg properly"
        val msgLean = "Don't lean keep your back straight"
        val msgKnee2Toes = "Keep your feet on the ground"
        val msgCenter = "Move to center"
        val msgRepeat = "Repeat the step slowly"
        val msgLegLift = "Lift your leg more"
        val msgBendMore = "Bend your knee more"
        val msgMoveHandMore = "Move your hand more"
        val msgHandMove = "Lift your hands more"
        val msgHesStraight = "Keep your hand straight"
        val msgElbowStraight = "Straighten your elbow"
        val msgFirstStage = "Lift your hands above shoulder"
        val msgRaiseHand = "Raise your hands more"
        val msgBendMovement = "Don't move hold your position"
        val msgBaseConditionKneeBend = "Straighten your leg"
        val msgBaseConditionLegLift = "Lower your leg to rest"
        val msgBaseConditionSeatedKnee = "Move your leg to ground"
        val msgBaseConditionHamstring = "Move back"
        val msgHamstringMoveForward = "Don't move bend forward"
        val moveHandSideways = "Bring your arm out to the side"
        val lowerShoulder = "Lower your shoulder"
        val msgelbowSide = "Keep your elbows to the side"
        val msgKeepElbow = "Keep your elbow in and bend at 90 degree"
        val msgLowerElbow = "Lower your elbow"
        val msgBendElbow = "Bend your elbow"
        val msgKeepHandDown = "Keep you hand down"
        val msgHand2Belly = "Keep you hand to the belly"
        val msgLowerElbowBend = "Lower your elbow with 90 degree bend"
        val msgKeepElbowShoulder = "Keep your elbow to shoulder level"
    }
    object limits {
        val shoulderPoints = 3 // Shoulder landmarks [shoulder,elbow,wrist] (total length is 3)
        val upperLimit = 2 // upper limit is used to check the previous data points lie less then limit.Used in knee exercises to to check whether leg is moving or not. For ex: current ankle x coordinate (0.3) should lie within + or - 20% of mean of previous 10 points
        val lowerLimit = 0 // similarly lower limit
        val hamstringLowerLimit = 90
        val hamstringUpperLimit = 110
        val normal = 1 // variable used to convert decimal value to integer. Ex : 0.4 to 0.4*normal=40
        val visibilityThreshold = 0.5f // visibility threshold (0-1).Above 50% of body landmarks are only considered
        val minRad = 0.4f // 40% of horizontal distance between both shoulder points are taken as radius of the circle which is used in shoulder exercises to test elbow and wrist keypoints lie within the circle or not for successfull rep calculation.
        val minRadShoulderER = 0.3f // 30% of horizontal distance between both shoulder points are taken as radius of the circle which is used in shoulder exercises to test elbow and wrist keypoints lie within the circle or not for successfull rep calculation.
        val minshoulderdist = 0.80 // 60% of of horizontal distance between both shoulder points is taken as minimum distance that hands are to be pulled away while performing shoulder external rotation both exercise.
        val minShoulderDistIR = 0.1
        val minLengthBody = 0.9f
        val seatedExUpper = 2 // these limits are used in seated knee extension to test whether the current HKA angle is with in 20 % of mean of previous 10 angles.
        val seatedExLower = 0 // similarly lower limit
        val minDataPoints = 2 // minimum data points to find mean and start holding time if current data point(angle/coordinate) in range upperlimit and lower limit
        val minDataPointsHamEX = 20
        val hipShoulderHeight = 0.8f // variable to hold 80% of vertical distance from hip to shoulder
        val hips = 2 // number of hips 2
        val face = 3
        val frameThresh = 100 // mini frame number for every feedback
        val minHandDist = 0.3f // 30% of horizontal distance between both wrist is considered to check the outward distance of hands from body, while pulling hands outwards in shoulder external task
        val legLandmark = 3 // leg co-ordinates [hip,knee,ankle] , total 3
        val bodyLandmarks = 3 //  body landmarks [shoulder,shoulder,nose], total 3
        val exTypeLayDownOnFloorUpperRange = 0.95f // Exercise type lay Down on floor upper range/limit . This limit is used to check whether the current range on body coordinates are with in upper and lower limit for approval of calibration screen.
        val exTypeLayDownOnFloorLowerRange = 0.5f // Exercise type lay Down on floor lower range/limit
        val exTypeStandOnFloorUpperRange = 0.95f // Exercise type stand on floor Upper range/limit
        val exTypeStandOnFloorLowerRange = 0.5f // Exercise type stand on floor lower range/limit
        val exTypeSitOnFloorUpperRange = 0.85f // //Exercise type sit on floor upper range/limit
        val exTypeSitOnFloorLowerRange = 0.4f // Exercise type sit  on floor lower range/limit
        val exTypeUpperBodyUpperRange = 0.6f // Exercise type upper body upper range/limit
        val exTypeUpperBodyLowerRange = 0.1f // Exercise type upper body lower range/limit
        val calibCenterRangeLowerLimit = 0.25f // this is the lower and upper range to make user to stay in center of the frame.
        val calibCenterRangeUpperLimit = 0.75f
        val frameThreshCalib = 5 // totally 5 consecutive frames are supposed to be in particular condition for approval of calibration screen.
        val upperRangeYLayDownOnFloor = 0.4f // these are the upper y axis limit. Used to make user to stand/lay/sit below this limit for these exercise types ["LayDownOnFloor","StandOnFloor","sitOnFloor","UpperBody"]
        val upperRangeYStandOnFloor = 0.1f
        val upperRangeYsitOnFloor = 0.1f
        val upperRangeYUpperBody = 0.2f
        val standLimit = 1f
        val hipShoulderMaxHeightShoulderIR = 0.30
        val shoulderLowerLimit = 0.50f
        val firstRep = 1
        val minChangeInAngle = 15
        val backAngleLimit = 60
        val faceShoulderHeightLimit = 0.2f
        val minShoulderHipLen = 0.3f
        val isUnsucessfulTime = 1
    }
    object holdingTime {
        val unsuccessTime = 1f // unsuccessful rep is considered only if the holding time is more than 30% for minimum hold time but fail to reach minimum hold time.
        val minRepeatTime = 1f
        val minFeedbackTime = 1
        val feedbackMinTimeInterval = 4
        val firstMsgMinTime = 0f
        val fluctuationTime = 0.6f
        val unsuccessfullrepLimit = 5f
    }

    object exercises {
        val kneeBendTowel = "Knee Bend"
        val straighLegRaise = "Straight Leg Raise"
        val innerRangeQuad = "Inner Range Quads"
        val hamstringStretch = "Hamstring Stretch"
        val isometricQuad = "Isometric Quads"
        val seatedKneeExtension = "Seated Knee Extension"
        val sit2Stand = "Sit to Stand"
        val shoulderExRotation = "Shoulder external rotation"
        val shoulderExRotationBoth = "Shoulder external rotation both"
        val shoulderInternalRotation = "Shoulder internal rotation"
        val shoulderAbduction = "Shoulder abduction"
        val shoulderAbduction90Bend = "90 deg Shoulder Abduction with IR"
        val shoulderFlexAnteriorRaise = "Shoulder flexion anterior raise"
        val shoulderFlexExRotation = "Shoulder flexion external rotation"
        val uprightRowBand = "Upright row band"
        val squat = "Squat"
        val staticlunge = "Static lunge"
        val lowRow = "Low Row"
        val shoulderPress = "Shoulder Press"
        val exTypeLaydown = "LayDownOnFloor"
        val exTypeStand = "StandOnFloor"
        val exTypeSit = "sitOnFloor"
        val exTypeUpperBody = "UpperBody"
    }

    object exerciseID {
        val kneeBendTowel = 1
        val straighLegRaise: Int = 2
        val innerRangeQuad = 3
        val hamstringStretch = 4
        val isometricQuad = 5
        val seatedKneeExtension = 6
        val sit2Stand = 7
        val shoulderExRotation = 8
        val shoulderExRotationBoth = 9
        val shoulderInternalRotation = 10
        val shoulderAbduction = 11
        val shoulderAbduction90Bend = 12
        val shoulderFlexAnteriorRaise = 13
        val shoulderFlexExRotation = 14
        val uprightRowBand = 15
        val squat = 18
        val staticlunge = 19
        val lowRow = 16
        val shoulderPress = 17
    }

    object constants {
        val exerciseTypes: Map<String, List<Any>> = mapOf(
            exercises.exTypeLaydown to listOf(exerciseID.straighLegRaise),
            exercises.exTypeStand to listOf(exerciseID.seatedKneeExtension, exerciseID.sit2Stand, exerciseID.squat, exerciseID.staticlunge),
            exercises.exTypeSit to listOf(exerciseID.hamstringStretch, exerciseID.kneeBendTowel, exerciseID.innerRangeQuad),
            exercises.exTypeUpperBody to listOf(
                exerciseID.shoulderExRotation, exerciseID.shoulderPress, exerciseID.uprightRowBand, exerciseID.shoulderAbduction,
                exerciseID.shoulderFlexAnteriorRaise, exerciseID.lowRow, exerciseID.shoulderFlexExRotation,
                exerciseID.shoulderExRotationBoth, exerciseID.shoulderInternalRotation, exerciseID.shoulderAbduction90Bend
            )
        )
    }
}