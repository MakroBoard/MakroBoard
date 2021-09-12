import 'package:flutter/material.dart';
import 'package:makro_board_client/dialogs/create_page_dialog.dart';

class CreateNewPageCard extends StatelessWidget {
  const CreateNewPageCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }

  Future showCreatePageDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreatePageDialog();
        });
  }
}
