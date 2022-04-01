import 'package:json_annotation/json_annotation.dart';

import 'view_config_parameter.dart';

@JsonSerializable()
class View {
  final String viewType;
  final String? value;
  final List<ViewConfigParameter> configParameters;
  final List<ViewConfigParameter> pluginParameters;
  final List<View>? subViews;

  View({required this.viewType, required this.value, required this.configParameters, required this.pluginParameters, required this.subViews});

  View.fromJson(Map<String, dynamic> json)
      : viewType = json["viewType"],
        value = json["value"],
        configParameters = List.castFrom(json["configParameters"]).map<ViewConfigParameter>((jsonConfigParameter) => ViewConfigParameter.fromJson(jsonConfigParameter)).toList(),
        pluginParameters = List.castFrom(json["pluginParameters"]).map<ViewConfigParameter>((jsonConfigParameter) => ViewConfigParameter.fromJson(jsonConfigParameter)).toList(),
        subViews = json["subViews"] == null ? null : List.castFrom(json["subViews"]).map<View>((jsonView) => View.fromJson(jsonView)).toList();
}
