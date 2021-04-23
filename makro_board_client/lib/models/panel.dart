import 'ViewConfigValue.dart';

class Panel {
  final int id;
  final String pluginName;
  final String symbolicName;
  final int order;
  final int groupId;
  final List<ViewConfigValue> configValues;

  Panel({
    required this.id,
    required this.pluginName,
    required this.symbolicName,
    required this.order,
    required this.groupId,
    required this.configValues,
  });

  Panel.createNew({required this.symbolicName, required this.pluginName, required this.groupId, required this.configValues})
      : id = -1,
        order = -1;

  Panel.empty()
      : id = -1,
        pluginName = "",
        symbolicName = "",
        order = -1,
        groupId = -1,
        configValues = [];

  Panel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        pluginName = json["pluginName"],
        symbolicName = json["symbolicName"],
        order = json["order"],
        groupId = json["groupId"],
        configValues = List.castFrom(json["configValues"]).map<ViewConfigValue>((jsonConfigParameter) => ViewConfigValue.fromJson(jsonConfigParameter)).toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbolicName': symbolicName,
      'pluginName': pluginName,
      'groupId': groupId,
      'configValues': configValues,
    };
  }

  bool get isEmpty => id < 0;
}
