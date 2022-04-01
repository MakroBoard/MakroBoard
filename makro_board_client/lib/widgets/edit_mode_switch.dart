import 'package:flutter/material.dart';

import 'global_settings.dart';

class EditModeSwitch extends StatelessWidget {
  const EditModeSwitch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "EditModus aktivieren",
      child: Switch(
        value: GlobalSettings.of(context)?.editMode ?? false,
        onChanged: (v) {
          var globalSettings = GlobalSettings.of(context);
          if (globalSettings != null) {
            globalSettings.updateEditMode(v);
          }
        },
      ),
    );
  }
}
