import 'package:flutter/material.dart';

class VoiceListenScreen extends StatefulWidget {
  const VoiceListenScreen({super.key});

  @override
  State<VoiceListenScreen> createState() => _VoiceListenScreenState();
}

class _VoiceListenScreenState extends State<VoiceListenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('음성 듣기'),
      ),
    );
  }
}