import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../const/key.dart';

class VoiceListenScreen extends StatefulWidget {
  final String currentCaption;
  const VoiceListenScreen(
      {super.key,
      required this.currentCaption,
      required int transcriptID,
      required int videoID});

  @override
  State<VoiceListenScreen> createState() => _VoiceListenScreenState();
}

class _VoiceListenScreenState extends State<VoiceListenScreen> {
  late AudioPlayer audioPlayer;
  String _caption = '';
  Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    _caption = widget.currentCaption;
    dio.options.baseUrl = baseURL;
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  Future<void> playRecording() async {
    try {
      final response = await dio.get(
        'videos/1/transcripts',
      );
      if (kDebugMode) {
        // print(response.realUri.runtimeType);
        print(response);
      }

      // await audioPlayer.play(urlSource);
      // await audioPlayer.play(UrlSource(response.realUri.toString()));
    } catch (e) {
      if (kDebugMode) {
        print('playRecording Error : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _caption,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            ElevatedButton(
              onPressed: playRecording,
              child: Text('Play Recording'),
            )
          ],
        ),
      ),
    );
  }
}
