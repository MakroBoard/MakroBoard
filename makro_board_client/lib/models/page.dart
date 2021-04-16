import 'group.dart';

class Page {
  final int id;
  final String symbolicName;
  final String label;
  final String icon;
  final List<Group> groups;

  Page({
    required this.id,
    required this.symbolicName,
    required this.label,
    required this.icon,
    required this.groups,
  });

  Page.createNew({required this.label, required this.icon})
      : id = 0,
        symbolicName = "",
        groups = List.empty();

  Page.empty()
      : id = -1,
        symbolicName = "",
        label = "",
        icon = "",
        groups = List.empty();

  Page.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        symbolicName = json["symbolicName"],
        label = json["label"],
        icon = json["icon"],
        groups = json["groups"] != null ? List.castFrom(json["groups"]).map<Group>((jsonGroup) => Group.fromJson(jsonGroup)).toList() : List.empty();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbolicName': symbolicName,
      'label': label,
      'icon': icon,
      'groups': groups,
    };
  }

  bool get isEmpty => id < 0;
}
