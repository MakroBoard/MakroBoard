import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/models/Control.dart';
import 'package:makro_board_client/models/Plugin.dart';
import 'package:makro_board_client/models/ViewConfigParameter.dart';
import 'package:makro_board_client/models/ViewConfigValue.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/group.dart' as models;
import 'package:makro_board_client/models/panel.dart' as models;

class CreatePanelDialog extends StatelessWidget {
  final models.Group group;
  const CreatePanelDialog({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _createGroupFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: Text("Panel zur Gruppe " + group.label + " hinzufügen"),
      children: [
        Form(
          key: _createGroupFormKey,
          child: Column(
            children: [
              FutureBuilder(
                future: Modular.get<ApiProvider>().getAvailableControls(),
                initialData: <Plugin>[],
                builder: (BuildContext context, AsyncSnapshot snapshot) => PanelSelector(
                  plugins: snapshot.data,
                ),
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
                      if (_createGroupFormKey.currentState!.validate()) {
                        try {
                          // await Modular.get<ApiProvider>().addPanel(models.Panel.createNew());

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

class PanelSelector extends StatefulWidget {
  final List<Plugin> plugins;

  PanelSelector({Key? key, required this.plugins}) : super(key: key);

  @override
  _PanelSelectorState createState() => _PanelSelectorState();
}

class _PanelSelectorState extends State<PanelSelector> {
  Plugin? selectedPlugin;
  Control? selectedControl;
  List<ViewConfigValue>? configValues;
  List<ViewConfigValue>? viewConfigValues;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 600,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: widget.plugins.length,
                itemBuilder: (context, pluginIndex) {
                  var plugin = widget.plugins[pluginIndex];
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
                              setState(() {
                                selectedPlugin = plugin;
                                selectedControl = control;
                                configValues = control.configParameters.map((cp) => ViewConfigValue(symbolicName: cp.symbolicName)).toList();
                                viewConfigValues = control.view.configParameters.map((cp) => ViewConfigValue(symbolicName: cp.symbolicName, defaultValue: cp.defaultValue)).toList();
                              });
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          if (selectedControl != null)
            Expanded(
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
                      itemBuilder: (context, index) => _creteConfigParameter(context, selectedControl!.view.configParameters[index], viewConfigValues![index]),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedControl!.configParameters.length,
                      itemBuilder: (context, index) => _creteConfigParameter(context, selectedControl!.configParameters[index], configValues![index]),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _creteConfigParameter(BuildContext context, ViewConfigParameter configParameter, ViewConfigValue configValue) {
    return Row(
      children: [
        // Text(configParameter.symbolicName),
        Flexible(child: _createConfigParameterInput(context, configParameter, configValue)),
      ],
    );
  }

  Widget _createConfigParameterInput(BuildContext context, ViewConfigParameter configParameter, ViewConfigValue configValue) {
    switch (configParameter.configParameterType) {
      case ConfigParameterType.string:
        return TextFormField(
          decoration: InputDecoration(
            // border: OutlineInputBorder(),
            labelText: configParameter.symbolicName,
          ),
          // TODO
          validator: (value) {
            if (configParameter.validationRegEx != null && configParameter.validationRegEx!.isNotEmpty) {
              if (!RegExp(configParameter.validationRegEx!).hasMatch(value!)) {
                return "Value doesn´t match \"" + configParameter.validationRegEx! + "\"";
              }
            }
            return null;
          },
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
}
