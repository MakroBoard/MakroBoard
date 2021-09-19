import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:makro_board_client/models/page.dart' as models;
import 'package:provider/provider.dart';
import 'dart:developer';

class EditPageDialog extends StatefulWidget {
  final models.Page page;
  const EditPageDialog({Key? key, required this.page}) : super(key: key);

  @override
  _EditPageDialogState createState() => _EditPageDialogState();
}

class _EditPageDialogState extends State<EditPageDialog> {
  IconData icon = Icons.add_box;

  @override
  Widget build(BuildContext context) {
    final _editPageFormKey = GlobalKey<FormState>();
    var editPage = widget.page.clone();
    icon = editPage.icon;

    return SimpleDialog(
      title: Text("Seite " + editPage.label + " bearbeiten"),
      children: [
        Form(
          key: _editPageFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.dns_outlined),
                ),
                initialValue: editPage.label,
                validator: (value) {
                  if (value == null) {
                    return "Um fortzufahren wird ein Name benötigt.";
                  }

                  return null;
                },
                onChanged: (value) {
                  editPage.label = value;
                },
              ),
              IconButton(
                padding: const EdgeInsets.all(32.0),
                tooltip: "Icon wählen",
                onPressed: () async {
                  var iconData = await FlutterIconPicker.showIconPicker(context,
                          iconPackMode: IconPack.fontAwesomeIcons) ??
                      Icons.check;
                  setState(() {
                    icon = iconData;
                  });
                },
                icon: Icon(icon),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    child: Text("Abbrechen"),
                  ),
                  TextButton(
                    child: Text("Speichern"),
                    onPressed: () async {
                      EasyLoading.show(status: 'Seite bearbeiten ...');
                      if (_editPageFormKey.currentState!.validate()) {
                        try {
                          await Provider.of<ApiProvider>(context, listen: false)
                              .editPage(editPage);

                          Navigator.of(context, rootNavigator: true).pop();
                        } catch (e) {
                          // TODO Fehler anzeigen?
                          debugPrint("asd");
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
      ],
    );
  }
}
