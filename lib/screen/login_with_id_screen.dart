import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:k_learning/class/token.dart';
import 'package:k_learning/const/color.dart';
import 'package:k_learning/const/key.dart';
import 'package:k_learning/main.dart';
import 'package:k_learning/screen/sign_up_screen.dart';

class LoginWithIDScreen extends StatefulWidget {
  const LoginWithIDScreen({super.key});

  @override
  State<LoginWithIDScreen> createState() => _LoginWithIDScreenState();
}

class _LoginWithIDScreenState extends State<LoginWithIDScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _passwordVisible = false;
  bool isTextEmpty = true;

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text('로그인에 실패했습니다. 올바른 정보를 입력하세요.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // AlertDialog 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  loginWithID() async {
    final dio = Dio();
    dio.options.baseUrl = baseURL;

    Map<String, String> param = {
      'email': email.text,
      'password': password.text
    };

    try {
      final response = await dio.post(
        'auth/signin',
        data: param,
      );

      if (response.statusCode == 200) {
        String accessToken = response.data['data']['accessToken'];
        String refreshToken = response.data['data']['refreshToken'];
        final storage = FlutterSecureStorage();

        String val = jsonEncode(
            Token(accessToken: accessToken, refreshToken: refreshToken));
        await storage.write(key: 'login', value: val);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => MainScreen(),
            ),
            (route) => false);
      } else {
        print('Login Fail');
        showAlertDialog(context);
      }
    } on DioException catch (e) {
      showAlertDialog(context);
    }
  }

  void _onTextChanged() {
    setState(() {
      isTextEmpty = email.text.isEmpty || password.text.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    email.addListener(_onTextChanged);
    password.addListener(_onTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getPlatformDependentColor(
          context,
          Colors.white,
          Colors.grey[850],
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: getPlatformDependentColor(
            context,
            Colors.black,
            Colors.white,
          ),
        ),
        title: Text(
          'LOGIN',
          style: TextStyle(
              color: getPlatformDependentColor(
                  context, Colors.black, Colors.white)),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Input('email', email),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Input('password', password),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                width: MediaQuery.of(context).size.width / 1,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: isTextEmpty ? Colors.grey : blueColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: loginWithID,
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                width: MediaQuery.of(context).size.width / 1,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    // padding: EdgeInsets.symmetric(
                    //   horizontal: MediaQuery.of(context).size.width / 3,
                    // ),
                    backgroundColor: blueColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SignUpScreen(
                          isSocial: false,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          )
        ],
      ),
    );
  }

  TextField Input(text, TextEditingController controller) {
    return TextField(
      obscureText: text == 'password' && _passwordVisible,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: blueColor),
        ),
        hintText: text,
        hintStyle: TextStyle(
          fontSize: 16.0,
          textBaseline:
              TextBaseline.alphabetic, // 텍스트 베이스라인을 변경하여 텍스트를 좌측 상단에 배치
        ),
        suffixIcon: (text == 'password')
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }
}
