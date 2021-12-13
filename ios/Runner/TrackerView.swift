//
//  TrackerView.swift
//  Runner
//
//  Created by Shrey Gupta on 01/11/21.
//
import Flutter
import UIKit
import AVKit
import common
import Photos

// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length
// swiftlint:disable vertical_whitespace

class TrackerView: NSObject {
    // MARK: - Properties
    private var posenetViewModel: PosenetViewModel? = PosenetViewModel()
    private var camera: Camera? = Camera()
    private var tracker: UpperBodyPoseTracker? = UpperBodyPoseTracker()
    
    var fpsCount = 0
    var isSessionInitialized = false
    
    weak var methodChannel = MethodChannel.shared
    weak var eventChannel = EventChannel.shared
    
    // MARK: - UI Elements
    private lazy var broadcastView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Lifecycle
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger?) {
        super.init()
        methodChannel?.delegate = self
        methodChannel?.initAllChannels()
        
        observePosenetViewModel()
        
        initialiseExerciseSession()
        
        cameraSetupListener()
        
        camera?.delegate = self
        camera?.start()
        
        tracker?.startGraph()
        tracker?.delegate = self
        
//        camera?.startRecording { videoLocation, error in
//            if let error = error {
//                fatalError("Error occoured while Recording: \(error)")
//            }
//
//            guard let url = videoLocation else { return }
//            print("DEBUG:- got video: \(url)")
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)})
//            { (saved, error) in
//                if error == nil {
//                    print("DEBUG:- ERROR WHILE SAVING: \(error!.localizedDescription)")
//                } else if saved {
//                    print("DEBUG:- VIDEO SAVED TO GALLERY SUCCESSFULLY!")
//                }
//            }
//        }
    }
    
    deinit {
        print("DEBUG:- DEINIT TRACKERVIEW")
        camera?.stop()
    }
    
    // MARK: - Helper Functions
    func observePosenetViewModel() {
        posenetViewModel?.countReps.addObserver { count in
            guard let count = count else { return }
            self.eventChannel?.updateRepCount(with: count)
        }
        
        posenetViewModel?.showCalib.addObserver { calib in
            guard let calib = calib else { return }
            self.eventChannel?.updateShowCalib(with: calib)
        }
        
        posenetViewModel?.isExFinished.addObserver { isExFinished in
            guard let isExFinished = isExFinished else { return }
            self.eventChannel?.updateIsExFinished(with: isExFinished)
            
            let currentIndex  = self.posenetViewModel?.getCurrValue()
            self.eventChannel?.updateCurrentIndex(with: currentIndex ?? Int32(0))
        }
        
        posenetViewModel?._actionStop.addObserver { actionStop in
            guard let actionStop = actionStop else { return }
            self.eventChannel?.updateActionStop(with: actionStop)
            
//            if Bool(truncating: actionStop) {
//                guard let recordStatus = self.posenetViewModel?._startRecording.value else { return }
//                
//                if Bool(truncating: recordStatus) {
//                    self.camera.stopRecording(shouldSave: true)
//                    self.posenetViewModel?._startRecording.postValue(value: KotlinBoolean(false))
//                }
//            }
        }
        
        posenetViewModel?.exFeedbackForTTS.addObserver { text in
            guard let text = text else { return }
            self.eventChannel?.updateFeedback(with: text)
        }
        
        
        posenetViewModel?.progressHold.addObserver { progressHold in
            guard let progressHold = progressHold else { return }
            self.eventChannel?.updateHoldTime(with: progressHold)
        }
        
        posenetViewModel?.timeToShow.addObserver { time in
            guard let timeToShow = time else { return }
            print("DEBUG:- TIME: \(timeToShow)")
            self.eventChannel?.updateElapsedTime(with: timeToShow)
            
            //            print("DEBUG:- FPS: \(self.fpsCount)")
            self.fpsCount = 0
        }
        
//        posenetViewModel?._startRecording.addObserver { shouldRecord in
//            guard let shouldRecord = shouldRecord else { return }
//            if Bool(truncating: shouldRecord) {
//                self.camera.startRecording { fileLocation, error in
//                    if let error = error {
//                        fatalError("Error occoured while Recording: \(error)")
//                    }
//
//                    guard let url = fileLocation else { return }
//                    print("DEBUG:- got video: \(url)")
//                    PHPhotoLibrary.shared().performChanges({
//                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)}) { (saved, error) in
//                            if error == nil {
//                                print("DEBUG:- ERROR WHILE SAVING: \(error!.localizedDescription)")
//                            } else if saved {
//                                print("DEBUG:- VIDEO SAVED TO GALLERY SUCCESSFULLY!")
//                            }
//                        }
//                }
//            }
//        }
        
    }
    
    func initialiseExerciseSession() {
        isSessionInitialized = true
        
        guard let posenetViewModel = posenetViewModel else { return }

        let exercisesArray = KotlinArray<Exercise>.init(size: Int32(methodChannel?.allExercises.count ?? 0)) { index in
            return self.methodChannel?.allExercises[Int(truncating: index)]
        }

        posenetViewModel.exercises = exercisesArray
//        posenetViewModel.initialPainScore = PosenetFragmentArgs.fromBundle(it).painScore
//        posenetViewModel.name = PosenetFragmentArgs.fromBundle(it).name
//        posenetViewModel.videoRecording = PosenetFragmentArgs.fromBundle(it).videoRecording
        posenetViewModel.breakInterval = Int32(5)
        
        posenetViewModel.exerciseResList.removeAllObjects()
        if posenetViewModel.exercises.size > 0 {
            for index in 0 ..< (posenetViewModel.exercises.size) {
                guard let exercise = posenetViewModel.exercises.get(index: index) else { return }
                let exerciseItem = ExerciseItem(name: exercise.name ?? "", correct_reps: 0, total_reps: 0, setList: NSMutableArray())
                
                posenetViewModel.exerciseResList.add(exerciseItem)
            }
        }
        
//        ExConstants.holdingTime().minimumHoldTime
        
        
        guard let currentExercise = posenetViewModel.exercises.get(index: posenetViewModel.getCurrValue()) else { return }
        posenetViewModel.repCounter = RepetitionCounter(exercise: currentExercise)
//        setCalibImage(viewModel.exercises[viewModel.getCurrValue()].name.toString())
        posenetViewModel.initialSetup()
        
//        posenetViewModel?.startExercise = true
    }
    
    func cameraSetupListener() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(removeLoading), userInfo: nil, repeats: false)
    }
    
    @objc func removeLoading() {
        eventChannel?.shouldShowLoading(shouldShow: false)
    }
}

// MARK: - FlutterPlatformView
extension TrackerView: FlutterPlatformView {
    func view() -> UIView {
        return broadcastView
    }
}

// MARK: - Delegate CameraDelegate
extension TrackerView: CameraDelegate {
    func didCaptureOutput(pixelBuffer: CVImageBuffer?) {
        tracker?.send(pixelBuffer)
    }
}

// MARK: - Delegate UpperBodyPoseTrackerDelegate
extension TrackerView: UpperBodyPoseTrackerDelegate {
    func upperBodyPoseTracker(_ tracker: UpperBodyPoseTracker!, didOutputLandmarks landmarks: [Landmark]!) {
        if isSessionInitialized {
            var allNativeLandmarks = [NativeLandmark]()
            
            landmarks.forEach { landmark in
                allNativeLandmarks.append(NativeLandmark(mpLandmark: landmark))
            }
            
            DispatchQueue.main.async {
                let kotlinLandmarks = KotlinMutableDictionary<KotlinInt, KotlinMutableDictionary<NSString, KotlinFloat>>.init(dictionary: self.threshLandmarks(landmarks: landmarks))
                self.posenetViewModel?.startProcess(poseLandmarks: kotlinLandmarks)
                
                self.eventChannel?.liveLandmarks(landmarks: allNativeLandmarks)
            }
        }
    }
    
    func threshLandmarks(landmarks: [Landmark]) -> [Int32: KotlinMutableDictionary<NSString, KotlinFloat>] {
        var idxToCoordinates: [Int32: KotlinMutableDictionary<NSString, KotlinFloat>] =  [Int32: KotlinMutableDictionary<NSString, KotlinFloat>]()
        
        landmarks.forEach { landmark in
            if landmark.presence > 0.5 {
                var landmarkDict = [NSString: Float]()
                landmarkDict["x"] = landmark.x.truncate(places: 4)
                landmarkDict["y"] = landmark.y.truncate(places: 4)
                landmarkDict["z"] = landmark.z.truncate(places: 4)
                
                let kotlinLandmark = KotlinMutableDictionary<NSString, KotlinFloat>.init(dictionary: landmarkDict)
                
                idxToCoordinates[landmark.index] = kotlinLandmark
            }
        }
        
        return idxToCoordinates
    }
    
    func upperBodyPoseTracker(_ tracker: UpperBodyPoseTracker!, didOutputPixelBuffer pixelBuffer: CVPixelBuffer!) {
        DispatchQueue.main.async {
            self.fpsCount += 1
            self.broadcastView.image = UIImage(ciImage: CIImage(cvPixelBuffer: pixelBuffer))
        }
    }
}


extension TrackerView: MethodChannelDelegate {
    func didUpdateAllExercises() {
        initialiseExerciseSession()
    }
    
    func startNextExercise() {
        posenetViewModel?.startNextExercise()
    }
    
    func finishAllExercises() {
//        guard let recordStatus = posenetViewModel?._startRecording.value else { return }
//
//        if Bool(truncating: recordStatus) {
//            camera.stopRecording(shouldSave: true)
//            posenetViewModel?._startRecording.postValue(value: KotlinBoolean(false))
//        }
        
        posenetViewModel?.stopCurrentSession()
    }
    
    func skipCurrentExercise() {
        posenetViewModel?.onSkipClick()
    }
    
    func removeCalibration() {
        posenetViewModel?.removeCalib()
    }
    
    func disposeSession() -> Bool {
        print("DEBUG:- DISPOSING SESSION")
        camera?.stop()
        camera = nil
        tracker = nil
        tracker?.delegate = nil
        
//        guard let recordStatus = posenetViewModel._startRecording.value else { return }
//
//        if Bool(truncating: recordStatus) {
//            camera.stopRecording(shouldSave: false)
//            posenetViewModel._startRecording.postValue(value: KotlinBoolean(false))
//        }
        
        posenetViewModel?.onStopTime()
        posenetViewModel = nil
        
        methodChannel = nil
        eventChannel = nil
        
        return true
    }
}
