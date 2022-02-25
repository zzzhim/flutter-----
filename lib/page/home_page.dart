import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'package:untitled/model/video_model.dart';
import 'package:untitled/navigator/hi_navigator.dart';
import 'package:untitled/page/home_tab_page.dart';
import 'package:untitled/util/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;
  TabController? _controller;
  var tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片·手书·配音"];

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: tabs.length, vsync: this);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: _tabBar(),
          ),
          Flexible(
            child: TabBarView(
              controller: _controller,
              children: tabs.map((tab) {
                return HomeTabPage(name: tab);
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
      tabs: tabs.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(tab),
          ),
        );
      }).toList(),
    );
  }
}
