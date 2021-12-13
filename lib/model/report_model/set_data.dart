import 'package:json_annotation/json_annotation.dart';
import 'package:rootally/model/report_model/knee_range.dart';

part 'set_data.g.dart';

@JsonSerializable(explicitToJson: true)
class SetData {
  int correctReps, incorrectReps, maxHoldTime, time;
  bool isSkipped;
  KneeRange? kneeRange;

  SetData({
    required this.correctReps,
    required this.incorrectReps,
    required this.maxHoldTime,
    required this.time,
    required this.isSkipped,
    this.kneeRange,
  });

  factory SetData.fromJson(Map<String, dynamic> json) =>
      _$SetDataFromJson(json);

  Map<String, dynamic> toJson() => _$SetDataToJson(this);
}
