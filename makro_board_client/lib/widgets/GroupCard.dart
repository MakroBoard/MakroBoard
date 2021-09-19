import 'package:flutter/material.dart';
import 'package:makro_board_client/dialogs/create_panel_dialog.dart';
import 'package:makro_board_client/dialogs/delete_dialog.dart';
import 'package:makro_board_client/dialogs/edit_group_dialog.dart';
import 'package:makro_board_client/models/panel.dart' as models;
import 'package:makro_board_client/models/group.dart' as models;
import 'package:makro_board_client/models/Plugin.dart' as models;
import 'package:makro_board_client/pages/pagePage.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:provider/provider.dart';

import 'ControlPanel.dart';
import 'GlobalSettings.dart';

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
                leading: Icon(Icons.done),
                trailing: PopupMenuButton<GroupContextMenu>(
                  onSelected: (selectedValue) {
                    switch (selectedValue) {
                      case GroupContextMenu.delete:
                        _removeGroupDialog(context, group);
                        break;
                      case GroupContextMenu.edit:
                        _showEditGroupDialog(context, group);
                        break;
                      case GroupContextMenu.addPanel:
                        _showAddPanelDialog(context, group);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<GroupContextMenu>(
                      value: GroupContextMenu.delete,
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Gruppe Löschen'),
                      ),
                    ),
                    const PopupMenuItem<GroupContextMenu>(
                      value: GroupContextMenu.edit,
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Gruppe bearbeiten'),
                      ),
                    ),
                    const PopupMenuItem<GroupContextMenu>(
                      value: GroupContextMenu.addPanel,
                      child: ListTile(
                        leading: Icon(Icons.add),
                        title: Text('Panel hinzufügen'),
                      ),
                    ),
                  ],
                  icon: Icon(Icons.more_vert),
                ),
              ),
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
      return Center(
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
