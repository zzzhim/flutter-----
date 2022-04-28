import 'package:flutter/material.dart';
import 'package:untitled/model/home_mo.dart';
import 'package:untitled/navigator/hi_navigator.dart';
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

    listener = (current, pre) {
      print('current:${current?.page}');
      print('pre:${pre?.page}');
    };

    HiNavigator.getInstance().addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        // child: Text('视频详情页，vid ${widget.videoModel.vid}'),
        child: Column(children: [
          Text('视频详情页，vid ${widget.videoModel.vid}'),
          Text('视频详情页，vid ${widget.videoModel.title}'),
          _videoView(),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(listener);

    super.dispose();
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(
      model.url ?? '',
      cover: model.cover,
    );
  }
}
