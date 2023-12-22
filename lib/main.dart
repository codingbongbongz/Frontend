import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:k_learning/screen/home_screen.dart';
import 'package:k_learning/screen/link_screen.dart';
import 'package:k_learning/screen/login_screen.dart';
import 'package:k_learning/screen/my_page_screen.dart';
import 'package:k_learning/screen/sign_up_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'layout/my_app_bar.dart';

void main() async {
  // login 세션 관리
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    print(ThemeMode.system);
  }
  final storage = FlutterSecureStorage();
  clearSecureStorageOnReinstall(storage);

  dynamic userInfo = await storage.read(key: 'login');
  if (userInfo == null) {
    runApp(MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.white,
        ),
        darkTheme: ThemeData.dark(),
        home: LoginScreen()));
  } else {
    runApp(
      MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.white,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
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
      appBar: null,
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'add Video',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'my page',
        ),
      ],
    );
  }

  void onTap(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      if (index == 1) {
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          context: context,
          builder: (BuildContext context) {
            return Container(
              height:
                  MediaQuery.of(context).size.height / 3.0, // 원하는 height로 조절
              child: LinkScreen(),
            ); // LinkScreen이 아래에서 올라옴
          },
        );
      } else {
        _selectedIndex = index;
      }
    });
  }

  Future<bool> init() async {
    final resp = await [Permission.microphone].request();
    final resp2 = await [Permission.camera].request();

    final microphonePermission = resp[Permission.microphone];
    final cameraPermission = resp2[Permission.camera];

    if (microphonePermission != PermissionStatus.granted) {
      throw '마이크 권한이 없습니다.';
    }
    if (cameraPermission != PermissionStatus.granted) {
      throw '카메라 권한이 없습니다.';
    }

    return true;
  }
}
