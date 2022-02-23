import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled/db/hi_cache.dart';
import 'package:untitled/http/core/hi_error.dart';
import 'package:untitled/http/core/hi_net.dart';
import 'package:untitled/http/core/mock_adpter.dart';
import 'package:untitled/http/dao/login_dao.dart';
import 'package:untitled/http/request/notice_request.dart';
import 'package:untitled/model/owner.dart';
import 'package:untitled/model/result.dart';
import 'package:untitled/model/video_model.dart';
import 'package:untitled/navigator/hi_navigator.dart';
import 'package:untitled/page/home_page.dart';
import 'package:untitled/page/login_page.dart';
import 'package:untitled/page/registration_page.dart';
import 'package:untitled/page/video_detail_page.dart';
import 'package:untitled/test_request.dart';
import 'package:untitled/util/color.dart';
import 'package:untitled/util/toast.dart';

void main() {
  runApp(BiliApp());
}

class BiliApp extends StatefulWidget {
  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
        future: HiCache.preInit(),
        builder: (
          BuildContext context,
          AsyncSnapshot<HiCache> asyncSnapshot,
        ) {
          // 定义route
          var widget = asyncSnapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _routeDelegate)
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
          return MaterialApp(
            theme: ThemeData(primaryColor: Colors.white),
            home: widget,
          );
        });
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState>? navigatorKey;

  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    // 实现路由跳转逻辑
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        this.videoModel = args!['videoMo'];
      }

      notifyListeners();
    }));
  }

  RouteStatus _routeStatus = RouteStatus.home;

  List<MaterialPage> pages = [];
  VideoModel? videoModel;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;

    if (index != -1) {
      // 要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      // tips 具体规则可以根据需要进行调整，这里要求栈中只允许有一个同样的页面的实例
      tempPages = tempPages.sublist(0, index);
    }

    var page;
    if (routeStatus == RouteStatus.home) {
      // 跳转首页时将栈中其他页面进行出栈，因为首页不可回退
      pages.clear();
      page = pageWrap(
        HomePage(),
      );
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(
        VideoDetailPage(
          videoModel: videoModel!,
        ),
      );
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    }

    // 重新创建一个数组，否则pages因引用没有改变路由不会生效
    tempPages = [...tempPages, page];
    pages = tempPages;

    return WillPopScope(
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, result) {
          if (route.settings is MaterialPage) {
            // 登录页未登录返回拦截
            if ((route.settings as MaterialPage).child is LoginPage) {
              if (!hasLogin) {
                showWarnToast("请先登录");
                return false;
              }
            }
          }

          // 在这里控制是否可以返回
          if (!route.didPop(result)) {
            return false;
          }

          // 出栈
          pages.removeLast();
          return true;
        },
      ),
      // 安卓物理返回键，无法返回上一页修复
      onWillPop: () async => !await navigatorKey!.currentState!.maybePop(),
    );
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath configuration) async {}

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    }

    return _routeStatus;
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;
}

class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = "/";

  BiliRoutePath.detail() : location = "/detail";
}
