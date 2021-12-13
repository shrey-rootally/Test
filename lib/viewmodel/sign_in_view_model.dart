import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rootally/constants/app_text.dart';
import 'package:rootally/locator.dart';
import 'package:rootally/constants/route_path.dart' as routes;
import 'package:rootally/model/sign_in_model.dart';
import 'package:rootally/services/navigation_service.dart';

class SignInViewModel extends GetxController {
  final _isLoading = false.obs;
  final _signInResponse = "".obs;
  final _hasLoggedInError = false.obs;
  final NavigationService _navigationService = locator<NavigationService>();

  bool get isLoading {
    return _isLoading.value;
  }

  String get signInResponse {
    return _signInResponse.value;
  }

  bool get hasLoggedInError {
    return _hasLoggedInError.value;
  }

  /// This function use for google sign in and validate user
  Future<void> signInUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    if (!_isLoading.value) {
      _isLoading.value = true;
      _hasLoggedInError.value = false;
      try {
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        bool result = await SignInModel().validateUser(userId: user.user!.uid);
        if (result) {
          _signInResponse.value = AppText.successText;
        } else {
          _signInResponse.value = 'You are not validated, Contact your physio';
          _hasLoggedInError.value = true;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          _signInResponse.value = 'Incorrect username or password';
        } else if (e.code == 'user-not-found') {
          _signInResponse.value = 'You are not registered';
        } else {
          _signInResponse.value = 'Something wants wrong';
        }
        _hasLoggedInError.value = true;
        log("ERROR FROM SIGN_IN VIEW MODEL - " + e.toString());
        _isLoading.value = false;
      } catch (e) {
        _hasLoggedInError.value = true;
        log("ERROR FROM SIGN_IN VIEW MODEL - " + e.toString());
        _isLoading.value = false;
      }
      _isLoading.value = false;
      if (_signInResponse.value == "success") {
        _navigationService.pushReplacementNamed(routes.homeRoute,
            argumates: routes.loginRoute);
      }
    }
  }
}
