// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<dynamic, dynamic> json) => Schedule(
      daysOfWeek: json['daysOfWeek'] as Map<dynamic, dynamic>,
      dailyFrequency: json['dailyFrequency'] as int,
      isDaily: json['isDaily'] as bool,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'daysOfWeek': instance.daysOfWeek,
      'dailyFrequency': instance.dailyFrequency,
      'isDaily': instance.isDaily,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
