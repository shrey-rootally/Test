import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> pushName(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {dynamic argumates}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: argumates);
  }

  void goBack({dynamic argumates}) {
    return navigatorKey.currentState!.pop(argumates);
  }
}
