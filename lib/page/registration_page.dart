import 'package:flutter/material.dart';
import 'package:untitled/http/dao/login_dao.dart';
import 'package:untitled/navigator/hi_navigator.dart';
import 'package:untitled/util/string_util.dart';
import 'package:untitled/util/toast.dart';
import 'package:untitled/widget/appbar.dart';
import 'package:untitled/widget/login_button.dart';
import 'package:untitled/widget/login_effect.dart';
import 'package:untitled/widget/login_input.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  String? userName;
  String? password;
  String? rePassword;
  String? imoocId;
  String? orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        "注册",
        "登录",
        () {
          HiNavigator.getInstance().onJumpTo(RouteStatus.login);
        },
      ),
      body: Container(
        child: ListView(children: <Widget>[
          LoginEffect(
            protect: protect,
          ),
          // 自适应键盘弹起，防止遮挡
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
          LoginInput(
            title: '确认密码',
            hint: '请再次输入密码',
            lineStretch: true,
            obscureText: true,
            onChanged: (text) {
              setState(() {
                rePassword = text;
              });
              checkInput();
            },
            focusChanged: (focus) {
              setState(() {
                protect = focus;
              });
            },
          ),
          LoginInput(
            title: '慕课网ID',
            hint: '请输入慕课网ID',
            keyboardType: TextInputType.number,
            lineStretch: true,
            obscureText: false,
            onChanged: (text) {
              setState(() {
                imoocId = text;
              });
              checkInput();
            },
          ),
          LoginInput(
            title: '课程订单号',
            hint: '请输入课程订单号后四位',
            keyboardType: TextInputType.number,
            lineStretch: true,
            obscureText: false,
            onChanged: (text) {
              setState(() {
                orderId = text;
              });
              checkInput();
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: _loginButton(),
          ),
        ]),
      ),
    );
  }

  void checkInput() {
    bool enable;

    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId)) {
      enable = true;
    } else {
      enable = false;
    }

    setState(() {
      loginEnable = enable;
    });
  }

  _loginButton() {
    return LoginButton(
      title: '注册',
      onPressed: () {
        if (loginEnable) {
          checkParams();
        } else {
          print('loginEnable is false');
        }
      },
    );
  }

  void send() async {
    try {
      var res =
          await LoginDao.registration(userName!, password!, imoocId!, orderId!);

      if (res['code'] == 0) {
        print('注册成功');
        showToast('注册成功');

        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      } else {
        print(res['msg']);
        showWarnToast(res['msg']);
      }
    } catch (e) {
      print(e);
    }
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = '两次密码不一致';
    } else if (orderId?.length != 4) {
      tips = '请输入订单号的后四位';
    }

    if (tips != null) {
      print(tips);
      showWarnToast(tips);

      return;
    }

    send();
  }
}
