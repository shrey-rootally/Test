import 'package:json_annotation/json_annotation.dart';

part 'knee_range.g.dart';

@JsonSerializable()
class KneeRange {
  int? avg, min, max;

  KneeRange({this.avg, this.min, this.max});

  factory KneeRange.fromJson(Map<String, dynamic> json) =>
      _$KneeRangeFromJson(json);

  Map<String, dynamic> toJson() => _$KneeRangeToJson(this);
}
