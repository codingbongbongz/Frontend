import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../const/key.dart';

class EditUserInfoScreen extends StatefulWidget {
  final String nickname;
  final String introduce;

  const EditUserInfoScreen({
    super.key,
    required this.nickname,
    required this.introduce,
  });

  @override
  State<EditUserInfoScreen> createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  var nickname = TextEditingController();
  var introduce = TextEditingController();
  String _nickname = '';
  String _introduce = '';

  patchUserInfo() async {
    var dio = await authDio(context);
    FormData formData = FormData.fromMap({
      // "Authorization": accessToken,
      "nickname": nickname.text,
      "introduce": introduce.text,
    });
    final response = await dio.patch(
      'mypage',
      data: formData,
      options: Options(
        headers: {"Content-Type": "multipart/form-data"},
      ),
    );

    dynamic responseBody = response.data['data'];
    // print(responseBody);
  }

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname;
    _introduce = widget.introduce;
    nickname.text = _nickname;
    introduce.text = _introduce;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              color: Colors.amber,
              height: 50,
              width: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nickname,
                maxLength: 10,
                decoration: InputDecoration(
                  // prefixIcon: Icon(Icons.link),,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelText: 'nickname',
                  // hintText: _nickname,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: introduce,
                maxLength: 30,
                maxLines: null,
                decoration: InputDecoration(
                  // prefixIcon: Icon(Icons.link),,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelText: 'introduce',
                  // contentPadding: EdgeInsets.symmetric(vertical: 30.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: patchUserInfo,
              child: const Text('edit UserInfo'),
            )
          ],
        ),
      ),
    );
  }
}
