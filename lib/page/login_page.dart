import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/db/hi_cache.dart';
import 'package:untitled/http/dao/login_dao.dart';
import 'package:untitled/navigator/hi_navigator.dart';
import 'package:untitled/util/string_util.dart';
import 'package:untitled/util/toast.dart';
import 'package:untitled/widget/appbar.dart';
import 'package:untitled/widget/login_button.dart';
import 'package:untitled/widget/login_effect.dart';
import 'package:untitled/widget/login_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  String? userName;
  String? password;

  @override
  Widget build(BuildContext context) {
    HiCache.preInit();

    return Scaffold(
      appBar: appBar('登录', '注册', () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),
      body: Container(
          child: ListView(
        children: [
          LoginEffect(
            protect: protect,
          ),
          LoginInput(
            title: '用户名',
            hint: '请输入用户名',
            lineStretch: true,
            onChanged: (text) {
              setState(() {
                userName = text;
              });
              checkInput();
            },
          ),
          LoginInput(
            title: '密码',
            hint: '请输入密码',
            lineStretch: true,
            obscureText: true,
            onChanged: (text) {
              setState(() {
                password = text;
              });
              checkInput();
            },
            focusChanged: (focus) {
              setState(() {
                protect = focus;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
            ),
            child: LoginButton(
              title: '登录',
              enable: loginEnable,
              onPressed: send,
            ),
          ),
        ],
      )),
    );
  }

  void checkInput() {
    bool enable;

    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }

    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    try {
      var res = await LoginDao.login(userName!, password!);

      if (res['code'] == 0) {
        print('登录成功');
        showToast('登录成功');

        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
      } else {
        print(res['msg']);
        showWarnToast(res['msg']);
      }
    } catch (e) {
      print(e);
    }
  }
}
