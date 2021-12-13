import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeCameraView extends StatelessWidget {
  const NativeCameraView({
    Key? key,
    required this.screenHeight,
    required this.cameraViewWidth,
    required this.viewType,
    required this.creationParams,
  }) : super(key: key);

  final double screenHeight;
  final double cameraViewWidth;
  final String viewType;
  final Map<String, dynamic> creationParams;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight,
      width: cameraViewWidth,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(color: Colors.black),
      child: Align(
        alignment: Alignment.centerLeft,
        child: defaultTargetPlatform == TargetPlatform.iOS
            ? UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        )
            : AndroidView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      ),
    );
  }
}
