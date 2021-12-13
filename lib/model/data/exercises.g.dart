// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercises.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<dynamic, dynamic> json) => Exercise(
      exerciseName: json['exerciseName'] as String,
      holdTime: json['holdTime'] as int?,
      repititions: json['repititions'] as int,
      id: json['id'] as int,
      sets: json['sets'] as int,
    );

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'exerciseName': instance.exerciseName,
      'holdTime': instance.holdTime,
      'repititions': instance.repititions,
      'sets': instance.sets,
      'id': instance.id,
    };
