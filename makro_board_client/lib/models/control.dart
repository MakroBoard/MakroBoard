import 'package:json_annotation/json_annotation.dart';

import 'view_config_parameter.dart';
import 'view.dart';

@JsonSerializable()
class Control {
  final String symbolicName;
  final View view;
  final List<ViewConfigParameter> configParameters;
  final List<Control>? subControls;

  Control({
    required this.symbolicName,
    required this.view,
    required this.configParameters,
    required this.subControls,
  });

  Control.fromJson(Map<String, dynamic> json)
      : symbolicName = json["symbolicName"],
        view = View.fromJson(json["view"]),
        configParameters = List.castFrom(json["configParameters"]).map<ViewConfigParameter>((jsonConfigParameter) => ViewConfigParameter.fromJson(jsonConfigParameter)).toList(),
        subControls = json["subControls"] == null ? null : List.castFrom(json["subControls"]).map<Control>((jsonControl) => Control.fromJson(jsonControl)).toList();
}
