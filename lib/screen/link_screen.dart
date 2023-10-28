import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:k_learning/const/color.dart';
// import 'package:flutter/services.dart';
import 'package:k_learning/screen/learning_screen.dart';

import '../const/key.dart';

class LinkScreen extends StatefulWidget {
  const LinkScreen({super.key});

  @override
  State<LinkScreen> createState() => _LinkScreenState();
}

class _LinkScreenState extends State<LinkScreen> {
  int videoID = 1;
  final _formKey = GlobalKey<FormState>();
  String _youtubeLink = '';
  TextEditingController _textController = TextEditingController();
  bool isTextEmpty = true;

  void uploadLink(context) async {
    var dio = await authDio(context);
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
          link: _youtubeLink,
          videoID: videoID,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      isTextEmpty = _textController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final linkController = TextEditingController();

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
    // showModalBottomSheet(context: context, builder: (BuildContext context) {

    // });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(children: [
          Container(
            width: double.infinity,
            height: 56.0,
            child: Center(
                child: Text(
              "영상 링크 추가",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ) // Your desired title
                ),
          ),
          Positioned(
              left: 0.0,
              top: 0.0,
              child: IconButton(
                  icon: Icon(Icons.close), // Your desired icon
                  onPressed: () {
                    Navigator.of(context).pop();
                  }))
        ]),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width / 1,
              child: TextFormField(
                validator: validator,
                onSaved: onSaved,
                controller: _textController,
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
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // padding: EdgeInsets.symmetric(
                //   horizontal: MediaQuery.of(context).size.width / 3,
                // ),
                backgroundColor: isTextEmpty ? Colors.grey : blueColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: onPressed,
              child: const Text('Start Learning'),
            ),
          ),
        ),
      ],
    );
  }
}
