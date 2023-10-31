import 'dart:convert';

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

  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  print(ThemeMode.system);
  final storage = FlutterSecureStorage();
  // await storage.deleteAll();
  clearSecureStorageOnReinstall(storage);

  dynamic userInfo = await storage.read(key: 'login');
  // print(userInfo['accessToken']);
  if (userInfo == null) {
    runApp(MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.white,
        ),
        darkTheme: ThemeData.dark(),
        home: LoginScreen()));
    // runApp(MaterialApp(
    //     home: SignUpScreen(
    //   isSocial: false,
    // )));
  } else {
    // final accessToken = jsonDecode(userInfo)['accessToken'];
    // print(accessToken);
    runApp(
      MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.white,
          brightness: Brightness.light,
          // primarySwatch: Colors.blue,
        ),
        // theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        // themeMode: mode,
        home: MainScreen(),
        // home: LoginScreen(),
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
      // backgroundColor: Colors.white,
      // backgroundColor:
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
        // "add Video" 아이템을 클릭했을 때 linkScreen을 아래에서 올리기
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          context: context,
          builder: (BuildContext context) {
            return Container(
              // color: Colors.white,
              // decoration: BoxDecoration(
              //     // borderRadius: BorderRadius.only(
              //     //   topLeft: Radius.circular(30),
              //     //   topRight: Radius.circular(30),
              //     // ),
              //     // border: Border.all(
              //     //   color: Colors.grey, // 원하는 border 색상을 지정
              //     //   width: 2.0, // border의 두께를 조절
              //     // ),
              //     ),
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
    // print(microphonePermission);
    return true;
  }
}
