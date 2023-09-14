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
  Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();
  var email = TextEditingController();
  var name = TextEditingController();
  var nickname = TextEditingController();
  var introduce = TextEditingController();
  var country = TextEditingController();
  var password = TextEditingController();

  @override
  void initState() {
    super.initState();

    dio.options.baseUrl = baseURL;
    dio.interceptors.add(CustomInterceptors());
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
                var param = {
                  'email': email.text,
                  'name': name.text,
                  'nickname': nickname.text,
                  'introduce': introduce.text,
                  'country': country.text,
                  'password': password.text
                };
                // print(email.text);
                // print(name.text);
                // print(nickname.text);
                // print(introduce.text);
                // print(country.text);
                // print(password.text);

                // Codec<String, String> stringToBase64 = utf8.fuse(base64);
                // String token = stringToBase64.encode(rawString);
                final response = await dio.post(
                  'auth/signup',
                  data: param,
                );
                // print(response.data['data']);
                // print(response.data['status']);
                if (response.statusCode == 200) {
                  // final jsonBody =
                  //     json.decode(response.data['data'].toString());
                  var accessToken = response.data['data']['accessToken'];
                  var refreshToken = response.data['data']['refreshToken'];
                  print(accessToken);
                  print(refreshToken);
                  final storage = FlutterSecureStorage();

                  var val = jsonEncode(Token(
                      accessToken: accessToken, refreshToken: refreshToken));
                  await storage.write(key: 'login', value: val);

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(
                          accessToken: accessToken,
                        ),
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
