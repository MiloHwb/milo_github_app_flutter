import 'package:flutter/material.dart';

class MiloTabBarWidget extends StatefulWidget {
  //底部模式tab
  static const int BOTTOM_TAB = 0;

  //顶部模式tab
  static const int TOP_TAB = 1;

  final int type;
  final bool resizeToAvoidBottomPadding;
  final List<Widget> tabItems;
  final List<Widget> tabViews;
  final Color backgroundColor;
  final Color indicatorColor;
  final Widget title;
  final Widget drawer;
  final Widget floatActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final Widget bottomBar;
  final TarWidgetControl tarWidgetControl;
  final ValueChanged<int> onPageChanged;

  MiloTabBarWidget(
      {Key key,
      this.type,
      this.resizeToAvoidBottomPadding = true,
      this.tabItems,
      this.tabViews,
      this.backgroundColor,
      this.indicatorColor,
      this.title,
      this.drawer,
      this.floatActionButton,
      this.floatingActionButtonLocation,
      this.bottomBar,
      this.tarWidgetControl,
      this.onPageChanged})
      : super(key: key);

  @override
  _MiloTabBarState createState() => _MiloTabBarState();
}

class _MiloTabBarState extends State<MiloTabBarWidget> with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabViews.length, vsync: this);
    _pageController = PageController();
  }

  ///整个页面dispose时，记得要把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case MiloTabBarWidget.TOP_TAB:
        return Scaffold(
//          resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding, //此方法已经被废弃
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomPadding,
          floatingActionButton: SafeArea(child: widget.floatActionButton ?? Container()),
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          persistentFooterButtons:
              widget.tarWidgetControl == null ? null : widget.tarWidgetControl.footerButtons,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: widget.title,
            bottom: TabBar(
              controller: _tabController,
              tabs: widget.tabItems,
              indicatorColor: widget.indicatorColor,
              onTap: (index) {
                widget.onPageChanged?.call(index);

                //以下两种方式选一即可
                _pageController.jumpToPage(index);
//                _pageController.jumpTo(MediaQuery.of(context).size.width * index);
              },
            ),
          ),
          body: PageView(
            controller: _pageController,
            children: widget.tabViews,
            onPageChanged: (index) {
              _tabController.animateTo(index);
              widget.onPageChanged?.call(index);
            },
          ),
          bottomNavigationBar: widget.bottomBar,
        );
      case MiloTabBarWidget.BOTTOM_TAB:
        return Scaffold(
          drawer: widget.drawer,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: widget.title,
          ),
          body: PageView(
            controller: _pageController,
            children: widget.tabViews,
            onPageChanged: (index) {
              widget.onPageChanged?.call(index);
              _tabController.animateTo(index);
            },
          ),
          bottomNavigationBar: Material(
            //为了适配主题风格，包一层Material实现风格套用
            color: Theme.of(context).primaryColor, //底部状态栏使用主题颜色
            child: SafeArea(
              child: TabBar(
                //TabBar导航栏，底部导航放到Scaffold的bottomNavigationBar中
                controller: _tabController, //配置控制器
                tabs: widget.tabItems,
                indicatorColor: widget.indicatorColor,
                onTap: (index) {
                  widget.onPageChanged?.call(index);
                  _pageController.jumpToPage(index);
                },
              ),
            ),
          ),
        );
    }
  }
}

class TarWidgetControl {
  List<Widget> footerButtons = [];
}
