import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:web_macro_soft_keyboard_client/models/client.dart';

import 'env_provider.dart';

@Injectable() // ← Injectable annotation
class ApiProvider {
  static const String requestTokenUrl = "/hub/clients";
  static const String confirmClientUrl = "/api/client/confirmclient";
  static const String removeClientUrl = "/api/client/removeClient";
  static const String checkTokenUrl = "/api/client/checktoken";
  static const String submitCodeUrl = "/api/client/submitcode";

  StreamController<List<Client>> streamClientController = StreamController<List<Client>>.broadcast();
  List<Client> currentClients = [];
  Stream<List<Client>> get clients => streamClientController.stream;
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
      _connection!.on('AddOrUpdateClient', (clients) async {
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
      });

      await _connection!.start();
      _connection!.on('AddOrUpdateToken', (tokens) async {
        for (var token in tokens!) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var setToken = await prefs.setString('token', token.toString());
        }
      });

      _connection!.on('RemoveClient', (clients) {
        for (var client in clients!) {
          currentClients.removeWhere(
            (element) => element.id == client["id"],
          );
          streamClientController.add(currentClients);
        }
      });
    } on Exception catch (e) {
      // TODO
    }
  }

  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('token');
    if (authToken == null) {
      return false;
    }
    var response = await http.get(
      Uri.http(envProvider.getBaseUrl(), checkTokenUrl),
      headers: {HttpHeaders.authorizationHeader: authToken},
    );

    return true;
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
}
