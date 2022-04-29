import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:untitled/model/home_mo.dart';
import 'package:untitled/model/video_model.dart';
import 'package:untitled/navigator/hi_navigator.dart';
import 'package:untitled/util/format_urli.dart';
import 'package:untitled/util/view_util.dart';

class VideoCard extends StatelessWidget {
  final VideoModel videoMo;

  const VideoCard({Key? key, required this.videoMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(videoMo.url!);
        HiNavigator.getInstance().onJumpTo(
          RouteStatus.detail,
          args: {"videoMo": videoMo},
        );
      },
      child: SizedBox(
        height: 200,
        child: Card(
          margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _itemImage(context),
                _infoText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        cachedImage(
          videoMo.cover ?? "",
          width: size.width / 2 - 20,
          height: 120,
        ),
        // FadeInImage.memoryNetwork(
        //   placeholder: kTransparentImage,
        //   image: videoMo.cover ?? "",
        //   width: size.width / 2 - 20,
        //   height: 120,
        //   fit: BoxFit.cover,
        //   alignment: Alignment.center,
        // ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 3,
              top: 5,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconText(Icons.ondemand_video, videoMo.view),
                _iconText(Icons.favorite_border, videoMo.favorite),
                _iconText(null, videoMo.duration),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _iconText(IconData? ondemand_video, int? count) {
    String views = "";
    if (IconData != null) {
      views = countFormat(count ?? 0);
    } else {
      views = durationTransform(videoMo.duration ?? 0);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (ondemand_video != null)
          Icon(
            ondemand_video,
            color: Colors.white,
            size: 10,
          ),
        Padding(
          padding: EdgeInsets.only(left: 3),
          child: Text(
            views,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  _infoText() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              videoMo.title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            _onwer(),
          ],
        ),
      ),
    );
  }

  _onwer() {
    var owner = videoMo.owner;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: cachedImage(
                owner?.face ?? "",
                width: 24,
                height: 24,
              ),
              // child: Image.network(
              //   owner?.face ?? "",
              //   width: 24,
              //   height: 24,
              // ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                owner?.name ?? "",
                style: TextStyle(fontSize: 10, color: Colors.black87),
              ),
            )
          ],
        ),
        Icon(
          Icons.more_vert_sharp,
          size: 15,
          color: Colors.grey,
        ),
      ],
    );
  }
}
