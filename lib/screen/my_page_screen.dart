import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:k_learning/class/user.dart';
import 'package:k_learning/const/color.dart';
import 'package:k_learning/const/key.dart';
import 'package:k_learning/main.dart';
import 'package:k_learning/screen/edit_userinfo_screen.dart';
import 'package:k_learning/screen/login_screen.dart';
import 'package:k_learning/screen/sign_up_screen.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => MyPageScreenState();
}

class MyPageScreenState extends State<MyPageScreen> {
  String nickname = '';
  String introduce = '';
  String profileImageUrl = '';

  late Future myGetUserInfo;

  // patchUserInfo2(String nickname, String introduce) async {
  //   var dio = await authDio(context);
  //   FormData formData = FormData.fromMap({
  //     // "Authorization": accessToken,
  //     "nickname": nickname,
  //     "introduce": introduce,
  //   });
  //   final response = await dio.patch(
  //     'mypage',
  //     data: formData,
  //     options: Options(
  //       headers: {"Content-Type": "multipart/form-data"},
  //     ),
  //   );

  //   dynamic responseBody = response.data['data'];
  //   // print(responseBody);
  // }

  patchUserInfo() async {
    var updatedInroduce = showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text('Edit user Info',
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
              onPressed: () async {
                // Navigator.of(context).pop();
                Navigator.pop(context);
                setState(() {
                  myGetUserInfo = getUserInfo();
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    if (updatedInroduce != null) {
      print(updatedInroduce);
    }
    // print(editedUserInfo);
  }

  logout() async {
    final storage = FlutterSecureStorage();
    await storage.deleteAll();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
        (route) => false);
  }

  withdrawal() async {
    var dio = await authDio(context);
    final response = await dio.delete('mypage');
    logout();
    // final storage = FlutterSecureStorage();
    // await storage.deleteAll();
    // dynamic responseBody = response.data;
    // print(responseBody);
    // // main();
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => LoginScreen(),
    //     ),
    // (route) => false);
  }

  Future<dynamic> getUserInfo() async {
    var dio = await authDio(context);
    final response = await dio.get('user');
    dynamic responseBody = response.data['data'];
    // var _userInfo = responseBody.map((e) => User.fromJson(e));

    // print(responseBody);
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: AppBar(
          backgroundColor: getPlatformDependentColor(
              context, Colors.white, Colors.grey[850]),
          elevation: 0,
          // bottom: 50,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(
          //   height: 10,
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder(
                future: myGetUserInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final data = snapshot.data;
                    return Padding(
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
                    );
                  }
                }),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                color: getPlatformDependentColor(
                    context, mediumGreyColor, Colors.grey[800]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   height: 1.0,
                    //   color: lightGreyColor,
                    // ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Learned Videos',
                        style: TextStyle(
                          color: getPlatformDependentColor(
                              context, Colors.black, Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      height: 1.0,
                      // width: 300.0,
                      color: lightGreyColor,
                    ),
                    TextButton(
                      onPressed: patchUserInfo,
                      child: Text(
                        'Edit User Info',
                        style: TextStyle(
                          color: getPlatformDependentColor(
                              context, Colors.black, Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      height: 1.0,
                      // width: 300.0,
                      color: lightGreyColor,
                    ),
                    TextButton(
                      onPressed: logout,
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                          color: getPlatformDependentColor(
                              context, Colors.black, Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      height: 1.0,
                      color: lightGreyColor,
                    ),
                    TextButton(
                      onPressed: withdrawal,
                      child:
                          Text('Sign Out', style: TextStyle(color: Colors.red)),
                    ),
                    // Container(
                    //   height: 1.0,
                    //   // width: 300.0,
                    //   color: Colors.grey,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
