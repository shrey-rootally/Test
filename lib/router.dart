import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rootally/constants/route_path.dart' as routes;
import 'package:rootally/view/homepage/homepage.dart';
import 'package:rootally/view/posenet_screen/posenet_screen.dart';
import 'package:rootally/view/report_screen/practice_report_screen.dart';
import 'package:rootally/view/report_screen/report_screen.dart';
import 'package:rootally/view/sign_in/sign_in_view.dart';
import 'package:rootally/view/start_session/start_session.dart';
import 'package:rootally/view/test/slider.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case routes.loginRoute:
      return MaterialPageRoute(builder: (context) => const SignIn());
    case routes.homeRoute:
      var from = "";
      settings.arguments == null
          ? from = ""
          : from = settings.arguments.toString();
      return MaterialPageRoute(
        builder: (context) => HomePage(
          from: from,
        ),
      );
    case routes.startSessionRoute:
      Map<String, dynamic> sessionData = settings.arguments == null
          ? {}
          : settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => StartSession(
          sessionDeta: sessionData,
        ),
      );
    case routes.testRoute:
      return MaterialPageRoute(
        builder: (context) => const Test(),
      );
    case routes.posenetRoute:
      return MaterialPageRoute(
        builder: (context) => const PosenetScreen(),
      );
    case routes.reportRoute:
      List<int> sessionData =
          settings.arguments == null ? [0, 0] : settings.arguments as List<int>;
      return MaterialPageRoute(
        builder: (context) => ReportScreen(
          sessionNumber: sessionData[0],
          initialPainScore: sessionData[1],
        ),
      );
    case routes.practiceReportRoute:
      return MaterialPageRoute(
        builder: (context) => const PracticeReportScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text("No path for ${settings.name}"),
          ),
        ),
      );
  }
}
