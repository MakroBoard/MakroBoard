import 'package:flutter/material.dart';
import 'package:makro_board_client/app_state.dart';
import 'package:makro_board_client/dialogs/delete_dialog.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/router/page_action.dart';
import 'package:makro_board_client/router/page_configuration.dart';
import 'package:makro_board_client/router/page_state.dart';
import 'package:makro_board_client/widgets/edit_mode_switch.dart';
import 'package:makro_board_client/widgets/global_settings.dart';
import 'package:makro_board_client/widgets/no_content.dart';
import 'package:makro_board_client/widgets/snack_bar_notification.dart';
import 'package:makro_board_client/widgets/makro_board_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:makro_board_client/models/page.dart' as models;
import 'package:makro_board_client/dialogs/create_page_dialog.dart';
import 'package:makro_board_client/dialogs/edit_page_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MakroBoardAppBar(
        context: context,
        titleText: "Home",
        additionalActions: const [
          EditModeSwitch(),
        ],
      ),
      body: SnackBarNotification(
        child: StreamBuilder(
          stream: Provider.of<ApiProvider>(context, listen: false).pages,
          initialData: Provider.of<ApiProvider>(context, listen: false).currentPages,
          builder: (context, snapshot) {
            var pages = snapshot.data as List<models.Page>;
            if (pages.isEmpty) {
              return NoContent(
                label: "Leider gibt es noch keine Seite.",
                iconData: Icons.hourglass_empty,
                addNewFunction: () => showCreatePageDialog(context),
                addNewLabel: "Neue Seite anlegen",
              );
            }

            return ResponsiveGridList(
              desiredItemWidth: 400,
              minSpacing: 10,
              children: _getPageWidgets(context, pages),
            );
          },
        ),
      ),
      floatingActionButton: GlobalSettings.of(context)?.editMode == true
          ? FloatingActionButton(
              onPressed: () => showCreatePageDialog(context),
              tooltip: "Add New Page",
              child: const Icon(Icons.add_box_outlined),
            )
          : null,
    );
  }

  Future showCreatePageDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CreatePageDialog();
        });
  }

  Future _showEditPageDialog(BuildContext context, models.Page page) {
    return showDialog(
      context: context,
      builder: (context) {
        return EditPageDialog(page: page.clone());
      },
    );
  }

  Future _showremovePageDialog(BuildContext context, models.Page page) {
    return showDialog(
      context: context,
      builder: (context) {
        return DeleteDialog(
          title: "Seite Löschen",
          deleteText: "Soll die Seite ${page.symbolicName} wirklich gelöscht werden?",
          executeText: "Gruppe ${page.symbolicName} wird gelöscht ...",
          deleteCallback: () => Provider.of<ApiProvider>(context, listen: false).removePage(page),
        );
      },
    );
  }

  List<Widget> _getPageWidgets(BuildContext context, List<models.Page>? pages) {
    if (pages == null || pages.isEmpty) {
      return <Widget>[];
    }

    var pageWidgets = pages.map<Widget>(
      (page) => InkWell(
        onTap: () {
          Provider.of<AppState>(context, listen: false).navigateTo(
            PageAction(
              state: PageState.addPage,
              page: pagePageConfig(page),
            ),
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  title: Text(page.label),
                  leading: Icon(page.icon),
                  trailing: (GlobalSettings.of(context)?.editMode == false)
                      ? null
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _showremovePageDialog(context, page),
                              icon: const Icon(Icons.delete),
                              tooltip: "Seite Löschen",
                            ),
                            IconButton(
                              onPressed: () => _showEditPageDialog(context, page),
                              icon: const Icon(Icons.edit),
                              tooltip: "Seite bearbeiten",
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (GlobalSettings.of(context)?.editMode == true) {
      pageWidgets = pageWidgets.followedBy(
        <Widget>[
          InkWell(
            onTap: () => showCreatePageDialog(context),
            child: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Neue Seite anlegen"),
                      leading: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return pageWidgets.toList();
  }
}

enum PageContextMenu { delete, edit }
