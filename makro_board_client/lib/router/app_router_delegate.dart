import 'package:beamer/beamer.dart' as beamer;
import 'package:flutter/material.dart';
import 'package:makro_board_client/pages/config_page.dart';
import 'package:makro_board_client/pages/homePage.dart';
import 'package:makro_board_client/pages/login_page.dart';
import 'package:makro_board_client/pages/not_found_page.dart';
import 'package:makro_board_client/pages/pagePage.dart';
import 'package:makro_board_client/pages/select_server_page.dart';
import 'package:makro_board_client/pages/settings_page.dart';
import 'package:makro_board_client/pages/splash_screen.dart';

import '../app_state.dart';
import 'page_action.dart';
import 'page_configuration.dart';
import 'page_state.dart';
import 'pages.dart';

class AppRouterDelegate extends RouterDelegate<PageConfiguration> with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  final List<Page> _pages = [];

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppState appState;

  AppRouterDelegate(this.appState) : navigatorKey = GlobalKey() {
    appState.addListener(notifyListeners);
  }

  /// Getter for a list that cannot be changed
  List<MaterialPage> get pages => List.unmodifiable(_pages);

  /// Number of pages function
  int numPages() => _pages.length;

  @override
  PageConfiguration? get currentConfiguration => appState.currentAction.page;

  void addPage(PageConfiguration? pageConfig) {
    final shouldAddPage = _pages.isEmpty || (_pages.last.arguments as PageConfiguration).uiPage != pageConfig?.uiPage;

    if (shouldAddPage) {
      switch (pageConfig?.uiPage) {
        case Pages.splash:
          _addPageData(const SplashScreen(), splashPageConfig);
          break;
        case Pages.home:
          _addPageData(const HomePage(), homePageConfig);
          break;
        case Pages.login:
          _addPageData(const LoginPage(), loginPageConfig);
          break;
        case Pages.selectserver:
          _addPageData(const SelectServerPage(), selectServerPageConfig);
          break;
        case Pages.config:
          _addPageData(const ConfigPage(), configPageConfig);
          break;
        case Pages.settings:
          _addPageData(const SettingsPage(), settingsPageConfig);
          break;
        case Pages.page:
          _addPageData(PagePage(initialPage: (pageConfig as PagePageConfiguration).page), pageConfig);
          break;
        case Pages.notfound:
          _addPageData(const NotFoundPage(), notFoundPageConfig);
          break;
        default:
          throw UnimplementedError("This uiPage is not implemented!");
      }
    }
  }

  void _setPageAction(PageAction action) {
    switch (action.page?.uiPage) {
      case Pages.splash:
        splashPageConfig.currentPageAction = action;
        break;
      case Pages.home:
        homePageConfig.currentPageAction = action;
        break;
      case Pages.login:
        loginPageConfig.currentPageAction = action;
        break;
      case Pages.selectserver:
        selectServerPageConfig.currentPageAction = action;
        break;
      case Pages.config:
        configPageConfig.currentPageAction = action;
        break;
      case Pages.settings:
        settingsPageConfig.currentPageAction = action;
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Navigator(
          transitionDelegate: const beamer.NoAnimationTransitionDelegate(),
          key: navigatorKey,
          onPopPage: _onPopPage,
          pages: buildPages(),
        ),
      ),
    );
  }

  bool _onPopPage(Route<dynamic> route, result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  void _removePage(Page? page) {
    if (page != null) {
      _pages.remove(page);
    }
  }

  void pop() {
    if (canPop()) {
      _removePage(_pages.last);
    }
  }

  bool canPop() {
    return _pages.length > 1;
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(_pages.last);
      return Future.value(true);
    }
    return Future.value(false);
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
      child: child,
      key: ValueKey(pageConfig.key),
      name: pageConfig.path,
      arguments: pageConfig,
    );
  }

  void _addPageData(Widget? child, PageConfiguration? pageConfig) {
    if (child != null && pageConfig != null) {
      _pages.add(
        _createPage(child, pageConfig),
      );
    }
  }

  void replace(PageConfiguration? newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

  void setPath(List<MaterialPage> path) {
    _pages.clear();
    _pages.addAll(path);
  }

  void replaceAll(PageConfiguration? newRoute) {
    setNewRoutePath(newRoute);
  }

  void push(PageConfiguration newRoute) {
    addPage(newRoute);
  }

  void pushWidget(Widget? child, PageConfiguration? newRoute) {
    _addPageData(child, newRoute);
  }

  void addAll(List<PageConfiguration>? routes) {
    _pages.clear();
    if (routes != null) {
      routes.forEach(addPage);
    }
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration? configuration) async {
    final shouldAddPage = _pages.isEmpty || (_pages.last.arguments as PageConfiguration).uiPage != configuration?.uiPage;
    if (shouldAddPage) {
      _pages.clear();
      addPage(configuration);
    }
  }

  List<Page> buildPages() {
    if (!appState.splashFinished) {
      replaceAll(splashPageConfig);
    } else {
      switch (appState.currentAction.state) {
        case PageState.none:
          break;
        case PageState.addPage:
          _setPageAction(appState.currentAction);
          addPage(appState.currentAction.page);
          break;
        case PageState.pop:
          pop();
          break;
        case PageState.replace:
          _setPageAction(appState.currentAction);
          replace(appState.currentAction.page);
          break;
        case PageState.replaceAll:
          _setPageAction(appState.currentAction);
          replaceAll(appState.currentAction.page);
          break;
        case PageState.addWidget:
          _setPageAction(appState.currentAction);
          pushWidget(appState.currentAction.widget, appState.currentAction.page);
          break;
        case PageState.addAll:
          addAll(appState.currentAction.pages);
          break;
      }
    }
    appState.resetCurrentAction();
    return List.of(_pages);
  }
}
