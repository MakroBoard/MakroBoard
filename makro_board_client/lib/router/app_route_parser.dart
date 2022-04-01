import 'package:flutter/material.dart';

import 'page_configuration.dart';
import 'pages.dart';

class AppRouteParser extends RouteInformationParser<PageConfiguration> {
  PageConfiguration parseUrl(String url) {
    final uri = Uri.parse(url);
    return parseUri(uri);
  }

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
    return parseUrl(routeInformation.location!);
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.splash:
        return const RouteInformation(location: "/" + splashPath);
      case Pages.home:
        return const RouteInformation(location: "/");
      case Pages.login:
        return const RouteInformation(location: "/" + loginPath);
      case Pages.selectserver:
        return const RouteInformation(location: "/" + selectServerPath);
      case Pages.config:
        return const RouteInformation(location: "/" + configPath);
      case Pages.settings:
        return const RouteInformation(location: "/" + settingsPath);
      case Pages.page:
        return RouteInformation(location: "/" + pagePath + "/" + (configuration as PagePageConfiguration).page.id.toString());
      default:
        return const RouteInformation(location: "/" + notFoundPath);
    }
  }
}
