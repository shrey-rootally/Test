import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  String email, hospitalId, name, role, uid, userStatus;

  User(
      {required this.email,
      required this.hospitalId,
      required this.name,
      required this.role,
      required this.uid,
      required this.userStatus});

  factory User.fromJson(Map<dynamic, dynamic> json) => _$UserFromJson(json);

  Map<dynamic, dynamic> toJson() => _$UserToJson(this);
}
