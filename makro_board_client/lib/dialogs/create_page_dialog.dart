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
  _CreatePageDialogState createState() => _CreatePageDialogState();
}

class _CreatePageDialogState extends State<CreatePageDialog> {
  String pageLabel = "";
  IconData icon = Icons.check;

  @override
  Widget build(BuildContext context) {
    final _createPageFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: Text("Neue Seite anlegen"),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _createPageFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
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
                    var iconData = await FlutterIconPicker.showIconPicker(context, iconPackMode: IconPack.fontAwesomeIcons) ?? Icons.check;
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
                      child: Text("Abbrechen"),
                    ),
                    TextButton(
                      child: Text("Anlegen"),
                      onPressed: () async {
                        EasyLoading.show(status: 'Neue Seite anlegen ...');
                        if (_createPageFormKey.currentState!.validate()) {
                          try {
                            await Provider.of<ApiProvider>(context, listen: false).addPage(models.Page.createNew(label: pageLabel, icon: icon));

                            Navigator.of(context, rootNavigator: true).pop();
                          } catch (e) {
                            log('Exception: ' + e.toString());
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
