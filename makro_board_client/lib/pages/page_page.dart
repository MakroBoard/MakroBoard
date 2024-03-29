import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:makro_board_client/dialogs/create_group_dialog.dart';
import 'package:makro_board_client/widgets/edit_mode_switch.dart';
import 'package:makro_board_client/widgets/global_settings.dart';
import 'package:makro_board_client/widgets/group_card.dart';
import 'package:makro_board_client/widgets/snack_bar_notification.dart';
import 'package:makro_board_client/widgets/makro_board_app_bar.dart';
import 'package:makro_board_client/models/page.dart' as models;
import 'package:makro_board_client/models/group.dart' as models;

import '../widgets/no_content.dart';

class PagePage extends StatelessWidget {
  final models.Page initialPage;
  const PagePage({Key? key, required this.initialPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MakroBoardAppBar(
        context: context,
        icon: Icon(initialPage.icon),
        titleText: initialPage.label,
        additionalActions: const [
          EditModeSwitch(),
        ],
      ),
      body: SnackBarNotification(
        child: StreamBuilder(
          stream: initialPage.groupsStream,
          initialData: initialPage.groups,
          builder: (context, snapshot) {
            var groups = snapshot.data as List<models.Group>;
            var axisCount = min(max((MediaQuery.of(context).size.width / 400).round(), 1), groups.length);
            var editMode = GlobalSettings.of(context)?.editMode == true;
            return initialPage.groups.isNotEmpty
                ? MasonryGridView.count(
                    key: ObjectKey(axisCount),
                    crossAxisCount: axisCount,
                    itemCount: groups.length + (editMode ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (editMode && index >= groups.length) {
                        return InkWell(
                          onTap: () => showCreateGroupDialog(context, initialPage),
                          child: const Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text("Neue Gruppe anlegen"),
                                    leading: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return GroupCard(group: groups[index]);
                    },
                    // staggeredTileBuilder: (int index) => const Tile.fit(1),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  )
                : NoContent(
                    label: "Leider ist die Seite noch Leer.",
                    iconData: Icons.hourglass_empty,
                    addNewFunction: () => showCreateGroupDialog(context, initialPage),
                    addNewLabel: "Neue Gruppe anlegen",
                  );
          },
        ),
      ),
      floatingActionButton: GlobalSettings.of(context)?.editMode == true
          ? FloatingActionButton(
              onPressed: () => showCreateGroupDialog(context, initialPage),
              tooltip: "Neue Gruppe Anlegen",
              child: const Icon(Icons.add_box_outlined),
            )
          : null,
    );
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
