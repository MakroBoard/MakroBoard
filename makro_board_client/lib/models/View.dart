import 'package:json_annotation/json_annotation.dart';

import 'ViewConfigParameter.dart';

@JsonSerializable()
class View {
  final String viewType;
  final String? value;
  final List<ViewConfigParameter> configParameters;
  final List<ViewConfigParameter> pluginParameters;

  View({
    required this.viewType,
    required this.value,
    required this.configParameters,
    required this.pluginParameters,
  });

  View.fromJson(Map<String, dynamic> json)
      : viewType = json["viewType"],
        value = json["value"],
        configParameters = List.castFrom(json["configParameters"]).map<ViewConfigParameter>((jsonConfigParameter) => ViewConfigParameter.fromJson(jsonConfigParameter)).toList(),
        pluginParameters = List.castFrom(json["pluginParameters"]).map<ViewConfigParameter>((jsonConfigParameter) => ViewConfigParameter.fromJson(jsonConfigParameter)).toList();
}
