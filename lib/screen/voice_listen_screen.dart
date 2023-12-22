import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:k_learning/const/color.dart';

import '../const/key.dart';

class VoiceListenScreen extends StatefulWidget {
  final String currentTranscript;
  final int transcriptID;
  final int videoID;
  const VoiceListenScreen({
    super.key,
    required this.currentTranscript,
    required this.transcriptID,
    required this.videoID,
  });

  @override
  State<VoiceListenScreen> createState() => _VoiceListenScreenState();
}

class _VoiceListenScreenState extends State<VoiceListenScreen> {
  late AudioPlayer audioPlayer;
  late int _transcriptID;
  late int _videoID;
  String _transcript = '';

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _transcript = widget.currentTranscript;
    _transcriptID = widget.transcriptID;
    _videoID = widget.videoID;
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  Future<dynamic> getTranslation() async {
    final dio = await authDio(context);

    final response = await dio.get('translations/$_transcriptID');

    dynamic responseBody = response.data['data'];
    // print(responseBody);
    // 임시요
    return responseBody[0]['text'];
  }

  Future<dynamic> getNouns() async {
    final dio = await authDio(context);

    FormData formData = FormData.fromMap({
      "sentence": _transcript,
    });

    final response = await dio.post(
      'openAI/nouns',
      data: formData,
      options: Options(
        headers: {"Content-Type": "multipart/form-data"},
      ),
    );

    dynamic responseBody = response.data['data']['nounsAndExamples'];

    List<dynamic> resultList = [];
    responseBody.forEach((key, value) {
      Map<String, List<dynamic>> innerMap = {};
      innerMap[key] = value;
      resultList.add(innerMap);
    });

    return resultList;
  }

  Future<void> playRecording() async {
    try {
      final dio = await authDio(context);
      final response = await dio.get(
        'videos/$_videoID/transcripts/$_transcriptID/audio',
      );
      if (kDebugMode) {
        print(response.realUri.toString());
      }
      await audioPlayer.play(UrlSource(response.realUri.toString()));
    } catch (e) {
      if (kDebugMode) {
        print('playRecording Error : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(children: [
          Container(
            width: double.infinity,
            height: 56.0,
            child: Center(
                child: Text(
              "Listen the exact pronunciation",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ) // Your desired title
                ),
          ),
          Positioned(
              left: 0.0,
              top: 0.0,
              child: IconButton(
                  icon: Icon(Icons.close), // Your desired icon
                  onPressed: () {
                    Navigator.of(context).pop();
                  }))
        ]),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
            bottom: 5.0,
          ),
          child: Text(
            _transcript,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: 0.0,
          ),
          child: FutureBuilder(
            future: getTranslation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final data = snapshot.data;

                return Text(data,
                    style: const TextStyle(
                      fontSize: 15,
                      color: greyColor,
                    ));
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1.0,
            child: ElevatedButton.icon(
              onPressed: playRecording,
              icon: Icon(
                Icons.volume_up,
                color: Colors.white,
              ),
              label: const Text(
                'Listen the exact pronunciation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: blueColor,
                padding: EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        FutureBuilder(
          future: getNouns(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final data = snapshot.data;

              return Expanded(
                flex: 1,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    String nouns = data[index].keys.first;
                    List<String> sentences = (data[index][nouns] as List)
                        .map((item) => item as String)
                        .toList();
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              12.0), // 원하는 BorderRadius 값 설정
                          color: MediaQuery.of(context).platformBrightness ==
                                  Brightness.light
                              ? lightGreyColor
                              : Colors.grey[800], // ListTile의 배경색 설정
                        ),
                        // margin: EdgeInsets.all(8.0),
                        // width: MediaQuery.of(context).size.width * 0.1,
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          child: ListTile(
                            title: Text(
                              nouns,
                              style: TextStyle(
                                color: blueColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: sentences
                                  .map((item) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Text(item,
                                            style: TextStyle(
                                              fontSize: 15,
                                            )),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        )
      ],
    );
  }
}
