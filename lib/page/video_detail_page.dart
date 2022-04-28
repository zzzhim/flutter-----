import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/model/home_mo.dart';
import 'package:untitled/navigator/hi_navigator.dart';
import 'package:untitled/util/view_util.dart';
import 'package:untitled/widget/appbar.dart';
import 'package:untitled/widget/navigation_bar.dart';
import 'package:untitled/widget/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoMo videoModel;

  const VideoDetailPage({Key? key, required this.videoModel}) : super(key: key);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  var listener;

  @override
  void initState() {
    super.initState();

    // listener = (current, pre) {
    //   print('current:${current?.page}');
    //   print('pre:${pre?.page}');
    // };

    // HiNavigator.getInstance().addListener(listener);

    // 设置黑色状态栏
    changeStatusBar(
      color: Colors.black,
      statusStyle: StatusStyle.LIGHT_CONTENT,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          child: Column(
            children: [
              HiNavigationBar(
                color: Colors.black,
                statusStyle: StatusStyle.LIGHT_CONTENT,
                child: Container(),
                height: MediaQuery.of(context).padding.top,
              ),
              _videoView(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // HiNavigator.getInstance().removeListener(listener);

    super.dispose();
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(
      model.url ?? '',
      cover: model.cover,
      autoPlay: true,
      overlayUI: videoAppBar(),
    );
  }
}
