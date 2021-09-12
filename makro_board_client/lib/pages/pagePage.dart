import 'dart:async';

import 'package:flutter/material.dart';
import 'package:makro_board_client/dialogs/create_group_dialog.dart';
import 'package:makro_board_client/widgets/EditMode.dart';
import 'package:makro_board_client/widgets/GroupCard.dart';
import 'package:makro_board_client/widgets/SnackBarNotification.dart';
import 'package:makro_board_client/widgets/WmskAppBar.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:makro_board_client/models/page.dart' as models;
import 'package:makro_board_client/models/group.dart' as models;

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
                  var globalSettings = GlobalSettings.of(context);
                  if (globalSettings != null) {
                    globalSettings.updateEditMode(v);
                  }
                }),
          ),
        ],
      ),
      body: SnackBarNotification(
        child: Container(
          child: StreamBuilder(
            stream: initialPage.groupsStream,
            initialData: initialPage.groups,
            builder: (context, snapshot) => initialPage.groups.length > 0
                ? ResponsiveGridList(
                    desiredItemWidth: 200,
                    minSpacing: 10,
                    children: _getGroupWidgets(context, snapshot.data as List<models.Group>),
                  )
                : Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 256,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          "Leider ist die Seite noch Leer.",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ],
                    ),
                  ),
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
          (group) => GroupCard(group: group),
        )
        .toList();
  }

  Future showCreateGroupDialog(BuildContext context, models.Page page) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateGroupDialog(page: page);
        });
  }
}

enum GroupContextMenu { delete, edit, addPanel }
