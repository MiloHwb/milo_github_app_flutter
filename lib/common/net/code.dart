import 'package:milo_github_app_flutter/common/event/http_error_event.dart';
import 'package:milo_github_app_flutter/common/event/index.dart';

///错误编码
class Code {
  ///网络错误
  static const NETWORK_ERROR = -1;

  ///网络超时
  static const NETWORK_TIMEOUT = -2;

  ///网络返回数据Json异常
  static const NETWORK_JSON_EXCEPTION = -3;

  static const SUCCESS = 200;

  static errorHandleFunction(code, message, noTip) {
    if (noTip) {
      return message;
    }
    eventBus.fire(HttpErrorEvent(code, message));
    return message;
  }
}
