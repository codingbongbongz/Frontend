import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:k_learning/class/categorie.dart';
import 'package:k_learning/class/login_platform.dart';
import 'package:k_learning/const/color.dart';
import 'package:k_learning/layout/my_app_bar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../class/token.dart';
import '../const/key.dart';
import '../main.dart';

class SignUpScreen extends StatefulWidget {
  final bool isSocial;
  String email; // 선택적으로 email을 받음
  String name; // 선택적으로 name을 받음

  SignUpScreen({
    Key? key,
    required this.isSocial,
    this.email = "",
    this.name = "",
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController nickname = TextEditingController();
  TextEditingController introduce = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _passwordVisible = false;
  bool _isSocial = false;
  final _countryList = ["English", "Vitenamese", "Korean"];
  String _selectCountry = "English";

  static final List<Categorie> _countries = [
    Categorie(id: 1, name: "English"),
    Categorie(id: 2, name: "Vietnamese"),
    Categorie(id: 3, name: "Korean"),
    Categorie(id: 4, name: "Japanese"),
    Categorie(id: 5, name: "Chinese"),
  ];

  @override
  void initState() {
    super.initState();

    _isSocial = widget.isSocial;
    if (_isSocial) {
      email.text = widget.email;
      name.text = widget.name;
      // 입력 불가 기능 추가
    }
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
        )),
        title: Text(
          'SIGN UP',
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
                child: Input('name', name),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Input('nickname', nickname),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Input('introduce', introduce),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButton<String>(
                    value: _selectCountry,
                    items: _countryList
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectCountry = value!;
                      });
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                height: 50,
                width: MediaQuery.of(context).size.width / 1,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: blueColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final dio = Dio();
                    dio.options.baseUrl = baseURL;
                    Map<String, String> param = {
                      'email': email.text,
                      'name': name.text,
                      'nickname': nickname.text,
                      'introduce': introduce.text,
                      'country': _selectCountry,
                      'password': password.text
                    };

                    final response = await dio.post(
                      'auth/signup',
                      data: param,
                    );

                    if (response.statusCode == 200) {
                      String accessToken = response.data['data']['accessToken'];
                      String refreshToken =
                          response.data['data']['refreshToken'];
                      final storage = FlutterSecureStorage();

                      String val = jsonEncode(Token(
                          accessToken: accessToken,
                          refreshToken: refreshToken));
                      await storage.write(key: 'login', value: val);

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen(),
                          ),
                          (route) => false);
                    }
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
          ),
        ],
      ),
    );
  }

  TextField Input(text, TextEditingController controller) {
    return TextField(
      readOnly: _isSocial && (text == 'email' || text == 'name'),
      obscureText: text == 'password' && _passwordVisible,
      controller: controller,
      maxLength: text == 'nickname' ? 8 : (text == 'introduce' ? 30 : null),
      maxLines: text == 'introduce' ? null : 1,
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
