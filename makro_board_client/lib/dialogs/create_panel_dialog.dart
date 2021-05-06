import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/models/Control.dart';
import 'package:makro_board_client/models/ViewConfigValue.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/Plugin.dart' as models;
import 'package:makro_board_client/models/group.dart' as models;
import 'package:makro_board_client/models/panel.dart' as models;
import 'package:makro_board_client/widgets/ConfigParameterInput.dart';

class CreatePanelDialog extends StatefulWidget {
  final models.Group group;
  const CreatePanelDialog({Key? key, required this.group}) : super(key: key);

  @override
  _CreatePanelDialogState createState() => _CreatePanelDialogState();
}

class _CreatePanelDialogState extends State<CreatePanelDialog> {
  models.Plugin? selectedPlugin;
  Control? selectedControl;
  List<ViewConfigValue>? configValues;
  List<ViewConfigValue>? viewConfigValues;

  late Future<List<models.Plugin>> _futurePlugins;
  List<models.Plugin> _currentPlugins = <models.Plugin>[];

  @override
  void initState() {
    _futurePlugins = Modular.get<ApiProvider>().getAvailableControls().then((value) => _currentPlugins = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _createPanelFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: Text("Panel zur Gruppe " + widget.group.label + " hinzufügen"),
      children: [
        Form(
          key: _createPanelFormKey,
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
                        ? Center(child: Text("Bitte ein Control auswählen"))
                        : Container(
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
                                      formKey: _createPanelFormKey,
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: selectedControl!.configParameters.length,
                                    itemBuilder: (context, index) => ConfigParameterInput(
                                      configParameter: selectedControl!.configParameters[index],
                                      configParameterValue: configValues![index],
                                      formKey: _createPanelFormKey,
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
                    child: Text("Abbrechen"),
                  ),
                  TextButton(
                    child: Text("Anlegen"),
                    onPressed: () async {
                      EasyLoading.show(status: 'Neue Gruppe anlegen ...');
                      if (selectedPlugin != null && selectedControl != null && configValues != null && _createPanelFormKey.currentState!.validate()) {
                        try {
                          await Modular.get<ApiProvider>().addPanel(
                            models.Panel.createNew(
                              pluginName: selectedPlugin!.pluginName,
                              groupId: widget.group.id,
                              symbolicName: selectedControl!.symbolicName,
                              configValues: configValues! + viewConfigValues!,
                            ),
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
