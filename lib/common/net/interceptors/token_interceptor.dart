import 'package:dio/dio.dart';
import 'package:milo_github_app_flutter/common/config/config.dart';
import 'package:milo_github_app_flutter/common/local/local_storage.dart';

class TokenInterceptors extends InterceptorsWrapper {
  String _token;

  @override
  Future onRequest(RequestOptions options) async {
    //授权码
    var authorizationCode = await getAuthorization();
    if (authorizationCode != null) {
      _token = authorizationCode;
    }
    options.headers['Authorization'] = _token;
    return options;
  }

  @override
  Future onResponse(Response response) async {
    try {
      var responseJson = response.data;
      if (response.statusCode == 201 && responseJson['token'] != null) {
        _token = 'token ' + responseJson['token'];
        await LocalStorage.save(Config.TOKEN_KEY, _token);
      }
    } catch (e) {
      print(e);
    }
    return response;
  }

  //清除授权
  clearAuthorization() {
    _token = null;
    LocalStorage.remove(Config.TOKEN_KEY);
  }

  Future<String> getAuthorization() async {
    String token = await LocalStorage.get(Config.TOKEN_KEY);
    if (token == null) {
      String basic = await LocalStorage.get(Config.USER_BASIC_CODE);
      if (basic == null) {
        //提示输入账号密码
        return '';
      } else {
        //通过basic去获取token，获取到设置，返回token
        return 'Basic $basic';
      }
    } else {
      _token = token;
      return token;
    }
  }
}
