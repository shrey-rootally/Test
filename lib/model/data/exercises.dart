import 'package:json_annotation/json_annotation.dart';

part 'exercises.g.dart';



@JsonSerializable()
class Exercise {
  String exerciseName;
  int? holdTime;
  int repititions, sets, id;

  Exercise(
      {required this.exerciseName,
      this.holdTime,
      required this.repititions,
      required this.sets,
      required this.id});

  factory Exercise.fromJson(Map<dynamic, dynamic> json) =>
      _$ExerciseFromJson(json);

  Map<dynamic, dynamic> toJson() => _$ExerciseToJson(this);
}
