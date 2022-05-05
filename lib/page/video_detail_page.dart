import 'package:flutter/material.dart';
import 'package:untitled/http/dao/video_detail_dao.dart';
import 'package:untitled/model/video_detail_mo.dart';
import 'package:untitled/model/video_model.dart';
import 'package:untitled/util/toast.dart';
import 'package:untitled/util/view_util.dart';
import 'package:untitled/widget/appbar.dart';
import 'package:untitled/widget/expandable_content.dart';
import 'package:untitled/widget/hi_tab.dart';
import 'package:untitled/widget/navigation_bar.dart';
import 'package:untitled/widget/video_header.dart';
import 'package:untitled/widget/video_toolbar.dart';
import 'package:untitled/widget/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel? videoModel;

  const VideoDetailPage({Key? key, required this.videoModel}) : super(key: key);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  TabController? _controller;
  List tabs = ["简介", "评论288"];
  VideoDetailMo? videoDetailMo;
  VideoModel? videoModel;

  @override
  void initState() {
    super.initState();

    videoModel = widget.videoModel;

    // 设置黑色状态栏
    changeStatusBar(
      color: Colors.black,
      statusStyle: StatusStyle.LIGHT_CONTENT,
    );

    _controller = TabController(length: tabs.length, vsync: this);

    _loadDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          child: videoModel?.url != null
              ? Column(
                  children: [
                    HiNavigationBar(
                      color: Colors.black,
                      statusStyle: StatusStyle.LIGHT_CONTENT,
                      child: Container(),
                      height: MediaQuery.of(context).padding.top,
                    ),
                    _buildVideoView(),
                    _buildTabNavigation(),
                    Flexible(
                      child: TabBarView(
                        controller: _controller,
                        children: [
                          _buildDetailList(),
                          Container(
                            child: Text('1111'),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // HiNavigator.getInstance().removeListener(listener);
    _controller?.dispose();
    super.dispose();
  }

  _buildVideoView() {
    var model = videoModel;
    return VideoView(
      model?.url ?? '',
      cover: model?.cover,
      autoPlay: true,
      overlayUI: videoAppBar(),
    );
  }

  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(
      tabs.map<Tab>((tabName) {
        return Tab(
          text: tabName,
        );
      }).toList(),
      controller: _controller,
    );
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        ...buildContents(),
        Container(
          height: 500,
          child: Text(videoModel?.vid?.toString() ?? ''),
        )
      ],
    );
  }

  buildContents() {
    var videoModeldel = videoModel!;

    return [
      VideoHeader(owner: videoModeldel.owner!),
      ExpandableContent(mo: videoModeldel),
      VideoToolbar(
        detailMo: videoDetailMo,
        videoModel: videoModel!,
        onLike: _doLike,
        onUnLike: _onUnLike,
        onFavorite: _onFavorite,
      ),
    ];
  }

  _doLike() {}

  _onUnLike() {}

  _onFavorite() {}

  void _loadDetail() async {
    try {
      VideoDetailMo result =
          await VideoDetailDao.get(videoModel!.vid.toString());

      print(result);

      setState(() {
        videoDetailMo = result;
        videoModel = result.videoInfo;
      });
    } catch (e) {
      print(e);
      showWarnToast('未知错误');
    }
  }
}
