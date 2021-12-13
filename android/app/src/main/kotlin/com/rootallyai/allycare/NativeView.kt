package com.rootallyai.allycare

import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager.PERMISSION_GRANTED
import android.graphics.SurfaceTexture
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.util.Size
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.View
import android.widget.Toast
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.ViewModelProviders
import com.google.mediapipe.components.*
import com.google.mediapipe.framework.*
import com.google.mediapipe.formats.proto.LandmarkProto
import com.google.mediapipe.framework.AndroidAssetUtil
import com.google.mediapipe.framework.Packet
import com.google.mediapipe.framework.PacketGetter
import com.google.mediapipe.framework.ProtoUtil
import com.google.mediapipe.glutil.EglManager
import com.google.protobuf.InvalidProtocolBufferException
import com.rootallyai.allycarebl.ExConstants
import com.rootallyai.allycarebl.PosenetViewModel
import com.rootallyai.allycarebl.RepetitionCounter
import com.rootallyai.allycarebl.model.Exercise
import com.rootallyai.allycarebl.model.ExerciseItem
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*
import io.flutter.plugin.platform.PlatformView
import java.lang.ref.WeakReference


internal class NativeView(val activity: Activity,
                          val messenger: BinaryMessenger,
                          val viewModel: PosenetViewModel,
                          val context: Context, id: Int,
                          creationParams: Map<String?, Any?>?)
    : PlatformView{

    private var previewDisplayView: SurfaceView = SurfaceView(context)

    private val navigator = object : MethodChannelInterface{
        override fun finishAllExercises() {
            Log.d("Navigator:","Inside finishAllExercises")
            viewModel.stopCurrentSession()
        }

        override fun startNextExercise() {
            Log.d("Navigator:","Inside startNextExercise")
            viewModel.startNextExercise()

        }

        override fun skipCurrentExercise() {
            Log.d("Navigator:","Inside skipCurrentExercise")
            viewModel.onSkipClick()

        }

        override fun removeCallibration() {
            Log.d("Navigator:","Inside skipCurrentExercise")
            viewModel.removeCalib()
        }

    }



    override fun getView(): View {
        Log.d("Hello:","Yes")
        return previewDisplayView
    }

    companion object {
        private const val TAG = "HandTrackingPlugin"
        private const val NAMESPACE = "plugins.zhzh.xyz/flutter_hand_tracking_plugin"
        private const val BINARY_GRAPH_NAME = "pose_tracking_gpu.binarypb"
        private const val INPUT_VIDEO_STREAM_NAME = "input_video"
        private const val OUTPUT_VIDEO_STREAM_NAME = "output_video"
        private const val OUTPUT_LANDMARKS_STREAM_NAME = "pose_landmarks"
        private const val MEDIAPIPE_TYPE_NAME = "mediapipe.NormalizedLandmarkList"
        private val CAMERA_FACING = CameraHelper.CameraFacing.FRONT
        // Flips the camera-preview frames vertically before sending them into FrameProcessor to be
        // processed in a MediaPipe graph, and flips the processed frames back when they are displayed.
        // This is needed because OpenGL represents images assuming the image origin is at the bottom-left
        // corner, whereas MediaPipe in general assumes the image origin is at top-left.
        private const val FLIP_FRAMES_VERTICALLY = true

        private fun getLandmarksString(landmarks: LandmarkProto.NormalizedLandmarkList): String {
            var landmarksString = ""
            for ((landmarkIndex, landmark) in landmarks.landmarkList.withIndex()) {
                landmarksString += ("\t\tLandmark["
                        + landmarkIndex
                        + "]: ("
                        + landmark.x
                        + ", "
                        + landmark.y
                        + ", "
                        + landmark.z
                        + ")\n")
            }
            return landmarksString
        }

        init { // Load all native libraries needed by the app.
            System.loadLibrary("mediapipe_jni")
            System.loadLibrary("opencv_java3")
        }
    }

    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())
    // {@link SurfaceTexture} where the camera-preview frames can be accessed.
    private var previewFrameTexture: SurfaceTexture? = null
    // {@link SurfaceView} that displays the camera-preview frames processed by a MediaPipe graph.
    // Creates and manages an {@link EGLContext}.
    private var eglManager: EglManager = EglManager(null)
    // Sends camera-preview frames into a MediaPipe graph for processing, and displays the processed
    // frames onto a {@link Surface}.
    private var processor: FrameProcessor = FrameProcessor(
        activity,
        eglManager.nativeContext,
        BINARY_GRAPH_NAME,
        INPUT_VIDEO_STREAM_NAME,
        OUTPUT_VIDEO_STREAM_NAME)
    // Converts the GL_TEXTURE_EXTERNAL_OES texture from Android camera into a regular texture to be
    // consumed by {@link FrameProcessor} and the underlying MediaPipe graph.
    private var converter: ExternalTextureConverter? = null
    // Handles camera access via the {@link CameraX} Jetpack support library.
    private var cameraHelper: Camera2Helper? = null



    override fun dispose() {
        converter?.close()
    }


    init {

        MethodEventChannel.navigator = WeakReference(this.navigator)

        viewModel.showCalib.addObserver {
            if(MethodEventChannel.eventSinkCalib!=null){
                MethodEventChannel.eventSinkCalib?.success(it)
            }
        }


        viewModel.countReps.addObserver {
            Log.d("Counter:",it.toString())
            if(MethodEventChannel.eventSinkRep!=null){
                Log.d("Counter:","Before eventSinkRep.sucess()")
                MethodEventChannel.eventSinkRep?.success(it)
            }
        }

        viewModel.isExFinished.addObserver {

            if(MethodEventChannel.eventSinkExFinished!=null){
                Log.d("Skip: ","Before ExFinished.success()")
                MethodEventChannel.eventSinkExFinished?.success(it)
            }
            if(MethodEventChannel.eventSinkCurrentIndex!=null){
                MethodEventChannel.eventSinkCurrentIndex?.success(viewModel.getCurrValue())
            }
        }

        viewModel._actionStop.addObserver {
            if(MethodEventChannel.eventSinkActionStop!=null){
                MethodEventChannel.eventSinkActionStop?.success(it)
            }
        }

        viewModel.exFeedbackForTTS.addObserver {
            if(MethodEventChannel.eventSinkFeedback!=null){
                MethodEventChannel.eventSinkFeedback?.success(it)
            }
        }

        viewModel.progressHold.addObserver {
            if(MethodEventChannel.eventSinkHold!=null){
                MethodEventChannel.eventSinkHold?.success(it)
            }
        }

        viewModel.timeToShow.addObserver{
            Log.d("Counter:HoldTime",it.toString())
            if(MethodEventChannel.eventSinkElapsedTime!=null){
                Log.d("Counter:","Before eventSinkHold.sucess()")
                MethodEventChannel.eventSinkElapsedTime?.success(it)
            }
        }

        




        Log.d("ViewModel:",viewModel.breakInterval.toString())
        setupPreviewDisplayView()
        // Initialize asset manager so that MediaPipe native libraries can access the app assets, e.g.,
        // binary graphs.
        AndroidAssetUtil.initializeNativeAssetManager(activity)
        setupProcess()
        PermissionHelper.checkAndRequestCameraPermissions(activity)

        if (PermissionHelper.cameraPermissionsGranted(activity)) onResume()
    }




    private fun onResume() {
        converter = ExternalTextureConverter(eglManager.context)
        converter!!.setFlipY(FLIP_FRAMES_VERTICALLY)
        converter!!.setRotation(270)
        converter!!.setConsumer(processor)
        if (PermissionHelper.cameraPermissionsGranted(activity)) {
            startCamera()
        }
    }

    private fun setupPreviewDisplayView() {
        previewDisplayView.visibility = View.GONE
        previewDisplayView.holder.addCallback(
            object : SurfaceHolder.Callback {
                override fun surfaceCreated(holder: SurfaceHolder) {
                    processor.videoSurfaceOutput.setSurface(holder.surface)
                }

                override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) { // (Re-)Compute the ideal size of the camera-preview display (the area that the
                    // camera-preview frames get rendered onto, potentially with scaling and rotation)
                    // based on the size of the SurfaceView that contains the display.
                    val viewSize = Size(width, height)
                    val widthNew: Int
                    val heightNew: Int
                    // Connect the converter to the camera-preview frames as its input (via
                    // previewFrameTexture), and configure the output width and height as the computed
                    // display size.

                    val optimalSize = cameraHelper!!.computeDisplaySizeFromViewSize(viewSize)

                    widthNew = context.resources?.displayMetrics!!.widthPixels
                    heightNew = (3 * context.resources?.displayMetrics!!.widthPixels) / 4

                    /*converter!!.setSurfaceTextureAndAttachToGLContext(
                        previewFrameTexture,
                        widthNew,
                        heightNew
                    )*/
                    converter!!.setSurfaceTextureAndAttachToGLContext(
                        previewFrameTexture,
                        optimalSize.width,
                        optimalSize.height
                    )
                }

                override fun surfaceDestroyed(holder: SurfaceHolder) {
                    processor.videoSurfaceOutput.setSurface(null)
                }
            })
    }

    private fun setupProcess() {

        /*val listExercise = listOf(
            Exercise("Straight Leg Raise",4,4,repetition = 1),
            Exercise("Straight Leg Raise",4,4,repetition = 1),
            Exercise("Straight Leg Raise",4,4,repetition = 1)
        )

        viewModel.exercises = listExercise.toTypedArray()*/

        viewModel.startExercise = true
        viewModel.exerciseResList.clear()

        viewModel.exercises.forEach {
            viewModel.exerciseResList.add(ExerciseItem(name = it.name?:""))
        }

        Log.d("Data:",viewModel.exercises.toString())
        Log.d("Data:",viewModel.exerciseResList.toString())



        /*listExercise.forEach{
            viewModel.exerciseResList.add(ExerciseItem(name = it.name?:""))
        }*/
        val currentExercise = viewModel.exercises[viewModel.getCurrValue()]
        viewModel.repCounter = RepetitionCounter(currentExercise)

        viewModel.initialSetup()

        ProtoUtil.registerTypeName(
            LandmarkProto.NormalizedLandmarkList::class.java,
            MEDIAPIPE_TYPE_NAME
        )

        processor.videoSurfaceOutput.setFlipY(FLIP_FRAMES_VERTICALLY)


        val textureFrameConsumer = object : TextureFrameConsumer {
            override fun onNewFrame(frame: TextureFrame?) {
                
                if(MethodEventChannel.eventSinkShowLoading!=null){
                    uiThreadHandler.post { 
                        MethodEventChannel.eventSinkShowLoading?.success(false)
                        }
                    
                }
                processor!!.removeConsumer(this)
            }
        }
        processor!!.addConsumer(textureFrameConsumer)

        processor.addPacketCallback(
            OUTPUT_LANDMARKS_STREAM_NAME
        ) { packet: Packet ->

            val value = 0
            Log.d("ViewModel:",viewModel.breakInterval.toString())
            val poseLandmarks =
                PacketGetter.getProto(
                    packet,
                    LandmarkProto.NormalizedLandmarkList::class.java
                )

            Log.d("Check:",poseLandmarks.landmarkList[0].x.toString() + ", " + poseLandmarks.landmarkList[0].y.toString() + ", " + poseLandmarks.landmarkList[0].z.toString())

            val landmarks = threshLandmarks(poseLandmarks)
            Log.d("Check:",""+landmarks.size+"a")

            viewModel.startProcess(landmarks)

            Log.d("Check:",poseLandmarks.landmarkList[0].x.toString() + ", " + poseLandmarks.landmarkList[0].y.toString() + ", " + poseLandmarks.landmarkList[0].z.toString())
        }
    }

    private fun startCamera() {

        cameraHelper = Camera2Helper(context,CustomSurfaceTexture(65))
        cameraHelper!!.setOnCameraStartedListener { surfaceTexture: SurfaceTexture? ->
            previewFrameTexture = surfaceTexture
            // Make the display view visible to start showing the preview. This triggers the
            // SurfaceHolder.Callback added to (the holder of) previewDisplayView.
            previewDisplayView.visibility = View.VISIBLE
        }
        cameraHelper!!.startCamera(activity, CAMERA_FACING, null)
    }

    fun threshLandmarks(output: LandmarkProto.NormalizedLandmarkList): MutableMap<Int, HashMap<String, Float>> {
        /**
        Function to filter the landmarks,Landmarks above 0.5 visibility are considered
        output :  is the NormalizedLandmarkList  with index:[x,y,z,confidence_score]
        return:   idxToCoordinates= {1:{x:0.2,y:0.3,z:0.97},2:[x:0.6,y:0.97,z:0.44],3:[x:0.87,y:0.88,z:0.66].........}
         */
        val idxToCoordinates = mutableMapOf<Int, HashMap<String, Float>>()
        for ((landmarkIndex, landmark) in output.landmarkList.withIndex()) {
            if (landmark.presence > ExConstants.limits.visibilityThreshold) {
                val coordinateMap: HashMap<String, Float> = HashMap<String, Float> ()
                coordinateMap.put("x", landmark.x)
                coordinateMap.put("y", landmark.y)
                coordinateMap.put("z", landmark.z)
                idxToCoordinates.put(landmarkIndex, coordinateMap)
            }
        }
        return idxToCoordinates
    }

    /*fun threshLandmarks(output: LandmarkProto.NormalizedLandmarkList): MutableMap<Int, MutableList<Float>> {
        // input is the NormalizedLandmarkList  with index:[x,y,z,confidence_score]
        val idxToCoordinates = mutableMapOf<Int, MutableList<Float>>()
        for ((landmarkIndex, landmark) in output.landmarkList.withIndex()) {
            if (landmark.presence > ExConstants.limits.visibilityThreshold) {
                idxToCoordinates[landmarkIndex] = mutableListOf(landmark.x, landmark.y, landmark.z)
            }
        }
        // idxToCoordinates= {1:[0.2,0.3,0.97],2:[0.6,0.97,0.44],3:[0.87,0.88,0.66].........}
        return idxToCoordinates
    }*/


}