import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:k_learning/screen/home_screen.dart';
import 'package:k_learning/screen/link_screen.dart';
import 'package:k_learning/screen/login_screen.dart';
import 'package:k_learning/screen/my_page_screen.dart';
import 'package:k_learning/screen/sign_up_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'class/token.dart';
import 'const/key.dart';
import 'layout/my_app_bar.dart';

void main() async {
  // login 세션 관리
  WidgetsFlutterBinding.ensureInitialized();

  final storage = FlutterSecureStorage();
  clearSecureStorageOnReinstall(storage);

  dynamic userInfo;
  String accessToken = '';
  // String refreshToken = '';
  // bool validToken = true;

  // // await storage.delete(key: 'login');
  userInfo = await storage.read(key: 'login');
  accessToken = jsonDecode(userInfo)['accessToken'];

  // if (userInfo != null) {
  //   accessToken = jsonDecode(userInfo)['accessToken'];
  //   // print('accessToken : $accessToken');

  //   refreshToken = jsonDecode(userInfo)['refreshToken'];
  //   // print('refreshToken : $refreshToken');
  //   Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();
  //   dio.options.baseUrl = baseURL;
  //   // dio.interceptors.add(
  //   //   InterceptorsWrapper(
  //   //     onRequest: (options, handler) {
  //   //       print("a");
  //   //       return handler.resolve(
  //   //         Response(requestOptions: options, data: 'fake data'),
  //   //       );
  //   //     },
  //   //     onError: (err, handler) {
  //   //       print(
  //   //           'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
  //   //       if (err.response?.statusCode == 403) {
  //   //         print('403 오류 발생: ${err.response?.data}');
  //   //       } else if (err.response?.statusCode == 404) {
  //   //         print('404 오류 발생: ${err.response?.data}');
  //   //       } else if (err.response?.statusCode == 401) {
  //   //         print('401 오류 발생: ${err.response?.data}');
  //   //       }
  //   //       print(err);
  //   //       // super.onError(err, handler);
  //   //     },
  //   //   ),
  //   // );
  //   // accessToken =
  //   //     'eyJ0eXBlIjoiYWNjZXNzVG9rZW4iLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhY2Nlc3NUb2tlbiIsInVzZXJJZCI6MTEsImlhdCI6MTY5NDc2MDQ0MywiZXhwIjoxNjk0Nzc0ODQzfQ.vexrTpFiEOCdHcuBDaHejDZQ02K2xby0tTA7cdcJ850';
  //   // refreshToken =
  //   //     'eyJ0eXBlIjoicmVmcmVzaFRva2VuIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiJyZWZyZXNoVG9rZW4iLCJ1c2VySWQiOjExLCJpYXQiOjE2OTQ0OTcxNjUsImV4cCI6MTY5NTcwNjc2NX0.DZYW1qhnsyXhpAj-KbN_XVPDSODjGviq3jLRmXKdLz0';

  //   dio.options.headers = {
  //     "accessToken": 'Bearer $accessToken',
  //     "refreshToken": 'Bearer $refreshToken',
  //   };
  //   final response = await dio.post('auth/token');
  //   print(response.data);

  //   // HTTP 상태 코드 확인
  //   if (response.statusCode == 201) {
  //     // 성공적인 응답 처리
  //     print('성공: ${response.data}');
  //     accessToken = response.data['data']['accessToken'];
  //     refreshToken = response.data['data']['refreshToken'];
  //   }
  // }

  // if (userInfo == null || !validToken) {
  //   // 여기에 토큰 validation 추가해야 함
  //   runApp(
  //     const MaterialApp(
  //       // home: LoginScreen(),
  //       home: SignUpScreen(),
  //     ),
  //   );
  // } else {
  //   runApp(
  //     MaterialApp(
  //       // home: LoginScreen(),%
  //       home: MainScreen(accessToken: accessToken),
  //     ),
  //   );
  // }

  runApp(
    MaterialApp(
      // home: LoginScreen(),%
      home: MainScreen(accessToken: accessToken),
    ),
  );
}

clearSecureStorageOnReinstall(storage) async {
  String key = 'hasRunbefore';
  SharedPreferences pref = await SharedPreferences.getInstance();
  // print(pref.getBool(key));
  if (pref.getBool(key) == null) {
    await storage.deleteAll();
    pref.setBool(key, true);
  }
}

class MainScreen extends StatefulWidget {
  final String accessToken;
  const MainScreen({super.key, required this.accessToken});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static String accessToken = '';
  bool microPhonePermission = false;

  @override
  void initState() {
    super.initState();
    accessToken = widget.accessToken;
  }

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(
      accessToken: accessToken,
    ),
    LinkScreen(
      accessToken: accessToken,
    ),
    MyPageScreen(
      accessToken: accessToken,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: FutureBuilder<bool>(
          future: init(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }
            // print();
            return Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            );
          }),
      bottomNavigationBar: btmNavBar(),
    );
  }

  BottomNavigationBar btmNavBar() {
    return BottomNavigationBar(
      onTap: onTap,
      backgroundColor: Colors.blue.shade100,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library),
          label: 'link',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'my page',
        ),
      ],
    );
  }

  void onTap(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> init() async {
    final resp = await [Permission.microphone].request();
    final microphonePermission = resp[Permission.microphone];

    if (microphonePermission != PermissionStatus.granted) {
      throw '마이크 권한이 없습니다.';
    }

    // print(microphonePermission);
    return true;
  }
}
