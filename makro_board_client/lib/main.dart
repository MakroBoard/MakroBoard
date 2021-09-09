import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:makro_board_client/pages/homePage.dart';
import 'package:makro_board_client/pages/login_page.dart';
import 'package:makro_board_client/pages/pagePage.dart';
import 'package:makro_board_client/pages/select_server_page.dart';
import 'package:makro_board_client/pages/splash_screen.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/provider/auth_provider.dart';
import 'package:makro_board_client/provider/env_provider.dart';
import 'package:makro_board_client/provider/notification_provider.dart';
import 'package:makro_board_client/widgets/EditMode.dart';
import 'package:provider/provider.dart';
import 'package:makro_board_client/theme/theme.dart';
import 'package:makro_board_client/models/page.dart' as models;

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        Provider<EnvProvider>(create: (c) => EnvProvider()),
        Provider<NotificationProvider>(create: (c) => NotificationProvider()),
        Provider<ApiProvider>(create: (c) => ApiProvider(envProvider: Provider.of(c, listen: false), notificationProvider: Provider.of(c, listen: false))),
        Provider<AuthProvider>(create: (c) => AuthProvider(apiProvider: Provider.of(c, listen: false)))
      ],
      child: GlobalSettings(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uri? _selectedServer;
  var _isAuthenticated = false;
  models.Page? _selectedPage;

  @override
  Widget build(BuildContext context) {
    Provider.of<ApiProvider>(context, listen: false).isAuthenticatedStream.listen((isAuthenticated) {
      if (_isAuthenticated != isAuthenticated) {
        setState(() {
          _isAuthenticated = isAuthenticated;
        });
      }
    });

    return MaterialApp(
      title: 'MakroBoard',
      // theme: ThemeData(
      //   // This is the theme of your application.
      //   //
      //   // Try running your application with "flutter run". You'll see the
      //   // application has a blue toolbar. Then, without quitting the app, try
      //   // changing the primarySwatch below to Colors.green and then invoke
      //   // "hot reload" (press "r" in the console where you ran "flutter run",
      //   // or simply save your changes to "hot reload" in a Flutter IDE).
      //   // Notice that the counter didn't reset back to zero; the application
      //   // is not restarted.
      //   primarySwatch: Colors.blue,
      // ),
      theme: makroBoardTheme,
      home: Navigator(
        pages: [
          if (_selectedServer == null)
            MaterialPage(
              key: ValueKey('SplashScreen'),
              child: SplashScreen(
                selectedServerChanged: _handleSelectedServer,
              ),
            ),
          if (_selectedServer != null)
            if (!_selectedServer!.hasPort || !_selectedServer!.hasAuthority)
              MaterialPage(
                key: ValueKey('SelectServerPage'),
                child: SelectServerPage(
                  selectedServerChanged: _handleSelectedServer,
                  isAuthenticatedChanged: _handleIsAuthenticatedChanged,
                ),
              )
            else if (!_isAuthenticated)
              MaterialPage(
                key: ValueKey('LoginPage'),
                child: LoginPage(
                    // selectedServerChanged: _handleSelectedServer,
                    // isAuthenticatedChanged: _handleIsAuthenticatedChanged,
                    ),
              )
            else
              MaterialPage(
                key: ValueKey('HomePage'),
                child: HomePage(
                  selectedPageChanged: _handleSelectedPageChanged,
                ),
              ),
          if (_selectedServer != null && _selectedPage != null)
            MaterialPage(
              key: ValueKey('Page_' + _selectedPage!.symbolicName),
              child: PagePage(
                initialPage: _selectedPage!,
                key: ValueKey(_selectedPage!.symbolicName),
              ),
            ),
        ],
        onPopPage: (route, result) {
          if (_selectedPage != null) {
            _selectedPage = null;
          }

          return route.didPop(result);
        },
      ),
      builder: EasyLoading.init(),
    );
  }

  void _handleSelectedServer(selectedServer) {
    setState(() {
      _selectedServer = selectedServer;
    });
  }

  void _handleIsAuthenticatedChanged(isAuthenticated) {
    setState(() {
      _isAuthenticated = isAuthenticated;
    });
  }

  void _handleSelectedPageChanged(page) {
    setState(() {
      _selectedPage = page;
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = super.createHttpClient(context)
      ..maxConnectionsPerHost = 5
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  }
}
