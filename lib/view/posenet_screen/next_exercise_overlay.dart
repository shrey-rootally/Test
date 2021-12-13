import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef StartNextExerciseCallback = void Function();

class NextExerciseOverlay extends ModalRoute<void> {
  String currentExerciseName;
  String nextExerciseName;
  int totalReps;
  int correctReps;
  int breakTime;
  bool isNextAvailable;
  final StartNextExerciseCallback startNextExercise;
  NextExerciseOverlay({
    Key? key,
    required this.currentExerciseName,
    required this.nextExerciseName,
    required this.totalReps,
    required this.correctReps,
    required this.breakTime,
    required this.isNextAvailable,
    required this.startNextExercise,
  });

  late int percentCorrectReps = ((correctReps / totalReps) * 100).round();
  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.85);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext mainContext) {
    double screenWidth = MediaQuery.of(mainContext).size.width;
    double screenHeight = MediaQuery.of(mainContext).size.height;
    double leftPadding = MediaQuery.of(mainContext).padding.left;
    double rightPadding = MediaQuery.of(mainContext).padding.right;
    double cameraViewWidth = ((screenHeight / 3) * 4);

    void didFinishTimer() {
      startNextExercise();
      Navigator.pop(mainContext);
    }

    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            // decoration: const BoxDecoration(color: Colors.red),
            height: screenHeight,
            width: cameraViewWidth - (leftPadding),
            alignment: Alignment.center,
            child: const Text(
              "FINISHED",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 44,
                color: Colors.green,
              ),
            ),
          ),
          Container(
            // decoration: const BoxDecoration(color: Colors.green),
            height: screenHeight,
            width: screenWidth - cameraViewWidth - (rightPadding),
            alignment: Alignment.center,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentExerciseName,
                        style:
                        const TextStyle(color: Colors.white, fontSize: 26),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              height: 45,
                              width: 45,
                              // decoration: BoxDecoration(color: Colors.amber),
                              child: Stack(
                                fit: StackFit.expand,
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      value: correctReps / totalReps),
                                  Center(
                                    child: Text(
                                      "$percentCorrectReps%",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              )),
                          const SizedBox(width: 10),
                          const Text(
                            "Correct Reps",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.75,
                  width: screenWidth - cameraViewWidth - (rightPadding) - 30,
                  height: 60,
                  child: Center(
                    child: Container(
                      // decoration: BoxDecoration(color: Colors.white),
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isNextAvailable
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Next Exercise",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                nextExerciseName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 21,
                                ),
                              )
                            ],
                          )
                              : Container(),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              didFinishTimer();
                            },
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Stack(
                                fit: StackFit.expand,
                                alignment: Alignment.center,
                                children: [
                                  TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0.0, end: 1),
                                    duration: Duration(seconds: breakTime),
                                    builder: (context, value, _) =>
                                        CircularProgressIndicator(
                                            color: Colors.white,
                                            value: value as double),
                                    onEnd: () => {didFinishTimer()},
                                  ),
                                  Center(
                                      child: Icon(
                                        isNextAvailable
                                            ? Icons.play_arrow_rounded
                                            : Icons.cancel_rounded,
                                        color: Colors.white,
                                        size: 35,
                                      )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
