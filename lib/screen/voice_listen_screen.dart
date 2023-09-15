import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../const/key.dart';

class VoiceListenScreen extends StatefulWidget {
  final String currentTranscript;
  final int transcriptID;
  final int videoID;
  final String accessToken;
  const VoiceListenScreen(
      {super.key,
      required this.currentTranscript,
      required this.transcriptID,
      required this.videoID,
      required this.accessToken});

  @override
  State<VoiceListenScreen> createState() => _VoiceListenScreenState();
}

class _VoiceListenScreenState extends State<VoiceListenScreen> {
  late AudioPlayer audioPlayer;
  late int _transcriptID;
  late int _videoID;
  String _transcript = '';
  String _accessToken = '';
  // Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    _transcript = widget.currentTranscript;
    _transcriptID = widget.transcriptID;
    _videoID = widget.videoID;
    _accessToken = widget.accessToken;
    // dio.options.baseUrl = baseURL;
    // dio.options.headers = {"Authorization": _accessToken};

    // dio.interceptors.add(CustomInterceptors());

    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  Future<void> playRecording() async {
    try {
      var dio = await authDio(context);
      // print('videos/$_videoID/transcripts/$_transcriptID/audio');
      final response = await dio.get(
        'videos/$_videoID/transcripts/$_transcriptID/audio',
        // options: Options(
        //   headers: {"Content-Type": "multipart/form-data"},
        // )
      );
      if (kDebugMode) {
        print(response.realUri.toString());
        // print('${baseURL}videos/$_videoID/transcripts/$_transcriptID/audio');
        // print(response.data);
      }
      await audioPlayer.play(UrlSource(response.realUri.toString()));
      // await audioPlayer.play(UrlSource(
      //     '${baseURL}videos/$_videoID/transcripts/$_transcriptID/audio'));
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
              _transcript,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            ElevatedButton(
              onPressed: playRecording,
              child: const Text('Play Recording'),
            )
          ],
        ),
      ),
    );
  }
}
