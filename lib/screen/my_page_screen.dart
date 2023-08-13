import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  final int uid;

  const MyPageScreen({super.key, required this.uid});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  int uid = 0;

  @override
  void initState() {
    super.initState();

    uid = widget.uid;
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
          child: Text('uid : $uid'),
        ),
      ],
    );
  }
}
