import 'package:dio/dio.dart';

/// header拦截器
class HeaderInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    //超时时间
    options.connectTimeout = 15000;
    return Future.value(options);
  }
}
