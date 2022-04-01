import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:makro_board_client/models/plugin.dart';
import 'package:makro_board_client/models/view_config_value.dart';
import 'package:makro_board_client/provider/api_provider.dart';

import 'config_parameter_input.dart';
import 'control_panel.dart';

class AvailableControls extends StatelessWidget {
  const AvailableControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<ApiProvider>(context, listen: false).getAvailableControls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none || !snapshot.hasData) {
          return const Text("No Code Available");
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
              var viewConfigValues = control.view.configParameters.map((cp) => ViewConfigValue(symbolicName: cp.symbolicName, defaultValue: cp.defaultValue)).toList();

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
                              itemBuilder: (context, index) => ConfigParameterInput(
                                key: Key(control.view.configParameters[index].symbolicName),
                                configParameter: control.view.configParameters[index],
                                configParameterValue: viewConfigValues[index],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: control.configParameters.length,
                              itemBuilder: (context, index) => ConfigParameterInput(
                                key: Key(control.configParameters[index].symbolicName),
                                configParameter: control.configParameters[index],
                                configParameterValue: configValues[index],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ControlPanel(
                          panel: null,
                          control: control,
                          configValues: configValues + viewConfigValues,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      );
}
