import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'package:untitled/util/color.dart';

class HiTab extends StatefulWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final double? fontSize;
  final double? borderWidth;
  final double? insets;
  final Color? unselectedLabelColor;

  const HiTab(
    this.tabs, {
    Key? key,
    this.controller,
    this.fontSize,
    this.borderWidth,
    this.insets,
    this.unselectedLabelColor = Colors.grey,
  }) : super(key: key);

  @override
  State<HiTab> createState() => _HiTabState();
}

class _HiTabState extends State<HiTab> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.controller,
      isScrollable: true,
      labelColor: primary,
      unselectedLabelColor: widget.unselectedLabelColor,
      labelStyle: TextStyle(fontSize: widget.fontSize),
      indicator: UnderlineIndicator(
        strokeCap: StrokeCap.round,
        borderSide: BorderSide(color: primary, width: widget.borderWidth ?? 0),
        insets: EdgeInsets.only(
          left: widget.insets ?? 0,
          right: widget.insets ?? 0,
        ),
      ),
      tabs: widget.tabs,
    );
    ;
  }
}
