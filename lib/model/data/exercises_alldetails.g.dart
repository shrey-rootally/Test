// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercises_alldetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseAll _$ExerciseAllFromJson(Map<dynamic, dynamic> json) => ExerciseAll(
      category: json['category'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      postureType: json['postureType'] as String,
      holdTime: json['holdTime'] as int? ?? 0,
      repititions: json['repititions'] as int,
      id: json['id'] as int,
      sets: json['sets'] as int,
      video: json['video'] as String,
      videoPauseAt: (json['videoPauseAt'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$ExerciseAllToJson(ExerciseAll instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': instance.category,
      'image': instance.image,
      'postureType': instance.postureType,
      'video': instance.video,
      'holdTime': instance.holdTime,
      'repititions': instance.repititions,
      'sets': instance.sets,
      'id': instance.id,
      'videoPauseAt': instance.videoPauseAt,
    };