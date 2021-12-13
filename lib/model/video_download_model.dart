import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:path_provider/path_provider.dart';
import 'package:rootally/model/data/exercises_alldetails.dart';

class VideoDownload {
  Future<bool> downloadFile({required String path}) async {
    //Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory? appDocDir = await getExternalStorageDirectory();
    File downloadToFile = File('${appDocDir?.path}$path');
    log(downloadToFile.path);

    try {
      bool exists = await downloadToFile.exists();
      if (!exists) {
        await downloadToFile.create(recursive: true);
      }
      await firebase_storage.FirebaseStorage.instance
          .ref(path)
          .writeToFile(downloadToFile);
      return true;
    } on firebase_core.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      log(e.toString());
      return false;
    }
  }

  Future<List<String>> checkFilesToDownload(
      {required List<ExerciseAll> list}) async {
    List<String> listToReturn = [];

    for (var element in list) {
      var available = await checkFileExists(path: element.video);
      if (!available) {
        listToReturn.add(element.video);
      }
      // if (element.stateFlowVideos.isEmpty) {
      //   var available = await checkFileExists(path: element.video);
      //   if (!available) {
      //     listToReturn.add(element.video);
      //   }
      // }
      // } else {
      //   for (var innerelement in element.stateFlowVideos) {
      //     var available = await checkFileExists(path: innerelement);
      //     if (!available) {
      //       listToReturn.add(innerelement);
      //     }
      //   }
      // }
    }
    //log("checkfiletoDownload "+listToReturn.toString());
    return listToReturn;
  }

  Future<bool> checkFileExists({required String path}) async {
    Directory? appDocDir = await getExternalStorageDirectory();
    File downloadToFile = File('${appDocDir?.path}$path');
    //log("checkFileExists "+downloadToFile.path);

    try {
      bool exists = await downloadToFile.exists();
      return exists;
    } on firebase_core.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      log(e.toString());
      return false;
    }
  }

  Future<void> hashCheck({required String path}) async {
    // firebase_storage.FullMetadata metadata = await firebase_storage.FirebaseStorage.instance.ref(path).getMetadata();
    await firebase_storage.FirebaseStorage.instance.ref(path).getMetadata();
  }
}
