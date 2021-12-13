// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportData _$ReportDataFromJson(Map<String, dynamic> json) => ReportData(
      initialPainScore: json['initialPainScore'] as int,
      laterPainScore: json['laterPainScore'] as int,
      timeElapsed: json['timeElapsed'] as int,
      timeStemp: json['timeStemp'] == null
          ? null
          : DateTime.parse(json['timeStemp'] as String),
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => ExerciseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      finalPainScore: json['finalPainScore'] as int?,
    );

Map<String, dynamic> _$ReportDataToJson(ReportData instance) =>
    <String, dynamic>{
      'finalPainScore': instance.finalPainScore,
      'initialPainScore': instance.initialPainScore,
      'laterPainScore': instance.laterPainScore,
      'timeElapsed': instance.timeElapsed,
      'timeStemp': instance.timeStemp?.toIso8601String(),
      'exercises': instance.exercises.map((e) => e.toJson()).toList(),
    };
