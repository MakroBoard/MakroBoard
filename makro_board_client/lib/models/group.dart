import 'panel.dart';

class Group {
  final int id;
  final int width;
  final int height;
  final String symbolicName;
  final int order;
  final List<Panel> panels;

  Group({
    required this.id,
    required this.width,
    required this.height,
    required this.symbolicName,
    required this.order,
    required this.panels,
  });

  Group.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        width = json["width"],
        height = json["height"],
        symbolicName = json["symbolicName"],
        order = json["order"],
        panels = List.castFrom(json["panels"]).map<Panel>((jsonPanel) => Panel.fromJson(jsonPanel)).toList();
}
