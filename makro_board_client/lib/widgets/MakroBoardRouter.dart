import 'package:flutter/material.dart';

class InheritedMakroBoardRouter extends InheritedWidget {
  // Data is your entire state. In our case just 'User'
  final MakroBoardRouterState data;

  // You must pass through a child and your state.
  InheritedMakroBoardRouter({
    required this.data,
    required Widget child,
  }) : super(child: child);

  // This is a built in method which you can use to check if
  // any state has changed. If not, no reason to rebuild all the widgets
  // that rely on your state.
  @override
  bool updateShouldNotify(InheritedMakroBoardRouter old) => true;
}

class MakroBoardRouter extends StatefulWidget {
  // You must pass through a child.
  final Widget child;

  MakroBoardRouter({
    required this.child,
  });

  // This is the secret sauce. Write your own 'of' method that will behave
  // Exactly like MediaQuery.of and Theme.of
  // It basically says 'get the data from the widget of this type.
  static MakroBoardRouterState? of(BuildContext context) {
    var widgetOfType = context.dependOnInheritedWidgetOfExactType<InheritedMakroBoardRouter>();
    return widgetOfType?.data;
  }

  @override
  MakroBoardRouterState createState() => new MakroBoardRouterState();
}

class MakroBoardRouterState extends State<MakroBoardRouter> {
  // Whichever properties you wanna pass around your app as state
  bool showConfig = false;
  bool showSettings = false;

  void reset() {
    showConfig = false;
    showSettings = false;
  }

  void updateShowConfig(bool showConfig) {
    if (this.showConfig != showConfig) {
      setState(() {
        this.showConfig = showConfig;
      });
    }
  }

  void updateShowSettings(bool showSettings) {
    if (this.showSettings != showSettings) {
      setState(() {
        this.showSettings = showSettings;
      });
    }
  }

  // Simple build method that just passes this state through
  // your InheritedWidget
  @override
  Widget build(BuildContext context) {
    return InheritedMakroBoardRouter(
      data: this,
      child: widget.child,
    );
  }
}
