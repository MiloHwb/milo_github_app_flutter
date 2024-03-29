import 'package:dio/dio.dart';
import 'package:milo_github_app_flutter/common/config/config.dart';

class LogInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    if (Config.DEBUG) {
      print('请求url：${options.path}');
      print('请求头：${options.headers.toString()}');
      if (options.data != null) {
        print('请求参数：${options.data.toString()}');
      }
    }
    return Future.value(options);
  }

  @override
  Future onResponse(Response response) {
    if (Config.DEBUG) {
      if (response != null) {
        print('返回参数：${response.toString()}');
      }
    }
    return Future.value(response);
  }

  @override
  Future onError(DioError err) async {
    if (Config.DEBUG) {
      print('请求异常：${err.toString()}');
      print('请求异常信息：${err.response?.toString() ?? ''}');
    }
    return err;
  }
}
