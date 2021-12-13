import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:rootally/constants/database_path.dart';
import 'package:get/get.dart';
import 'package:rootally/model/data/exercise_program_model.dart';
import 'package:rootally/viewmodel/today_screen_view_model.dart';

import 'data/exercises_alldetails.dart';

class RtdbDataPublisher {
  final _database = FirebaseDatabase.instance.reference();

  /// This function will fetch all exercise related data of perticular user
  Future<bool> getExercisePrograms(
      {required String uid, required String hospitalId}) async {
    TodayScreenViewModel homePageViewModel = Get.put(TodayScreenViewModel());
    late ExerciseProgramModel exerciseProgram;
    try {
      /// We maintain data stream for live data
      _database
          .child(hospitalId + DatabasePath.exerciseProgram + "/$uid")
          .orderByChild("currentStatus")
          .equalTo("active")
          .onValue
          .listen(
        (event) {
          if (event.snapshot.value != null) {
            var userExerciseProgramData =
                event.snapshot.value as Map<dynamic, dynamic>;
            userExerciseProgramData.forEach(
              (key, value) {
                exerciseProgram = ExerciseProgramModel.fromJson(value);
              },
            );
            homePageViewModel.setExerciseProgramModel(exerciseProgram);
          }
        },
      );
      return true;
    } catch (e) {
      log("ERROR FROM rtdb_data_publisher.getExercisePrograms() - " +
          e.toString());
    }
    return false;
  }

  /// This function will fetch session completed on perticular day
  Future<void> fetchSessionPerDay(
      {required String uid, required String hospitalId}) async {
    String currentDate =
        DateFormat("dd-MMM-yyyy").format(DateTime.now()).toLowerCase();
    currentDate = currentDate.substring(0, 3) +
        currentDate[3].toUpperCase() +
        currentDate.substring(4);

    String path = hospitalId +
        DatabasePath.sessionsCompletedPerDay +
        "/$uid" +
        "/$currentDate";

    TodayScreenViewModel homePageViewModel = Get.put(TodayScreenViewModel());
    _database.child(path).onValue.listen(
      (event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> todaySessionTrack =
              event.snapshot.value as Map<dynamic, dynamic>;
          homePageViewModel
              .setCompletedSession(todaySessionTrack["sessionDone"] ?? 0);
        }
      },
    );
  }

  /// This function will fetch all exercise related data
  Future<bool> getExerciseAllDetails(
      {required String hospitalId}) async {
    TodayScreenViewModel homePageViewModel = Get.put(TodayScreenViewModel());
    try {
      /// We maintain data stream for live data
      _database
          .child(hospitalId + DatabasePath.exercisesList)
          .onValue
          .listen(
            (event) {
          if (event.snapshot.value != null) {
            List<ExerciseAll> tempList = [];
            var exerciseList =
            event.snapshot.value as Map<dynamic, dynamic>;
            exerciseList.forEach(
                  (key, value) {
                    tempList.add(ExerciseAll.fromJson(value));
              },
            );
            homePageViewModel.setExerciseAllModel(tempList);
          }
        },
      );
      return true;
    } catch (e) {
      log("ERROR FROM rtdb_data_publisher.getExerciseAllDetails() - " +
          e.toString());
    }
    return false;
  }

}
