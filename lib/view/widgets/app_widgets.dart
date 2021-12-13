import 'package:flutter/material.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/locator.dart';
import 'package:rootally/services/navigation_service.dart';

class AppWidgets {
  static final NavigationService _navigationService =
      locator<NavigationService>();
  static const Widget circularProgressIndicator = Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor),
    ),
  );

  static Widget getAppBtn(
      {required double width,
      required double height,
      required Widget child,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.secondaryColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(width),
        ),
        child: child,
      ),
    );
  }

  static Widget getBackBtn() {
    return GestureDetector(
      onTap: () {
        _navigationService.goBack();
      },
      child: const Icon(Icons.arrow_back),
    );
  }
}
