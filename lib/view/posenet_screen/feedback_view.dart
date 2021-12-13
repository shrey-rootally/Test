import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedbackView extends StatelessWidget {
  const FeedbackView({
    Key? key,
    required this.screenWidth,
    required this.cameraViewWidth,
    required String feedbackString,
    required this.repFinishedText,
  })  : _feedbackString = feedbackString,
        super(key: key);

  final double screenWidth;
  final double cameraViewWidth;
  final String _feedbackString;
  final String repFinishedText;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 70,
      right: 70,
      child: Column(
        children: [
          Container(
            height: 50,
            // decoration: BoxDecoration(color: Colors.red),
            width: screenWidth - cameraViewWidth - 140,
            alignment: Alignment.topCenter,
            child: Text(
              _feedbackString,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Container(
            height: 60,
            width: screenWidth - cameraViewWidth - 140,
            alignment: Alignment.center,
            child: Text(
              repFinishedText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 24,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}