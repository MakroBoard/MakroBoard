import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:signalr_core/signalr_core.dart';
import 'package:web_macro_soft_keyboard_client/models/client.dart';

import 'env_provider.dart';

@Injectable() // ← Injectable annotation
class DataProvider {
  static const String requestTokenUrl = "/hub/clients";
  static const String confirmClientUrl = "/api/client/confirmclient";
  static const String removeClientUrl = "/api/client/removeClient";

  StreamController<List<Client>> streamClientController = StreamController<List<Client>>.broadcast();
  List<Client> currentClients = [];
  Stream<List<Client>> get clients => streamClientController.stream;
  HubConnection? _connection;

  final EnvProvider envProvider;
  DataProvider({
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
      _connection!.on('AddOrUpdateClient', (clients) {
        for (var client in clients!) {
          var existingClient = currentClients.firstWhere(
            (element) => element.id == client["id"],
            orElse: () => Client.empty(),
          );

          var newClient = Client(
            id: client["id"],
            clientIp: client["clientIp"],
            code: client["code"],
            lastConnection: client["lastConnection"],
            registerDate: client["registerDate"],
            state: client["state"],
            token: client["token"],
            validUntil: client["validUntil"],
          );
          if (existingClient.isEmpty) {
            currentClients.add(newClient);
          } else {
            var index = currentClients.indexOf(existingClient);
            currentClients[index] = newClient;
          }

          streamClientController.add(currentClients);
        }
      });

      _connection!.on('RemoveClient', (client) {
        // print(message.toString());
      });
    } on Exception catch (e) {
      // TODO
    }
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
