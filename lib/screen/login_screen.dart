import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:k_learning/layout/my_app_bar.dart';
import 'package:k_learning/screen/sign_up_screen.dart';

import '../const/key.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();
  String ID = '';
  String PW = '';
  @override
  void initState() {
    super.initState();

    dio.options.baseUrl = baseURL;
    dio.options.headers = {"userId": 1};
    dio.interceptors.add(CustomInterceptors());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            color: Colors.blue.shade100,
            width: 100,
            height: 100,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[350]),
              'K-learning'),
          SizedBox(
            height: 10,
          ),
          Text('K-컨텐츠를 통해 쉽고 재밌게 한국어를 학습해보세요!'),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  ID = text;
                });
              },
              decoration: const InputDecoration(
                // prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelText: 'ID',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  PW = text;
                });
              },
              decoration: const InputDecoration(
                // prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelText: 'PW',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SignUpScreen(),
                ),
              );
            },
            child: Text('SIGN UP'),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () async {
                final rawString = '$ID:$PW';

                Codec<String, String> stringToBase64 = utf8.fuse(base64);
                String token = stringToBase64.encode(rawString);
                final response = await dio.get('auth/signin',
                    options: Options(headers: {
                      'Authorization': 'Basic $token',
                    }));
              },
              child: Text('LOGIN')),
        ],
      ),
    );
  }
}
