import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

enum StatusStyle {
  LIGHT_CONTENT,
  DARK_CONTENT,
}

// 可自定义样式的沉浸式导航栏
class HiNavigationBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    _statusBarInit();
    // 状态栏高度
    var top = MediaQuery.of(context).padding.top;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + height,
      child: child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: color),
    );
  }

  void _statusBarInit() async {
    // 沉浸式状态栏样式
    // await FlutterStatusbarcolor.setNavigationBarColor(
    //     statusStyle == StatusStyle.DARK_CONTENT ? Colors.black54 : Colors.white,
    //     animate: false);
    await FlutterStatusbarcolor.setStatusBarColor(
        statusStyle == StatusStyle.DARK_CONTENT ? Colors.black54 : Colors.white,
        animate: false);
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(
        statusStyle == StatusStyle.DARK_CONTENT);
  }
}
