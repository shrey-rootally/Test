// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_program_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseProgramModel _$ExerciseProgramModelFromJson(
        Map<dynamic, dynamic> json) =>
    ExerciseProgramModel(
      breakTime: json['breakTime'] as int,
      createdBy: json['createdBy'] as String,
      createdById: json['createdById'] as String,
      createdByName: json['createdByName'] as String,
      currentStatus: json['currentStatus'] as String,
      programName: json['programName'] as String,
      nextVersionId: json['nextVersionId'] as String,
      prevVersionId: json['prevVersionId'] as String,
      endDate: json['endDate'] as String,
      creationDate: json['creationDate'] as String,
      startDate: json['startDate'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<dynamic, dynamic>))
          .toList(),
      schedule: Schedule.fromJson(json['schedule'] as Map<dynamic, dynamic>),
    );

Map<String, dynamic> _$ExerciseProgramModelToJson(
        ExerciseProgramModel instance) =>
    <String, dynamic>{
      'breakTime': instance.breakTime,
      'createdBy': instance.createdBy,
      'createdById': instance.createdById,
      'createdByName': instance.createdByName,
      'currentStatus': instance.currentStatus,
      'programName': instance.programName,
      'nextVersionId': instance.nextVersionId,
      'prevVersionId': instance.prevVersionId,
      'creationDate': instance.creationDate,
      'endDate': instance.endDate,
      'startDate': instance.startDate,
      'exercises': instance.exercises.map((e) => e.toJson()).toList(),
      'schedule': instance.schedule.toJson(),
    };
