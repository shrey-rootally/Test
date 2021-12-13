import 'package:json_annotation/json_annotation.dart';
import 'package:rootally/model/data/exercises.dart';
import 'package:rootally/model/data/schedule.dart';

part 'exercise_program_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExerciseProgramModel {
  int breakTime;
  String createdBy,
      createdById,
      createdByName,
      currentStatus,
      programName,
      nextVersionId,
      prevVersionId,
      creationDate,
      endDate,
      startDate;
  List<Exercise> exercises;
  Schedule schedule;

  ExerciseProgramModel(
      {required this.breakTime,
      required this.createdBy,
      required this.createdById,
      required this.createdByName,
      required this.currentStatus,
      required this.programName,
      required this.nextVersionId,
      required this.prevVersionId,
      required this.endDate,
      required this.creationDate,
      required this.startDate,
      required this.exercises,
      required this.schedule});

  factory ExerciseProgramModel.fromJson(Map<dynamic, dynamic> json) =>
      _$ExerciseProgramModelFromJson(json);

  Map<dynamic, dynamic> toJson() => _$ExerciseProgramModelToJson(this);
}
