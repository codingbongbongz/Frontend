import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:k_learning/class/user.dart';
import 'package:k_learning/const/key.dart';
import 'package:k_learning/main.dart';
import 'package:k_learning/screen/edit_userinfo_screen.dart';
import 'package:k_learning/screen/login_screen.dart';
import 'package:k_learning/screen/sign_up_screen.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String nickname = '';
  String introduce = '';
  String profileImageUrl = '';

  late Future myGetUserInfo;
  patchUserInfo() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text('사용자 정보 수정',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
          ),
          content: EditUserInfoScreen(
            profileImageUrl: profileImageUrl,
            nickname: nickname,
            introduce: introduce,
          ),
          insetPadding: const EdgeInsets.all(8.0),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  myGetUserInfo = getUserInfo();
                });
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  logout() async {
    final storage = FlutterSecureStorage();
    await storage.deleteAll();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => SignUpScreen(
            isSocial: false,
          ),
        ),
        (route) => false);
  }

  withdrawal() async {
    var dio = await authDio(context);
    final response = await dio.delete('mypage');

    final storage = FlutterSecureStorage();
    await storage.deleteAll();
    dynamic responseBody = response.data;
    print(responseBody);
    // main();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
        (route) => false);
  }

  Future<dynamic> getUserInfo() async {
    var dio = await authDio(context);
    final response = await dio.get('user');
    dynamic responseBody = response.data['data'];
    // var _userInfo = responseBody.map((e) => User.fromJson(e));

    print(responseBody);
    // print(responseBody.runtimeType);
    profileImageUrl ??= responseBody['profileImageUrl'];
    nickname = responseBody['nickname'];
    introduce = responseBody['introduce'];

    return responseBody;
  }

  @override
  void initState() {
    super.initState();
    myGetUserInfo = getUserInfo();
    // getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //   height: 10,
        // ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder(
              future: myGetUserInfo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final data = snapshot.data;
                  return GestureDetector(
                    onTap: patchUserInfo,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // 'nickname',
                                data['nickname'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(data['introduce'],
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                          data['profileImageUrl'] != null
                              ? Image.network(data['profileImageUrl'])
                              : Icon(Icons.person),
                        ],
                      ),
                    ),
                  );
                }
              }),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () {},
                child: Text('학습한 동영상', style: TextStyle(color: Colors.black)),
              ),
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () {
                  // MyPageScreen.themeNotifier.value =
                  //     MyApp.themeNotifier.value == ThemeMode.light
                  //         ? ThemeMode.dark
                  //         : ThemeMode.light;
                },
                child: Text('다크모드', style: TextStyle(color: Colors.black)),
              ),
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: logout,
                child: Text('로그아웃', style: TextStyle(color: Colors.black)),
              ),
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: withdrawal,
                child: Text('탈퇴하기', style: TextStyle(color: Colors.red)),
              ),
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
