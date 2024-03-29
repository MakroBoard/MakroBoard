import 'package:flutter/material.dart';

import 'page_configuration.dart';
import 'pages.dart';

class AppRouteParser extends RouteInformationParser<PageConfiguration> {
  PageConfiguration parseUri(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      return splashPageConfig;
    }

    final path = uri.pathSegments[0];

    if (uri.pathSegments.length == 1) {
      switch (path) {
        case splashPath:
          return splashPageConfig;
        case homePath:
          return homePageConfig;
        case loginPath:
          return loginPageConfig;
        case selectServerPath:
          return selectServerPageConfig;
        case configPath:
          return configPageConfig;
        case settingsPath:
          return settingsPageConfig;
        default:
          return notFoundPageConfig;
      }
    } else if (uri.pathSegments.length == 2) {
      switch (path) {
        case pagePath:
          // TODO Load Page from Id
          // return pagePageConfig(int.parse(uri.pathSegments[1]));
          break;
      }
    }

    return notFoundPageConfig;
  }

  @override
  Future<PageConfiguration> parseRouteInformation(RouteInformation routeInformation) async {
    return parseUri(routeInformation.uri);
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.splash:
        return RouteInformation(uri: Uri.parse("/$splashPath"));
      case Pages.home:
        return RouteInformation(uri: Uri.parse("/"));
      case Pages.login:
        return RouteInformation(uri: Uri.parse("/$loginPath"));
      case Pages.selectserver:
        return RouteInformation(uri: Uri.parse("/$selectServerPath"));
      case Pages.config:
        return RouteInformation(uri: Uri.parse("/$configPath"));
      case Pages.settings:
        return RouteInformation(uri: Uri.parse("/$settingsPath"));
      case Pages.page:
        return RouteInformation(uri: Uri.parse("/$pagePath/${(configuration as PagePageConfiguration).page.id}"));
      default:
        return RouteInformation(uri: Uri.parse("/$notFoundPath"));
    }
  }
}
