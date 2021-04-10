import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:web_macro_soft_keyboard_client/models/Control.dart';
import 'package:web_macro_soft_keyboard_client/models/ViewConfigParameter.dart';
import 'package:web_macro_soft_keyboard_client/models/Plugin.dart';
import 'package:web_macro_soft_keyboard_client/models/ViewConfigValue.dart';
import 'package:web_macro_soft_keyboard_client/provider/api_provider.dart';

class AvailableControls extends StatelessWidget {
  const AvailableControls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Modular.get<ApiProvider>().getAvailableControls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none || !snapshot.hasData) {
          return Text("No Code Available");
        }

        var plugins = snapshot.data as List<Plugin>;

        return ListView.builder(
          itemCount: plugins.length,
          itemBuilder: (context, index) {
            var plugin = plugins[index];
            return _createPluginCard(plugin);
          },
        );
      },
      // builder: (context, snapshot) => snapshot.connectionState == ConnectionState.none || !snapshot.hasData
      //     ? Text("No Code Available")
      //     : Text(
      //         snapshot.data.runtimeType.toString(),
      //       ),
    );
  }

  Widget _createPluginCard(Plugin plugin) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              plugin.pluginName,
              textAlign: TextAlign.left,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: plugin.controls.length,
            itemBuilder: (context, index) {
              var control = plugin.controls[index];
              var configValues = control.configParameters.map((cp) => ViewConfigValue(symbolicName: cp.symbolicName)).toList();
              var viewConfigValues = control.view.configParameters.map((cp) => ViewConfigValue(symbolicName: cp.symbolicName, value: cp.defaultValue)).toList();

              return Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              control.symbolicName,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: control.view.configParameters.length,
                              itemBuilder: (context, index) => _creteConfigParameter(control.view.configParameters[index], viewConfigValues[index]),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: control.configParameters.length,
                              itemBuilder: (context, index) => _creteConfigParameter(control.configParameters[index], configValues[index]),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _createControl(control, configValues, viewConfigValues),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      );

  Widget _creteConfigParameter(ViewConfigParameter configParameter, ViewConfigValue configValue) {
    return Row(
      children: [
        // Text(configParameter.symbolicName),
        Flexible(child: _createConfigParameterInput(configParameter, configValue)),
      ],
    );
  }

  Widget _createConfigParameterInput(ViewConfigParameter configParameter, ViewConfigValue configValue) {
    switch (configParameter.configParameterType) {
      case ConfigParameterType.string:
        return TextField(
          decoration: InputDecoration(
            // border: OutlineInputBorder(),
            labelText: configParameter.symbolicName,
          ),
          onChanged: (value) => configValue.value = value,
        );
      case ConfigParameterType.bool:
        return CheckboxListTile(
          title: Text(configParameter.symbolicName),
          controlAffinity: ListTileControlAffinity.leading,
          value: configParameter.defaultValue as bool,
          onChanged: (value) => configValue.value = value,
        );
      default:
        return Text("No Input definded for " + configParameter.configParameterType.toString());
    }
  }

  Widget _createControl(Control control, List<ViewConfigValue> configValues, List<ViewConfigValue> viewConfigValues) {
    switch (control.view.viewType) {
      case "Button":
        return TextButton(
          onPressed: () => {},
          child: Text(viewConfigValues.firstWhere((element) => element.symbolicName == "label").value.toString()),
        );
      case "Image":
        return Text(control.view.viewType);
      case "Slider":
        return Text(control.view.viewType);
      default:
        return Text(control.view.viewType);
    }
  }
}
