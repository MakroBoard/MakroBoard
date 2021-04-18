import 'dart:async';

import 'panel.dart';

class Group {
  final int id;
  final int width;
  final int height;
  final String label;
  final String symbolicName;
  final int order;
  final int pageId;
  final List<Panel> panels;

  StreamController<List<Panel>> streamPanelController = StreamController<List<Panel>>.broadcast();
  Stream<List<Panel>> get panelsStream => streamPanelController.stream;

  Group({
    required this.id,
    required this.width,
    required this.height,
    required this.symbolicName,
    required this.label,
    required this.order,
    required this.pageId,
    required this.panels,
  });

  Group.createNew({required this.label, required this.pageId})
      : id = 0,
        width = -1,
        height = -1,
        symbolicName = "",
        order = -1,
        panels = List.empty(growable: true);

  Group.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        width = json["width"],
        height = json["height"],
        label = json["label"],
        symbolicName = json["symbolicName"],
        order = json["order"],
        pageId = json["pageId"],
        panels = json["panels"] != null ? List.castFrom(json["panels"]).map<Panel>((jsonPanel) => Panel.fromJson(jsonPanel)).toList() : List.empty(growable: true);

  Group.empty()
      : id = -1,
        width = -1,
        height = -1,
        label = "",
        symbolicName = "",
        order = -1,
        pageId = -1,
        panels = List.empty();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbolicName': symbolicName,
      'label': label,
      'pageId': pageId,
    };
  }

  bool get isEmpty => id < 0;

  void notifyPanelsUpdated() {
    streamPanelController.add(panels);
  }
}
