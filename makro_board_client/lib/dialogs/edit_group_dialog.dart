import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/page.dart' as models;
import 'package:makro_board_client/models/group.dart' as models;

class EditGroupDialog extends StatelessWidget {
  final models.Group group;
  const EditGroupDialog({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _editGroupFormKey = GlobalKey<FormState>();
    
    var editGroup = group.clone();

    return SimpleDialog(
      title: Text("Gruppe " + editGroup.label + " bearbeiten"),
      children: [
        Form(
          key: _editGroupFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
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
                    child: Text("Abbrechen"),
                  ),
                  TextButton(
                    child: Text("Speichern"),
                    onPressed: () async {
                      EasyLoading.show(status: 'Gruppe bearbeiten ...');
                      if (_editGroupFormKey.currentState!.validate()) {
                        try {
                          
                          await Modular.get<ApiProvider>().editGroup(editGroup);

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
