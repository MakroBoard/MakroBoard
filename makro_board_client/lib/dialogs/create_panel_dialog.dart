import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/models/Control.dart';
import 'package:makro_board_client/models/Plugin.dart';
import 'package:makro_board_client/models/ViewConfigParameter.dart';
import 'package:makro_board_client/models/ViewConfigValue.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/group.dart' as models;

class CreatePanelDialog extends StatefulWidget {
  final models.Group group;
  const CreatePanelDialog({Key? key, required this.group}) : super(key: key);

  @override
  _CreatePanelDialogState createState() => _CreatePanelDialogState();
}

class _CreatePanelDialogState extends State<CreatePanelDialog> {
  Plugin? selectedPlugin;
  Control? selectedControl;
  List<ViewConfigValue>? configValues;
  List<ViewConfigValue>? viewConfigValues;

  late Future<List<Plugin>> _futurePlugins;
  List<Plugin> _currentPlugins = <Plugin>[];
  @override
  void initState() {
    _futurePlugins = Modular.get<ApiProvider>().getAvailableControls().then((value) => _currentPlugins = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _createGroupFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: Text("Panel zur Gruppe " + widget.group.label + " hinzufügen"),
      children: [
        Form(
          key: _createGroupFormKey,
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
                                    itemBuilder: (context, index) => ConfigParameterWidget(
                                      configParameter: selectedControl!.view.configParameters[index],
                                      configParameterValue: viewConfigValues![index],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: selectedControl!.configParameters.length,
                                    itemBuilder: (context, index) => ConfigParameterWidget(
                                      configParameter: selectedControl!.configParameters[index],
                                      configParameterValue: configValues![index],
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

class PanelSelector extends StatelessWidget {
  final List<Plugin> plugins;
  final Function(Plugin, Control) onPanelSelected;
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

// class _PanelSelectorState extends State<PanelSelector> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300,
//       width: 300,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView.builder(
//           itemCount: widget.plugins.length,
//           itemBuilder: (context, pluginIndex) {
//             var plugin = widget.plugins[pluginIndex];
//             return ListView.builder(
//               shrinkWrap: true,
//               itemCount: plugin.controls.length,
//               itemBuilder: (context, index) {
//                 var control = plugin.controls[index];
//                 return Container(
//                   color: (widget.selectedControl == control) ? Theme.of(context).primaryColor.withAlpha(128) : Colors.transparent,
//                   child: ListTile(
//                     title: Text(control.symbolicName),
//                     subtitle: Text(plugin.pluginName),
//                     onTap: () {
//                       if (widget.selectedControl != control) {
//                         widget.onPanelSelected(plugin, control);
//                       }
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

class ConfigParameterWidget extends StatelessWidget {
  final ViewConfigParameter configParameter;
  final ViewConfigValue configParameterValue;

  const ConfigParameterWidget({Key? key, required this.configParameter, required this.configParameterValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // Text(configParameter.symbolicName),
          Flexible(child: _createConfigParameterInput(context, configParameter, configParameterValue)),
        ],
      ),
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
              var foundValue = RegExp(configParameter.validationRegEx!).stringMatch(value!);
              if (foundValue == null || foundValue != value) {
                return "Value doesn´t match \"" + configParameter.validationRegEx! + "\"";
              }
            }
            return null;
          },
          onChanged: (value) => configValue.value = value,
        );
      case ConfigParameterType.bool:
        var value = configParameter.defaultValue as bool;
        if (configValue.value != null && configValue.value is bool) {
          value = configValue.value as bool;
        }
        return CheckboxListTile(
          title: Text(configParameter.symbolicName),
          controlAffinity: ListTileControlAffinity.leading,
          value: value,
          onChanged: (value) => configValue.value = value,
        );
      default:
        return Text("No Input definded for " + configParameter.configParameterType.toString());
    }
  }
}
