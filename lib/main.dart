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
  // await storage.deleteAll();
  clearSecureStorageOnReinstall(storage);

  dynamic userInfo = await storage.read(key: 'login');
  // print(userInfo['accessToken']);
  if (userInfo == null) {
    runApp(MaterialApp(home: SignUpScreen()));
  } else {
    final accessToken = jsonDecode(userInfo)['accessToken'];
    print(accessToken);
    runApp(
      MaterialApp(
        home: MainScreen(),
      ),
    );
  }
}

clearSecureStorageOnReinstall(storage) async {
  String key = 'hasRunbefore';
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.getBool(key) == null) {
    await storage.deleteAll();
    pref.setBool(key, true);
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool microPhonePermission = false;

  @override
  void initState() {
    super.initState();
  }

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    LinkScreen(),
    MyPageScreen(),
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
