import 'package:untitled/http/core/hi_net_adpter.dart';
import 'package:untitled/http/request/base_request.dart';

// 测试适配器，mock数据
class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    return Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        return HiNetResponse(
          request: request,
          data: {
            "code": 200,
            "message": "success",
          } as T,
          statusCode: 403,
        );
      },
    );
  }
}
