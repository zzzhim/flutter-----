import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:untitled/http/dao/home_dao.dart';
import 'package:untitled/model/home_mo.dart';
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

class _HomeTabPageState extends State<HomeTabPage> {
  List<VideoMo> videoList = [];
  int pageIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
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
    );
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: HiBanner(bannerList: widget.bannerList ?? []),
    );
  }

  void _loadData({loadMore = false}) async {
    if (!loadMore) {
      pageIndex = 1;
    }

    var currentIndex = pageIndex + (loadMore ? 1 : 0);

    try {
      HomeMo result = await HomeDao.get(
        widget.categoryName,
        pageIndex: currentIndex,
        pageSize: 50,
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
    }
  }
}
