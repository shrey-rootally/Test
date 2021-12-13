import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicators extends StatefulWidget {
  const LoadingIndicators({Key? key}) : super(key: key);

  @override
  _LoadingIndicatorsState createState() => _LoadingIndicatorsState();
}

class _LoadingIndicatorsState extends State<LoadingIndicators> {
  final int numberOfIndicators = 4;
  int currentActiveIndicator = 0;
  final Color loadingColor = const Color(0xFFFE6263);
  final double loadingIndicatorHeight = 12;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    startAnimation();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    timer?.cancel();
    super.dispose();
  }

  List<Container> getAllIndicators() {
    List<Container> indicators = [];

    for (int i = 0; i < numberOfIndicators; i++) {
      indicators.add(Container(
        height: loadingIndicatorHeight,
        width: loadingIndicatorHeight,
        decoration: BoxDecoration(
            color: i == currentActiveIndicator ? loadingColor : Colors.grey,
            borderRadius:
            BorderRadius.all(Radius.circular(loadingIndicatorHeight / 2))),
      ));
    }

    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: getAllIndicators(),
    );
  }

  startAnimation() {
    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => updateProgress());
  }

  updateProgress() {
    setState(() {
      if (currentActiveIndicator < (numberOfIndicators - 1)) {
        currentActiveIndicator++;
      } else {
        currentActiveIndicator = 0;
      }
    });
  }
}