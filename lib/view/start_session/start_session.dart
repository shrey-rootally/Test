import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/constants/app_text.dart';
import 'package:rootally/model/data/exercises.dart';
import 'package:rootally/utils/helper.dart';
import 'package:rootally/view/start_session/start_exercise_list_tile.dart';
import 'package:rootally/view/widgets/app_widgets.dart';
import 'package:rootally/view/widgets/pain_score_bottom_sheet.dart';

class StartSession extends StatelessWidget {
  final Map<String, dynamic> sessionDeta;
  const StartSession({Key? key, required this.sessionDeta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Exercise> exercise = sessionDeta["exercises"] as List<Exercise>;
    return Scaffold(
      backgroundColor: AppColors.blueBackgroudColor,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? height * 0.27
                            : height * 0.58,
                        padding: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/background/blue_bubbles.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AppWidgets.getBackBtn(),
                                emptyVerticalBox(height: 5),
                                Text(
                                  AppText.startText +
                                      " " +
                                      sessionDeta["sessionName"],
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                emptyVerticalBox(height: 5),
                                Text(
                                  sessionDeta["programName"] +
                                      " " +
                                      AppText.programmeText,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                emptyVerticalBox(height: 10),
                                Container(
                                  height: 25,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.secondaryColor,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      AppText.leftShoulderText,
                                      style: TextStyle(
                                        color: AppColors.greenBackgroudColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                emptyVerticalBox(height: 10),
                                Row(
                                  children: [
                                    getSmallBox(
                                      text: AppText.setsText,
                                      color: AppColors.setsBoxColor,
                                    ),
                                    emptyHorizontalBox(),
                                    getSmallBox(
                                      text: AppText.repsText,
                                      color: AppColors.repsBoxColor,
                                    ),
                                    emptyHorizontalBox(),
                                    getSmallBox(
                                      text: AppText.holdTimeText,
                                      color: AppColors.holdTimeBoxColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Image.asset(
                              "assets/exercise/demo_screen_exercise_logo.png",
                              height: 120,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                getExerciseList(exercise),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? height * 0.1
                        : height * 0.2,
                width: width,
                decoration: BoxDecoration(
                  color: AppColors.bottomBarColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryColor.withOpacity(0.2),
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.1,
                  vertical: height * 0.02,
                ),
                child: AppWidgets.getAppBtn(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      builder: (context) => const PainScoreBottomSheet(
                        btnText: AppText.startSessionText,
                        btnIcon: Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.greenAccentColor,
                          size: 32,
                        ),
                      ),
                    ).then(
                      (value) {
                        log(value.toString());
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.greenAccentColor,
                        size: 32,
                      ),
                      Text(
                        AppText.startSessionText,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  height: height,
                  width: width,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getSmallBox({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          width: 16,
          height: 16,
        ),
        emptyHorizontalBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget getExerciseList(exercise) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.60,
              padding: const EdgeInsets.only(top: 15),
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) =>
                    StartExerciseListTile(exercise: exercise[index]),
                itemCount: exercise.length,
              ),
            ),
            emptyVerticalBox(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 0
                  : MediaQuery.of(context).size.height * 0.2,
            )
          ],
        ),
        childCount: 1,
      ),
    );
  }
}
