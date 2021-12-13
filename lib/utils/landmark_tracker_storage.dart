import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:rootally/model/data/landmark.dart';

class LandmarkTrackerStorage {
  List<LandmarkJson> setOfLandmarkList = <LandmarkJson>[];
  Timer? timer;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // final path= Directory("storage/emulated/0");

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/testLogs.json");
  }

  void addLandmarks(List<Landmark> poseLandmarks) {
    timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      setOfLandmarkList.add(
          LandmarkJson(poseLandmarks, DateTime.now().millisecondsSinceEpoch));
    });
  }

  Future<File> write() async {
    final file = await _localFile;
    String json = jsonEncode(setOfLandmarkList);

    timer?.cancel();

    return file.writeAsString(json, mode: FileMode.append);
  }
}
