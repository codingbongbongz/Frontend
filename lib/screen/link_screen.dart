import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:k_learning/screen/learning_screen.dart';

import '../const/key.dart';

class LinkScreen extends StatefulWidget {
  // final String accessToken;
  const LinkScreen({super.key});

  @override
  State<LinkScreen> createState() => _LinkScreenState();
}

class _LinkScreenState extends State<LinkScreen> {
  // String accessToken = '';
  int videoID = 1;
  final _formKey = GlobalKey<FormState>();
  String _youtubeLink = '';

  // Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();

  void uploadLink(context) async {
    var dio = await authDio(context);
    // print(_youtubeLink);
    FormData formData = FormData.fromMap({
      // "Authorization": accessToken,
      "link": _youtubeLink,
    });

    final response = await dio.post(
      'upload',
      data: formData,
      options: Options(
        headers: {"Content-Type": "multipart/form-data"},
        // contentType: Headers.multipartFormDataContentType,
      ),
    );
    // print(response.data['data']['videoId']);
    // codingbongbongz://video/3fa0fsafsah
    // iOS: x-callback-url
    videoID = response.data['data']['videoId'];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => LearningScreen(
          // accessToken: accessToken,
          link: _youtubeLink,
          videoID: videoID,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // dio.options.baseUrl = baseURL;
    // dio.interceptors.add(CustomInterceptors());
    // accessToken = widget.accessToken;
    // dio.options.headers = {"Authorization": accessToken};
  }

  @override
  Widget build(BuildContext context) {
    final linkController = TextEditingController();

    void onPressed() {
      final formKeyState = _formKey.currentState;
      if (formKeyState!.validate()) {
        formKeyState.save();
        uploadLink(context);
      }
    }

    String? validator(String? value) {
      if (value == null || value.isEmpty) {
        return '유튜브 링크를 입력해주세요.';
      }

      // 유튜브 링크 검증
      bool isYoutubeLink =
          value.startsWith("https://www.youtube.com/watch?v=") ||
              value.startsWith("https://youtu.be/");

      if (!isYoutubeLink) {
        return '유효한 유튜브 링크가 아닙니다.';
      }

      return null;
    }

    void onSaved(String? value) {
      _youtubeLink = value!.substring(value.indexOf('=') + 1);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: TextFormField(
              validator: validator,
              onSaved: onSaved,
              controller: linkController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelText: 'Input Youtube Link',
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (String value) {
                onPressed();
              },
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('Start Learning'),
        ),
      ],
    );
  }
}
