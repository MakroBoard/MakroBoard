import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/dialogs/create_page_dialog.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/provider/auth_provider.dart';
import 'package:makro_board_client/widgets/WmskAppBar.dart';
import 'package:responsive_grid/responsive_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WmskAppBar(title: "Home").getAppBar(context),
      body: Container(
        child: StreamBuilder(
          stream: Modular.get<ApiProvider>().pages,
          builder: (context, snapshot) => ResponsiveGridList(
            desiredItemWidth: 200,
            minSpacing: 10,
            children: _getPageWidgets(context, snapshot.data as List<Page>),
          ),
        ),
      ),
    );
  }

  List<Widget> _getPageWidgets(BuildContext context, List<Page>? pages) {
    var result = <Widget>[
      Card(
        child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CreatePageDialog();
                });
          },
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
                child: Text(page.name!),
              ),
            )
            .toList() +
        result;
  }
}
