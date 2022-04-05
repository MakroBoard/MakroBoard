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
            return initialPage.groups.isNotEmpty
                ? MasonryGridView.count(
                    key: ObjectKey(axisCount),
                    crossAxisCount: axisCount,
                    itemCount: groups.length,
                    itemBuilder: (BuildContext context, int index) => StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: GroupCard(group: groups[index]),
                    ),
                    // staggeredTileBuilder: (int index) => const Tile.fit(1),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
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
                  );
          },
        ),
      ),
      floatingActionButton: GlobalSettings.of(context)?.editMode == true
          ? FloatingActionButton(
              child: const Icon(Icons.add_box_outlined),
              onPressed: () => showCreateGroupDialog(context, initialPage),
              tooltip: "Neue Gruppe Anlegen",
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
