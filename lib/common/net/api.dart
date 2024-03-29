//http请求
import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:milo_github_app_flutter/common/net/code.dart';
import 'package:milo_github_app_flutter/common/net/interceptors/error_interceptor.dart';
import 'package:milo_github_app_flutter/common/net/interceptors/header_interceptors.dart';
import 'package:milo_github_app_flutter/common/net/interceptors/response_interceptors.dart';
import 'package:milo_github_app_flutter/common/net/interceptors/token_interceptor.dart';
import 'package:milo_github_app_flutter/common/net/result_data.dart';

class HttpManager {
  static const CONTENT_TYPE_JSON = 'application/json';
  static const CONTENT_TYPE_FORM = 'application/x-www-form-urlencoded';

  Dio _dio = Dio(); //使用默认配置

  final TokenInterceptors _tokenInterceptors = TokenInterceptors();

  HttpManager() {
    _dio.interceptors
      ..add(HeaderInterceptors())
      ..add(_tokenInterceptors)
      ..add(LogInterceptor())
      ..add(ErrorInterceptors(_dio))
      ..add(ResponseInterceptors());
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  netFetch(url, params, Map<String, dynamic> header, Options option, {noTip = false}) async {
    Map<String, dynamic> headers = HashMap();
    if (headers != null) {
      headers.addAll(header);
    }

    if (option != null) {
      option.headers = headers;
    } else {
      option = Options(method: 'get');
      option.headers = headers;
    }

    resultError(DioError e) {
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = Response(statusCode: 666);
      }

      if (e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }
      return ResultData(Code.errorHandleFunction(errorResponse.statusCode, e.message, noTip), false,
          errorResponse.statusCode);
    }

    Response response;
    try {
      response = await _dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      return resultError(e);
    }
    if (response.data is DioError) {
      return resultError(response.data);
    }
    return response.data;
  }

  ///清除授权
  clearAuthorization() {
    _tokenInterceptors.clearAuthorization();
  }

  ///获取授权
  Future<String> getAuthorization() async {
    return _tokenInterceptors.getAuthorization();
  }
}

final HttpManager httpManager = HttpManager();
