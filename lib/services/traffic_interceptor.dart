import 'package:dio/dio.dart';


class TrafficInterceptor extends Interceptor{

  final accessToken = 'pk.eyJ1IjoidmFsbW9udDk3IiwiYSI6ImNsOTAzcGNiMDA2eXczb283b2gwaWFkc2MifQ.dPxjjDThsFqDqWRs4WxgjQ';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    options.queryParameters.addAll({
      'alternatives' : true,
      'geometries'   : 'polyline6',
      'overview'     : 'simplified',
      'steps'        : false,
      'access_token' : accessToken
    });

    super.onRequest(options, handler);
  }

}