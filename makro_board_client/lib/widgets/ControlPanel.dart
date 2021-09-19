import 'package:flutter/material.dart';
import 'package:makro_board_client/models/Control.dart';
import 'package:makro_board_client/models/ViewConfigValue.dart';
import 'package:makro_board_client/widgets/panels/ButtonPanel.dart';

import 'panels/ProgressPanel.dart';
import 'panels/TextPanel.dart';

class ControlPanel extends StatelessWidget {
  final Control control;
  final List<ViewConfigValue> configValues;

  const ControlPanel({required this.control, required this.configValues});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _createControl(context, control, configValues),
    );
  }

  Widget _createControl(BuildContext context, Control control, List<ViewConfigValue> configValues) {
    switch (control.view.viewType) {
      case "Button":
        return ButtonPanel(configValues: configValues, control: control);
      case "Text":
        return TextPanel(configValues: configValues);
      case "ProgressBar":
        return ProgressPanel(configValues: configValues);

      default:
        return Text("Missing Control: " + control.view.viewType);
    }
  }
}
