import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_learning/screen/learning_screen.dart';

class LinkScreen extends StatefulWidget {
  final int uid;
  const LinkScreen({super.key, required this.uid});

  @override
  State<LinkScreen> createState() => _LinkScreenState();
}

class _LinkScreenState extends State<LinkScreen> {
  int uid = 0;
  final _formKey = GlobalKey<FormState>();
  String _youtubeLink = '';

  @override
  void initState() {
    super.initState();

    uid = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    final linkController = TextEditingController();

    void onPressed() {
      final formKeyState = _formKey.currentState;
      if (formKeyState!.validate()) {
        formKeyState.save();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => LearningScreen(
                uid: uid,
                link: _youtubeLink.substring(
                  _youtubeLink.indexOf('=') + 1,
                )),
          ),
        );
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
      _youtubeLink = value!;
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
