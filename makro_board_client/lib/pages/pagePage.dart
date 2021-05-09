import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/dialogs/create_group_dialog.dart';
import 'package:makro_board_client/dialogs/create_panel_dialog.dart';
import 'package:makro_board_client/dialogs/delete_dialog.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/widgets/ControlPanel.dart';
import 'package:makro_board_client/widgets/EditMode.dart';
import 'package:makro_board_client/widgets/WmskAppBar.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:makro_board_client/models/Plugin.dart' as models;
import 'package:makro_board_client/models/page.dart' as models;
import 'package:makro_board_client/models/group.dart' as models;
import 'package:makro_board_client/models/panel.dart' as models;

class PagePage extends StatelessWidget {
  final models.Page initialPage;
  const PagePage({required Key key, required this.initialPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WmskAppBar(
        titleText: initialPage.label,
        additionalActions: [
          Tooltip(
            message: "EditModus aktivieren",
            child: Switch(
                value: GlobalSettings.of(context)?.editMode ?? false,
                onChanged: (v) {
                  var editMode = GlobalSettings.of(context);
                  if (editMode != null) {
                    editMode.updateEditMode(v);
                  }
                }),
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: initialPage.groupsStream,
          initialData: initialPage.groups,
          builder: (context, snapshot) => ResponsiveGridList(
            desiredItemWidth: 200,
            minSpacing: 10,
            children: _getGroupWidgets(context, snapshot.data as List<models.Group>),
          ),
        ),
      ),
      floatingActionButton: GlobalSettings.of(context)?.editMode == true
          ? FloatingActionButton(
              child: Icon(Icons.add_box_outlined),
              onPressed: () => showCreateGroupDialog(context, initialPage),
              tooltip: "Neue Gruppe Anlegen",
            )
          : null,
    );
  }

  List<Widget> _getGroupWidgets(BuildContext context, List<models.Group>? groups) {
    if (groups == null) {
      return <Widget>[];
    }

    return groups
        .map<Widget>(
          (group) => Card(
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
                    future: Modular.get<ApiProvider>().getAvailableControls(),
                    builder: (context, availableControlsSnapShot) => StreamBuilder(
                      stream: group.panelsStream,
                      initialData: group.panels,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return _getGroupPanelWidgets(context, availableControlsSnapShot.data as List<models.Plugin>, snapshot.data);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
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
          control: control,
          configValues: panel.configValues,
        );
      },
    );
  }

  Future showCreateGroupDialog(BuildContext context, models.Page page) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateGroupDialog(page: page);
        });
  }

  Future _showAddPanelDialog(BuildContext context, models.Group group) {
    return showDialog(
      context: context,
      builder: (context) {
        return CreatePanelDialog(group: group);
      },
    );
  }
}

Future _removeGroupDialog(BuildContext context, models.Group group) {
  return showDialog(
    context: context,
    builder: (context) {
      return DeleteDialog(
        title: "Gruppe Löschen",
        deleteText: "Soll die Gruppe ${group.symbolicName} wirklich gelöscht werden?",
        executeText: "Gruppe ${group.symbolicName} wird gelöscht ...",
        deleteCallback: () => Modular.get<ApiProvider>().removeGroup(group),
      );
    },
  );
}

enum GroupContextMenu { delete, addPanel }
