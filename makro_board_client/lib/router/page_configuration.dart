import 'package:makro_board_client/router/pages.dart';

import 'package:makro_board_client/models/page.dart' as models;
import 'page_action.dart';

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;
  PageAction? currentPageAction;

  PageConfiguration({required this.key, required this.path, required this.uiPage, this.currentPageAction});
}

class PagePageConfiguration extends PageConfiguration {
  final models.Page page;
  PagePageConfiguration({required this.page})
      : super(
          key: 'Page',
          path: pagePath,
          uiPage: Pages.page,
          currentPageAction: null,
        );
}

PageConfiguration splashPageConfig = PageConfiguration(key: 'Splash', path: splashPath, uiPage: Pages.splash, currentPageAction: null);
PageConfiguration homePageConfig = PageConfiguration(key: 'Home', path: homePath, uiPage: Pages.home, currentPageAction: null);
PageConfiguration loginPageConfig = PageConfiguration(key: 'Login', path: loginPath, uiPage: Pages.login, currentPageAction: null);
PageConfiguration selectServerPageConfig = PageConfiguration(key: 'SelectServer', path: selectServerPath, uiPage: Pages.selectserver, currentPageAction: null);
PageConfiguration configPageConfig = PageConfiguration(key: 'Config', path: configPath, uiPage: Pages.config, currentPageAction: null);
PageConfiguration settingsPageConfig = PageConfiguration(key: 'Settings', path: settingsPath, uiPage: Pages.settings, currentPageAction: null);
PageConfiguration pagePageConfig(models.Page page) => PagePageConfiguration(page: page);
PageConfiguration notFoundPageConfig = PageConfiguration(key: '404', path: notFoundPath, uiPage: Pages.notfound, currentPageAction: null);
