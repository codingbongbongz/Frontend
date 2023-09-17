import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:k_learning/layout/my_app_bar.dart';

import '../class/token.dart';
import '../const/key.dart';
import '../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var email = TextEditingController();
  var name = TextEditingController();
  var nickname = TextEditingController();
  var introduce = TextEditingController();
  var country = TextEditingController();
  var password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
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
            child: Input('nickname', nickname),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Input('introduce', introduce),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Input('country', country),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Input('password', password),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () async {
                var dio = await authDio(context);
                var param = {
                  'email': email.text,
                  'name': name.text,
                  'nickname': nickname.text,
                  'introduce': introduce.text,
                  'country': country.text,
                  'password': password.text
                };

                final response = await dio.post(
                  'auth/signup',
                  data: param,
                );

                if (response.statusCode == 200) {
                  var accessToken = response.data['data']['accessToken'];
                  var refreshToken = response.data['data']['refreshToken'];
                  print(accessToken);
                  print(refreshToken);
                  final storage = FlutterSecureStorage();

                  var val = jsonEncode(Token(
                      accessToken: accessToken, refreshToken: refreshToken));
                  await storage.write(key: 'login', value: val);

                  // await storage.write(key: 'ACCESS_TOKEN', value: accessToken);
                  // await storage.write(
                  //     key: 'REFRESH_TOKEN', value: refreshToken);

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(),
                      ),
                      (route) => false);
                }
              },
              child: Text('SIGN UP')),
        ],
      ),
    );
  }

  TextField Input(text, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.link),,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.blue),
        ),
        labelText: text,
      ),
    );
  }
}
