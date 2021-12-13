import 'package:flutter/material.dart';
import 'package:rootally/constants/progress_bar_checkpoint_type.dart';

class ProgressBarCheckpoint extends StatelessWidget {
  final int numberOfSeconds;
  final ProgressBarCheckpointType type;

  const ProgressBarCheckpoint(
      {Key? key, required this.numberOfSeconds, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double normalSize = 15.0;
    double largeSize = 22.0;
    const Color purple = Color(0xFF694CFF);
    const Color darkGrey = Color(0xFF6D6D6D);

    return InkResponse(
        child: Container(
          width: type == ProgressBarCheckpointType.last ? largeSize : normalSize,
          height: type == ProgressBarCheckpointType.last ? largeSize : normalSize,
          decoration: BoxDecoration(
            color:
            type == ProgressBarCheckpointType.completed ? purple : Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
              child: type != ProgressBarCheckpointType.last
                  ? Icon(
                Icons.done,
                color: Colors.white,
                size: normalSize - 4,
              )
                  : Text(
                '$numberOfSeconds',
                style: const TextStyle(color: darkGrey),
              )),
        ));
  }
}
