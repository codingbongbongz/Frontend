import 'package:flutter/material.dart';
import 'package:k_learning/screen/home_screen.dart';
import 'package:k_learning/screen/link_screen.dart';
import 'package:k_learning/screen/my_page_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'layout/my_app_bar.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MainScreen(
        userID: 1,
      ),
    ),
    // Scaffold(
    //   body: MainScreen(uid: 4567),
    // ),
  );
}

class MainScreen extends StatefulWidget {
  final int userID;
  const MainScreen({super.key, required this.userID});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static int userID = 0;
  bool microPhonePermission = false;

  @override
  void initState() {
    super.initState();
    userID = widget.userID;
  }

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(
      userID: userID,
    ),
    LinkScreen(
      userID: userID,
    ),
    MyPageScreen(
      uid: userID,
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
