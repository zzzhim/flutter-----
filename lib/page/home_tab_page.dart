import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:untitled/http/dao/home_dao.dart';
import 'package:untitled/model/home_mo.dart';
import 'package:untitled/model/video_model.dart';
import 'package:untitled/util/color.dart';
import 'package:untitled/widget/hi_banner.dart';
import 'package:untitled/widget/video_card.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;

  const HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  List<VideoModel> videoList = [];
  int pageIndex = 1;
  ScrollController _scrollController = ScrollController();

  bool laoding = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;

      print('dis:$dis');

      if (dis < 300) {
        _loadData(loadMore: true);
      }
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            controller: _scrollController,
            // 允许滚动
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (widget.bannerList != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 8, top: 10),
                  child: _banner(),
                ),
              MasonryGridView.count(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: widget.bannerList != null ? 0 : 10,
                ),
                shrinkWrap: true,
                crossAxisCount: 2,
                itemCount: videoList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return VideoCard(
                    videoMo: videoList[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      color: primary,
      onRefresh: () async {
        _loadData();
      },
    );
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: HiBanner(bannerList: widget.bannerList ?? []),
    );
  }

  void _loadData({loadMore = false}) async {
    if (laoding) {
      return;
    }

    laoding = true;
    print('-------------------------------------------');
    print('--------------------laoding-----------------------');
    print('-------------------------------------------');

    if (!loadMore) {
      pageIndex = 1;
    }

    var currentIndex = pageIndex + (loadMore ? 1 : 0);

    try {
      HomeMo result = await HomeDao.get(
        widget.categoryName,
        pageIndex: currentIndex,
        pageSize: 10,
      );

      setState(() {
        if (loadMore && result.videoList != null) {
          if (result.videoList!.isNotEmpty) {
            videoList = [...videoList, ...result.videoList!];
            pageIndex++;
          }
        } else {
          videoList = result.videoList != null ? result.videoList! : videoList;
        }
      });

      print('loadData():${jsonEncode(result)}');
    } catch (e) {
      print(jsonEncode(e));
      // showWarnToast(e?.m);
    } finally {
      Future.delayed(Duration(milliseconds: 200), () {
        laoding = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
