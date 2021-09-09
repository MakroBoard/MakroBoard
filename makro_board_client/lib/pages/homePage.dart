import 'dart:async';

import 'package:flutter/material.dart';
import 'package:makro_board_client/dialogs/create_page_dialog.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/widgets/SnackBarNotification.dart';
import 'package:makro_board_client/widgets/WmskAppBar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:makro_board_client/models/page.dart' as models;

class HomePage extends StatelessWidget {
  final ValueChanged<models.Page> selectedPageChanged;

  const HomePage({
    required this.selectedPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WmskAppBar(titleText: "Home"),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note_add),
        onPressed: () => showCreatePageDialog(context),
        tooltip: "Neue Seite Anlegen",
      ),
    );
  }

  List<Widget> _getPageWidgets(BuildContext context, List<models.Page>? pages) {
    var result = <Widget>[
      Card(
        child: InkWell(
          onTap: () => showCreatePageDialog(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("Add New Page"),
              leading: Icon(Icons.add),
            ),
          ),
        ),
      ),
    ];

    if (pages == null) {
      return result;
    }

    return pages
            .map<Widget>(
              (page) => Card(
                child: InkWell(
                  onTap: () {
                    selectedPageChanged(page);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(page.label),
                      leading: Icon(page.icon),
                    ),
                  ),
                ),
              ),
            )
            .toList() +
        result;
  }

  Future showCreatePageDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreatePageDialog();
        });
  }
}
