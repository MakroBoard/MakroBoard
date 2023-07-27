import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/page.dart' as models;
import 'package:makro_board_client/models/group.dart' as models;
import 'package:provider/provider.dart';

class CreateGroupDialog extends StatelessWidget {
  final models.Page page;
  const CreateGroupDialog({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String groupLabel = "";
    final createGroupFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: const Text("Neue Gruppe anlegen"),
      children: [
        Form(
          key: createGroupFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
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
                  groupLabel = value;
                },
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
                      EasyLoading.show(status: 'Neue Gruppe anlegen ...');
                      if (createGroupFormKey.currentState!.validate()) {
                        try {
                          await Provider.of<ApiProvider>(context, listen: false).addGroup(models.Group.createNew(label: groupLabel, pageId: page.id));

                          Navigator.of(context, rootNavigator: true).pop();
                        } catch (e) {
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
      ],
    );
  }
}
