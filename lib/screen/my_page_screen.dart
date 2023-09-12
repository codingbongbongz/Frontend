import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  final String accessToken;

  const MyPageScreen({super.key, required this.accessToken});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String accessToken = '';

  @override
  void initState() {
    super.initState();

    accessToken = widget.accessToken;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
          child: Text('My Page Screen'),
        ),
        Center(
          child: Text('accessToken : $accessToken'),
        ),
      ],
    );
  }
}
