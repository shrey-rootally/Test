import 'package:json_annotation/json_annotation.dart';
import 'package:rootally/model/data/postureType.dart';

part 'exercises_alldetails.g.dart';

@JsonSerializable()
class ExerciseAll {
  String name, category, image, postureType;
  String video;
  int? holdTime;
  int repititions, sets, id;
  List<int>? videoPauseAt;

  ExerciseAll({
    required this.category,
    required this.name,
    required this.image,
    required this.postureType,
    this.holdTime = 0,
    required this.repititions,
    required this.id,
    required this.sets,
    required this.video,
    this.videoPauseAt,
  });

  factory ExerciseAll.fromJson(Map<dynamic, dynamic> json) =>
      _$ExerciseAllFromJson(json);

  Map<dynamic, dynamic> toJson() => _$ExerciseAllToJson(this);
}
