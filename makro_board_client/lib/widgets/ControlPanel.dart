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
        return Center(
          child: ChangeNotifierProvider.value(
            value: configValues.firstWhere(
              (element) => element.symbolicName == "text",
              orElse: () {
                var newConfigValue = ViewConfigValue(symbolicName: "text", defaultValue: null);
                configValues.add(newConfigValue);
                return newConfigValue;
              },
            ),
            builder: (context, _) => Text(context.watch<ViewConfigValue>().value.toString()),
          ),
        );
      case "ProgressBar":
        return ProgressBarControl(
          minValue: configValues.firstWhere(
            (element) => element.symbolicName == "min",
            orElse: () {
              var newConfigValue = ViewConfigValue(symbolicName: "min", defaultValue: null);
              configValues.add(newConfigValue);
              return newConfigValue;
            },
          ),
          maxValue: configValues.firstWhere(
            (element) => element.symbolicName == "max",
            orElse: () {
              var newConfigValue = ViewConfigValue(symbolicName: "max", defaultValue: null);
              configValues.add(newConfigValue);
              return newConfigValue;
            },
          ),
          value: configValues.firstWhere(
            (element) => element.symbolicName == "value",
            orElse: () {
              var newConfigValue = ViewConfigValue(symbolicName: "value", defaultValue: null);
              configValues.add(newConfigValue);
              return newConfigValue;
            },
          ),
        );

      default:
        return Text("Missing Control: " + control.view.viewType);
    }
  }
}

class ProgressBarControl extends StatefulWidget {
  final ViewConfigValue minValue;
  final ViewConfigValue maxValue;
  final ViewConfigValue value;

  ProgressBarControl({Key? key, required this.minValue, required this.maxValue, required this.value}) : super(key: key);

  @override
  _ProgressBarControlState createState() => _ProgressBarControlState();
}

class _ProgressBarControlState extends State<ProgressBarControl> {
  @override
  void initState() {
    widget.minValue.addListener(updateProgressBar);
    widget.maxValue.addListener(updateProgressBar);
    widget.value.addListener(updateProgressBar);

    super.initState();
  }

  void updateProgressBar() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.minValue.removeListener(updateProgressBar);
    widget.maxValue.removeListener(updateProgressBar);
    widget.value.removeListener(updateProgressBar);
  }

  @override
  Widget build(BuildContext context) {
    var minValue = widget.minValue.value as int? ?? 0;
    var maxValue = widget.maxValue.value as int? ?? 16000;
    var value = widget.value.value as int? ?? 0;

    var progress = value / (maxValue - minValue);
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              if (minValue != 0) Text(minValue.toString()),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: LinearProgressIndicator(
                          value: progress,
                        ),
                      ),
                      Center(
                        child: Text(value.toString()),
                      )
                    ],
                  ),
                ),
              ),
              Text(maxValue.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
