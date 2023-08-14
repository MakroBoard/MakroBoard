import 'package:flutter/material.dart';
import 'package:makro_board_client/models/view_config_parameter.dart';
import 'package:makro_board_client/models/view_config_value.dart';

class ConfigParameterInput extends StatefulWidget {
  final ViewConfigParameter configParameter;
  final ViewConfigValue configParameterValue;

  final GlobalKey<FormState>? formKey;

  const ConfigParameterInput({Key? key, required this.configParameter, required this.configParameterValue, this.formKey}) : super(key: key);

  @override
  ConfigParameterInputState createState() => ConfigParameterInputState();
}

class ConfigParameterInputState extends State<ConfigParameterInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Text(configParameter.symbolicName),
        Flexible(child: _createConfigParameterInput(context, widget.configParameter, widget.configParameterValue)),
      ],
    );
  }

  Widget _createConfigParameterInput(BuildContext context, ViewConfigParameter configParameter, ViewConfigValue configValue) {
    switch (configParameter.configParameterType) {
      case ConfigParameterType.string:
        return TextFormField(
          decoration: InputDecoration(
            // border: OutlineInputBorder(),
            labelText: configParameter.label?.getText() ?? configParameter.symbolicName,
          ),
          initialValue: configValue.value.toString(),
          // TODO
          validator: (value) {
            if (configParameter.validationRegEx != null && configParameter.validationRegEx!.isNotEmpty) {
              var foundValue = RegExp(configParameter.validationRegEx!).stringMatch(value!);
              if (foundValue == null || foundValue != value) {
                return "Value doesn´t match \"${configParameter.validationRegEx!}\"";
              }
            }
            return null;
          },
          onChanged: (value) {
            configValue.value = value;
            widget.formKey?.currentState!.validate();
          },
        );
      case ConfigParameterType.bool:
        var value = configParameter.defaultValue as bool;
        if (configValue.value != null && configValue.value is bool) {
          value = configValue.value as bool;
        }
        return CheckboxListTile(
          title: Text(configParameter.symbolicName),
          controlAffinity: ListTileControlAffinity.leading,
          value: value,
          onChanged: (value) {
            setState(() => configValue.value = value);
            widget.formKey?.currentState!.validate();
          },
        );
      case ConfigParameterType.enumType:
        if (configParameter.enumItems == null || configParameter.enumItems!.isEmpty) {
          return const Text("No EnumItems are defined!");
        }
        return DropdownButtonFormField<String>(
          items: configParameter.enumItems!
              .map((EnumItem e) => DropdownMenuItem<String>(
                    value: e.id,
                    child: Text(e.label.getText()),
                  ))
              .toList(),
          value: configValue.value?.toString() ?? configParameter.defaultValue.toString(),
          onChanged: (value) {
            configValue.value = value;
            widget.formKey?.currentState!.validate();
          },
        );
      default:
        return Text("No Input definded for ${configParameter.configParameterType}");
    }
  }
}
