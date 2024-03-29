import 'package:flutter/material.dart';
import 'package:makro_board_client/dialogs/create_panel_dialog.dart';
import 'package:makro_board_client/dialogs/delete_dialog.dart';
import 'package:makro_board_client/dialogs/edit_group_dialog.dart';
import 'package:makro_board_client/models/panel.dart' as models;
import 'package:makro_board_client/models/group.dart' as models;
import 'package:makro_board_client/models/plugin.dart' as models;
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:provider/provider.dart';

import 'control_panel.dart';
import 'global_settings.dart';

class GroupCard extends StatelessWidget {
  final models.Group group;

  const GroupCard({required this.group, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (GlobalSettings.of(context)?.editMode == true)
              ListTile(
                  title: Text(group.label),
                  leading: const Icon(Icons.done),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(onPressed: () => _removeGroupDialog(context, group), icon: const Icon(Icons.delete)),
                      IconButton(onPressed: () => _showEditGroupDialog(context, group), icon: const Icon(Icons.edit)),
                      IconButton(onPressed: () => _showAddPanelDialog(context, group), icon: const Icon(Icons.add)),
                    ],
                  )),
            FutureBuilder(
              future: Provider.of<ApiProvider>(context, listen: false).getAvailableControls(),
              builder: (context, availableControlsSnapShot) => StreamBuilder(
                stream: group.panelsStream,
                initialData: group.panels,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return _getGroupPanelWidgets(context, availableControlsSnapShot.data != null ? availableControlsSnapShot.data as List<models.Plugin> : <models.Plugin>[], snapshot.data);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _showAddPanelDialog(BuildContext context, models.Group group) {
    return showDialog(
      context: context,
      builder: (context) {
        return CreatePanelDialog(group: group);
      },
    );
  }

  Future _showEditGroupDialog(BuildContext context, models.Group group) {
    return showDialog(
      context: context,
      builder: (context) {
        return EditGroupDialog(group: group);
      },
    );
  }

  Widget _getGroupPanelWidgets(BuildContext context, List<models.Plugin>? plugins, List<models.Panel>? panels) {
    if (plugins == null || plugins.isEmpty || panels == null || panels.isEmpty) {
      return const Center(
        child: Text("Keine Panels konfiguriert"),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: panels.length,
      itemBuilder: (context, index) {
        var panel = panels[index];
        var plugin = plugins.firstWhere((p) => p.pluginName == panel.pluginName);
        var control = plugin.controls.firstWhere((c) => c.symbolicName == panel.symbolicName);
        return ControlPanel(
          panel: panel,
          control: control,
          configValues: panel.configValues,
        );
      },
    );
  }

  Future _removeGroupDialog(BuildContext context, models.Group group) {
    return showDialog(
      context: context,
      builder: (context) {
        return DeleteDialog(
          title: "Gruppe Löschen",
          deleteText: "Soll die Gruppe ${group.symbolicName} wirklich gelöscht werden?",
          executeText: "Gruppe ${group.symbolicName} wird gelöscht ...",
          deleteCallback: () => Provider.of<ApiProvider>(context, listen: false).removeGroup(group),
        );
      },
    );
  }
}
