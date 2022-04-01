import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:makro_board_client/dialogs/create_group_dialog.dart';
import 'package:makro_board_client/widgets/EditModeSwitch.dart';
import 'package:makro_board_client/widgets/GlobalSettings.dart';
import 'package:makro_board_client/widgets/GroupCard.dart';
import 'package:makro_board_client/widgets/SnackBarNotification.dart';
import 'package:makro_board_client/widgets/MakroBoardAppBar.dart';
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
        additionalActions: [
          EditModeSwitch(),
        ],
      ),
      body: SnackBarNotification(
        child: Container(
          child: StreamBuilder(
            stream: initialPage.groupsStream,
            initialData: initialPage.groups,
            builder: (context, snapshot) {
              var groups = snapshot.data as List<models.Group>;
              var axisCount = min(max((MediaQuery.of(context).size.width / 400).round(), 1), groups.length);
              return initialPage.groups.length > 0
                  ? StaggeredGridView.countBuilder(
                      key: ObjectKey(axisCount),
                      crossAxisCount: axisCount,
                      addAutomaticKeepAlives: false,
                      itemCount: groups.length,
                      itemBuilder: (BuildContext context, int index) => GroupCard(group: groups[index]),
                      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
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

  Future showCreateGroupDialog(BuildContext context, models.Page page) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateGroupDialog(page: page);
        });
  }
}

enum GroupContextMenu { delete, edit, addPanel }
