import 'ViewConfigParameter.dart';

class Panel {
  final int id;
  final int width;
  final int height;
  final String pluginName;
  final String symbolicName;
  final int order;
  final List<ViewConfigParameter> configParameters;

  Panel({
    required this.id,
    required this.width,
    required this.height,
    required this.pluginName,
    required this.symbolicName,
    required this.order,
    required this.configParameters,
  });

  Panel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        width = json["width"],
        height = json["height"],
        pluginName = json["pluginName"],
        symbolicName = json["symbolicName"],
        order = json["order"],
        configParameters = List.castFrom(json["configParameters"]).map<ViewConfigParameter>((jsonConfigParameter) => ViewConfigParameter.fromJson(jsonConfigParameter)).toList();
}
