import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/constants/app_text.dart';
import 'package:rootally/utils/helper.dart';
import 'package:rootally/viewmodel/sign_in_view_model.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController? email = TextEditingController(),
      pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          "assets/logo.png",
                          width: 50,
                          height: 50,
                        ),
                      ),
                      emptyVerticalBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            AppText.signInText,
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          emptyHorizontalBox(width: 10),
                          const Icon(Icons.login, size: 25),
                        ],
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                          side: const BorderSide(
                              color: AppColors.secondaryColor, width: 2),
                        ),
                        elevation: 0,
                        child: ListTile(
                          title: TextFormField(
                            controller: email,
                            validator: (val) {
                              if (val == null || val == "") {
                                return AppText.emailRequiredText;
                              } else if (!EmailValidator.validate(val)) {
                                return AppText.invalidEmailText;
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: AppText.emailAddressText,
                              border: InputBorder.none,
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                          side: const BorderSide(
                              color: AppColors.secondaryColor, width: 2),
                        ),
                        elevation: 0,
                        child: ListTile(
                          title: TextFormField(
                            decoration: const InputDecoration(
                              hintText: AppText.passwordText,
                              border: InputBorder.none,
                              alignLabelWithHint: true,
                            ),
                            controller: pass,
                            obscureText: _passwordVisible,
                            validator: (value) {
                              if (value == null || value == "") {
                                return AppText.passwordRequiredText;
                              } else if (value.length <= 7) {
                                return AppText.minEightRequiredText;
                              } else {
                                return null;
                              }
                            },
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            child: _passwordVisible
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                      emptyVerticalBox(height: 5),
                      GetX<SignInViewModel>(
                        init: SignInViewModel(),
                        builder: (controller) {
                          return controller.hasLoggedInError
                              ? Row(
                                  children: [
                                    const Icon(
                                      Icons.error,
                                      color: AppColors.redColor,
                                    ),
                                    Text(
                                      controller.signInResponse,
                                      style: const TextStyle(
                                          color: AppColors.redColor),
                                    )
                                  ],
                                )
                              : Container();
                        },
                      ),
                      emptyVerticalBox(height: 60),
                      GetX<SignInViewModel>(
                        builder: (controller) => MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.signInUser(
                                  email: email!.text,
                                  password: pass!.text,
                                  context: context);
                            }
                          },
                          child: controller.isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.secondaryColor),
                                )
                              : const Text(
                                  AppText.signInOrSignUpText,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                          minWidth: double.infinity,
                          height: 50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                              color: AppColors.secondaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      emptyVerticalBox(height: 10),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          AppText.forgetPasswordText,
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wifi_calling_3_outlined,
                            color: AppColors.primaryColor,
                            size: 16,
                          ),
                          emptyHorizontalBox(width: 10),
                          const Text(
                            AppText.contactUsText,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      emptyVerticalBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
