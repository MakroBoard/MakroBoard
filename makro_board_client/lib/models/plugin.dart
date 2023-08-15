import 'package:json_annotation/json_annotation.dart';
import 'package:makro_board_client/models/image.dart';

import 'control.dart';
import 'localizable_string.dart';

@JsonSerializable()
class Plugin {
  final String pluginName;
  final List<Control> controls;
  final LocalizableString title;
  final Image? icon;

  Plugin({
    required this.pluginName,
    required this.title,
    required this.icon,
    required this.controls,
  });

  Plugin.fromJson(Map<String, dynamic> json)
      : pluginName = json["pluginName"],
        title = LocalizableString.fromJson(json["title"] as Map<String, dynamic>),
        icon = json.containsKey("icon") && json["icon"] != null ? Image.formJson(json["icon"] as Map<String, dynamic>) : null,
        controls = List.castFrom(json["controls"]).map<Control>((jsonControl) => Control.fromJson(jsonControl)).toList();
}
