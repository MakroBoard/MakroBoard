import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:makro_board_client/models/control.dart';
import 'package:makro_board_client/models/view_config_value.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/plugin.dart' as models;
import 'package:makro_board_client/models/panel.dart' as models;
import 'package:makro_board_client/widgets/config_parameter_input.dart';
import 'package:provider/provider.dart';

class EditPanelDialog extends StatelessWidget {
  final models.Panel panel;
  final Control control;

  final List<ViewConfigValue> configValues;
  final List<ViewConfigValue> viewConfigValues;

  EditPanelDialog({Key? key, required this.panel, required this.control})
      : configValues = control.configParameters.map((cp) => panel.configValues.firstWhere((element) => element.symbolicName == cp.symbolicName)).toList(),
        viewConfigValues = control.view.configParameters.map((cp) => panel.configValues.firstWhere((element) => element.symbolicName == cp.symbolicName)).toList(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final createPanelFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: Text("Panel ${panel.symbolicName} bearbeiten"),
      children: [
        Form(
          key: createPanelFormKey,
          child: Column(
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // ListTile(
                      //   title: Text(selectedControl!.symbolicName),
                      //   subtitle: Text(selectedPlugin!.pluginName),
                      // ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: control.view.configParameters.length,
                        itemBuilder: (context, index) => ConfigParameterInput(
                          configParameter: control.view.configParameters[index],
                          configParameterValue: viewConfigValues[index],
                          formKey: createPanelFormKey,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: control.configParameters.length,
                        itemBuilder: (context, index) => ConfigParameterInput(
                          configParameter: control.configParameters[index],
                          configParameterValue: configValues[index],
                          formKey: createPanelFormKey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    child: const Text("Abbrechen"),
                  ),
                  TextButton(
                    child: const Text("'Ändern'"),
                    onPressed: () async {
                      EasyLoading.show(status: 'Panel ändern ...');
                      if (createPanelFormKey.currentState!.validate()) {
                        try {
                          await Provider.of<ApiProvider>(context, listen: false).editPanel(
                            panel,
                          );

                          Navigator.of(context, rootNavigator: true).pop();
                        } catch (e) {
                          // TODO Fehler anzeigen?
                        }
                      }
                      EasyLoading.dismiss();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PanelSelector extends StatelessWidget {
  final List<models.Plugin> plugins;
  final Function(models.Plugin, Control) onPanelSelected;
  final Control? selectedControl;

  const PanelSelector({Key? key, required this.plugins, required this.onPanelSelected, required this.selectedControl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: plugins.length,
          itemBuilder: (context, pluginIndex) {
            var plugin = plugins[pluginIndex];
            return ListView.builder(
              shrinkWrap: true,
              itemCount: plugin.controls.length,
              itemBuilder: (context, index) {
                var selectedControl = plugin.controls[index];
                return Container(
                  color: (selectedControl == selectedControl) ? Theme.of(context).primaryColor.withAlpha(128) : Colors.transparent,
                  child: ListTile(
                    title: Text(selectedControl.symbolicName),
                    subtitle: Text(plugin.pluginName),
                    onTap: () {
                      if (selectedControl != selectedControl) {
                        onPanelSelected(plugin, selectedControl);
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
