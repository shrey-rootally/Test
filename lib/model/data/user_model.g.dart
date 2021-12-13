// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<dynamic, dynamic> json) => User(
      email: json['email'] as String,
      hospitalId: json['hospitalId'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      uid: json['uid'] as String,
      userStatus: json['userStatus'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'hospitalId': instance.hospitalId,
      'name': instance.name,
      'role': instance.role,
      'uid': instance.uid,
      'userStatus': instance.userStatus,
    };
