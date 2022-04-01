class ConfigParameterValue {
  final int id;
  final ConfigParameterType configParameterType;
  final String symbolicName;
  final String value;

  ConfigParameterValue({
    required this.id,
    required this.configParameterType,
    required this.symbolicName,
    required this.value,
  });

  ConfigParameterValue.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        configParameterType = json["configParameterType"],
        symbolicName = json["symbolicName"],
        value = json["pluginNvalueame"];
}

enum ConfigParameterType { control, view }
