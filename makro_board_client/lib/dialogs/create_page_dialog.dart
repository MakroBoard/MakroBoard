import 'package:flutter/material.dart';

class CreatePageDialog extends StatelessWidget {
  const CreatePageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Neue Seite anlegen"),
      children: [
        Text("Hier kommen die Eingabefelder hin"),
        ButtonBar(
          children: [
            TextButton(
              onPressed: () {},
              child: Text("Abbrechen"),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Anlegen"),
            ),
          ],
        ),
      ],
    );
  }
}
