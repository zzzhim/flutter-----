import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String url;
  final String? cover;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;

  const VideoView(
    this.url, {
    Key? key,
    this.cover,
    this.autoPlay = false,
    this.looping = false,
    this.aspectRatio = 16 / 9,
  }) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController? videoPlayerController;

  ChewieController? chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 初始化播放器
    videoPlayerController = VideoPlayerController.network(widget.url);

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController as VideoPlayerController,
      autoPlay: widget.autoPlay as bool,
      looping: widget.looping as bool,
      aspectRatio: widget.aspectRatio,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth / widget.aspectRatio;

    // TODO: implement build
    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.grey,
      child: Chewie(controller: chewieController as ChewieController),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // 销毁播放器
    (videoPlayerController as VideoPlayerController).dispose();
    (chewieController as ChewieController).dispose();
  }
}
