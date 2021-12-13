import 'package:json_annotation/json_annotation.dart';
import 'package:rootally/model/report_model/set_data.dart';

part 'exercise_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ExerciseData {
  String name;
  int assignReps;
  List<SetData> setList;

  ExerciseData({
    required this.name,
    required this.assignReps,
    required this.setList,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDataFromJson(json);

  Map<dynamic, dynamic> toJson() => _$ExerciseDataToJson(this);
}
