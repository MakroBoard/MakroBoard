class ViewConfigParameter {
  final ConfigParameterType configParameterType;
  final String symbolicName;
  final Object defaultValue;
  final String? validationRegEx;
  final int? minValue;
  final int? maxValue;

  ViewConfigParameter({
    required this.configParameterType,
    required this.symbolicName,
    required this.defaultValue,
    required this.validationRegEx,
    required this.minValue,
    required this.maxValue,
  });

  ViewConfigParameter.fromJson(Map<String, dynamic> json)
      : configParameterType = ConfigParameterType.from[json["parameterType"]],
        symbolicName = json["symbolicName"],
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
