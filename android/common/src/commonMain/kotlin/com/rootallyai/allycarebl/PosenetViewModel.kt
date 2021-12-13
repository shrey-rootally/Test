package com.rootallyai.allycarebl

import co.touchlab.stately.concurrency.value
import dev.icerock.moko.mvvm.viewmodel.ViewModel
import com.rootallyai.allycarebl.model.Exercise
import com.rootallyai.allycarebl.model.ExerciseItem
import com.rootallyai.allycarebl.model.KneeRange
import com.rootallyai.allycarebl.model.SetItem
import dev.icerock.moko.mvvm.livedata.LiveData
import dev.icerock.moko.mvvm.livedata.MutableLiveData
import dev.icerock.moko.mvvm.livedata.map
import kotlinx.coroutines.*
import kotlinx.datetime.Clock
import kotlin.collections.ArrayList
import co.touchlab.stately.concurrency.AtomicInt
import co.touchlab.stately.concurrency.AtomicReference
import co.touchlab.stately.concurrency.AtomicBoolean
import co.touchlab.stately.concurrency.value
import co.touchlab.stately.concurrency.AtomicLong


class PosenetViewModel: ViewModel() {
    private val _counter = MutableLiveData(0)
    private val _timer = MutableLiveData(0)
    private val _timeToShow = MutableLiveData(PosenetConstants.DEFAULT_TIME)
    val counter: LiveData<String> = _counter.map { "$it" }
    val countReps: LiveData<Int> = _counter.map { it }
    val timeToShow: LiveData<String> = _timeToShow.map { it }

    lateinit var exercises: Array<Exercise>

    var videoRecording = false
    var isRecording = false
    var startExercise: Boolean = false
    var pauseExercise = false
    var startHoldTime: Boolean = false
    var repCounter: RepetitionCounter? = null
    var count = 0
    lateinit var timerHold : Job
    lateinit var time : Job
    var calib = false
    //var bitmapToVideoEncoder: BitmapToVideoEncoder? = null
    var stopped = false
    var breakInterval = 5
    val exerciseResList = mutableListOf<ExerciseItem>()
    var backPressed = false
    var currCamWeight = 3f
    var currVidWeight = 2f
    val timestamp = Clock.System.now().toEpochMilliseconds() / 1000
    var initialPainScore = 0
    var isStop = false
    lateinit var name: String
    //var timer = Timer()
    var practice = false
    var countCall = 0


    private val _curr = MutableLiveData(0)
    val curr: LiveData<Int> = _curr.map { it }
    private val _exSize = MutableLiveData(0)
    val exSize: LiveData<Int> = _exSize.map { it }

    private val _exFeedbackForTTS = MutableLiveData("")
    val exFeedbackForTTS: LiveData<String> = _exFeedbackForTTS.map { it }
    private val _exFeedbackForUI = MutableLiveData("")
    val exFeedbackForUI: LiveData<String> = _exFeedbackForUI.map { it }
    private val _exName = MutableLiveData("")
    val exName: LiveData<String> = _exName.map { it }
    private val _exReps = MutableLiveData(0)
    val exReps: LiveData<Int> = _exReps.map { it }
    private val _progressNext = MutableLiveData(0)
    val progressNext: LiveData<Int> = _progressNext.map { it }
    private val _progressHold = MutableLiveData(0)
    val progressHold: LiveData<Int> = _progressHold.map { it }
    private val _progressStep = MutableLiveData(0)
    val progressStep: LiveData<Int> = _progressStep.map { it }
    private val _exNum = MutableLiveData("")
    val exNum: LiveData<String> = _exNum.map { it }
    private val _holdTime = MutableLiveData("")
    val holdTime: LiveData<String> = _holdTime.map { it }
    private val _isExFinished = MutableLiveData(false)
    val isExFinished: LiveData<Boolean> = _isExFinished.map { it }
    private val _isRepFinished = MutableLiveData(false)
    val isRepFinished: LiveData<Boolean> = _isRepFinished.map { it }
    private val _showHoldTime = MutableLiveData(false)
    val showHoldTime: LiveData<Boolean> = _showHoldTime.map { it }
    private val _maxHold = MutableLiveData(0)
    val maxHold: LiveData<Int> = _maxHold.map { it }
    private val _maxHoldView = MutableLiveData(0)
    val maxHoldView: LiveData<Int> = _maxHoldView.map { it }
    private val _txtNewEx = MutableLiveData(PosenetConstants.START_NEXT_EXERCISE_TEXT)
    val txtNewEx: LiveData<String> = _txtNewEx.map { it }
    private val _optLayoutVisible = MutableLiveData(false)
    val optLayoutVisible: LiveData<Boolean> = _optLayoutVisible.map { it }
    private val _changeConstraints = MutableLiveData(false)
    val changeConstraints: LiveData<Boolean> = _changeConstraints.map { it }
    val _toggleLayoutVisibility = MutableLiveData(false)
    val toggleLayoutVisibility: LiveData<Boolean> = _toggleLayoutVisibility.map { it }
    val _pauseLayoutVisibility = MutableLiveData(false)
    val pauseLayoutVisibility: LiveData<Boolean> = _pauseLayoutVisibility.map { it }
    private val _loadingVisible = MutableLiveData(true)
    val loadingVisible: LiveData<Boolean> = _loadingVisible.map { it }
    val _startRecording = MutableLiveData(false)
    private val _stopRecording = MutableLiveData(false)
    var _navigateUp = MutableLiveData(false)
    var _playSound = MutableLiveData(false)
    var _actionStop = MutableLiveData(false)
    var _showCalib = MutableLiveData(true)
    val showCalib: LiveData<Boolean> = _showCalib.map { it }
    var _showExFinished = MutableLiveData(false)
    val showExFinished: LiveData<Boolean> = _showExFinished.map { it }
    var _startVideo = MutableLiveData(PosenetConstants.SETUP)
    private val _correctRepPercent = MutableLiveData(0)
    val correctRepPercent: LiveData<Int> = _correctRepPercent.map { it }

    val testfloat = MutableLiveData(0f)

    var volumePercent = 0.0f
    private var prevHoldValue = 0

    var segmentedVideo = false
    var videoState = ArrayList<String>()
    private val _curVideoState = MutableLiveData(0)
    val curVideoState: LiveData<Int> = _curVideoState.map { it }
    var videoEndReached = MutableLiveData(false)
    var endStateDuration = 0

    var steps = 0f


    fun removeLoading() {

        _progressNext.postValue(breakInterval * 1000)
        _loadingVisible.postValue(false)
    }

    fun videoTypeCheck(videoName: String) {
        if (videoName == PosenetConstants.StraightLegRaise) {
            segmentedVideo = true
            videoState.clear()

            _curVideoState.postValue(0)
        } else {
            segmentedVideo = false
            _startVideo.postValue(PosenetConstants.SETUP)
        }
    }

    fun initialSetup() {
        //ExConstants.holdingTime.minimumHoldTime.value = exercises[getCurrValue()].hold_time

        // _startVideo.postValue(PosenetConstants.SETUP)

        time = startElapsedTime()
        videoTypeCheck(exercises[getCurrValue()].name!!)

        calculateHolderImage()
        _exSize.value = exercises.size
    }

    fun updateSegment(value: Int) {
        _curVideoState.value = value
    }

    fun testingProcess() {
        _counter.value = _counter.value + 1;
    }

    fun startProcess(poseLandmarks: MutableMap<Int, HashMap<String, Float>>) {
        if (!repCounter!!.exMutable.constants.TTStext.isEmpty()) {
            if (repCounter!!.exMutable.constants.isFeedback) {
                _exFeedbackForUI.postValue(repCounter!!.exMutable.constants.TTStext)
            }
            _exFeedbackForTTS.postValue(repCounter!!.exMutable.constants.TTStext)
            repCounter!!.exMutable.constants.TTStext = ""
        }
        if (startExercise && !pauseExercise) {
            val tempCount = repCounter!!.OnFrame(poseLandmarks)
            Platform().logMessage("DEBUG:- KMM: StartHoldTime: " + startHoldTime + "holdTime: " + repCounter!!.exMutable.flags.holdTime)
            // When we get a confirmation from the Repetition Counter that we can start the hold time now
            if (repCounter!!.exMutable.flags.holdTime && !startHoldTime) {
                startHoldTime = true
                startHoldTimer()
            }

            if (startHoldTime && !repCounter!!.exMutable.flags.holdTime) {
                if (tempCount > count) {
                    // playSound(_maxHoldView.value!!)
                    count = tempCount.toInt()

                    _isRepFinished.postValue(true)
                    hideRepFinish(2000)
                }
                if (_progressHold.value!! >= _maxHold.value!!) {
                    _curVideoState.value?.let {
                        _curVideoState.postValue(it + 1)
                    }
                }
                startHoldTime = false
                print("startProcess cancelHoldTimer called")
                cancelHoldTimer()
                timerHold.cancel()
            }

            // if (!ExConstants.flags.holdTime) {
            //     cancelHoldTimer()
            // }

            if (exercises[getCurrValue()].name == "Sit to Stand") {
                count = tempCount.toInt()
            }

            // Following code updates the rep count on the UI
//            _counter.value = tempCount.toInt()
            _counter.postValue(tempCount.toInt())
            // Once the given number of reps are performed, we can finish current exercise
            // it will end either if he completes all success reps or attempts 150% of the assigned reps
            if (exercises[getCurrValue()].rep_count > 0 && (count >= (exercises[getCurrValue()].rep_count * PosenetConstants.Exercise_Reps_Threshold) ||
                        repCounter!!.exMutable.reps.successRep == exercises[getCurrValue()].rep_count)
            ) {
                Platform().logMessage("DEBUG:- KMM: successrep " + repCounter!!.exMutable.reps.successRep + " repcount: " + exercises[getCurrValue()].rep_count + " currvalue " + getCurrValue())
                if (!segmentedVideo) {
                    changeExercise(0L)
                } else {
                    changeExercise(endStateDuration * 1L)
                }
            }
        }

        // The following code checks the calibration success
        Platform().logMessage("startProcess calib 1: " + calib + ", exerciseType: " + repCounter!!.exMutable.limits.exerciseType)
        Platform().logMessage("startProcess exerciseTypes 1: " + ExConstants.constants.exerciseTypes["LayDownOnFloor"].toString() + ", currentExercise: " + repCounter!!.exMutable.constants.currentExercise)
        if (!calib) {
            Platform().logMessage("startProcess calib 2: " + calib)
            repCounter!!.exMutable.constants.currentExercise = repCounter?.exercise?.name.toString()
            repCounter!!.exMutable.limits.exerciseType = "LayDownOnFloor"
            repCounter!!.optimumRange(poseLandmarks)
        }

        // Following code updates the UI once the calibration is successful
        //
        Platform().logMessage("startProcess optiRange 1: " + repCounter!!.exMutable.flags.optiRange)
        if (!calib && repCounter!!.exMutable.flags.optiRange) {
            Platform().logMessage("startProcess optiRange 2: " + repCounter!!.exMutable.flags.optiRange)
            _showCalib.postValue(false)
        }
    }


    fun changeExercise(delay: Long) { // this: CoroutineScope
        Platform().logMessage("DEBUG:- KMM:- changeExercise called")
        CoroutineScope(Dispatchers.Main).launch {
            startExercise = false
            delay(delay)
            count = 0
            kmmFinishCurrentExercise()
        }
    }
    fun hideRepFinish(delay: Long) { // this: CoroutineScope

        CoroutineScope(Dispatchers.Main).launch {
            delay(delay)
            _isRepFinished.postValue(false)
        }
    }

    fun removeCalib() {
        calib = true
        updateData()
        //startElapsedTime()
        time = startElapsedTime()

        startExercise = true
    }

    private fun startNextExerciseTimer() {

        _showExFinished.postValue(true)
        var countMillis = 0


        CoroutineScope(Dispatchers.Main).launch {
            while (true){
                delay(1)
                countMillis++
                _progressNext.postValue(countMillis)
                if (countMillis == breakInterval * 1000) {
                    cancel()
                    startNextExercise()
                }
            }
        }
    }
    fun testingFunction():Int {
        return repCounter!!.exMutable.holdingTime.minimumHoldTime
    }

    fun startNextExercise() {
        _showExFinished.postValue(false)

        if (isStop) {
            //stopRecording()
            _actionStop.postValue(true)
        } else if (getCurrValue() == exercises.size) {

            //stopRecording()
            _actionStop.postValue(true)
        } else {
            startExercise = true
            updateData()


            onStopTime()
            updateVisibility()
            Platform().logMessage("DEBUG:-  KMM:- isExFinished:" + isExFinished.value.toString())
            //Log.d("isExFinished:", isExFinished.value.toString())
            // _startVideo.postValue(PosenetConstants.SETUP)
            videoTypeCheck(exercises[getCurrValue()].name!!)

            _showCalib.postValue(true)
            calib = false
            repCounter?.reset(exercises[getCurrValue()])
//            repCounter?.exercise = exercises[getCurrValue()]
//            repCounter!!.exMutable.reps.successRep = 0
//            repCounter!!.exMutable.reps.unsucessRep = 0
//            repCounter!!.exMutable.holdingTime.minimumHoldTime = exercises[getCurrValue()].hold_time
            calculateHolderImage()
        }
    }

    fun finishCurrentExercise() {
        onPauseTime()

        val currIndex = getCurrValue()

        exerciseResList[currIndex].total_reps += repCounter!!.exMutable.reps.successRep  + repCounter!!.exMutable.reps.unsucessRep
        exerciseResList[currIndex].correct_reps += repCounter!!.exMutable.reps.successRep

        _correctRepPercent.postValue(((exerciseResList[currIndex].correct_reps.toFloat() / exerciseResList[currIndex].total_reps.toFloat()) * 100).toInt())

        val kneeRange = KneeRange(
            repCounter!!.exMutable.constants.lowestRange,
            repCounter!!.exMutable.constants.highestRange,
            repCounter!!.exMutable.constants.averageRange
        )
        val holdTime = exercises[getCurrValue()].hold_time.toDouble()

        val setItem = SetItem(
            repCounter!!.exMutable.reps.successRep,
            repCounter!!.exMutable.reps.successRep + repCounter!!.exMutable.reps.unsucessRep,
            holdTime,
            getTime(),
            kneeRange
        )

        exerciseResList[currIndex].setList.add(setItem)

        if (exercises[getCurrValue()].repetition == 1)
            incrementCurr()
        else
            exercises[getCurrValue()].repetition -= 1
        //Log.d("Curr1:", getCurrValue().toString())
        updateVisibility()
        //Log.d("isExFinished:", isExFinished.value.toString())
        showHoldTime(false)
        _startVideo.postValue(PosenetConstants.PAUSE)

        //Log.d("New:", exerciseResList.toString())
        if (!calib)
            startNextExercise()
        else
            startNextExerciseTimer()
    }

    fun stopCurrentSession() {
        isStop = true
        kmmFinishCurrentExercise()
    }

    fun kmmFinishCurrentExercise() {
        onPauseTime()

        val currIndex = getCurrValue()
        exerciseResList[currIndex].total_reps += repCounter!!.exMutable.reps.successRep  + repCounter!!.exMutable.reps.unsucessRep
        exerciseResList[currIndex].correct_reps += repCounter!!.exMutable.reps.successRep
        _correctRepPercent.postValue(((exerciseResList[currIndex].correct_reps.toFloat() / exerciseResList[currIndex].total_reps.toFloat()) * 100).toInt())
        val kneeRange = KneeRange(
            repCounter!!.exMutable.constants.lowestRange,
            repCounter!!.exMutable.constants.highestRange,
            repCounter!!.exMutable.constants.averageRange
        )
        val holdTime = exercises[getCurrValue()].hold_time.toDouble()
        val setItem = SetItem(
            repCounter!!.exMutable.reps.successRep,
            repCounter!!.exMutable.reps.successRep + repCounter!!.exMutable.reps.unsucessRep,
            holdTime,
            getTime(),
            kneeRange
        )

        exerciseResList[currIndex].setList.add(setItem)
        if (exercises[getCurrValue()].repetition == 1)
            incrementCurr()
        else
            exercises[getCurrValue()].repetition -= 1
        //Log.d("Curr1:", getCurrValue().toString())
        if (isStop) {
            _curr.postValue(exercises.size - 1)
            startNextExercise()
        } else {
            updateVisibility()
        }

        //Log.d("isExFinished:", isExFinished.value.toString())
        showHoldTime(false)
////        _startVideo.postValue(PosenetConstants.PAUSE)

        //Log.d("New:", exerciseResList.toString())
////        if (!calib)
////            startNextExercise()
//  //      else
// //           startNextExerciseTimer()
    }

    private fun cancelHoldTimer() {
        timerHold.cancel()
        _progressHold.postValue(0)
        _progressStep.postValue(-1)
        prevHoldValue = 0
    }

    private fun playSound(value: Int) {

        val percent = value.toFloat() / _maxHoldView.value!!.toFloat()
        // val percentdouble = String.format("%.2f", value/_maxHoldView.value!!).toDouble()
        //Log.d("Check:", "percent - " + percent + "," + value + "," + _maxHoldView.value + ",")
        volumePercent = percent
        if (volumePercent <= 1) {
            _playSound.postValue(true)
        }
    }

    fun starttimerHold(): Job {
        return CoroutineScope(Dispatchers.Main).launch {
            var countMillis = 0
            while(isActive) {
                //do your network request here
                delay(100)
                countMillis++
                _progressHold.postValue(countMillis * 100)
                val currentprogress = (countMillis / 1000)
                val currentHoldValue = (currentprogress / steps).toInt()
                //Log.d("Check:", "currentprogress - " + currentprogress + "," + prevHoldValue)
                if (currentHoldValue > prevHoldValue) {
                    //Log.d("Check:", "currentprogress - " + currentprogress)

                    prevHoldValue = currentHoldValue
                    playSound(currentHoldValue)
                }
                _progressStep.postValue(currentHoldValue)
            }
        }
    }

    private fun startHoldTimer() {
        _isRepFinished.postValue(false)
        timerHold = starttimerHold()
    }



    private fun calculateHolderImage() {
        val tempHold = exercises[getCurrValue()].hold_time
        if (tempHold <= 5 && tempHold > 1) {

            steps = 1f
        } else {
            steps = (tempHold / 5).toFloat()
        }

        _progressStep.postValue(-1)
    }

    fun getCurrValue(): Int {

        return _curr.value!!
    }

    fun updateData() {
        _exName.postValue(exercises[getCurrValue()].name.toString())
        _exReps.postValue(exercises[getCurrValue()].rep_count)
        _exNum.postValue((getCurrValue() + 1).toString())
        _holdTime.postValue(exercises[getCurrValue()].hold_time.toString())
        _maxHold.postValue(exercises[getCurrValue()].hold_time * 1000)
        _maxHoldView.postValue(exercises[getCurrValue()].hold_time)
    }

    fun incrementCurr() {
        if (getCurrValue() < exercises.size)
            _curr.postValue(_curr.value?.plus(1))
    }

    fun updateVisibility() {
        _isExFinished.postValue(_isExFinished.value != true)
    }

    fun updateText() {
        // _txtNewEx.postValue(PosenetConstants.FINISH_SESSION_TEXT)
        if (getCurrValue() < exercises.size)
            _txtNewEx.postValue(exercises[getCurrValue()].name.toString())
    }

    fun showHoldTime(value: Boolean) {
        _showHoldTime.postValue(value)
    }

    fun startElapsedTime(): Job {
        return CoroutineScope(Dispatchers.Main).launch {
            var countMillis = 0
            while(isActive) {
                //do your network request here
                delay(1000)
                _timer.postValue(_timer.value?.plus(1))
                getShowTime()
            }
        }
    }
    /*fun startElapsedTime() {
        time = Timer()
        time.scheduleAtFixedRate(
            object : TimerTask() {
                override fun run() {
                    _timer.postValue(_timer.value?.plus(1))
                    getShowTime()
                }
            },
            1000L,
            1000L
        )
    }
     */

    fun onStopTime() {
        time.cancel()
        _timer.postValue(0)
        _counter.postValue(0)
    }

    fun getTime(): Int {
        return _timer.value!!
    }

    fun onPauseTime() {
        time.cancel()
    }

    fun onStopClicked() {
        if (!isStop && !isExFinished.value!!) {
            isStop = true
            startExercise = false
//            stopRecording()
            updateText()
            isStop = true
            kmmFinishCurrentExercise()
        }
    }

    fun onSkipClick() {
        if (!isExFinished.value!!) {
            startExercise = false
            kmmFinishCurrentExercise()
        }
    }

    fun getShowTime() {
        val min = (_timer.value?.div(60))
        val sec = _timer.value?.minus((min?.times(60)!!))

        lateinit var minToShow: String
        lateinit var secToShow: String

        minToShow = if (min.toString().length == 1) {
            "0$min"
        } else {
            "$min"
        }

        secToShow = if (sec.toString().length == 1) {
            "0$sec"
        } else {
            "$sec"
        }

        _timeToShow.postValue("$minToShow:$secToShow min")
    }

}