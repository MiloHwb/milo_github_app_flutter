import 'package:flutter/material.dart';

class MiloTitleBar extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onPressed;
  final bool needRightLocalIcon;
  final Widget rightWidget;

  MiloTitleBar(this.title,
      {this.iconData, this.onPressed, this.needRightLocalIcon = false, this.rightWidget});

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (rightWidget == null) {
      //是否添加title的右侧按钮
      widget = (needRightLocalIcon)
          ? IconButton(
              icon: Icon(
                iconData,
                size: 19,
              ),
              onPressed: onPressed,
            )
          : Container();
    }

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          widget,
        ],
      ),
    );
  }
}
