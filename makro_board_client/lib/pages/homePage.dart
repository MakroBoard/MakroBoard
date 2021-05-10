import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/dialogs/create_page_dialog.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/widgets/WmskAppBar.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:makro_board_client/models/page.dart' as models;

class HomePage extends StatelessWidget {
  const HomePage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WmskAppBar(titleText: "Home"),
      body: Container(
        child: StreamBuilder(
          stream: Modular.get<ApiProvider>().pages,
          initialData: Modular.get<ApiProvider>().currentPages,
          builder: (context, snapshot) => ResponsiveGridList(
            desiredItemWidth: 200,
            minSpacing: 10,
            children: _getPageWidgets(context, snapshot.data as List<models.Page>),
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
      // Card(
      //   child: InkWell(
      //     onTap: () => showCreatePageDialog(context),
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: ListTile(
      //         title: Text("Add New Page"),
      //         leading: Icon(Icons.add),
      //       ),
      //     ),
      //   ),
      // ),
    ];

    if (pages == null) {
      return result;
    }

    return pages
            .map<Widget>(
              (page) => Card(
                child: InkWell(
                  onTap: () {
                    Modular.to.pushNamed('/page', arguments: page);
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
