import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/page.dart' as models;
import 'package:provider/provider.dart';

class CreatePageDialog extends StatefulWidget {
  const CreatePageDialog({Key? key}) : super(key: key);

  @override
  CreatePageDialogState createState() => CreatePageDialogState();
}

class CreatePageDialogState extends State<CreatePageDialog> {
  String pageLabel = "";
  IconData icon = Icons.check;

  @override
  Widget build(BuildContext context) {
    final createPageFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: const Text("Neue Seite anlegen"),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: createPageFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: pageLabel,
                  decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    labelText: "Name",
                    prefixIcon: Icon(Icons.dns_outlined),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Um fortzufahren wird ein Name benötigt.";
                    }

                    return null;
                  },
                  onChanged: (value) {
                    pageLabel = value;
                  },
                ),
                IconButton(
                  padding: const EdgeInsets.all(32.0),
                  tooltip: "Icon wählen",
                  onPressed: () async {
                    var iconData = await FlutterIconPicker.showIconPicker(context, iconPackModes: [IconPack.fontAwesomeIcons]) ?? Icons.check;
                    setState(() {
                      icon = iconData;
                    });
                  },
                  icon: Icon(icon),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                      child: const Text("Abbrechen"),
                    ),
                    TextButton(
                      child: const Text("Anlegen"),
                      onPressed: () async {
                        EasyLoading.show(status: 'Neue Seite anlegen ...');
                        if (createPageFormKey.currentState!.validate()) {
                          try {
                            await Provider.of<ApiProvider>(context, listen: false).addPage(models.Page.createNew(label: pageLabel, icon: icon));
                            if (!context.mounted) return;
                            Navigator.of(context, rootNavigator: true).pop();
                          } catch (e) {
                            log('Exception: $e');
                            // TODO Fehler anzeigen?
                          }
                        }
                        EasyLoading.dismiss();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
