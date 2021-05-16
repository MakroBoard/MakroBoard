import 'package:json_annotation/json_annotation.dart';

import 'Control.dart';

@JsonSerializable()
class Plugin {
  final String pluginName;
  final List<Control> controls;

  Plugin({
    required this.pluginName,
    required this.controls,
  });

  Plugin.fromJson(Map<String, dynamic> json)
      : pluginName = json["pluginName"],
        controls = List.castFrom(json["controls"]).map<Control>((jsonControl) => Control.fromJson(jsonControl)).toList();
}
