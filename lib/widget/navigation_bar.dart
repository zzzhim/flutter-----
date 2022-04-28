import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:untitled/util/view_util.dart';

enum StatusStyle {
  LIGHT_CONTENT,
  DARK_CONTENT,
}

class HiNavigationBar extends StatefulWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget child;

  const HiNavigationBar({
    Key? key,
    this.statusStyle = StatusStyle.DARK_CONTENT,
    this.color = Colors.white,
    this.height = 46,
    required this.child,
  }) : super(key: key);

  @override
  _HiNavigationBar createState() => _HiNavigationBar();
}

// 可自定义样式的沉浸式导航栏
class _HiNavigationBar extends State<HiNavigationBar> {
  @override
  Widget build(BuildContext context) {
    _statusBarInit();
    // 状态栏高度
    var top = MediaQuery.of(context).padding.top;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + widget.height,
      child: widget.child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: widget.color),
    );
  }

  void _statusBarInit() async {
    // 沉浸式状态栏样式
    changeStatusBar(color: widget.color, statusStyle: widget.statusStyle);
  }
}
