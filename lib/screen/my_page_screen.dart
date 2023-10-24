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
        SizedBox(
          height: 20,
        ),
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
                  return Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: data['profileImageUrl'] != null
                              ? Image.network(data['profileImageUrl'])
                              : Icon(Icons.person)),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // 'nickname',
                                data['nickname'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                data['introduce'],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Icon(Icons.edit),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
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
                        },
                        icon: Icon(Icons.edit),
                        iconSize: 15,
                      )
                    ],
                  );
                }
              }),
        ),
        SizedBox(
          height: 30,
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
                child:
                    Text('학습했던 동영상 확인', style: TextStyle(color: Colors.black)),
              ),
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () {},
                child: Text('다크모드', style: TextStyle(color: Colors.black)),
              ),
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: withdrawal,
                child: Text('서비스 탈퇴하기', style: TextStyle(color: Colors.black)),
              ),
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () async {
                  final storage = FlutterSecureStorage();
                  await storage.deleteAll();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SignUpScreen(
                          isSocial: false,
                        ),
                      ),
                      (route) => false);
                },
                child: Text('로그 아웃', style: TextStyle(color: Colors.black)),
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
