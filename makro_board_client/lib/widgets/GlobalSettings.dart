import 'package:flutter/material.dart';

class InheritedGlobalSettings extends InheritedWidget {
  // Data is your entire state. In our case just 'User'
  final GlobalSettingsState data;

  // You must pass through a child and your state.
  InheritedGlobalSettings({
    required this.data,
    required Widget child,
  }) : super(child: child);

  // This is a built in method which you can use to check if
  // any state has changed. If not, no reason to rebuild all the widgets
  // that rely on your state.
  @override
  bool updateShouldNotify(InheritedGlobalSettings old) => true;
}

class GlobalSettings extends StatefulWidget {
  // You must pass through a child.
  final Widget child;

  GlobalSettings({
    required this.child,
  });

  // This is the secret sauce. Write your own 'of' method that will behave
  // Exactly like MediaQuery.of and Theme.of
  // It basically says 'get the data from the widget of this type.
  static GlobalSettingsState? of(BuildContext context) {
    var widgetOfType = context.dependOnInheritedWidgetOfExactType<InheritedGlobalSettings>();
    return widgetOfType?.data;
  }

  @override
  GlobalSettingsState createState() => new GlobalSettingsState();
}

class GlobalSettingsState extends State<GlobalSettings> {
  // Whichever properties you wanna pass around your app as state
  bool editMode = false;

  void updateEditMode(bool editMode) {
    if (this.editMode != editMode) {
      setState(() {
        this.editMode = editMode;
      });
    }
  }

  // Simple build method that just passes this state through
  // your InheritedWidget
  @override
  Widget build(BuildContext context) {
    return InheritedGlobalSettings(
      data: this,
      child: widget.child,
    );
  }
}
