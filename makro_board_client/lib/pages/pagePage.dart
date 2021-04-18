import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:makro_board_client/dialogs/create_group_dialog.dart';
import 'package:makro_board_client/dialogs/create_page_dialog.dart';
import 'package:makro_board_client/dialogs/create_panel_dialog.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/widgets/WmskAppBar.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:makro_board_client/models/page.dart' as models;
import 'package:makro_board_client/models/group.dart' as models;
import 'package:makro_board_client/models/panel.dart' as models;

class PagePage extends StatelessWidget {
  final models.Page initialPage;
  const PagePage({required Key key, required this.initialPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WmskAppBar(title: initialPage.label).getAppBar(context),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_box_outlined),
        onPressed: () => showCreateGroupDialog(context, initialPage),
        tooltip: "Neue Gruppe Anlegen",
      ),
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
                  ListTile(
                    title: Text(group.label),
                    leading: Icon(Icons.done),
                    trailing: PopupMenuButton<GroupContextMenu>(
                      onSelected: (selectedValue) {
                        switch (selectedValue) {
                          case GroupContextMenu.delete:
                            // TODO: Handle this case.
                            break;
                          case GroupContextMenu.addPanel:
                            _showAddPanelDialog(context, group);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem<GroupContextMenu>(
                          value: GroupContextMenu.delete,
                          child: Icon(Icons.delete),
                        ),
                        const PopupMenuItem<GroupContextMenu>(
                          value: GroupContextMenu.addPanel,
                          child: Icon(Icons.add),
                        ),
                      ],
                      icon: Icon(Icons.more_vert),
                    ),
                  ),
                  StreamBuilder(
                    stream: group.panelsStream,
                    initialData: group.panels,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Container(
                        child: _getGroupPanelWidgets(context, snapshot.data),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _getGroupPanelWidgets(BuildContext context, List<models.Panel>? panels) {
    if (panels == null || panels.isEmpty) {
      return Center(
        child: Text("Keine Panels konfiguriert"),
      );
    }
    return ListView.builder(
      itemCount: panels.length,
      itemBuilder: (context, index) => Text(panels[index].symbolicName),
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

enum GroupContextMenu { delete, addPanel }
