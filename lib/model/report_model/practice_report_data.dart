import 'package:json_annotation/json_annotation.dart';

part 'practice_report_data.g.dart';

@JsonSerializable()
class PracticeReportData {
  int completedReps, incompletedReps;
  String exersiceName;

  PracticeReportData(
      {required this.completedReps,
      required this.incompletedReps,
      required this.exersiceName});

  factory PracticeReportData.fromJson(Map<String, dynamic> json) =>
      _$PracticeReportDataFromJson(json);

  Map<dynamic, dynamic> toJson() => _$PracticeReportDataToJson(this);
}
