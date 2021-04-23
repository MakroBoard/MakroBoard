import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:http/http.dart' as http;
import 'package:makro_board_client/models/group.dart';
import 'package:makro_board_client/models/panel.dart';

import 'package:signalr_core/signalr_core.dart';
import 'package:makro_board_client/models/Control.dart';
import 'package:makro_board_client/models/Plugin.dart';
import 'package:makro_board_client/models/ViewConfigValue.dart';
import 'package:makro_board_client/models/client.dart';
import 'package:makro_board_client/models/page.dart';

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
  static const String addPageUrl = "/api/layout/addpage";
  static const String addGroupUrl = "/api/layout/addgroup";
  static const String addPanelUrl = "/api/layout/addpanel";

  StreamController<List<Page>> streamPageController = StreamController<List<Page>>.broadcast();
  Stream<List<Page>> get pages => streamPageController.stream;
  List<Page> currentPages = [];
  List<Group> currentGroups = [];
  List<Panel> currentPanels = [];

  StreamController<List<Client>> streamClientController = StreamController<List<Client>>.broadcast();
  Stream<List<Client>> get clients => streamClientController.stream;
  List<Client> currentClients = [];

  StreamController<String> streamTokenController = StreamController<String>.broadcast();
  Stream<String> get token => streamTokenController.stream;

  HubConnection? _connection;
  Uri? _serverUri;

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

  Future<bool> initialize(Uri serverUri) async {
    try {
      _serverUri = serverUri;
      var url = serverUri.replace(path: requestTokenUrl).toString();
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
      _connection!.on('AddOrUpdateGroup', _onAddOrUpdateGroup);
      _connection!.on('AddOrUpdatePanel', _onAddOrUpdatePanel);

      return true;
    } on Exception catch (e) {
      print(e.toString());
    }

    return false;
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
      var newTokenString = newToken.toString();
      await Settings.setValue("server_token", newTokenString);
      streamTokenController.add(newTokenString);
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
      var existingPage = currentPages.firstWhere(
        (element) => element.id == page["id"],
        orElse: () => Page.empty(),
      );

      var newPage = Page.fromJson(page);
      if (existingPage.isEmpty) {
        currentPages.add(newPage);
      } else {
        var index = currentPages.indexOf(existingPage);
        currentPages[index] = newPage;
      }

      streamPageController.add(currentPages);
    }
  }

  void _onAddOrUpdateGroup(groups) async {
    for (var group in groups!) {
      var existingPage = currentPages.firstWhere(
        (element) => element.id == group["pageID"],
        orElse: () => Page.empty(),
      );

      if (existingPage.isEmpty) {
        continue;
      }

      var existingGroup = existingPage.groups.firstWhere(
        (element) => element.id == group["id"],
        orElse: () => Group.empty(),
      );

      var newGroup = Group.fromJson(group);
      if (existingGroup.isEmpty) {
        currentGroups.add(newGroup);
        existingPage.groups.add(newGroup);
      } else {
        var indexCurrentGroup = currentGroups.indexOf(existingGroup);
        currentGroups[indexCurrentGroup] = newGroup;

        var index = existingPage.groups.indexOf(existingGroup);
        existingPage.groups[index] = newGroup;
      }
      existingPage.notifyGroupsUpdated();
    }
  }

  void _onAddOrUpdatePanel(panels) async {
    for (var panel in panels!) {
      var existingPanel = currentPanels.firstWhere(
        (element) => element.id == panel["id"],
        orElse: () => Panel.empty(),
      );

      if (existingPanel.isEmpty) {
        continue;
      }

      var existingGroup = currentGroups.firstWhere(
        (element) => element.id == panel["groupId"],
        orElse: () => Group.empty(),
      );

      var newPanel = Panel.fromJson(panel);
      if (existingPanel.isEmpty) {
        currentPanels.add(newPanel);
        existingGroup.panels.add(newPanel);
      } else {
        var indexCurrentPanel = currentPanels.indexOf(existingPanel);
        currentPanels[indexCurrentPanel] = newPanel;

        var index = existingGroup.panels.indexOf(existingPanel);
        existingGroup.panels[index] = newPanel;
      }
      existingGroup.notifyPanelsUpdated();
    }
  }

  Future<bool> isAuthenticated() async {
    // return false;
    try {
      var authToken = Settings.getValue("server_token", "");
      if (authToken.isEmpty) {
        return false;
      }

      var response = await http.get(
        _serverUri!.replace(path: checkTokenUrl),
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
      _serverUri!.replace(path: submitCodeUrl),
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
      await http.post(
        _serverUri!.replace(path: confirmClientUrl),
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
      await http.post(
        _serverUri!.replace(path: removeClientUrl),
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

  Future<List<Plugin>> getAvailableControls() async {
    try {
      var response = await http.get(
        _serverUri!.replace(path: getControlsUrl),
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

    return List.empty(growable: true);
  }

  Future executeControl(Control control, List<ViewConfigValue> configValues) async {
    try {
      var jsonBody = json.encode({"symbolicName": control.symbolicName, "configValues": configValues});
      await http.post(
        _serverUri!.replace(path: executeControlUrl),
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

  Future addPage(Page page) async {
    await http.post(
      _serverUri!.replace(path: addPageUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(page),
    );
  }

  Future addGroup(Group group) async {
    await http.post(
      _serverUri!.replace(path: addGroupUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(group),
    );
  }

  Future addPanel(Panel panel) async {
    await http.post(
      _serverUri!.replace(path: addPanelUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(panel),
    );
  }
}
