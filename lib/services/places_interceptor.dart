

import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor{
  
  final accessToken = 'pk.eyJ1IjoidmFsbW9udDk3IiwiYSI6ImNsOTAzcGNiMDA2eXczb283b2gwaWFkc2MifQ.dPxjjDThsFqDqWRs4WxgjQ';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token' : accessToken,
      'language'     : 'es',
    });
    super.onRequest(options, handler);
  }


}