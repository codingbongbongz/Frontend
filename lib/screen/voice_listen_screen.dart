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
  const VoiceListenScreen(
      {super.key,
      required this.currentTranscript,
      required this.transcriptID,
      required this.videoID});

  @override
  State<VoiceListenScreen> createState() => _VoiceListenScreenState();
}

class _VoiceListenScreenState extends State<VoiceListenScreen> {
  late AudioPlayer audioPlayer;
  late int _transcriptID;
  late int _videoID;
  String _transcript = '';
  Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    _transcript = widget.currentTranscript;
    _transcriptID = widget.transcriptID;
    _videoID = widget.videoID;
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
      // print('videos/$_videoID/transcripts/$_transcriptID/audio');
      final response = await dio.get(
        'videos/$_videoID/transcripts/$_transcriptID/audio',
      );
      if (kDebugMode) {
        // print(response.realUri.runtimeType);
        print(response);
      }

      // await audioPlayer.play(urlSource);
      await audioPlayer.play(UrlSource(response.realUri.toString()));
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
