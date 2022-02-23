import 'package:flutter/material.dart';
import 'package:untitled/model/video_model.dart';
import 'package:untitled/navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Column(
        children: [
          Text('首页'),
          MaterialButton(
            onPressed: () {
              HiNavigator.getInstance().onJumpTo(
                RouteStatus.detail,
                args: {'videoMo': VideoModel(1001)},
              );
            },
            child: Text('详情'),
          )
        ],
      )),
    );
  }
}
