import 'package:flutter/material.dart';
import 'package:makro_board_client/app_state.dart';
import 'package:makro_board_client/dialogs/delete_dialog.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/router/page_action.dart';
import 'package:makro_board_client/router/page_configuration.dart';
import 'package:makro_board_client/router/page_state.dart';
import 'package:makro_board_client/widgets/edit_mode_switch.dart';
import 'package:makro_board_client/widgets/global_settings.dart';
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
          builder: (context, snapshot) => ResponsiveGridList(
            desiredItemWidth: 200,
            minSpacing: 10,
            children: _getPageWidgets(context, snapshot.data as List<models.Page>),
          ),
        ),
      ),
      floatingActionButton: GlobalSettings.of(context)?.editMode == true
          ? FloatingActionButton(
              child: const Icon(Icons.add_box_outlined),
              onPressed: () => showCreatePageDialog(context),
              tooltip: "Add New Page",
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
    if (pages == null) {
      return <Widget>[];
    }

    return pages
        .map<Widget>(
          (page) => Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Provider.of<AppState>(context, listen: false).navigateTo(
                        PageAction(
                          state: PageState.addPage,
                          page: pagePageConfig(page),
                        ),
                      );
                    },
                    title: Text(page.label),
                    leading: Icon(page.icon),
                    trailing: (GlobalSettings.of(context)?.editMode == false)
                        ? null
                        : PopupMenuButton<PageContextMenu>(
                            onSelected: (selectedValue) {
                              switch (selectedValue) {
                                case PageContextMenu.delete:
                                  _showremovePageDialog(context, page);
                                  break;
                                case PageContextMenu.edit:
                                  _showEditPageDialog(context, page);
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem<PageContextMenu>(
                                value: PageContextMenu.delete,
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Seite Löschen'),
                                ),
                              ),
                              const PopupMenuItem<PageContextMenu>(
                                value: PageContextMenu.edit,
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Seite bearbeiten'),
                                ),
                              ),
                            ],
                            icon: const Icon(Icons.more_vert),
                          ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}

enum PageContextMenu { delete, edit }
