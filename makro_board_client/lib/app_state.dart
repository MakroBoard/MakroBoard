import 'package:flutter/material.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/router/page_action.dart';
import 'package:makro_board_client/router/page_configuration.dart';
import 'package:makro_board_client/router/page_state.dart';
import 'package:makro_board_client/router/pages.dart';
import 'package:provider/provider.dart';

class AppState extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool _splashFinished = false;
  bool get splashFinished => _splashFinished;

  PageConfiguration? _initialConfig;
  set initialConfig(PageConfiguration initialConfig) {
    _initialConfig = initialConfig;
  }

  Pages? _currentPage;
  Pages? get currentPage => _currentPage;

  PageAction _currentAction = PageAction();
  PageAction get currentAction => _currentAction;
  set currentAction(PageAction action) {
    _currentAction = action;
    notifyListeners();
  }

  init(BuildContext context) {
    Provider.of<ApiProvider>(context, listen: false).isAuthenticatedStream.listen((isAuthenticated) {
      if (_isAuthenticated != isAuthenticated) {
        _isAuthenticated = isAuthenticated;
        if (!isAuthenticated) {
          navigateTo(PageAction(state: PageState.replaceAll, page: loginPageConfig));
        }
      }
    });
  }

  void resetCurrentAction() {
    _currentPage = _currentAction.page?.uiPage;
    _currentAction = PageAction();
  }

  void setSplashFinished(PageConfiguration config) {
    _splashFinished = true;

    if (_initialConfig == splashPageConfig || _initialConfig == null) {
      _initialConfig = config;
    }

    _currentAction = PageAction(state: PageState.replaceAll, page: _initialConfig);
    notifyListeners();
  }

  void navigateTo(PageAction action) {
    _currentAction = action;
    notifyListeners();
  }

  void navigateToDetails(Widget widget, PageConfiguration pageConfig) {
    _currentAction = PageAction(state: PageState.addWidget, page: pageConfig, widget: widget);
    notifyListeners();
  }
}
