import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

const String baseURL = "http://43.200.72.190:8081/";

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.contentType == null) {
      final dynamic data = options.data;
      final String? contentType;
      if (data is FormData) {
        contentType = Headers.multipartFormDataContentType;
      } else if (data is Map) {
        contentType = Headers.formUrlEncodedContentType;
      } else if (data is String) {
        contentType = Headers.jsonContentType;
      } else if (data != null) {
        contentType =
            Headers.textPlainContentType; // Can be removed if unnecessary.
      } else {
        contentType = null;
      }
      options.contentType = contentType;
    }
    log('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    log('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}

Dio dio = Dio();
