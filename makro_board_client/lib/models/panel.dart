import 'ConfigParameterValue.dart';

class Panel {
  final int id;
  final String pluginName;
  final String symbolicName;
  final int order;
  final int groupId;
  final List<ConfigParameterValue> configParameters;

  Panel({
    required this.id,
    required this.pluginName,
    required this.symbolicName,
    required this.order,
    required this.groupId,
    required this.configParameters,
  });

  Panel.createNew({required this.symbolicName, required this.pluginName, required this.groupId})
      : id = -1,
        order = -1,
        configParameters = [];

  Panel.empty()
      : id = -1,
        pluginName = "",
        symbolicName = "",
        order = -1,
        groupId = -1,
        configParameters = [];

  Panel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        pluginName = json["pluginName"],
        symbolicName = json["symbolicName"],
        order = json["order"],
        groupId = json["groupId"],
        configParameters = List.castFrom(json["configParameters"]).map<ConfigParameterValue>((jsonConfigParameter) => ConfigParameterValue.fromJson(jsonConfigParameter)).toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbolicName': symbolicName,
      'pluginName': pluginName,
      'groupId': groupId,
    };
  }

  bool get isEmpty => id < 0;
}
