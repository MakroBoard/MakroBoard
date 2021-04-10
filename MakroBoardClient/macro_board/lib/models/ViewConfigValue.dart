class ViewConfigValue {
  final String symbolicName;
  Object? value;

  ViewConfigValue({required this.symbolicName, this.value});

  ViewConfigValue.fromJson(Map<String, dynamic> json)
      : symbolicName = json["symbolicName"],
        value = json["value"];

  Map<String, dynamic> toJson() {
    return {
      'symbolicName': symbolicName,
      'value': value,
    };
  }
}
