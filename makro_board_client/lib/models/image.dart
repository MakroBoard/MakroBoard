import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Image {
  final String name;
  final String type;

  Image({
    required this.name,
    required this.type,
  });

  Image.formJson(Map<String, dynamic> json)
      : name = json["name"],
        type = json["type"];
}
