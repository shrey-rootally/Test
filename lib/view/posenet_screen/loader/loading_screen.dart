import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class LoadingScreenOverlay extends ModalRoute<void> {
  final Color backgroundColor = const Color(0xFFE5E5E5);
  Color textColor = const Color(0xFF6D6D6D);

  final double loadingIndicatorHeight = 12;
  // static var currentActiveIndex = 0;
  int totalIndicators = 4;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(1);

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
      child: _buildOverlayContent(context),
    );
  }

  Widget _buildOverlayContent(BuildContext mainContext) {
    double screenHeight = MediaQuery.of(mainContext).size.height;
    // startAnimation();
    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      // alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: screenHeight * 0.3,
            height: screenHeight * 0.25,
            child: const Image(
              image: AssetImage('assets/exercise/loading_exercise.png'),
            ),
          ),
          Text(
            "Stretch your body till we setup your Camera.",
            style: TextStyle(color: textColor, fontSize: 20),
          ),
          const SizedBox(
            height: 11,
          ),
          SizedBox(
            height: loadingIndicatorHeight,
            width: loadingIndicatorHeight * (totalIndicators * 1.3),
            child: const LoadingIndicators(),
          )
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
