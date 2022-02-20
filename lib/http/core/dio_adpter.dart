// Dio适配器
import 'package:dio/dio.dart';
import 'package:untitled/http/core/hi_error.dart';
import 'package:untitled/http/core/hi_net_adpter.dart';
import 'package:untitled/http/request/base_request.dart';

class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    var response, options = Options(headers: request.header);
    var error;

    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio().post(
          request.url(),
          data: request.params,
          options: options,
        );
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio().delete(
          request.url(),
          data: request.params,
          options: options,
        );
      }
    } on DioError catch (e) {
      print(e);
      error = e;
      response = e.response;
    }

    if (error != null) {
      // 抛出异常
      throw HiNetError(
        response?.statusCode ?? -1,
        error.toString(),
        data: buildRes(response, request),
      );
    }

    return buildRes(response, request);
  }

  // 构建HiNetResponse
  Future<HiNetResponse<T>> buildRes<T>(
      Response? response, BaseRequest request) {
    return Future.value(
      HiNetResponse(
        data: response?.data,
        request: request,
        statusCode: response?.statusCode,
        statusMessage: response?.statusMessage,
        extra: response,
      ),
    );
  }
}
