import 'ConfigParameter.dart';

class View {
  final String viewType;
  final String? value;
  final List<ConfigParameter> configParameters;

  View({
    required this.viewType,
    required this.value,
    required this.configParameters,
  });

  View.fromJson(Map<String, dynamic> json)
      : viewType = json["viewType"],
        value = json["value"],
        configParameters = List.castFrom(json["configParameters"]).map<ConfigParameter>((jsonConfigParameter) => ConfigParameter.fromJson(jsonConfigParameter)).toList();
}
