import 'package:untitled/db/hi_cache.dart';
import 'package:untitled/http/core/hi_net.dart';
import 'package:untitled/http/request/base_request.dart';
import 'package:untitled/http/request/login_request.dart';
import 'package:untitled/http/request/registration_request.dart';

class LoginDao {
  static String BOARDING_PASS = 'boarding-pass';

  static login(String userName, String password) {
    return _send(userName, password);
  }

  static registration(
    String userName,
    String password,
    String imoocId,
    String orderId,
  ) {
    return _send(userName, password, imoocId: imoocId, orderId: orderId);
  }

  static _send(String userName, String password, {imoocId, orderId}) async {
    BaseRequest request;

    if (imoocId != null && orderId != null) {
      request = RegistrationRequest();

      request.add("imoocId", imoocId).add("orderId", orderId);
    } else {
      request = LoginRequest();
    }

    request.add("userName", userName).add("password", password);

    var result = await HiNet.getInstance().fire(request);

    if (result['code'] == 0 && result['data'] != null) {
      // 保持登录令牌
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
    }

    return result;
  }

  static getBoardingPass() {
    return HiCache.getInstance().get(BOARDING_PASS) ?? "";
  }
}
