import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import 'group.dart';

class Page {
  final int id;
  final String symbolicName;
  final String label;
  final IconData icon;
  final List<Group> groups;

  StreamController<List<Group>> streamGroupController = StreamController<List<Group>>.broadcast();
  Stream<List<Group>> get groupsStream => streamGroupController.stream;

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
        groups = List.empty(growable: true);

  Page.empty()
      : id = -1,
        symbolicName = "",
        label = "",
        icon = Icons.not_interested,
        groups = List.empty();

  Page.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        symbolicName = json["symbolicName"],
        label = json["label"],
        icon = json["icon"] != null && json["icon"] != "" ? mapToIconData(jsonDecode(json["icon"])) : Icons.not_interested,
        groups = json["groups"] != null ? List.castFrom(json["groups"]).map<Group>((jsonGroup) => Group.fromJson(jsonGroup)).toList() : List.empty(growable: true);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbolicName': symbolicName,
      'label': label,
      'icon': jsonEncode(iconDataToMap(icon)),
      'groups': groups,
    };
  }

  bool get isEmpty => id < 0;

  void notifyGroupsUpdated() {
    streamGroupController.add(groups);
  }
}
