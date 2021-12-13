import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/constants/app_text.dart';
import 'package:rootally/model/report_model/practice_report_data.dart';
import 'package:rootally/utils/helper.dart';
import 'package:rootally/view/widgets/app_widgets.dart';

class PracticeReportScreen extends StatefulWidget {
  const PracticeReportScreen({Key? key}) : super(key: key);

  @override
  State<PracticeReportScreen> createState() => _PracticeReportScreenState();
}

class _PracticeReportScreenState extends State<PracticeReportScreen> {
  late double height, width, accuracy;
  late bool isPortait;
  late PracticeReportData practiceReportData;
  @override
  void initState() {
    practiceReportData = PracticeReportData(
        completedReps: 6, incompletedReps: 4, exersiceName: "Leg Raise");
    accuracy = practiceReportData.completedReps *
        100 /
        (practiceReportData.completedReps +
            practiceReportData.incompletedReps) /
        100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    isPortait = MediaQuery.of(context).orientation == Orientation.portrait;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.cyanBackgrondColor,
      body: SafeArea(
          child: Stack(
        children: [
          getBackground(),
          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              getTopComponent(),
              getReportComponent(context),
            ],
          ),
        ],
      )),
    );
  }

  SliverList getTopComponent() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SizedBox(
            height: isPortait ? height * 0.18 : height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 10),
                  child: AppWidgets.getBackBtn(),
                ),
                const Center(
                  child: Text(
                    AppText.exerciseDemoText,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                emptyVerticalBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppText.completedText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    emptyHorizontalBox(width: 4),
                    Image.asset(
                      "assets/checked_green.png",
                      height: 23,
                      width: 23,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container getBackground() {
    return Container(
      height: height * 0.27,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background/cyan_bubbles.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  SliverList getReportComponent(mainContext) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: isPortait ? height * 0.778 : height,
            child: Column(
              children: [
                emptyVerticalBox(
                  height: height * 0.07,
                ),
                getPercentIndicator(),
                emptyVerticalBox(height: 20),
                getExerciseDetailText(),
                emptyVerticalBox(height: 10),
                Container(
                  height: 95,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.demoTileColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            practiceReportData.exersiceName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryColor,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "${(practiceReportData.completedReps + practiceReportData.incompletedReps)} ${AppText.repsText}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondaryColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      emptyVerticalBox(height: 6),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  "${AppText.correctText} ${AppText.repsText} - ",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColors.greyTextColor,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: practiceReportData.completedReps.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColors.reportPrimaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      emptyVerticalBox(height: 6),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  "${AppText.incorrectText} ${AppText.repsText} -",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColors.greyTextColor,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text:
                                  practiceReportData.incompletedReps.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColors.reportSecondaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getExerciseDetailText() {
    return const Align(
      alignment: Alignment.topLeft,
      child: Text(
        AppText.exerciseDetailText,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.secondaryColor,
          fontSize: 18,
        ),
      ),
    );
  }

  CircularPercentIndicator getPercentIndicator() {
    return CircularPercentIndicator(
      radius: 130,
      lineWidth: 7.0,
      percent: accuracy,
      animation: true,
      animationDuration: 1200,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AppText.accuracyText,
            style: TextStyle(
              color: AppColors.reportPrimaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "${(accuracy * 100).toInt()}%",
            style: const TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 29,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      progressColor: AppColors.reportPrimaryColor,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
