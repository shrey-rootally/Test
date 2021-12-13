// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rootally/constants/progress_bar_checkpoint_type.dart';
import 'package:rootally/model/data/exercises_alldetails.dart';
import 'package:rootally/model/data/landmark.dart';
import 'package:rootally/utils/landmark_tracker_storage.dart';
import 'package:rootally/view/posenet_screen/progress_bar_checkpoint.dart';
import 'package:rootally/view/posenet_screen/repcount_view.dart';
import 'package:rootally/view/posenet_screen/video_player_view.dart';
import 'package:video_player/video_player.dart';

import 'elapsedtime_view.dart';
import 'feedback_view.dart';
import 'loader/loading_screen.dart';
import 'native_camera_view.dart';
import 'next_exercise_overlay.dart';

class PosenetScreen extends StatefulWidget {
  const PosenetScreen({Key? key}) : super(key: key);

  @override
  State<PosenetScreen> createState() => _PosenetScreenState();
}

class _PosenetScreenState extends State<PosenetScreen> {
  late VideoPlayerController _videoPlayer;
  final FlutterTts tts = FlutterTts();
  bool isTTSMuted = false;
  late Future<void> _initializeVideoPlayerFuture;

  List<ExerciseAll> allExercises = [];
  List<Landmark> allCurrentLandmarks = [];
  int currentIndex = 0;

  static AudioCache audioPlayer = AudioCache();

  static const EventChannel currentRepCountEventChannel =
      EventChannel('com.allycare.dev/repCount');
  static const EventChannel feedbackEventChannel =
      EventChannel('com.allycare.dev/feedback');
  static const EventChannel elapsedTimeEventChannel =
      EventChannel('com.allycare.dev/elapsedTime');
  static const EventChannel holdTimeEventChannel =
      EventChannel("com.allycare.dev/holdTime");
  static const EventChannel showCalibEventChannel =
      EventChannel("com.allycare.dev/showCalib");
  static const EventChannel isExFinishedEventChannel =
      EventChannel("com.allycare.dev/isExFinished");
  static const EventChannel actionStopEventChannel =
      EventChannel("com.allycare.dev/actionStop");
  static const EventChannel currentIndexEventChannel =
      EventChannel("com.allycare.dev/currentIndex");
  static const EventChannel liveLandmarksEventChannel =
      EventChannel("com.allycare.dev/liveLandmarks");

  static const EventChannel showLoadingScreenEventChannel =
      EventChannel("com.allycare.dev/showLoadingScreen");

  String _feedbackString = 'This is sample feedback';
  int currentRepCount = 0;
  String _elapsedTimeString = 'xx:xx min';
  String repFinishedText = "";
  int _repHoldTime = 0;

  bool isCalibrationOn = false;

  String calibrationScreenImageName = "standing_notdetected";

  int currentHoldTimeInSeconds = 0;

  double _repProgressValue = 0;

  bool isFirstTracking = true;
  final LandmarkTrackerStorage trackerStorage = LandmarkTrackerStorage();
  bool isLandmarkTrackingStopped = false;

  int totalRepCount = 0;
  static const methodChannel = MethodChannel('com.allycare.dev');

  Future<void> stopSessionMethodChannel() async {
    try {
      final int _ = await methodChannel.invokeMethod('finishAllExercises');
    } on PlatformException catch (e) {
      print("Failed to get finishAllExercises: '${e.message}'.");
    }
  }

  void startTrackingLandmark() {
    trackerStorage.addLandmarks(allCurrentLandmarks);
  }

  void stopTrackingLandmark() {
    trackerStorage.write();
  }

  Future<void> skipExeriseMethodChannel() async {
    try {
      print('trying to skip exercise');
      final bool _ = await methodChannel.invokeMethod('skipCurrentExercise');
    } on PlatformException catch (e) {
      print("Failed to get skipCurrentExercise: '${e.message}'.");
    }
  }

  Future<void> startNextExerciseMethodChannel() async {
    print("trying to start next exercise 1");
    try {
      print("trying to start next exercise 2");
      final bool _ = await methodChannel.invokeMethod('startNextExercise');
    } on PlatformException catch (e) {
      print("Failed to get startNextExercise: '${e.message}'.");
    }
  }

  void showRepFinished() {
    setState(() {
      repFinishedText = "REP FINISHED!";
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        repFinishedText = "";
      });
    });
  }

  List<ProgressBarCheckpoint> getConfiguredProgressCheckpoints() {
    List<ProgressBarCheckpoint> allCheckpoints = [];

    int numberOfSeconds = _repHoldTime ~/ 1000;

    playCheckPointAudio(numberOfSeconds);

    for (var i = 0; i <= allExercises[currentIndex].holdTime!; i++) {
      allCheckpoints.add(ProgressBarCheckpoint(
          numberOfSeconds: i,
          type: i == allExercises[currentIndex].holdTime
              ? ProgressBarCheckpointType.last
              : (i <= numberOfSeconds
                  ? ProgressBarCheckpointType.completed
                  : ProgressBarCheckpointType.incomplete)));
    }

    return allCheckpoints;
  }

  void playCheckPointAudio(int newSecond) {
    const metronome1Sound = "metronome1.mp3";
    const metronome2Sound = "metronome2.mp3";
    const finishSound = "finishRep.mp3";

    if (newSecond > currentHoldTimeInSeconds) {
      currentHoldTimeInSeconds = newSecond;

      if (newSecond == allExercises[currentIndex].holdTime) {
        audioPlayer.play(finishSound);
      } else if (newSecond % 2 == 0) {
        audioPlayer.play(metronome1Sound);
      } else {
        audioPlayer.play(metronome2Sound);
      }
    }
  }

  void updateRepProgressBar() {
    setState(() {
      _repProgressValue = currentRepCount / totalRepCount;
    });
  }

  Future<void> fetchAllExercises() async {
    for (int i = 0; i < 3; i++) {
      allExercises.add(ExerciseAll(
          category: "knee",
          image: "sss",
          postureType: "upperBodyFrontView",
          id: 2,
          name: "Straight Leg Raise",
          holdTime: 3,
          sets: 1,
          video: "video",
          repititions: 5));
    }

    // parsing
    List<Map<dynamic, dynamic>> allExercisesData = [];
    for (var exercise in allExercises) {
      var exerciseData = exercise.toJson();
      allExercisesData.add(exerciseData);
    }

    try {
      final bool _ = await methodChannel.invokeMethod('setAllExercises', {
        "data": allExercisesData,
      });
    } on PlatformException catch (e) {
      print("Failed to set all Exercises: '${e.message}'.");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).push(LoadingScreenOverlay());
    });

    fetchAllExercises();
    super.initState();

    /// VIDEO PLAYER
    _videoPlayer = VideoPlayerController.asset("assets/comp_1.mp4");
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _videoPlayer.initialize();

    // Use the controller to loop the video.
    _videoPlayer.setLooping(true);
    //_videoPlayer.play();

    /// EVENT CHANNEL

    showLoadingScreenEventChannel
        .receiveBroadcastStream("showLoadingScreen")
        .listen((event) {
      final bool shouldShow = event;

      if (!shouldShow) {
        Navigator.of(context).pop();
      }
    });
    feedbackEventChannel.receiveBroadcastStream("feedback").listen((event) {
      final String feedbackMsg = event;

      setState(() {
        if (!isTTSMuted) {
          tts.speak(feedbackMsg);
        }

        _feedbackString = feedbackMsg;
      });
    });

    elapsedTimeEventChannel
        .receiveBroadcastStream("elapsedTime")
        .listen((event) {
      final String time = event;

      setState(() {
        _elapsedTimeString = time;
      });
    });

    holdTimeEventChannel.receiveBroadcastStream("holdTime").listen((event) {
      final int time = event;
      setState(() {
        _repHoldTime = time;
      });
    });

    showCalibEventChannel.receiveBroadcastStream("showCalib").listen((event) {
      final bool showCalib = event;
      setState(() {
        if (showCalib) {
          _openCalibration(context);
        } else {
          _removeCalibration(context);
        }
      });
    });

    isExFinishedEventChannel
        .receiveBroadcastStream("isExFinished")
        .listen((event) {
      final bool isExFinished = event;
      setState(() {
        if (isExFinished) {
          _openNextExercisePopup(context);
        }
      });
    });

    actionStopEventChannel.receiveBroadcastStream("actionStop").listen((event) {
      final bool actionStop = event;
      print("GOR IN FLUTTER: $actionStop");
      if (actionStop) {
        if (!isLandmarkTrackingStopped) {
          isLandmarkTrackingStopped = true;
          stopTrackingLandmark();
        }
      }
    });

    currentIndexEventChannel
        .receiveBroadcastStream("currentIndex")
        .listen((event) {
      final int newCurrentIndex = event;
      setState(() {
        totalRepCount = allExercises[newCurrentIndex].repititions;

        if (newCurrentIndex > currentIndex) {
          currentRepCount = 0;
        }

        currentIndex = newCurrentIndex;
      });
    });

    // RepCount EventChannel Init
    currentRepCountEventChannel.receiveBroadcastStream("repCount").listen(
        (event) {
      final int newRepCount = event;
      if (newRepCount > currentRepCount) {
        currentRepCount = newRepCount;
        showRepFinished();
        updateRepProgressBar();
        currentHoldTimeInSeconds = 0;
        // if (newRepCount == totalRepCount) {
        //   _openNextExercisePopup(context);
        // }
      }
    }, onError: (error) {
      print('ERROR WHILE REP COUNT INIT: ${error.toString()}');
    });

    liveLandmarksEventChannel
        .receiveBroadcastStream("liveLandmarks")
        .listen((event) {
      final allLandmarksData = event as List<Object?>;
      List<Landmark> allLandmarks = [];

      allLandmarksData.forEach((landmarkData) {
        Map<String, dynamic> map = jsonDecode(landmarkData.toString());
        final landmark = Landmark.fromJson(map);
        allLandmarks.add(landmark);
      });

      allCurrentLandmarks = allLandmarks;

      if (isFirstTracking) {
        startTrackingLandmark();
        isFirstTracking = false;
      }
    });
  }

  @override
  void dispose() async {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _videoPlayer.dispose();
    print("FLUTTER DISPOSE CaLLED!");
    try {
      final bool success = await methodChannel.invokeMethod("disposeSession");
      if (success) {
        print("FLUTTER DISPOSING!");

        if (!isLandmarkTrackingStopped) {
          stopTrackingLandmark();
        }
        super.dispose();
      }
    } on PlatformException catch (e) {
      print("Failed to get disposeSession: '${e.message}'.");
    }
  }

//   Future<bool> _showMyDialog() async {
//     bool canExit;
//   return ;
// }

  Future<bool> _promptExit() async {
    late bool canExit;
    AlertDialog dialog = AlertDialog(
      title: const Text('Stop Session?'),
      content: const Text(
          "Are you sure you want to stop this session? \nYour progress won't be saved."),
      actions: [
        TextButton(
          onPressed: () {
            Future.value(true);
            canExit = true;
          },
          child: const Text("Confirm"),
        ),
        TextButton(
          onPressed: () {
            Future.value(false);
            canExit = false;
          },
          child: const Text("Cancel"),
        ),
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return dialog;
      },
    );

    return false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double cameraViewWidth = (screenHeight / 3) * 4;
    // This is used in the platform side to register the view.
    const String viewType = '<platform-view-type>';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    ValueNotifier<bool> isDialOpen = ValueNotifier(false);

    return ConditionalWillPopScope(
      onWillPop: () async {
        // show the confirm dialog
        print("i am here");
        return await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Are you sure want to leave?'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    //return false when click on "NO"
                    child: Text('No'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    //return true when click on "Yes"
                    child: Text('Yes'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      shouldAddCallbacks: true,
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              fit: StackFit.loose,
              children: [
                Container(
                  height: screenHeight,
                  width: cameraViewWidth,
                  alignment: Alignment.center,
                  child: NativeCameraView(
                      screenHeight: screenHeight,
                      cameraViewWidth: cameraViewWidth,
                      viewType: viewType,
                      creationParams: creationParams),
                ),
                CreateProgressBar(cameraViewWidth),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: isCalibrationOn,
                  child: Container(
                    height: screenHeight,
                    width: cameraViewWidth,
                    // decoration: BoxDecoration(color: Colors.amber),
                    alignment: Alignment.center,
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.85)),
                      height: screenHeight,
                      width: cameraViewWidth,
                      alignment: Alignment.center,
                      child: Image(
                        colorBlendMode: BlendMode.overlay,
                        height: screenHeight * 0.85,
                        fit: BoxFit.contain,
                        image: AssetImage(
                            'assets/exercise/$calibrationScreenImageName.png'),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Stack(
              fit: StackFit.loose,
              children: [
                VideoPlayerView(
                    initializeVideoPlayerFuture: _initializeVideoPlayerFuture,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    cameraViewWidth: cameraViewWidth,
                    videoPlayer: _videoPlayer),
                FeedbackView(
                    screenWidth: screenWidth,
                    cameraViewWidth: cameraViewWidth,
                    feedbackString: _feedbackString,
                    repFinishedText: repFinishedText),
                RepCountView(currentRepCount: currentRepCount),
                CreateActionButton(screenHeight, screenWidth, cameraViewWidth,
                    isDialOpen, context),
                ElapsedTimeView(
                    screenHeight: screenHeight,
                    elapsedTimeString: _elapsedTimeString)
              ],
            )
          ],
        ),
        // floatingActionButton: CreateMoreOptionsButton(isDialOpen, context),
      ),
    );
  }

  Positioned CreateActionButton(
      double screenHeight,
      double screenWidth,
      double cameraViewWidth,
      ValueNotifier<bool> isDialOpen,
      BuildContext context) {
    return Positioned(
      top: screenHeight - 90,
      left: screenWidth - cameraViewWidth - 90,
      child: Container(
        height: 60,
        width: 60,
        alignment: Alignment.center,
        // decoration: BoxDecoration(color: Colors.red),
        child: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(color: Colors.red),
          openCloseDial: isDialOpen,
          backgroundColor: Colors.white,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          spacing: 15,
          spaceBetweenChildren: 2,
          closeManually: false,
          children: [
            SpeedDialChild(
                child: const Icon(Icons.volume_off, color: Colors.blue),
                label: 'Mute',
                // backgroundColor: Colors.blue,
                onTap: () {
                  setState(() {
                    isTTSMuted = isTTSMuted == true ? false : true;
                  });
                }),
            SpeedDialChild(
                child: const Icon(Icons.skip_next, color: Colors.blue),
                label: 'Skip',
                onTap: () {
                  skipExeriseMethodChannel();
                }),
            SpeedDialChild(
                child: const Icon(Icons.stop, color: Colors.red),
                label: 'Finish',
                onTap: () {
                  stopSessionMethodChannel();
                }),
          ],
        ),
      ),
    );
  }

  _openNextExercisePopup(context) {
    Navigator.of(context).push(NextExerciseOverlay(
        currentExerciseName: allExercises[currentIndex].name,
        nextExerciseName: currentIndex < (allExercises.length - 1)
            ? allExercises[currentIndex + 1].name
            : "",
        totalReps: allExercises[currentIndex].repititions,
        correctReps: 0,
        breakTime: 5,
        isNextAvailable: currentIndex < (allExercises.length - 1),
        startNextExercise: startNextExerciseMethodChannel));
  }

  _openCalibration(context) {
    var currentExerciseTypeString = allExercises[currentIndex].postureType;
    switch (currentExerciseTypeString) {
      case "layDownOnBed":
        calibrationScreenImageName = "calib_laydownonfloor_complete";
        break;
      case "stand":
        calibrationScreenImageName = "calib_standing_complete";
        break;
      case "sitOnBed":
        calibrationScreenImageName = "calib_sitonbed_complete";
        break;
      case "upperBodyFrontView":
        calibrationScreenImageName = "calib_upperbodyfrontview_complete";
        break;
      case "upperBodySideView":
        calibrationScreenImageName = "calib_upperbodysideview_complete";
        break;
    }

    setState(() {
      isCalibrationOn = true;
    });
  }

  _removeCalibration(context) async {
    try {
      final bool _ = await methodChannel.invokeMethod('removeCalibration');

      _videoPlayer.play();
    } on PlatformException catch (e) {
      print("Failed to remove Calibration: '${e.message}'.");
    }

    setState(() {
      isCalibrationOn = false;
    });
  }

  Positioned CreateProgressBar(double cameraViewWidth) {
    return Positioned(
      top: 20,
      left: 60,
      right: 60,
      child: Stack(children: [
        Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: Container(
              height: 3,
              width: cameraViewWidth - 120,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: LinearProgressIndicator(
                value: (_repHoldTime /
                    (allExercises[currentIndex].holdTime! * 1000)),
                backgroundColor: Colors.white,
                color: const Color(0xFF694CFF),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            // color: Colors.amber,
          ),
          height: 30,
          width: cameraViewWidth - 120,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: getConfiguredProgressCheckpoints(),
            ),
          ),
        ),
      ]),
    );
  }
}
