import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:makro_board_client/models/control.dart';
import 'package:makro_board_client/models/view_config_value.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/plugin.dart' as models;
import 'package:makro_board_client/models/group.dart' as models;
import 'package:makro_board_client/models/panel.dart' as models;
import 'package:makro_board_client/widgets/config_parameter_input.dart';
import 'package:provider/provider.dart';

class CreatePanelDialog extends StatefulWidget {
  final models.Group group;
  const CreatePanelDialog({Key? key, required this.group}) : super(key: key);

  @override
  CreatePanelDialogState createState() => CreatePanelDialogState();
}

class CreatePanelDialogState extends State<CreatePanelDialog> {
  models.Plugin? selectedPlugin;
  Control? selectedControl;
  List<ViewConfigValue>? configValues;
  List<ViewConfigValue>? viewConfigValues;

  late Future<List<models.Plugin>> _futurePlugins;
  List<models.Plugin> _currentPlugins = <models.Plugin>[];

  @override
  void initState() {
    _futurePlugins = Provider.of<ApiProvider>(context, listen: false).getAvailableControls().then((value) => _currentPlugins = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final createPanelFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: Text("Panel zur Gruppe ${widget.group.label} hinzufügen"),
      children: [
        Form(
          key: createPanelFormKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: _futurePlugins,
                      initialData: _currentPlugins,
                      builder: (BuildContext context, AsyncSnapshot snapshot) => PanelSelector(
                        plugins: snapshot.data,
                        selectedControl: selectedControl,
                        onPanelSelected: (newSelectedPlugin, newSelectedControl) {
                          setState(() {
                            selectedPlugin = newSelectedPlugin;
                            selectedControl = newSelectedControl;
                            configValues = newSelectedControl.configParameters.map((cp) => ViewConfigValue(symbolicName: cp.symbolicName)).toList();
                            viewConfigValues = newSelectedControl.view.configParameters.map((cp) => ViewConfigValue(symbolicName: cp.symbolicName, defaultValue: cp.defaultValue)).toList();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: selectedControl == null
                        ? const Center(child: Text("Bitte ein Control auswählen"))
                        : SizedBox(
                            height: 300,
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(selectedControl!.symbolicName),
                                    subtitle: Text(selectedPlugin!.pluginName),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: selectedControl!.view.configParameters.length,
                                    itemBuilder: (context, index) => ConfigParameterInput(
                                      configParameter: selectedControl!.view.configParameters[index],
                                      configParameterValue: viewConfigValues![index],
                                      formKey: createPanelFormKey,
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: selectedControl!.configParameters.length,
                                    itemBuilder: (context, index) => ConfigParameterInput(
                                      configParameter: selectedControl!.configParameters[index],
                                      configParameterValue: configValues![index],
                                      formKey: createPanelFormKey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    child: const Text("Abbrechen"),
                  ),
                  TextButton(
                    child: const Text("Anlegen"),
                    onPressed: () async {
                      EasyLoading.show(status: 'Neue Gruppe anlegen ...');
                      if (selectedPlugin != null && selectedControl != null && configValues != null && createPanelFormKey.currentState!.validate()) {
                        try {
                          await Provider.of<ApiProvider>(context, listen: false).addPanel(
                            models.Panel.createNew(
                              pluginName: selectedPlugin!.pluginName,
                              groupId: widget.group.id,
                              symbolicName: selectedControl!.symbolicName,
                              configValues: configValues! + viewConfigValues!,
                            ),
                          );
                          if (!context.mounted) return;
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
