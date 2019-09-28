import 'package:flutter/material.dart';
import 'package:milo_github_app_flutter/page/home_page.dart';
import 'package:milo_github_app_flutter/page/login_page.dart';

class NavigatorUtils {
  ///替换
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  ///切换到无参页面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  ///主页
  static goHome(BuildContext context) {
    pushReplacementNamed(context, HomePage.sName);
  }

  ///登录页
  static goLogin(BuildContext context) {
    pushReplacementNamed(context, LoginPage.sName);
  }

  ///Page页面的容易，做一次通用自定义
  static Widget pageContainer(Widget widget) {
    return MediaQuery(
      //不受系统字体缩放影响
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1),
      child: widget,
    );
  }
}
