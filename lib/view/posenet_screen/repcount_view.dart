import 'package:flutter/cupertino.dart';

class RepCountView extends StatelessWidget {
  const RepCountView({
    Key? key,
    required this.currentRepCount,
  }) : super(key: key);

  final int currentRepCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$currentRepCount", style: const TextStyle(fontSize: 20)),
          const Text("Reps", style: TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}
