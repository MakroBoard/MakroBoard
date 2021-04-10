import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:macro_board/models/Control.dart';
import 'package:macro_board/models/Plugin.dart';
import 'package:macro_board/models/ViewConfigValue.dart';
import 'package:macro_board/models/client.dart';
import 'package:macro_board/models/page.dart';

import 'env_provider.dart';

@Injectable() // ← Injectable annotation
class ApiProvider {
  static const String requestTokenUrl = "/hub/clients";
  static const String confirmClientUrl = "/api/client/confirmclient";
  static const String removeClientUrl = "/api/client/removeClient";
  static const String checkTokenUrl = "/api/client/checktoken";
  static const String submitCodeUrl = "/api/client/submitcode";
  static const String getControlsUrl = "/api/controls/availablecontrols";
  static const String executeControlUrl = "/api/controls/execute";

  StreamController<List<Client>> streamClientController = StreamController<List<Client>>.broadcast();
  StreamController<String> streamTokenController = StreamController<String>.broadcast();
  List<Client> currentClients = [];
  Stream<List<Client>> get clients => streamClientController.stream;
  Stream<String> get token => streamTokenController.stream;
  HubConnection? _connection;

  final EnvProvider envProvider;
  ApiProvider({
    required this.envProvider, // ← The parameters of the constructur will define the generated binding
  }) {
    // Stream<Client> subscribeClients() async* {
    //   // while (!(await isAuthenticated())) {
    //   //   var loginCode = await _getNewLoginCode();
    //   //   Duration timerDuration = loginCode.validUntil.difference(DateTime.now());
    //   //   yield loginCode;
    //   //   await Future.delayed(timerDuration);
    //   // }
    // }
  }

  Future initialize() async {
    try {
      var url = Uri.https(envProvider.getBaseUrl(), requestTokenUrl).toString();
      _connection = HubConnectionBuilder()
          .withUrl(
              url,
              HttpConnectionOptions(
                logging: (level, message) => print(message),
              ))
          .build();

      await _connection!.start();
      _connection!.on('AddOrUpdateClient', _onAddOrUpdateClient);
      _connection!.on('AddOrUpdateToken', _onAddOrUpdateToken);
      _connection!.on('RemoveClient', _onRemoveClient);
      _connection!.on('AddOrUpdatePage', _onAddOrUpdatePage);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void _onRemoveClient(clients) {
    for (var client in clients!) {
      currentClients.removeWhere(
        (element) => element.id == client["id"],
      );
      streamClientController.add(currentClients);
    }
  }

  void _onAddOrUpdateToken(tokens) async {
    for (var newToken in tokens!) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var newTokenString = newToken.toString();
      var setToken = await prefs.setString('token', newTokenString);
      if (setToken) {
        streamTokenController.add(newTokenString);
      }
    }
  }

  void _onAddOrUpdateClient(clients) async {
    for (var client in clients!) {
      var existingClient = currentClients.firstWhere(
        (element) => element.id == client["id"],
        orElse: () => Client.empty(),
      );

      var newClient = Client.fromJson(client);
      if (existingClient.isEmpty) {
        currentClients.add(newClient);
      } else {
        var index = currentClients.indexOf(existingClient);
        currentClients[index] = newClient;
      }

      streamClientController.add(currentClients);
    }
  }

  void _onAddOrUpdatePage(pages) async {
    for (var page in pages!) {
      // var existingClient = currentClients.firstWhere(
      //   (element) => element.id == client["id"],
      //   orElse: () => Client.empty(),
      // );

      var newClient = Page.fromJson(page);
      // if (existingClient.isEmpty) {
      //   currentClients.add(newClient);
      // } else {
      //   var index = currentClients.indexOf(existingClient);
      //   currentClients[index] = newClient;
      // }

      // streamClientController.add(currentClients);
    }
  }

  Future<bool> isAuthenticated() async {
    // return false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('token');
      if (authToken == null) {
        return false;
      }
      var response = await http.get(
        Uri.https(envProvider.getBaseUrl(), checkTokenUrl),
        headers: <String, String>{
          HttpHeaders.authorizationHeader: authToken,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      return true;
    } on Exception catch (e) {
      log('Exception: ' + e.toString());
      return false;
    }
  }

  Future<DateTime> submitCode(int code) async {
    var response = await http.post(
      Uri.https(envProvider.getBaseUrl(), submitCodeUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(code),
    );

    var dateTime = DateTime.parse(json.decode(response.body));
    return dateTime;
  }

  Future confirmClient(Client client) async {
    try {
      var response = await http.post(
        Uri.https(envProvider.getBaseUrl(), confirmClientUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(client),
      );

      // var dateTime = DateTime.parse(json.decode(response.body));
      // return LoginCode(code: randomNumber, validUntil: dateTime);
    } on Exception catch (e) {
      print('never reached' + e.toString());
    }
  }

  Future removeClient(Client client) async {
    try {
      var jsonBody = json.encode(client);
      var response = await http.post(
        Uri.https(envProvider.getBaseUrl(), removeClientUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      // var dateTime = DateTime.parse(json.decode(response.body));
      // return LoginCode(code: randomNumber, validUntil: dateTime);
    } on Exception catch (e) {
      print('never reached' + e.toString());
    }
  }

  Future<List<Plugin>> getAvailableControls() async {
    try {
      var response = await http.get(
        Uri.https(envProvider.getBaseUrl(), getControlsUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var jsonData = json.decode(response.body);
      var result = List.castFrom(jsonData).map((jsonPlugin) => Plugin.fromJson(jsonPlugin)).toList();

      return result;
      // var dateTime = DateTime.parse(json.decode(response.body));
      // return LoginCode(code: randomNumber, validUntil: dateTime);
    } on Exception catch (e) {
      print('never reached' + e.toString());
    }

    return List.empty();
  }

  Future executeControl(Control control, List<ViewConfigValue> configValues) async {
    try {
      var jsonBody = json.encode({"symbolicName": control.symbolicName, "configValues": configValues});
      var response = await http.post(
        Uri.https(envProvider.getBaseUrl(), executeControlUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      // var dateTime = DateTime.parse(json.decode(response.body));
      // return LoginCode(code: randomNumber, validUntil: dateTime);
    } on Exception catch (e) {
      print('never reached' + e.toString());
    }
  }
}
