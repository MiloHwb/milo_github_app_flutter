import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:milo_github_app_flutter/common/style/milo_style.dart';

///通用下拉上刷控件
class MiloPullLoadWidget extends StatefulWidget {
  ///控制器，比如数据和一些配置
  final MiloPullLoadWidgetControl control;

  ///item渲染
  final IndexedWidgetBuilder itemBuilder;

  ///加载更多回调
  final RefreshCallback onLoadMore;

  ///下拉刷新回调
  final RefreshCallback onRefresh;

  final Key refreshKey;

  MiloPullLoadWidget(this.control, this.itemBuilder, this.onLoadMore, this.onRefresh,
      {this.refreshKey});

  @override
  _MiloPullLoadWidgetState createState() => _MiloPullLoadWidgetState();
}

class _MiloPullLoadWidgetState extends State<MiloPullLoadWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.control.needLoadMore.addListener(() {
      //延迟两秒等待确认
      try {
        Future.delayed(Duration(seconds: 2), () {
          // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
          _scrollController.notifyListeners();
        });
      } catch (e) {
        print(e);
      }
    });

    //增加滑动监听
    _scrollController.addListener(() {
      //判断当前滑动位置是不是达到底部，触发加载更多回调
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (widget.control.needLoadMore.value) {
          widget.onLoadMore?.call();
        }
      }
    });
  }

  ///根据配置状态返回实际列表数量
  ///实际上这里可以根据你的需要做更多的处理
  ///比如多个头部，是否需要空页面，是否需要显示加载更多
  int _getListCount() {
    //是否需要头部
    if (widget.control.needHeader) {
      //如果需要头部，用item 0 的widget作为listview的头部
      //列表数量大于0时，因为头部和底部加载更多选项，需要对列表总数量+2
      return widget.control.dataList.length > 0
          ? widget.control.dataList.length + 2
          : widget.control.dataList.length + 1;
    } else {
      //如果不需要头部，在没有数据时，固定返回数量1用于空页面呈现
      if (widget.control.dataList.length == 0) {
        return 1;
      }
      //如果有数据，因为有加载更多选项，需要对列表数据总数+1
      return widget.control.dataList.length > 0
          ? widget.control.dataList.length + 1
          : widget.control.dataList.length;
    }
  }

  //根据配置状态返回实际列表渲染item
  Widget _getItem(int index) {
    if (!widget.control.needHeader &&
        index == widget.control.dataList.length &&
        widget.control.dataList.length != 0) {
      //如果不需要头部，并且index等于数据长度时，渲染加载更多Item（因为index是从0开始）
      return _buildProgressIndicator();
    } else if (widget.control.needHeader &&
        index == _getListCount() - 1 &&
        widget.control.dataList.length != 0) {
      //如果需要头部，并且数据不为0时，当index等于实际渲染长度-1，渲染加载更多item
      return _buildProgressIndicator();
    } else if (!widget.control.needHeader && widget.control.dataList.length == 0) {
      //如果不需要头部，并且数据为0，渲染空页面
      return _buildEmpty();
    } else {
      //回调外部正常渲染item，如果这里有需要，可以直接返回相对位置的index
      return widget.itemBuilder(context, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      //GlobalKey，用于外部获取RefreshIndicator的State，做显示刷新
      key: widget.refreshKey,
      //下拉刷新触发，返回的是一个Future
      onRefresh: widget.onRefresh,

      child: ListView.builder(
        //保持ListView在任何情况都能滚动，解决在RefreshIndicator的兼容问题
        physics: const AlwaysScrollableScrollPhysics(),
        //根据状态返回子控件
        itemBuilder: (context, index) {
          return _getItem(index);
        },
        //根据状态返回数量
        itemCount: _getListCount(),
        //滑动监听
        controller: _scrollController,
      ),
    );
  }

  ///空页面
  Widget _buildEmpty() {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: null,
              child: Image(
                image: AssetImage(MILOIcons.DEFAULT_USER_ICON),
                width: 70,
                height: 70,
              )),
          Container(
            child: Text(
              '目前什么也没有哟',
              style: MiloConstant.normalText,
            ),
          )
        ],
      ),
    );
  }

  //上拉加载更多
  Widget _buildProgressIndicator() {
    Widget bottomWidget = (widget.control.needLoadMore.value)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //loading框
              SpinKitRotatingCircle(
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '正在加载更多',
                style: TextStyle(
                  color: Color(0xFF121917),
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        //不需要加载
        : Container();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: bottomWidget,
      ),
    );
  }
}

class MiloPullLoadWidgetControl {
  //数据，对齐增减，不能替换
  List dataList = [];

  //是否需要加载更多
  ValueNotifier<bool> needLoadMore = ValueNotifier(false);

  //是否需要头部
  bool needHeader = false;
}
