package com.rootallyai.allycare

import android.util.Log
import androidx.lifecycle.ViewModelProvider
import com.rootallyai.allycarebl.PosenetViewModel
import com.rootallyai.allycarebl.model.Exercise
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.videoplayer.*


class MainActivity: FlutterFragmentActivity() {

    private lateinit var viewModel: PosenetViewModel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.getPlugins().add(VideoPlayerPlugin())

        viewModel  = ViewModelProvider(this).get(PosenetViewModel::class.java)

        initializeEventMethodChannels(flutterEngine.dartExecutor.binaryMessenger)

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("<platform-view-type>",NativeViewFactory(this,flutterEngine.dartExecutor.binaryMessenger,viewModel))
    }

    private fun initializeEventMethodChannels(messenger: BinaryMessenger) {
        MethodEventChannel.methodChannel = MethodChannel(messenger, "com.allycare.dev")
        MethodEventChannel.eventChannelRep= EventChannel(messenger, "com.allycare.dev/repCount")
        MethodEventChannel.eventChannelFeedback= EventChannel(messenger, "com.allycare.dev/feedback")
        MethodEventChannel.eventChannelElapsedTime= EventChannel(messenger, "com.allycare.dev/elapsedTime")
        MethodEventChannel.eventChannelCalib= EventChannel(messenger, "com.allycare.dev/showCalib")
        MethodEventChannel.eventChannelExFinished= EventChannel(messenger, "com.allycare.dev/isExFinished")
        MethodEventChannel.eventChannelActionStop= EventChannel(messenger, "com.allycare.dev/actionStop")
        MethodEventChannel.eventChannelCurrentIndex= EventChannel(messenger, "com.allycare.dev/currentIndex")
        MethodEventChannel.eventChannelHold= EventChannel(messenger, "com.allycare.dev/holdTime")
        MethodEventChannel.eventChannelShowLoading = EventChannel(messenger, "com.allycare.dev/showLoadingScreen")

        MethodEventChannel.methodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "setAllExercises" -> {
                    val data  = call.arguments as Map<*, *>
                    val list = data ["data"] as List<Map<*,*>>

                    val listExercise = mutableListOf<Exercise>()



                    for(x in list){
                        Log.d("Data:",x.toString())
                        val practice = "practice"
                        val name = x["name"].toString()
                        val repetition = x["repititions"].toString().toInt()
                        val video = x["video"].toString()
                        val repCount = x["repititions"].toString().toInt()
                        val holdTime = x["holdTime"].toString().toInt()
                        val id = x["id"].toString().toInt()
                        listExercise.add(
                            Exercise(name,holdTime,repCount,video,practice,id,repetition)
                        )
                    }

                    Log.d("Data:",listExercise.toString())
                    viewModel.exercises = listExercise.toTypedArray()

                }
                "finishAllExercises" -> {
                    MethodEventChannel.finishAllExercises()
                }
                "skipCurrentExercise" -> {
                    MethodEventChannel.skipCurrentExercise()
                }
                "startNextExercise" -> {
                    MethodEventChannel.startNextExercise()
                }
            }

            result.success(true)
        }


        MethodEventChannel.eventChannelRep!!.setStreamHandler(repStreamHandler())
        MethodEventChannel.eventChannelHold!!.setStreamHandler(holdStreamHandler())
        MethodEventChannel.eventChannelActionStop!!.setStreamHandler(stopStreamHandler())
        MethodEventChannel.eventChannelCurrentIndex!!.setStreamHandler(currentIndexStreamHandler())
        MethodEventChannel.eventChannelExFinished!!.setStreamHandler(exFinishedStreamHandler())
        MethodEventChannel.eventChannelFeedback!!.setStreamHandler(feedbackStreamHandler())
        MethodEventChannel.eventChannelElapsedTime!!.setStreamHandler(timeStreamHandler())
        MethodEventChannel.eventChannelCalib!!.setStreamHandler(calibStreamHandler())
        MethodEventChannel.eventChannelShowLoading!!.setStreamHandler(showLoadingStreamHandler())
    }

    private fun showLoadingStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                MethodEventChannel.eventSinkShowLoading = events
                // Log.e(TAG, "Listen Event Channel")
            }

            override fun onCancel(arguments: Any?) {
                MethodEventChannel.eventSinkShowLoading = null
            }
        }
    }

    private fun calibStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                MethodEventChannel.eventSinkCalib = events
                // Log.e(TAG, "Listen Event Channel")
            }

            override fun onCancel(arguments: Any?) {
                MethodEventChannel.eventSinkCalib = null
            }
        }
    }

    private fun repStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                MethodEventChannel.eventSinkRep = events
                // Log.e(TAG, "Listen Event Channel")
            }

            override fun onCancel(arguments: Any?) {
                MethodEventChannel.eventSinkRep = null
            }
        }
    }

    private fun holdStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                MethodEventChannel.eventSinkHold = events
                // Log.e(TAG, "Listen Event Channel")
            }

            override fun onCancel(arguments: Any?) {
                MethodEventChannel.eventSinkHold = null
            }
        }
    }

    private fun stopStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                MethodEventChannel.eventSinkActionStop = events
            }
            override fun onCancel(arguments: Any?) {
                MethodEventChannel.eventSinkActionStop = null
            }
        }
    }

    private fun currentIndexStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                MethodEventChannel.eventSinkCurrentIndex = events
            }
            override fun onCancel(arguments: Any?) {
                MethodEventChannel.eventSinkCurrentIndex = null
            }
        }
    }

    private fun exFinishedStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                MethodEventChannel.eventSinkExFinished = events
            }
            override fun onCancel(arguments: Any?) {
                MethodEventChannel.eventSinkExFinished = null
            }
        }
    }

    private fun feedbackStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                MethodEventChannel.eventSinkFeedback = events
            }
            override fun onCancel(arguments: Any?) {
                MethodEventChannel.eventSinkFeedback = null
            }
        }
    }

    private fun timeStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                MethodEventChannel.eventSinkElapsedTime = events
            }
            override fun onCancel(arguments: Any?) {
                MethodEventChannel.eventSinkElapsedTime = null
            }
        }
    }

}
