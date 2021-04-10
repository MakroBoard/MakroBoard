class ConfigParameter {
  final int id;
  final ConfigParameterType configParameterType;
  final String symbolicName;
  final String value;

  ConfigParameter({
    required this.id,
    required this.configParameterType,
    required this.symbolicName,
    required this.value,
  });

  ConfigParameter.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        configParameterType = json["configParameterType"],
        symbolicName = json["symbolicName"],
        value = json["pluginNvalueame"];
}

enum ConfigParameterType { Control, View }
