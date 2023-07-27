import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/group.dart' as models;
import 'package:provider/provider.dart';

class EditGroupDialog extends StatelessWidget {
  final models.Group group;
  const EditGroupDialog({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editGroupFormKey = GlobalKey<FormState>();

    var editGroup = group.clone();

    return SimpleDialog(
      title: Text("Gruppe ${editGroup.label} bearbeiten"),
      children: [
        Form(
          key: editGroupFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.dns_outlined),
                ),
                initialValue: editGroup.label,
                validator: (value) {
                  if (value == null) {
                    return "Um fortzufahren wird ein Name benötigt.";
                  }

                  return null;
                },
                onChanged: (value) {
                  editGroup.label = value;
                },
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
                      EasyLoading.show(status: 'Gruppe bearbeiten ...');
                      if (editGroupFormKey.currentState!.validate()) {
                        try {
                          await Provider.of<ApiProvider>(context, listen: false).editGroup(editGroup);

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
