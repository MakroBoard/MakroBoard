import 'ViewConfigParameter.dart';

class View {
  final String viewType;
  final String? value;
  final List<ViewConfigParameter> configParameters;

  View({
    required this.viewType,
    required this.value,
    required this.configParameters,
  });

  View.fromJson(Map<String, dynamic> json)
      : viewType = json["viewType"],
        value = json["value"],
        configParameters = List.castFrom(json["configParameters"]).map<ViewConfigParameter>((jsonConfigParameter) => ViewConfigParameter.fromJson(jsonConfigParameter)).toList();
}
