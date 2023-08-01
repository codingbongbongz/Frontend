import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

// import 'audio_player.dart';

class VoiceInputScreen extends StatefulWidget {
  const VoiceInputScreen({super.key});

  @override
  State<VoiceInputScreen> createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
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
      // print(file);
      log(bytes.toString());
      // File audioFile = File(audioPath);
      // final bytes = audioFile.readAsBytesSync();
      // final byteData = bytes.buffer.asByteData();
      // if (kDebugMode) {
      //   print(audioFile); // print(content);
      //   print(bytes);
      //   print(byteData);
      // }

      // FilePickerResult? result =
      //     await FilePicker.platform.pickFiles(initialDirectory: audioPath);
      // if (result != null) {
      //   print(result.files.first.toString());
      //   // Uint8List? fileBytes = result.files.first.bytes;
      //   // String fileName = result.files.first.name;
      //   // print(fileBytes);
      //   // print(fileName);
      // }
    } catch (e) {
      if (kDebugMode) {
        print("readFile Error : $e");
      }
    }
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        // 경로 지정을 통한 파일 확장자 지정
        // String path;
        // final dir = await getTemporaryDirectory();
        // path = p.join(
        //   "file://${dir.path}",
        //   'audio_${DateTime.now().millisecondsSinceEpoch}.mp4',
        // );

        // if (kDebugMode) {
        //   print(path);
        // }
        // await audioRecord.start(path: path);
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
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
      // readFile(audioPath);
    } catch (e) {
      if (kDebugMode) {
        print('stopRecording Error : $e');
      }
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath);
      print(urlSource);
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
          if (isRecording)
            const Text(
              "Recording in Progress",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ElevatedButton(
            onPressed: isRecording ? stopRecording : startRecording,
            child:
                isRecording ? Text('Stop Recording') : Text('Start Recording'),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: readFile,
            child: Text('readFile'),
          ),
          if (!isRecording && audioPath != '')
            ElevatedButton(
              onPressed: playRecording,
              child: Text('Play Recording'),
            )
        ],
      ),
    ));
  }
}
