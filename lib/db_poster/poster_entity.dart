import 'dart:typed_data';

class PosterEntity {
  int id;
  DateTime createdTime;
  Uint8List image;

  PosterEntity({
    required this.id,
    required this.createdTime,
    required this.image,
  });

  factory PosterEntity.fromJson(Map<String, dynamic> json) {
    return PosterEntity(
      id: json['id'],
      createdTime: DateTime.parse(json['createdTime']),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdTime': createdTime.toIso8601String(),
      'image': image,
    };
  }
}