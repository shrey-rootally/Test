import 'package:flutter/material.dart';
import 'package:rootally/locator.dart';
import 'package:rootally/services/navigation_service.dart';
import 'package:rootally/constants/route_path.dart' as routes;
import 'package:rootally/utils/helper.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          onPressed: () => _navigationService.pushName(routes.testRoute),
          child: const Text("Goto Test"),
        ),
        emptyVerticalBox(),
        MaterialButton(
          onPressed: () => _navigationService.pushName(
            routes.reportRoute,
            arguments: [1, 1],
          ),
          child: const Text("Goto Report"),
        ),
        emptyVerticalBox(),
        MaterialButton(
          onPressed: () =>
              _navigationService.pushName(routes.practiceReportRoute),
          child: const Text("Goto Practice Report"),
        ),
      ],
    );
  }
}
