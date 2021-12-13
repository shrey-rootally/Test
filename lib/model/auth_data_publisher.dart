import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:rootally/constants/database_path.dart';
import 'package:rootally/constants/local_storage_key.dart';
import 'package:rootally/model/data/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthDataPublisher {
  final _database = FirebaseDatabase.instance.reference();

  /// This function will fetch user data
  Future<User> getUser({required String userId}) async {
    try {
      DataSnapshot data =
          await _database.child(DatabasePath.user + "/$userId").once();

      if (data.value != null) {
        User user = User.fromJson(data.value);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(LocalStorageKey.userId, user.uid);
        preferences.setString(LocalStorageKey.hospitalId, user.hospitalId);
        preferences.setString(LocalStorageKey.userName, user.name);
        preferences.setString(LocalStorageKey.userEmail, user.email);
        return user;
      }
      return User.fromJson({});
    } catch (e) {
      log("ERROR FROM auth_data_publisher.getUser() - " + e.toString());
      return User.fromJson({});
    }
  }
}
