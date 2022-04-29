import 'package:untitled/http/core/hi_net.dart';
import 'package:untitled/http/request/video_detail_request.dart';
import 'package:untitled/model/video_detail_mo.dart';

// 详情页面dao
class VideoDetailDao {
  static get(String vid) async {
    VideoDetailRequest request = VideoDetailRequest();

    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    // ignore: avoid_print
    print(result);
    return VideoDetailMo.fromJson(result['data']);
  }
}
