import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

import '../const/key.dart';

class VoiceInputScreen extends StatefulWidget {
  final String currentTranscript;
  final int videoID;
  final int transcriptID;
  final String accessToken;

  const VoiceInputScreen(
      {super.key,
      required this.currentTranscript,
      required this.videoID,
      required this.transcriptID,
      required this.accessToken});

  @override
  State<VoiceInputScreen> createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  String _accessToken = '';
  // var tst;
  bool isRecording = false;
  String audioPath = '';

  String _transcript = '';

  late int _transcriptID;
  late int _videoID;
  // Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();

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
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> readFile() async {
    try {
      var dio = await authDio(context);
      final file = File.fromUri(Uri.parse(audioPath));
      final bytes = await file.readAsBytes();

      FormData formData = FormData.fromMap({
        "audio": MultipartFile.fromBytes(bytes, filename: "$_transcript.m4a"),
        "Authorization": _accessToken,
      });

      final response = await dio.post(
        'videos/$_videoID/transcripts/$_transcriptID/audio',
        data: formData,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );
      if (kDebugMode) {
        print(response);
      }
    } catch (e) {
      if (kDebugMode) {
        print("readFile Error : $e");
      }
    }
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();

        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('startRecording Error : $e');
      }
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    } catch (e) {
      if (kDebugMode) {
        print('stopRecording Error : $e');
      }
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath);

      if (kDebugMode) {
        print(audioPath);
      }

      await audioPlayer.play(urlSource);
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
          Text(_transcript),
          if (isRecording)
            const Column(
              children: [
                CircularProgressIndicator(),
                Text(
                  "Recording in Progress",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ElevatedButton(
            onPressed: isRecording ? stopRecording : startRecording,
            child: isRecording
                ? const Text('Stop Recording')
                : const Text('Start Recording'),
          ),
          const SizedBox(
            height: 25,
          ),
          if (!isRecording && audioPath != '')
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: readFile,
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: playRecording,
                  child: const Text('Play Recording'),
                )
              ],
            ),
        ],
      ),
    ));
  }
}
