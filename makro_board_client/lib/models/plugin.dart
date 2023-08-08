import 'package:json_annotation/json_annotation.dart';

import 'control.dart';

@JsonSerializable()
class Plugin {
  final String pluginName;
  final List<Control> controls;
  final LocalizableString title;

  Plugin({
    required this.pluginName,
    required this.title,
    required this.controls,
  });

  Plugin.fromJson(Map<String, dynamic> json)
      : pluginName = json["pluginName"],
        title = LocalizableString.fromJson(json["title"] as Map<String, dynamic>),
        controls = List.castFrom(json["controls"]).map<Control>((jsonControl) => Control.fromJson(jsonControl)).toList();
}

@JsonSerializable()
class LocalizableString {
  final Map<String, String> localizedStrings;
  LocalizableString({
    required this.localizedStrings,
  });

  LocalizableString.fromJson(Map<String, dynamic> json) : localizedStrings = (json["localizedStrings"] as Map<String, dynamic>).map((key, value) => MapEntry(key, value));

  String getText() {
    return localizedStrings.values.first;
  }
}
