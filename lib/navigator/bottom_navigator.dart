import 'package:flutter/material.dart';
import 'package:untitled/navigator/hi_navigator.dart';
import 'package:untitled/page/favorite_page.dart';
import 'package:untitled/page/home_page.dart';
import 'package:untitled/page/profile_page.dart';
import 'package:untitled/page/ranking_page.dart';
import 'package:untitled/util/color.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  static int _initialPage = 0;

  final _defaultColor = Colors.grey;
  final _acticveColor = primary;
  int _currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);
  List<Widget>? _pages;
  bool _hasBuild = false;

  @override
  Widget build(BuildContext context) {
    _pages = [
      HomePage(
        onJumpTo: (index) => _onJumpTo(index, pageChange: false),
      ),
      RankPage(),
      FavoritePage(),
      ProfilePage(),
    ];

    if (!_hasBuild) {
      // 页面第一次打开时通知打开的是哪个tab
      HiNavigator.getInstance()
          .onBottomTabChange(_initialPage, _pages![_initialPage]);
      _hasBuild = true;
    }

    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages!,
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
        // 禁止滚动
        // physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onJumpTo(index),
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('排行榜', Icons.local_fire_department, 1),
          _bottomItem('收藏', Icons.favorite, 2),
          _bottomItem('我的', Icons.live_tv, 3),
        ],
        selectedItemColor: _acticveColor,
      ),
    );
  }

  _bottomItem(String label, IconData icon, int i) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _defaultColor,
      ),
      label: label,
      activeIcon: Icon(
        icon,
        color: _acticveColor,
      ),
    );
  }

  void _onJumpTo(int index, {bool pageChange = false}) {
    if (!pageChange) {
      _controller.jumpToPage(index);
    } else {
      HiNavigator.getInstance().onBottomTabChange(index, _pages![index]);
    }

    setState(() {
      // 切换到对应的tap
      _currentIndex = index;
    });
  }
}
