import 'package:flutter/material.dart';
import 'package:untitled/model/home_mo.dart';
import 'package:untitled/navigator/hi_navigator.dart';

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

    this.listener = (current, pre) {
      print('current:${current?.page}');
      print('pre:${pre?.page}');
    };

    HiNavigator.getInstance().addListener(this.listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text('视频详情页，vid ${widget.videoModel.vid}'),
      ),
    );
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);

    super.dispose();
  }
}
