import 'dart:async';

import 'package:flutter/material.dart';
import 'package:milo_github_app_flutter/common/utils/navigator_utils.dart';
import 'package:milo_github_app_flutter/page/home_page.dart';
import 'package:milo_github_app_flutter/page/login_page.dart';
import 'package:milo_github_app_flutter/page/welcome_page.dart';

void main() {
  runZoned(() {
    runApp(MyApp());
  }, onError: (Object obj, StackTrace stack) {
    print(obj);
    print(stack);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        WelcomePage.sName: (context) {
          return WelcomePage();
        },
        HomePage.sName: (context) {
          return NavigatorUtils.pageContainer(HomePage());
        },
        LoginPage.sName: (context) {
          return NavigatorUtils.pageContainer(LoginPage());
        },
      },
    );
  }
}
