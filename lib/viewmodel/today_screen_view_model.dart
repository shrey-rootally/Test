import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:rootally/constants/local_storage_key.dart';
import 'package:rootally/model/data/exercise_program_model.dart';
import 'package:rootally/model/data/exercises_alldetails.dart';
import 'package:rootally/model/rtdb_data_publisher.dart';
import 'package:rootally/model/video_download_model.dart';
import 'package:rootally/services/navigation_service.dart';
import 'package:rootally/constants/route_path.dart' as routes;
import 'package:shared_preferences/shared_preferences.dart';

import '../locator.dart';

class TodayScreenViewModel extends GetxController {
  ExerciseProgramModel? _exerciseProgramModel;
  RxBool dataLoaded = false.obs;
  RxList<String> filesToDownload = <String>[].obs;
  String email = "", name = "", uid = "", hospitalId = "";
  int completedSession = 0;
  final NavigationService _navigationService = locator<NavigationService>();
  List<ExerciseAll>? _exerciseAllModel;

  void setExerciseProgramModel(ExerciseProgramModel value) {

    _exerciseProgramModel = value;
    dataLoaded.value = true;
    update();
  }
  void setExerciseAllModel(List<ExerciseAll> value){

    _exerciseAllModel = value;
    update();
  }

  ExerciseProgramModel? get exerciseProgramModel => _exerciseProgramModel;
  List<ExerciseAll>? get exerciseAllModel => _exerciseAllModel;

  void setCompletedSession(int val) {
    completedSession = val;
    update();
  }

  /// This function will call user already logged in
  Future fetchExerciseProgram({required bool fromLogin}) async {
    await getLocalData();
    if (fromLogin) {
      log("Already");
      await RtdbDataPublisher().getExerciseAllDetails(hospitalId: hospitalId);
      await RtdbDataPublisher().fetchSessionPerDay(
        uid: uid,
        hospitalId: hospitalId,
      );
      await RtdbDataPublisher().getExercisePrograms(
        uid: uid,
        hospitalId: hospitalId,
      );
    }
    //log("Loaded");
    //dataLoaded.value = true;
  }

  List<ExerciseAll> getExerciseWithAllData(){
    List<ExerciseAll> tempList = [];
    for(var element in _exerciseProgramModel!.exercises){

      int id  = element.id;
      for(var innerelement in _exerciseAllModel!){
        if(id == innerelement.id){
          tempList.add(innerelement);
          break;
        }
      }
    }
    return tempList;
  }

  Future needToDownloadFiles({required List<ExerciseAll> list}) async {
    filesToDownload.value = await VideoDownload().checkFilesToDownload(list:list);

  }


  Future<void> getLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    email = preferences.getString(LocalStorageKey.userEmail) ?? "";
    name = preferences.getString(LocalStorageKey.userName) ?? "";
    uid = preferences.getString(LocalStorageKey.userId)!;
    hospitalId = preferences.getString(LocalStorageKey.hospitalId)!;
  }

  Future goToStartSession({required int sessionNumber}) async {
    _navigationService.pushName(
      routes.startSessionRoute,
      arguments: {
        "exercises": exerciseProgramModel!.exercises,
        "sessionName": "Session $sessionNumber",
        "programName": exerciseProgramModel!.programName
      },
    );
  }

  Future goToPosenet() async {
    _navigationService.pushName(
      routes.posenetRoute,
    );
  }
}
