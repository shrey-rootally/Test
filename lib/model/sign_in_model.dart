import 'package:rootally/model/auth_data_publisher.dart';
import 'package:rootally/model/data/user_model.dart';
import 'package:rootally/model/rtdb_data_publisher.dart';

class SignInModel {
  /// This function will check if user assign any session or not
  Future<bool> validateUser({required String userId}) async {
    try {
      User fetchedUser = await AuthDataPublisher().getUser(userId: userId);

      ///If user active then he is able to looged in
      if (fetchedUser.userStatus == "active") {
        await RtdbDataPublisher().fetchSessionPerDay(
            hospitalId: fetchedUser.hospitalId, uid: fetchedUser.uid);
        return await RtdbDataPublisher().getExercisePrograms(
            uid: fetchedUser.uid, hospitalId: fetchedUser.hospitalId);
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
