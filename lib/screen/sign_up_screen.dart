import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:k_learning/layout/my_app_bar.dart';

import '../const/key.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();

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
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
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
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () async {
                final rawString = 'test@@';

                Codec<String, String> stringToBase64 = utf8.fuse(base64);
                String token = stringToBase64.encode(rawString);
                final response = await dio.get('auth/signup',
                    options: Options(headers: {
                      'Authorization': 'Basic $token',
                    }));
              },
              child: Text('SIGN UP')),
        ],
      ),
    );
  }
}
