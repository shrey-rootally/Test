import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/constants/app_text.dart';
import 'package:rootally/constants/route_path.dart' as routes;
import 'package:rootally/utils/helper.dart';
import 'package:rootally/view/today_screen/current_day_session_tile.dart';
import 'package:rootally/view/today_screen/future_day_session_tile.dart';
import 'package:rootally/view/widgets/app_widgets.dart';
import 'package:rootally/view/widgets/download_widget.dart';
import 'package:rootally/viewmodel/today_screen_view_model.dart';

class TodayScreen extends StatefulWidget {
  final String from;
  const TodayScreen({Key? key, this.from = ""}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final TodayScreenViewModel _todayScreenViewModelController =
      Get.put(TodayScreenViewModel());

  late bool currentDayExercise;
  DateTime? nextSessionDate;

  @override
  void initState() {
    _todayScreenViewModelController.fetchExerciseProgram(
        fromLogin: widget.from != routes.loginRoute &&
            !_todayScreenViewModelController.dataLoaded.value);

    _todayScreenViewModelController.dataLoaded.listen((p0) {
      if (p0) {
        var getExercise =
            _todayScreenViewModelController.getExerciseWithAllData();
        _todayScreenViewModelController.needToDownloadFiles(list: getExercise);
      }
    });

    _todayScreenViewModelController.filesToDownload.listen((p0) {
      if (p0.isNotEmpty) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return DownloadDialog(list: p0);
            });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodayScreenViewModel>(
      builder: (controller) => controller.exerciseProgramModel == null
          ? AppWidgets.circularProgressIndicator
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            emptyVerticalBox(height: 50),
                            getGreetingText(controller: controller),
                            emptyVerticalBox(height: 15),
                            getSessionTrackData(controller: controller),
                            emptyVerticalBox(),
                          ],
                        ),
                      ),
                      getSessions(controller: controller)
                    ],
                  ),
                ),
                getBtn(controller: controller)
              ],
            ),
    );
  }

  getGreetingText({required TodayScreenViewModel controller}) {
    String greetingMsg = AppText.goodMorningText;
    int currentHour = DateTime.now().hour;
    if (currentHour < 12) {
      greetingMsg = AppText.goodMorningText;
    } else if (currentHour >= 12 && currentHour < 17) {
      greetingMsg = AppText.goodAfternoonText;
    } else {
      greetingMsg = AppText.goodEveningText;
    }

    return Text(
      "$greetingMsg \n${controller.name}",
      style: const TextStyle(
        fontSize: 30,
        height: 1.1,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  getSessionTrackData({required TodayScreenViewModel controller}) {
    ///This Will check if user has current day session
    String currentDay = DateFormat("EEEE").format(DateTime.now()).toLowerCase();
    currentDayExercise =
        controller.exerciseProgramModel!.schedule.daysOfWeek[currentDay];
    List<String> firstSessionTrackString = ["", ""],
        secondSessionTrackString = ["", ""];
    String firstIcon = "", secondIcon = "";
    int pendingSession,
        completedSession = controller.completedSession,
        dailyFrequency =
            controller.exerciseProgramModel!.schedule.dailyFrequency;

    if (currentDayExercise && dailyFrequency != completedSession) {
      pendingSession = dailyFrequency - completedSession;
      firstSessionTrackString[0] = AppText.pendingText;
      firstSessionTrackString[1] = "$pendingSession " + AppText.sessionsText;
      secondSessionTrackString[0] = AppText.completedText;
      secondSessionTrackString[1] = "$completedSession " + AppText.sessionsText;
      firstIcon = "session_pending_icon.png";
      secondIcon = "session_completed_icon.png";
    } else if (currentDayExercise && dailyFrequency == completedSession) {
      String nextSessionFormattedStr = findNextSessionData(controller);
      firstSessionTrackString[0] = AppText.allSessionText;
      firstSessionTrackString[1] = AppText.completedText + "!";
      secondSessionTrackString[0] = AppText.nextSessionText;
      secondSessionTrackString[1] = nextSessionFormattedStr;
      firstIcon = "session_completed_icon.png";
      secondIcon = "session_pending_icon.png";
    } else {
      ///This Will check next session
      String nextSessionFormattedStr = findNextSessionData(controller);
      firstSessionTrackString[0] = AppText.noSessionsText;
      firstSessionTrackString[1] = AppText.todayText;
      secondSessionTrackString[0] = AppText.nextSessionText;
      secondSessionTrackString[1] = nextSessionFormattedStr;

      firstIcon = "no_session_icon.png";
      secondIcon = "session_pending_icon.png";
      // log(nextSessionDate.toString());
    }

    return Row(
      children: [
        Expanded(
          child: getStatusBox(firstIcon, firstSessionTrackString),
        ),
        emptyHorizontalBox(width: 10),
        Expanded(
          child: getStatusBox(secondIcon, secondSessionTrackString),
        ),
      ],
    );
  }

  Widget getStatusBox(String firstIcon, List<String> sessionTrackString) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.sessionTrackBoxColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/$firstIcon",
            width: 30,
          ),
          emptyHorizontalBox(width: 10),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: sessionTrackString[0] + "\n",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyTextColor,
                  ),
                ),
                TextSpan(
                  text: sessionTrackString[1],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String findNextSessionData(controller) {
    for (var i = 1; i <= 7; i++) {
      DateTime nextDate = DateTime.now().add(Duration(days: i));
      String nextDay = DateFormat("EEEE").format(nextDate).toLowerCase();
      if (controller.exerciseProgramModel!.schedule.daysOfWeek[nextDay]) {
        nextSessionDate = nextDate;
        break;
      }
    }

    return DateFormat("dd MMMM").format(nextSessionDate!);
  }

  Widget getSessions({required TodayScreenViewModel controller}) {
    int totalSessions =
        controller.exerciseProgramModel!.schedule.dailyFrequency;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => currentDayExercise
            ? index == totalSessions
                ? emptyVerticalBox(height: 70)
                : CurrentDaySessionTileUI(
                    index: index,
                    totalSessionCount: totalSessions,
                    data: {
                      "sessionName": "Session ${index + 1}",
                      "sessionDone": controller.completedSession
                    },
                  )
            : index == totalSessions
                ? emptyVerticalBox(height: 70)
                : FutureDaySessionTileUI(
                    index: index,
                    totalSessionCount: totalSessions,
                    data: {
                      "sessionName": "Session ${index + 1}",
                      "nextSessionDate": nextSessionDate
                    },
                  ),
        childCount: totalSessions + 1,
      ),
    );
  }

  getBtn({required TodayScreenViewModel controller}) {
    bool storeTodayStatus = currentDayExercise &&
        controller.exerciseProgramModel!.schedule.dailyFrequency !=
            controller.completedSession;
    return Positioned(
      bottom: 20,
      right: 20,
      child: GestureDetector(
        onTap: () async {
          /*if (storeTodayStatus) {
            controller.goToStartSession(
                sessionNumber: controller.completedSession + 1);
          }*/
          controller.goToPosenet();
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(50),
            // border: Border.all(
            //   color: AppColors.secondaryColor,
            //   width: 3,
            // ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondaryColor.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          height: 50,
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                storeTodayStatus ? Icons.play_arrow : CupertinoIcons.compass,
                color: AppColors.whiteColor,
                size: storeTodayStatus ? 30 : 24,
              ),
              emptyHorizontalBox(width: 5),
              Text(
                storeTodayStatus
                    ? AppText.startSessionText
                    : AppText.practiceText,
                style:
                    const TextStyle(fontSize: 14, color: AppColors.whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
