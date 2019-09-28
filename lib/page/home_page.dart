import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:milo_github_app_flutter/common/style/milo_style.dart';
import 'package:milo_github_app_flutter/widget/milo_tabbar_widget.dart';

import 'dynamic_page.dart';
import 'my_page.dart';
import 'trend_page.dart';

/// 主页
class HomePage extends StatelessWidget {
  static final String sName = 'home';

  Future<bool> _dialogExitApp() {
    //如果是Android，就回到桌面
    if (Platform.isAndroid) {
      var androidIntent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: "android.intent.category.HOME",
      );
      androidIntent.launch();
    }
    return Future.value(false);
  }

  Widget _renderTab(icon, text) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 16),
          Text(text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = <Widget>[
      _renderTab(MILOIcons.MAIN_DT, '动态'),
      _renderTab(MILOIcons.MAIN_QS, '趋势'),
      _renderTab(MILOIcons.MAIN_MY, '我的'),
    ];

    return WillPopScope(
      onWillPop: _dialogExitApp,
      child: MiloTabBarWidget(
        drawer: null,
        type: MiloTabBarWidget.BOTTOM_TAB,
        tabItems: tabs,
        tabViews: <Widget>[
          DynamicPage(),
          TrendPage(),
          MyPage(),
        ],
        backgroundColor: MILOColors.primarySwatch,
        indicatorColor: Color(MILOColors.white),
      ),
    );
  }
}
