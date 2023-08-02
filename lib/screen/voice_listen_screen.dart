import 'package:flutter/material.dart';

class VoiceListenScreen extends StatefulWidget {
  final String currentCaption;
  const VoiceListenScreen({super.key, required this.currentCaption});

  @override
  State<VoiceListenScreen> createState() => _VoiceListenScreenState();
}

class _VoiceListenScreenState extends State<VoiceListenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.currentCaption),
      ),
    );
  }
}
