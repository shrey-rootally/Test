import 'package:json_annotation/json_annotation.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  Map<dynamic, dynamic> daysOfWeek;
  int dailyFrequency;
  bool isDaily;
  String startDate, endDate;

  Schedule(
      {required this.daysOfWeek,
      required this.dailyFrequency,
      required this.isDaily,
      required this.startDate,
      required this.endDate});

  factory Schedule.fromJson(Map<dynamic, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<dynamic, dynamic> toJson() => _$ScheduleToJson(this);
}
