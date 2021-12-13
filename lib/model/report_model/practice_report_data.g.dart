// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_report_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PracticeReportData _$PracticeReportDataFromJson(Map<String, dynamic> json) =>
    PracticeReportData(
      completedReps: json['completedReps'] as int,
      incompletedReps: json['incompletedReps'] as int,
      exersiceName: json['exersiceName'] as String,
    );

Map<String, dynamic> _$PracticeReportDataToJson(PracticeReportData instance) =>
    <String, dynamic>{
      'completedReps': instance.completedReps,
      'incompletedReps': instance.incompletedReps,
      'exersiceName': instance.exersiceName
    };
