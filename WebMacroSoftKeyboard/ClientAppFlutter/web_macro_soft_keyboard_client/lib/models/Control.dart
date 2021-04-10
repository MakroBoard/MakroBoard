import 'ViewConfigParameter.dart';
import 'View.dart';

class Control {
  final String symbolicName;
  final View view;
  final List<ViewConfigParameter> configParameters;

  Control({
    required this.symbolicName,
    required this.view,
    required this.configParameters,
  });

  Control.fromJson(Map<String, dynamic> json)
      : symbolicName = json["symbolicName"],
        view = View.fromJson(json["view"]),
        configParameters = List.castFrom(json["configParameters"]).map<ViewConfigParameter>((jsonConfigParameter) => ViewConfigParameter.fromJson(jsonConfigParameter)).toList();
}
