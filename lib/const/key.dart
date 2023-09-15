import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../class/token.dart';

const String baseURL = "http://43.200.72.190/";

// class CustomInterceptors extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     if (options.contentType == null) {
//       final dynamic data = options.data;
//       final String? contentType;
//       if (data is FormData) {
//         contentType = Headers.multipartFormDataContentType;
//       } else if (data is Map) {
//         contentType = Headers.formUrlEncodedContentType;
//       } else if (data is String) {
//         contentType = Headers.jsonContentType;
//       } else if (data != null) {
//         contentType =
//             Headers.textPlainContentType; // Can be removed if unnecessary.
//       } else {
//         contentType = null;
//       }
//       options.contentType = contentType;
//     }
//     log('REQUEST[${options.method}] => PATH: ${options.path}');
//     super.onRequest(options, handler);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
//     super.onResponse(response, handler);
//   }

//   @override
//   Future onError(DioException err, ErrorInterceptorHandler handler) async {
//     log('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
//     if (err.response?.statusCode == 403) {
//       print('403 오류 발생: ${err.response?.data}');
//     }
//     super.onError(err, handler);
//   }
// }

Future<Dio> authDio(BuildContext context) async {
  Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();
  dio.options.baseUrl = baseURL;
  final storage = new FlutterSecureStorage();

  dio.interceptors.clear();

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    // 기기에 저장된 AccessToken 로드
    // final accessToken = await storage.read(key: 'login');
    dynamic userInfo = await storage.read(key: 'login');
    final accessToken = jsonDecode(userInfo)['accessToken'];

    // 매 요청마다 헤더에 AccessToken을 포함
    options.headers['Authorization'] = accessToken;
    return handler.next(options);
  }, onError: (error, handler) async {
    // 인증 오류가 발생했을 경우: AccessToken의 만료
    if (error.response?.statusCode == 401) {
      // 기기에 저장된 AccessToken과 RefreshToken 로드
      dynamic userInfo = await storage.read(key: 'login');
      final accessToken = jsonDecode(userInfo)['accessToken'];
      final refreshToken = jsonDecode(userInfo)['refreshToken'];

      // 토큰 갱신 요청을 담당할 dio 객체 구현 후 그에 따른 interceptor 정의
      var refreshDio = Dio()..httpClientAdapter = IOHttpClientAdapter();
      refreshDio.options.baseUrl = baseURL;

      refreshDio.interceptors.clear();

      refreshDio.interceptors
          .add(InterceptorsWrapper(onError: (error, handler) async {
        // 다시 인증 오류가 발생했을 경우: RefreshToken의 만료
        if (error.response?.statusCode == 401) {
          // 기기의 자동 로그인 정보 삭제
          print("401 에러");
          await storage.deleteAll();

          // . . .
          // 로그인 만료 dialog 발생 후 로그인 페이지로 이동
          // . . .
        }
        return handler.next(error);
      }));

      // 토큰 갱신 API 요청 시 AccessToken(만료), RefreshToken 포함
      // refreshDio.options.headers['accessToken'] = 'Bearer $accessToken';
      // refreshDio.options.headers['refreshToken'] = 'Bearer $refreshToken';
      refreshDio.options.headers = {
        "accessToken": 'Bearer $accessToken',
        "refreshToken": 'Bearer $refreshToken',
      };
      print("refreshDio");
      // 토큰 갱신 API 요청
      final refreshResponse = await refreshDio.post('/auth/token');

      // response로부터 새로 갱신된 AccessToken과 RefreshToken 파싱
      // final newAccessToken = refreshResponse.headers['accessToken']![0];
      // final newRefreshToken = refreshResponse.headers['refreshToken']![0];
      final newAccessToken = refreshResponse.data['data']['accessToken'];
      final newRefreshToken = refreshResponse.data['data']['refreshToken'];

      // 기기에 저장된 AccessToken과 RefreshToken 갱신
      var val = jsonEncode(
          Token(accessToken: newAccessToken, refreshToken: newRefreshToken));
      await storage.write(key: 'login', value: val);
      // await storage.write(key: 'ACCESS_TOKEN', value: newAccessToken);
      // await storage.write(key: 'REFRESH_TOKEN', value: newRefreshToken);

      // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
      error.requestOptions.headers['Authorization'] = newAccessToken;

      // 수행하지 못했던 API 요청 복사본 생성
      final clonedRequest = await dio.request(error.requestOptions.path,
          options: Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers),
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters);

      // API 복사본으로 재요청
      return handler.resolve(clonedRequest);
    }

    return handler.next(error);
  }));

  return dio;
}
