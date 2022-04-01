import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DeleteDialog extends StatelessWidget {
  final Future Function() deleteCallback;
  final String title;
  final String deleteText;
  final String executeText;

  const DeleteDialog({Key? key, required this.title, required this.deleteText, required this.executeText, required this.deleteCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(deleteText),
        ),
        ButtonBar(
          children: [
            TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text("Nein"),
            ),
            TextButton(
              child: const Text("Ja"),
              onPressed: () async {
                EasyLoading.show(status: executeText);
                await deleteCallback();
                EasyLoading.dismiss();
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      ],
    );
  }
}
