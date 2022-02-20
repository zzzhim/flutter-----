import 'package:untitled/http/core/dio_adpter.dart';
import 'package:untitled/http/core/hi_error.dart';
import 'package:untitled/http/core/hi_net_adpter.dart';
import 'package:untitled/http/core/mock_adpter.dart';
import 'package:untitled/http/request/base_request.dart';

class HiNet {
  HiNet._();

  static HiNet? _instance;

  static HiNet getInstance() {
    // ignore: prefer_conditional_assignment, unnecessary_null_comparison
    if (_instance == null) {
      _instance = HiNet._();
    }

    return _instance!;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    var error;

    try {
      response = await send(request);

      if (response != null) {
        var result = response.data;

        var status = response.statusCode;

        return requestResponse(status, result);
      }
    } on HiNetError catch (e) {
      error = e;
      print(e);
      print(e.data);
      printLog(e.message);
    } catch (e) {
      // 其他异常
      error = e;
      printLog(e);
    }
  }

  T requestResponse<T>(int? status, T result) {
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(
          result.toString(),
          data: result,
        );
      default:
        throw HiNetError(
          status ?? -1,
          result.toString(),
          data: result,
        );
    }
  }

  Future<dynamic> send<T>(BaseRequest request) async {
    // 使用Dio发送请求
    HiNetAdapter adapter = DioAdapter();

    return adapter.send(request);
  }

  void printLog(log) {
    // ignore: avoid_print
    print('hi_net:${log.toString()}');
  }
}
