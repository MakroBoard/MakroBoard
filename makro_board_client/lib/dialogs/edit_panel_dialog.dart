import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:makro_board_client/models/Control.dart';
import 'package:makro_board_client/models/ViewConfigValue.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/Plugin.dart' as models;
import 'package:makro_board_client/models/panel.dart' as models;
import 'package:makro_board_client/widgets/ConfigParameterInput.dart';
import 'package:provider/provider.dart';

class EditPanelDialog extends StatelessWidget {
  final models.Panel panel;
  final Control control;

  final List<ViewConfigValue> configValues;
  final List<ViewConfigValue> viewConfigValues;

  EditPanelDialog({required this.panel, required this.control})
      : configValues = control.configParameters.map((cp) => panel.configValues.firstWhere((element) => element.symbolicName == cp.symbolicName)).toList(),
        viewConfigValues = control.view.configParameters.map((cp) => panel.configValues.firstWhere((element) => element.symbolicName == cp.symbolicName)).toList();

  @override
  Widget build(BuildContext context) {
    final _createPanelFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: Text("Panel " + panel.symbolicName + " bearbeiten"),
      children: [
        Form(
          key: _createPanelFormKey,
          child: Column(
            children: [
              Container(
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
                          formKey: _createPanelFormKey,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: control.configParameters.length,
                        itemBuilder: (context, index) => ConfigParameterInput(
                          configParameter: control.configParameters[index],
                          configParameterValue: configValues[index],
                          formKey: _createPanelFormKey,
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
                    child: Text("Abbrechen"),
                  ),
                  TextButton(
                    child: Text("'Ändern'"),
                    onPressed: () async {
                      EasyLoading.show(status: 'Panel ändern ...');
                      if (_createPanelFormKey.currentState!.validate()) {
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

  PanelSelector({required this.plugins, required this.onPanelSelected, required this.selectedControl});
  @override
  Widget build(BuildContext context) {
    return Container(
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
                var control = plugin.controls[index];
                return Container(
                  color: (selectedControl == control) ? Theme.of(context).primaryColor.withAlpha(128) : Colors.transparent,
                  child: ListTile(
                    title: Text(control.symbolicName),
                    subtitle: Text(plugin.pluginName),
                    onTap: () {
                      if (selectedControl != control) {
                        onPanelSelected(plugin, control);
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
