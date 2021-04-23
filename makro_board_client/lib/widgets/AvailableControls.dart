import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/models/Control.dart';
import 'package:makro_board_client/models/ViewConfigParameter.dart';
import 'package:makro_board_client/models/plugin.dart';
import 'package:makro_board_client/models/ViewConfigValue.dart';
import 'package:makro_board_client/provider/api_provider.dart';

import 'ConfigParameterInput.dart';
import 'ControlPanel.dart';

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
                                configParameter: control.view.configParameters[index],
                                configParameterValue: viewConfigValues[index],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: control.configParameters.length,
                              itemBuilder: (context, index) => ConfigParameterInput(
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
