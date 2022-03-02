import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'package:untitled/core/hi_state.dart';
import 'package:untitled/http/dao/home_dao.dart';
import 'package:untitled/model/home_mo.dart';
import 'package:untitled/navigator/hi_navigator.dart';
import 'package:untitled/page/home_tab_page.dart';
import 'package:untitled/util/color.dart';
import 'package:untitled/util/toast.dart';
import 'package:untitled/widget/navigation_bar.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;

  const HomePage({
    Key? key,
    this.onJumpTo,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;
  TabController? _controller;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: categoryList.length, vsync: this);

    this.listener = (current, pre) {
      print('current:${current?.page}');
      print('pre:${pre?.page}');

      if (widget == current.page || current.page is HomePage) {
        print('打开了首页, onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页: onPause');
      }
    };

    HiNavigator.getInstance().addListener(this.listener);

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build;

    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: [
          HiNavigationBar(
            height: 50,
            child: _appBar(),
            color: Colors.white,
            statusStyle: StatusStyle.LIGHT_CONTENT,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: _tabBar(),
          ),
          Flexible(
            child: TabBarView(
              controller: _controller,
              children: categoryList.map((tab) {
                return HomeTabPage(
                  categoryName: tab.name ?? "",
                  bannerList: tab.name == "推荐" ? bannerList : null,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    _controller?.dispose();

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return TabBar(
      controller: _controller,
      isScrollable: true,
      labelColor: Colors.black,
      indicator: UnderlineIndicator(
        strokeCap: StrokeCap.round,
        borderSide: BorderSide(color: primary, width: 3),
        insets: EdgeInsets.only(left: 15, right: 15),
      ),
      tabs: categoryList.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(tab.name ?? ""),
          ),
        );
      }).toList(),
    );
  }

  void _loadData() async {
    try {
      HomeMo result = await HomeDao.get('推荐');

      print('loadData():${jsonEncode(result)}');

      if (result.categoryList != null) {
        // tab长度变化后需要重新创建TabController
        _controller =
            TabController(length: result.categoryList!.length, vsync: this);

        setState(() {
          categoryList = result.categoryList ?? [];
          bannerList = result.bannerList ?? [];
        });
      }
    } catch (e) {
      print(jsonEncode(e));
      // showWarnToast(e?.m);
    }
  }

  _appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Image(
                width: 46,
                height: 46,
                image: AssetImage('images/avatar.png'),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 32,
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  decoration: BoxDecoration(color: Colors.grey[100]),
                ),
              ),
            ),
          ),
          Icon(
            Icons.explore_outlined,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
