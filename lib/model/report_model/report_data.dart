import 'package:json_annotation/json_annotation.dart';
import 'package:rootally/model/report_model/exercise_data.dart';

part 'report_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ReportData {
  int? finalPainScore;
  int initialPainScore, laterPainScore, timeElapsed;
  DateTime? timeStemp;

  List<ExerciseData> exercises;
  ReportData({
    required this.initialPainScore,
    required this.laterPainScore,
    required this.timeElapsed,
    required this.timeStemp,
    required this.exercises,
    this.finalPainScore,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDataToJson(this);
}
