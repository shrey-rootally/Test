import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:rootally/model/video_download_model.dart';

class VideoDownloadViewModel extends GetxController {
  final RxBool downloadComplete = false.obs;
  final _percent = 0.obs;
  final _progress = 0.0.obs;

  int get percent => _percent.value;
  double get progress => _progress.value;

  /// This function will download the videos to local storage
  Future fetchVideos({required List<String> videoList}) async {
    for (int i = 0; i < videoList.length; i++) {
      // bool downloaded = await VideoDownload().downloadFile(path: videoList[i]);
      await VideoDownload().downloadFile(path: videoList[i]);
      _progress.value = (i + 1) / videoList.length;
      _percent.value = (_progress.value * 100).toInt();
    }
    downloadComplete.value = true;
    log("file downloaded");
  }
}
