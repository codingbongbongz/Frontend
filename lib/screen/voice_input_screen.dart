import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

import '../const/key.dart';

class VoiceInputScreen extends StatefulWidget {
  final String currentTranscript;
  final int videoID;
  final int transcriptID;
  const VoiceInputScreen(
      {super.key,
      required this.currentTranscript,
      required this.videoID,
      required this.transcriptID});

  @override
  State<VoiceInputScreen> createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  // var tst;
  bool isRecording = false;
  String audioPath = '';

  String _transcript = '';

  late int _transcriptID;
  late int _videoID;
  Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();

    _transcript = widget.currentTranscript;
    _transcriptID = widget.transcriptID;
    _videoID = widget.videoID;
    dio.options.baseUrl = baseURL;

    // dio.options.headers = {"userID": 1};
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (
        RequestOptions options,
        RequestInterceptorHandler handler,
      ) {
        if (options.contentType == null) {
          final dynamic data = options.data;
          final String? contentType;
          if (data is FormData) {
            contentType = Headers.multipartFormDataContentType;
          } else if (data is Map) {
            contentType = Headers.formUrlEncodedContentType;
          } else if (data is String) {
            contentType = Headers.jsonContentType;
          } else if (data != null) {
            contentType =
                Headers.textPlainContentType; // Can be removed if unnecessary.
          } else {
            contentType = null;
          }
          options.contentType = contentType;
        }
        handler.next(options);
      },
    ));
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
      final file = File.fromUri(Uri.parse(audioPath));
      final bytes = await file.readAsBytes();

      FormData formData = FormData.fromMap({
        "audio": MultipartFile.fromBytes(bytes, filename: "$_transcript.opus"),
        "userId": 1
      });

      final response = await dio.post(
        'videos/$_videoID/transcripts/$_transcriptID/audio',
        data: formData,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
          // contentType: Headers.multipartFormDataContentType,
        ),
      );
      print(response);
    } catch (e) {
      if (kDebugMode) {
        print("readFile Error : $e");
      }
    }
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        // final tempDir = await getApplicationDocumentsDirectory();
        // String path = '${tempDir.path}/audio.m4a';
        // if (path.startsWith('/Users')) {
        //   path = 'file://$path';
        // }
        // print(path);
        String path = Directory.systemTemp.path;
        // path ??= p.join(
        //   Directory.systemTemp.path,
        // );

        path = p.withoutExtension(p.normalize(path));
        path += '/$_transcript.ogg';
        print(path);
        await audioRecord.start(path: path, encoder: AudioEncoder.opus);

        // await audioRecord.start();

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

      // final file = File.fromUri(Uri.parse(audioPath));
      // final bytes = await file.readAsBytes();
      // Source byteSource = BytesSource(bytes);
      if (kDebugMode) {
        print(audioPath);
      }
      // await audioPlayer.play(byteSource);

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
