import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:makro_board_client/models/page.dart' as models;
import 'package:provider/provider.dart';

// test
class EditPageDialog extends StatefulWidget {
  final models.Page page;
  const EditPageDialog({Key? key, required this.page}) : super(key: key);

  @override
  EditPageDialogState createState() => EditPageDialogState();
}

class EditPageDialogState extends State<EditPageDialog> {
  EditPageDialogState();

  @override
  Widget build(BuildContext context) {
    final editPageFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: Text("Seite ${widget.page.label} bearbeiten"),
      children: [
        Form(
          key: editPageFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.dns_outlined),
                ),
                initialValue: widget.page.label,
                validator: (value) {
                  if (value == null) {
                    return "Um fortzufahren wird ein Name benötigt.";
                  }

                  return null;
                },
                onChanged: (value) {
                  widget.page.label = value;
                },
              ),
              IconButton(
                padding: const EdgeInsets.all(32.0),
                tooltip: "Icon wählen",
                onPressed: () async {
                  var iconData = await FlutterIconPicker.showIconPicker(
                        context,
                        iconPackModes: [IconPack.material],
                        adaptiveDialog: true,
                      ) ??
                      Icons.check;
                  setState(() {
                    widget.page.icon = iconData;
                  });
                },
                icon: Icon(widget.page.icon),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    child: const Text("Abbrechen"),
                  ),
                  TextButton(
                    child: const Text("Speichern"),
                    onPressed: () async {
                      EasyLoading.show(status: 'Seite bearbeiten ...');
                      if (editPageFormKey.currentState!.validate()) {
                        try {
                          await Provider.of<ApiProvider>(context, listen: false).editPage(widget.page);
                          if (!context.mounted) return;
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
