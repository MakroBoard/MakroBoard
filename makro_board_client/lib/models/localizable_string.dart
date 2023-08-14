import 'package:json_annotation/json_annotation.dart';

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
