import 'package:flutter/material.dart';
import 'package:makro_board_client/models/view_config_value.dart';

import '../progress_bar_control.dart';

class ProgressPanel extends StatelessWidget {
  final List<ViewConfigValue> configValues;
  const ProgressPanel({
    Key? key,
    required this.configValues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressBarControl(
      minValue: configValues.firstWhere(
        (element) => element.symbolicName.split(".").last == "min",
        orElse: () {
          var newConfigValue = ViewConfigValue(symbolicName: "min", defaultValue: null);
          configValues.add(newConfigValue);
          return newConfigValue;
        },
      ),
      maxValue: configValues.firstWhere(
        (element) => element.symbolicName.split(".").last == "max",
        orElse: () {
          var newConfigValue = ViewConfigValue(symbolicName: "max", defaultValue: null);
          configValues.add(newConfigValue);
          return newConfigValue;
        },
      ),
      value: configValues.firstWhere(
        (element) => element.symbolicName.split(".").last == "value",
        orElse: () {
          var newConfigValue = ViewConfigValue(symbolicName: "value", defaultValue: null);
          configValues.add(newConfigValue);
          return newConfigValue;
        },
      ),
    );
  }
}
