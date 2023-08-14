import 'package:json_annotation/json_annotation.dart';
import 'package:makro_board_client/models/localizable_string.dart';

@JsonSerializable()
class ViewConfigParameter {
  final ConfigParameterType configParameterType;
  final String symbolicName;
  final LocalizableString? label;
  final Object? defaultValue;
  final String? validationRegEx;
  final int? minValue;
  final int? maxValue;

  ViewConfigParameter({
    required this.configParameterType,
    required this.symbolicName,
    required this.label,
    required this.defaultValue,
    required this.validationRegEx,
    required this.minValue,
    required this.maxValue,
  });

  ViewConfigParameter.fromJson(Map<String, dynamic> json)
      : configParameterType = ConfigParameterType.from[json["parameterType"]],
        symbolicName = json["symbolicName"],
        label = json.containsKey("label") && json["label"] != null ? LocalizableString.fromJson(json["label"] as Map<String, dynamic>) : null,
        defaultValue = json["defaultValue"],
        validationRegEx = json["validationRegEx"],
        minValue = json["minValue"],
        maxValue = json["maxValue"];
}

enum ConfigParameterType {
  from,
  string,
  int,
  bool,
}

extension ConfigParameterTypeIndex on ConfigParameterType {
  operator [](String key) => (name) {
        switch (name) {
          case 'string':
            return ConfigParameterType.string;
          case 'int':
            return ConfigParameterType.int;
          case 'bool':
            return ConfigParameterType.bool;
          default:
            throw RangeError("enum ConfigParameterType contains no value '$name'");
        }
      }(key);
}
