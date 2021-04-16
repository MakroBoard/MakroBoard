import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/dialogs/create_page_dialog.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/widgets/WmskAppBar.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:makro_board_client/models/page.dart' as models;

class PagePage extends StatelessWidget {
  final models.Page initialPage;
  const PagePage({required Key key, required this.initialPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WmskAppBar(title: initialPage.label).getAppBar(context),
      body: Container(
        child: Text("Test"),
        // child: StreamBuilder(
        //   stream: Modular.get<ApiProvider>().pages,
        //   initialData: Modular.get<ApiProvider>().currentPages,
        //   builder: (context, snapshot) => ResponsiveGridList(
        //     desiredItemWidth: 200,
        //     minSpacing: 10,
        //     children: _getPageWidgets(context, snapshot.data as List<models.Page>),
        //   ),
        // ),
      ),
    );
  }
}
