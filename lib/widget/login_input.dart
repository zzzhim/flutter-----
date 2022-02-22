// 登录输入框，自定义widget

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/util/color.dart';

class LoginInput extends StatefulWidget {
  final String? title;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? focusChanged;
  final bool lineStretch;
  final bool obscureText;
  final TextInputType? keyboardType;

  const LoginInput({
    Key? key,
    this.title,
    this.hint,
    this.onChanged,
    this.focusChanged,
    this.lineStretch = false,
    this.obscureText = false,
    this.keyboardType,
  }) : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 是否获取光标的监听
    _focusNode.addListener(() {
      print("Has Focus: ${_focusNode.hasFocus}");

      if (widget.focusChanged != null) {
        widget.focusChanged!(_focusNode.hasFocus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15),
              width: 100,
              child: Text(
                widget.title ?? "",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            _input(),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
          child: Divider(
            height: 1,
            thickness: 0.5,
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  _input() {
    return Expanded(
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        autofocus: !widget.obscureText,
        cursorColor: primary,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w300,
        ),
        // 输入框样式
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          border: InputBorder.none,
          hintText: widget.hint ?? "",
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ),
    );
  }
}
