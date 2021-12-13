class Landmark {
  int index;
  double x;
  double y;
  double z;
  double presence;
  double visibility;

  Landmark({
    required this.index,
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
    required this.presence,
  });

  Landmark.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        x = json['x'],
        y = json['y'],
        z = json['z'],
        presence = json['presence'],
        visibility = json['visibility'];

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'z': z,
        'index': index,
        'presence': presence,
        'visibility': visibility
      };
}

class LandmarkJson {
  final List<dynamic> landmarks;
  final int timestamp;

  LandmarkJson(this.landmarks, this.timestamp);

  LandmarkJson.fromJson(Map<String, dynamic> json)
      : landmarks = json['landmarks'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
        'landmarks': landmarks,
        'timestamp': timestamp,
      };
}
