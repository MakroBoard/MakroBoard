import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/models/Control.dart';
import 'package:makro_board_client/models/ViewConfigValue.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:provider/provider.dart';

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
        return TextButton(
          onPressed: () => Modular.get<ApiProvider>().executeControl(control, configValues),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ChangeNotifierProvider.value(
              value: configValues.firstWhere((element) => element.symbolicName == "label"),
              builder: (context, _) => Text(context.watch<ViewConfigValue>().value.toString()),
            ),
          ),
        );
      case "Text":
        return ChangeNotifierProvider.value(
          value: configValues.firstWhere(
            (element) => element.symbolicName == "text",
            orElse: () {
              var newConfigValue = ViewConfigValue(symbolicName: "text", defaultValue: null);
              configValues.add(newConfigValue);
              return newConfigValue;
            },
          ),
          builder: (context, _) => Text(context.watch<ViewConfigValue>().value.toString()),
        );
      // case "Image":
      //   return Text(control.view.viewType);
      // case "Slider":
      //   return Text(control.view.viewType);
      default:
        return Text("Missing Control: " + control.view.viewType);
    }
  }
}
