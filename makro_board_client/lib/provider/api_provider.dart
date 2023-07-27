import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart' as material;
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:http/http.dart' as http;
import 'package:makro_board_client/models/api/Request.dart';
import 'package:makro_board_client/models/group.dart';
import 'package:makro_board_client/models/panel.dart';
import 'package:makro_board_client/provider/notification_provider.dart';

import 'package:signalr_core/signalr_core.dart';
import 'package:makro_board_client/models/control.dart';
import 'package:makro_board_client/models/plugin.dart';
import 'package:makro_board_client/models/view_config_value.dart';
import 'package:makro_board_client/models/client.dart';
import 'package:makro_board_client/models/page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'env_provider.dart';

class ApiProvider {
  static const String requestTokenUrl = "/hub/clients";
  static const String confirmClientUrl = "/api/client/confirmclient";
  static const String removeClientUrl = "/api/client/removeClient";
  static const String checkTokenUrl = "/api/client/checktoken";
  static const String submitCodeUrl = "/api/client/submitcode";
  static const String getControlsUrl = "/api/controls/availablecontrols";
  static const String executeControlUrl = "/api/controls/execute";
  static const String addPageUrl = "/api/layout/addpage";
  static const String editPageUrl = "/api/layout/editpage";
  static const String addGroupUrl = "/api/layout/addgroup";
  static const String editGroupUrl = "/api/layout/editgroup";
  static const String addPanelUrl = "/api/layout/addpanel";
  static const String editPanelUrl = "/api/layout/editpanel";
  static const String removeGroupUrl = "/api/layout/removegroup";
  static const String removePanelUrl = "/api/layout/removepanel";
  static const String removePageUrl = "/api/layout/removepage";

  Map<String, String> get _defaultHeader => <String, String>{
        HttpHeaders.authorizationHeader: Settings.getValue("server_token", defaultValue: "") ?? "",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept-Language': _locale ?? "*"
      };

  List<Plugin> currentPlugins = [];

  StreamController<List<Page>> streamPageController = StreamController<List<Page>>.broadcast();
  Stream<List<Page>> get pages => streamPageController.stream;
  List<Page> currentPages = [];

  StreamController<List<Client>> streamClientController = StreamController<List<Client>>.broadcast();
  Stream<List<Client>> get clients => streamClientController.stream;
  List<Client> currentClients = [];

  StreamController<bool> streamIsAuthenticatedController = StreamController<bool>.broadcast();
  Stream<bool> get isAuthenticatedStream => streamIsAuthenticatedController.stream;
  bool currentIsAuthenticated = false;

  HubConnection? _connection;
  Uri? _serverUri;
  String? _locale;

  final EnvProvider envProvider;
  final NotificationProvider notificationProvider;
  material.BuildContext? currentContext;
  ApiProvider({
    required this.envProvider, // ← The parameters of the constructur will define the generated binding
    required this.notificationProvider, // ← The parameters of the constructur will define the generated binding
  });

  void updateContext(material.BuildContext context) {
    currentContext = context;
  }

  Future<bool> initialize(Uri serverUri, String locale) async {
    try {
      _serverUri = serverUri;
      _locale = locale;

      var url = serverUri.replace(path: requestTokenUrl).toString();
      _connection = HubConnectionBuilder()
          .withUrl(
              url,
              HttpConnectionOptions(
                  // logging: (level, message) => print(message),
                  ))
          .withAutomaticReconnect()
          .build();

      _connection!.on('AddOrUpdateClient', _onAddOrUpdateClient);
      _connection!.on('AddOrUpdateToken', _onAddOrUpdateToken);
      _connection!.on('RemoveClient', _onRemoveClient);
      _connection!.on('AddOrUpdatePage', _onAddOrUpdatePage);
      _connection!.on('RemovePage', _onRemovePage);
      _connection!.on('AddOrUpdateGroup', _onAddOrUpdateGroup);
      _connection!.on('RemoveGroup', _onRemoveGroup);
      _connection!.on('AddOrUpdatePanel', _onAddOrUpdatePanel);
      _connection!.on('RemovePanel', _onRemovePanel);
      _connection!.on('UpdatePanelData', _onUpdatePanelData);

      Completer c = Completer();
      _connection!.on('Initialized', (_) => c.complete());
      await _connection!.start();
      await c.future;
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
      currentIsAuthenticated = true;
      streamIsAuthenticatedController.add(currentIsAuthenticated);
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

  void _onRemovePage(pages) async {
    for (var page in pages) {
      var existingPage = currentPages.firstWhere(
        (element) => element.id == page["id"],
        orElse: () => Page.empty(),
      );

      if (!existingPage.isEmpty) {
        currentPages.remove(existingPage);
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
        existingPage.groups.add(newGroup);
      } else {
        var index = existingPage.groups.indexOf(existingGroup);
        existingPage.groups[index] = newGroup;
      }
      existingPage.notifyGroupsUpdated();
    }
  }

  void _onRemoveGroup(groups) async {
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

      if (!existingGroup.isEmpty) {
        existingPage.groups.remove(existingGroup);
      }

      existingPage.notifyGroupsUpdated();
    }
  }

  void _onAddOrUpdatePanel(panels) async {
    for (var panel in panels!) {
      Group existingGroup = _getExistingGroup(panel);

      if (existingGroup.isEmpty) {
        continue;
      }

      var existingPanel = existingGroup.panels.firstWhere(
        (element) => element.id == panel["id"],
        orElse: () => Panel.empty(),
      );

      var newPanel = Panel.fromJson(panel);
      if (existingPanel.isEmpty) {
        existingGroup.panels.add(newPanel);
      } else {
        var index = existingGroup.panels.indexOf(existingPanel);
        existingGroup.panels[index] = newPanel;
      }
      existingGroup.notifyPanelsUpdated();
    }
  }

  void _onRemovePanel(panels) async {
    for (var panel in panels!) {
      Group existingGroup = _getExistingGroup(panel);

      if (existingGroup.isEmpty) {
        continue;
      }

      var existingPanel = existingGroup.panels.firstWhere(
        (element) => element.id == panel["id"],
        orElse: () => Panel.empty(),
      );

      if (!existingPanel.isEmpty) {
        existingGroup.panels.remove(existingPanel);
      }

      existingGroup.notifyPanelsUpdated();
    }
  }

  Group _getExistingGroup(panel) {
    Group existingGroup = Group.empty();

    for (var page in currentPages) {
      existingGroup = page.groups.firstWhere(
        (element) => element.id == panel["groupId"],
        orElse: () => Group.empty(),
      );
      if (!existingGroup.isEmpty) {
        break;
      }
    }
    return existingGroup;
  }

  void _onUpdatePanelData(panelDatas) async {
    var existingPanel = Panel.empty();
    for (var panelData in panelDatas!) {
      for (var page in currentPages) {
        for (var group in page.groups) {
          var existingPanel = group.panels.firstWhere(
            (element) => element.id == panelData["panelId"],
            orElse: () => Panel.empty(),
          );
          if (!existingPanel.isEmpty) {
            var controlName = panelData["controlName"];
            var values = panelData["values"] as List;
            for (var value in values) {
              var symbolicName = controlName + "." + value["symbolicName"];
              var parameterValue = value["value"];

              log('UpdatePanelData: $symbolicName => $parameterValue');

              var configValue = existingPanel.configValues.firstWhere(
                (element) => element.symbolicName == symbolicName,
                orElse: () {
                  var result = ViewConfigValue(symbolicName: symbolicName, defaultValue: parameterValue);
                  existingPanel.configValues.add(result);
                  return result;
                },
              );

              configValue.value = parameterValue;
            }
            break;
          }
        }
        if (!existingPanel.isEmpty) {
          break;
        }
      }
      if (!existingPanel.isEmpty) {
        break;
      }
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      var jsonResponse = await http.get(
        _serverUri!.replace(path: checkTokenUrl),
        headers: _defaultHeader,
      );

      var result = _handleResponse(jsonResponse, (r) => CheckTokenResponse.fromJson(r));
      currentIsAuthenticated = _checkResponse(result);
      streamIsAuthenticatedController.add(currentIsAuthenticated);
      return currentIsAuthenticated;
    } on Exception catch (e) {
      log('Exception: $e', error: e);
      return false;
    }
  }

  Future<DateTime> submitCode(int code) async {
    var response = await http.post(_serverUri!.replace(path: submitCodeUrl), headers: _defaultHeader, body: json.encode(SubmitCodeRequest(code)));

    var submitCodeResponse = SubmitCodeResponse.fromJson(json.decode(response.body));

    var dateTime = DateTime.parse(submitCodeResponse.validUntil);
    Settings.setValue("server_code", code);
    return dateTime;
  }

  Future confirmClient(Client client) async {
    try {
      var jsonResponse = await http.post(
        _serverUri!.replace(path: confirmClientUrl),
        headers: _defaultHeader,
        body: json.encode(ConfirmClientRequest(client)),
      );

      var result = _handleResponse(jsonResponse, (r) => ConfirmClientResponse.fromJson(r));
      _checkResponse(result);
    } on Exception catch (e) {
      log('never reached$e', error: e);
    }
  }

  Future removeClient(Client client) async {
    try {
      var jsonResponse = await http.post(
        _serverUri!.replace(path: removeClientUrl),
        headers: _defaultHeader,
        body: json.encode(RemoveClientRequest(client)),
      );

      var result = _handleResponse(jsonResponse, (r) => RemoveClientResponse.fromJson(r));
      _checkResponse(result);
    } on Exception catch (e) {
      log('never reached$e', error: e);
    }
  }

  Future<List<Plugin>> getAvailableControls() async {
    try {
      if (currentPlugins.isEmpty) {
        var jsonResponse = await http.get(
          _serverUri!.replace(path: getControlsUrl),
          headers: _defaultHeader,
        );

        var jsonData = AvailableControlsResponse.fromJson(json.decode(jsonResponse.body));
        // currentPlugins = List.castFrom(jsonData).map((jsonPlugin) => Plugin.fromJson(jsonPlugin)).toList();
        currentPlugins = jsonData.plugins;
      }
      return currentPlugins;
    } on Exception catch (e) {
      log('never reached$e', error: e);
    }

    return List.empty(growable: true);
  }

  Future<String?> executeControl(Control control, List<ViewConfigValue> configValues) async {
    try {
      // notificationProvider.addSnackBarNotification(Notification(
      //   text: "Execute " + control.symbolicName,
      // ));

      var jsonResponse = await http.post(
        _serverUri!.replace(path: executeControlUrl),
        headers: _defaultHeader,
        body: json.encode(ExecuteRequest(control.symbolicName, configValues)),
      );

      var result = _handleResponse(jsonResponse, (r) => ExecuteResponse.fromJson(r));

      if (result != null && result.status == ResponseStatus.ok) {
        notificationProvider.addSnackBarNotification(
          Notification(
            text: result.result,
            notificationType: NotificationType.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      if (_checkResponse(result)) {
        return result?.result;
      }
    } on Exception catch (e) {
      log('never reached$e', error: e);
    }

    return null;
  }

  Future addPage(Page page) async {
    var jsonResponse = await http.post(
      _serverUri!.replace(path: addPageUrl),
      headers: _defaultHeader,
      body: json.encode(AddPageRequest(page)),
    );

    var result = _handleResponse(jsonResponse, (r) => AddPageResponse.fromJson(r));
    _checkResponse(result);
  }

  Future editPage(Page page) async {
    var jsonResponse = await http.post(
      _serverUri!.replace(path: editPageUrl),
      headers: _defaultHeader,
      body: json.encode(EditPageRequest(page)),
    );

    var result = _handleResponse(jsonResponse, (r) => EditPageResponse.fromJson(r));
    _checkResponse(result);
  }

  Future removePage(Page page) async {
    try {
      var jsonResponse = await http.post(
        _serverUri!.replace(path: removePageUrl),
        headers: _defaultHeader,
        body: json.encode(RemovePageRequest(page.id)),
      );
      var result = _handleResponse(jsonResponse, (r) => RemovePageResponse.fromJson(r));
      _checkResponse(result);
    } on Exception catch (e) {
      log('never reached$e', error: e);
    }
  }

  Future addGroup(Group group) async {
    var jsonResponse = await http.post(
      _serverUri!.replace(path: addGroupUrl),
      headers: _defaultHeader,
      body: json.encode(AddGroupRequest(group)),
    );

    var result = _handleResponse(jsonResponse, (r) => AddGroupResponse.fromJson(r));
    _checkResponse(result);
  }

  Future editGroup(Group group) async {
    var jsonResponse = await http.post(
      _serverUri!.replace(path: editGroupUrl),
      headers: _defaultHeader,
      body: json.encode(EditGroupRequest(group)),
    );

    var result = _handleResponse(jsonResponse, (r) => EditGroupResponse.fromJson(r));
    _checkResponse(result);
  }

  Future removeGroup(Group group) async {
    try {
      var jsonResponse = await http.post(
        _serverUri!.replace(path: removeGroupUrl),
        headers: _defaultHeader,
        body: json.encode(RemoveGroupRequest(group.id)),
      );
      var result = _handleResponse(jsonResponse, (r) => RemoveGroupResponse.fromJson(r));
      _checkResponse(result);
    } on Exception catch (e) {
      log('never reached$e', error: e);
    }
  }

  Future addPanel(Panel panel) async {
    var jsonResponse = await http.post(
      _serverUri!.replace(path: addPanelUrl),
      headers: _defaultHeader,
      body: json.encode(AddPanelRequest(panel)),
    );

    var result = _handleResponse(jsonResponse, (r) => AddPanelResponse.fromJson(r));
    _checkResponse(result);
  }

  Future editPanel(Panel panel) async {
    var jsonResponse = await http.post(
      _serverUri!.replace(path: editPanelUrl),
      headers: _defaultHeader,
      body: json.encode(EditPanelRequest(panel)),
    );

    var result = _handleResponse(jsonResponse, (r) => EditPanelResponse.fromJson(r));
    _checkResponse(result);
  }

  Future removePanel(Panel panel) async {
    try {
      var jsonResponse = await http.post(
        _serverUri!.replace(path: removePanelUrl),
        headers: _defaultHeader,
        body: json.encode(RemovePanelRequest(panel.id)),
      );
      var result = _handleResponse(jsonResponse, (r) => RemovePanelResponse.fromJson(r));
      _checkResponse(result);
    } on Exception catch (e) {
      log('never reached$e', error: e);
    }
  }

  T? _handleResponse<T extends Response>(http.Response response, T Function(Map<String, dynamic>) create) {
    if (response.statusCode == 200) {
      var result = create(jsonDecode(response.body));

      if (result.status != ResponseStatus.ok) {
        // TODO Handle Error

        notificationProvider.addSnackBarNotification(Notification(
          text: result.error!,
          notificationType: NotificationType.error,
        ));
      }
      return result;
    } else if (currentContext != null) {
      notificationProvider.addSnackBarNotification(Notification(
        text: AppLocalizations.of(currentContext!)!.error_network_unexpectedresponse(response.statusCode, response.reasonPhrase ?? AppLocalizations.of(currentContext!)!.error_unexpected),
        notificationType: NotificationType.error,
        duration: const Duration(seconds: 4),
      ));
    }

    return null;
  }

  bool _checkResponse(Response? response) {
    if (response != null && response.status == ResponseStatus.ok) {
      return true;
    }

    // TODO Error Notification
    return false;
  }
}
