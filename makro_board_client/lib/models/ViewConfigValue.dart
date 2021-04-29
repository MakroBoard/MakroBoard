import 'package:flutter/material.dart';

class ViewConfigValue extends ChangeNotifier {
  final String symbolicName;
  Object? _value;

  Object? get value => _value;

  set value(Object? value) {
    _value = value;
    notifyListeners();
  }

  ViewConfigValue({required this.symbolicName, Object? defaultValue}) {
    value = defaultValue;
  }

  ViewConfigValue.fromJson(Map<String, dynamic> json)
      : symbolicName = json["symbolicName"],
        _value = json["value"];

  Map<String, dynamic> toJson() {
    return {
      'symbolicName': symbolicName,
      'value': value,
    };
  }
}

class ChangeNotifiers with ChangeNotifier {
  final List<ChangeNotifier> changeNotifiers;
  ChangeNotifiers({required this.changeNotifiers}) {
    changeNotifiers.forEach((element) {
      element.addListener(() {
        notifyListeners();
      });
    });
  }
}
