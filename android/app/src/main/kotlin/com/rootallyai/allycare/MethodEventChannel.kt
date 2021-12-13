package com.rootallyai.allycare

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference

object MethodEventChannel {

    var methodChannel: MethodChannel? = null
    var eventChannelRep: EventChannel? = null
    var eventChannelFeedback: EventChannel? = null
    var eventChannelElapsedTime: EventChannel? = null
    var eventChannelCalib: EventChannel? = null
    var eventChannelExFinished: EventChannel? = null
    var eventChannelActionStop: EventChannel? = null
    var eventChannelCurrentIndex: EventChannel? = null
    var eventChannelHold: EventChannel? = null
    var eventChannelShowLoading: EventChannel? = null
    var eventSinkRep: EventChannel.EventSink? = null
    var eventSinkHold: EventChannel.EventSink? = null
    var eventSinkFeedback: EventChannel.EventSink? = null
    var eventSinkElapsedTime: EventChannel.EventSink? = null
    var eventSinkCalib: EventChannel.EventSink? = null
    var eventSinkExFinished: EventChannel.EventSink? = null
    var eventSinkActionStop: EventChannel.EventSink? = null
    var eventSinkCurrentIndex: EventChannel.EventSink? = null
    var eventSinkShowLoading: EventChannel.EventSink? = null
    lateinit var navigator: WeakReference<MethodChannelInterface>

    fun finishAllExercises(){
        navigator.get()?.finishAllExercises()
    }

    fun startNextExercise(){
        navigator.get()?.startNextExercise()
    }

    fun skipCurrentExercise(){
        navigator.get()?.skipCurrentExercise()
    }

    fun removeCallibration(){
        navigator.get()?.removeCallibration()
    }

}