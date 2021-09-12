import 'package:flutter/material.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/widgets/CreateNewPageCard.dart';
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
    );
  }

  List<Widget> _getPageWidgets(BuildContext context, List<models.Page>? pages) {
    var result = <Widget>[
      CreateNewPageCard(),
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
}
