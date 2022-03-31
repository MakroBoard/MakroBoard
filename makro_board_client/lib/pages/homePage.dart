import 'package:flutter/material.dart';
import 'package:makro_board_client/dialogs/delete_dialog.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/widgets/EditModeSwitch.dart';
import 'package:makro_board_client/widgets/GlobalSettings.dart';
import 'package:makro_board_client/widgets/SnackBarNotification.dart';
import 'package:makro_board_client/widgets/MakroBoardAppBar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:makro_board_client/models/page.dart' as models;
import 'package:makro_board_client/dialogs/create_page_dialog.dart';
import 'package:makro_board_client/dialogs/edit_page_dialog.dart';

class HomePage extends StatelessWidget {
  final ValueChanged<models.Page> selectedPageChanged;

  const HomePage({
    required this.selectedPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MakroBoardAppBar(
        context: context,
        titleText: "Home",
        additionalActions: [
          EditModeSwitch(),
        ],
      ),
      body: SnackBarNotification(
        child: Container(
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
      ),
      floatingActionButton: GlobalSettings.of(context)?.editMode == true
          ? FloatingActionButton(
              child: Icon(Icons.add_box_outlined),
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
          return CreatePageDialog();
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
                      selectedPageChanged(page);
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
                            icon: Icon(Icons.more_vert),
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
