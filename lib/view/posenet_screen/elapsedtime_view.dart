import 'package:flutter/cupertino.dart';

class ElapsedTimeView extends StatelessWidget {
  const ElapsedTimeView({
    Key? key,
    required this.screenHeight,
    required String elapsedTimeString,
  })  : _elapsedTimeString = elapsedTimeString,
        super(key: key);

  final double screenHeight;
  final String _elapsedTimeString;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: screenHeight - 50,
      child: Container(
        height: 50,
        width: 120,
        alignment: Alignment.center,
        child: Text(_elapsedTimeString, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
