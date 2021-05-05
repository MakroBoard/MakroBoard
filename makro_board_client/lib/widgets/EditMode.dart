import 'package:flutter/material.dart';

class InheritedEditMode extends InheritedWidget {
  // Data is your entire state. In our case just 'User'
  final EditModeState data;

  // You must pass through a child and your state.
  InheritedEditMode({
    required this.data,
    required Widget child,
  }) : super(child: child);

  // This is a built in method which you can use to check if
  // any state has changed. If not, no reason to rebuild all the widgets
  // that rely on your state.
  @override
  bool updateShouldNotify(InheritedEditMode old) => true;
}

class EditMode extends StatefulWidget {
  // You must pass through a child.
  final Widget child;
  final bool editMode;

  EditMode({
    required this.child,
    required this.editMode,
  });

  // This is the secret sauce. Write your own 'of' method that will behave
  // Exactly like MediaQuery.of and Theme.of
  // It basically says 'get the data from the widget of this type.
  static EditModeState? of(BuildContext context) {
    var widgetOfType = context.dependOnInheritedWidgetOfExactType<InheritedEditMode>();
    return widgetOfType?.data;
  }

  @override
  EditModeState createState() => new EditModeState();
}

class EditModeState extends State<EditMode> {
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
    return InheritedEditMode(
      data: this,
      child: widget.child,
    );
  }
}
