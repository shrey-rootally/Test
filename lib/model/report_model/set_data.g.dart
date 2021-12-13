// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetData _$SetDataFromJson(Map<String, dynamic> json) => SetData(
      correctReps: json['correctReps'] as int,
      incorrectReps: json['incorrectReps'] as int,
      maxHoldTime: json['maxHoldTime'] as int,
      time: json['time'] as int,
      isSkipped: json['isSkipped'] as bool,
      kneeRange: json['kneeRange'] == null
          ? null
          : KneeRange.fromJson(json['kneeRange'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SetDataToJson(SetData instance) => <String, dynamic>{
      'correctReps': instance.correctReps,
      'incorrectReps': instance.incorrectReps,
      'maxHoldTime': instance.maxHoldTime,
      'time': instance.time,
      'isSkipped': instance.isSkipped,
      'kneeRange': instance.kneeRange?.toJson(),
    };
