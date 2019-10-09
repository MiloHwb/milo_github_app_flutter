import 'package:dio/dio.dart';
import 'package:milo_github_app_flutter/common/net/result_data.dart';

import '../code.dart';

class ResponseInterceptors extends InterceptorsWrapper {
  @override
  Future onResponse(Response response) async {
    RequestOptions option = response.request;
    try {
      if (option.contentType != null && option.contentType['primaryType'] == 'text') {
        return ResultData(response.data, true, Code.SUCCESS);
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResultData(response.data, true, Code.SUCCESS, headers: response.headers);
      }
    } catch (e) {
      print(e.toString() + option.path);
      return ResultData(response.data, false, response.statusCode, headers: response.headers);
    }
  }
}
