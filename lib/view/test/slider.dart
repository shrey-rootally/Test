import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:rootally/view/widgets/pain_score_bottom_sheet.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              builder: (context) => const PainScoreBottomSheet(
                btnText: "Noo noo",
              ),
            ).then((value) => log(value.toString()));
          },
          child: const Text("Open Slider"),
        ),
      ),
    );
  }
}
