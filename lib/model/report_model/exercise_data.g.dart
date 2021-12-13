// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseData _$ExerciseDataFromJson(Map<String, dynamic> json) => ExerciseData(
      name: json['name'] as String,
      assignReps: json['assignReps'] as int,
      setList: (json['setList'] as List<dynamic>)
          .map((e) => SetData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExerciseDataToJson(ExerciseData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'assignReps': instance.assignReps,
      'setList': instance.setList.map((e) => e.toJson()).toList(),
    };
