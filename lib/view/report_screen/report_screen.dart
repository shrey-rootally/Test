import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/constants/app_text.dart';
import 'package:rootally/model/report_model/report_data.dart';
import 'package:rootally/utils/helper.dart';
import 'package:rootally/view/report_screen/report_chart_tile.dart';
import 'package:rootally/view/report_screen/test_report_data.dart';
import 'package:rootally/view/widgets/app_widgets.dart';
import 'package:rootally/view/widgets/pain_score_bottom_sheet.dart';

class ReportScreen extends StatefulWidget {
  final int sessionNumber;
  final int initialPainScore;
  const ReportScreen(
      {Key? key, required this.sessionNumber, required this.initialPainScore})
      : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late ReportData reportData;
  late double height, width;
  late bool isPortrait;
  late double accuracyPercent;

  @override
  void initState() {
    reportData = TestReportData.reportData;

    int assignReps = 0, correctReps = 0;

    for (var element in reportData.exercises) {
      assignReps += element.assignReps * element.setList.length;
      for (var setData in element.setList) {
        correctReps += setData.correctReps;
      }
    }

    if (correctReps >= assignReps) {
      accuracyPercent = 100;
    } else {
      accuracyPercent = correctReps / assignReps;
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => const PainScoreBottomSheet(
          btnText: AppText.showResultsText,
        ),
      ).then(
        (value) {
          /// Take PainScore from HERE
          log(value.toString());
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

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
        ),
      ),
    );
  }

  Widget getBackground() {
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

  Widget getTopComponent() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SizedBox(
            height: isPortrait ? height * 0.18 : height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 10),
                  child: AppWidgets.getBackBtn(),
                ),
                const Center(
                  child: Text(
                    AppText.youDidAmazingText,
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
                    Text(
                      AppText.sessionText +
                          " ${widget.sessionNumber == 0 ? "" : widget.sessionNumber} " +
                          AppText.completedText,
                      style: const TextStyle(
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
            height: isPortrait ? height * 0.778 : height,
            child: Column(
              children: [
                emptyVerticalBox(height: 10),
                getPercentIndicator(),
                emptyVerticalBox(height: 10),
                getInfoText(),
                emptyVerticalBox(height: 10),
                seeDetailTitle(),
                emptyVerticalBox(height: 10),
                getSetDetails(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getPercentIndicator() {
    return CircularPercentIndicator(
      radius: 130,
      lineWidth: 7.0,
      percent: accuracyPercent,
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
            "${(accuracyPercent * 100).toInt()}%",
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

  Widget getInfoText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: AppColors.redColor,
          size: 20,
        ),
        emptyHorizontalBox(width: 5),
        const Text(
          AppText.notifyMsgText,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.greyTextColor,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        )
      ],
    );
  }

  Widget seeDetailTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          AppText.seeDetailsText,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.reportPrimaryColor,
                  ),
                ),
                emptyHorizontalBox(width: 5),
                const Text(
                  AppText.completeText,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            emptyVerticalBox(height: 5),
            Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.reportSecondaryColor,
                  ),
                ),
                emptyHorizontalBox(width: 5),
                const Text(
                  AppText.inCompleteText,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget getSetDetails() {
    return Expanded(
      child: ListView.builder(
        itemCount: reportData.exercises.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return ReportChartTile(
            exerciseData: reportData.exercises[index],
          );
        },
      ),
    );
  }
}
