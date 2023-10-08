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
    // getNouns();
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  Future<dynamic> getNouns() async {
    var dio = await authDio(context);

    FormData formData = FormData.fromMap({
      // "Authorization": accessToken,
      "sentence": _transcript,
    });
    // var formData = {
    //   "sentence": _transcript,
    // };

    final response = await dio.post(
      'openAI/nouns',
      data: formData,
      options: Options(
        headers: {"Content-Type": "multipart/form-data"},
      ),
    );
    var tmp = response.data['data'];
    print(tmp);

    dynamic responseBody = response.data['data']['nounsAndExamples'];
    print(responseBody);
    print(responseBody.runtimeType);

    List<dynamic> resultList = [];
    // List<Map<String, List<String>>>
    responseBody.forEach((key, value) {
      // List<dynamic> innerList = [];
      Map<String, List<dynamic>> innerMap = {};
      innerMap[key] = value;
      resultList.add(innerMap);
      // innerList.add(key);
      // // innerList.addAll(value);
      // resultList.add(key);
      // resultList.addAll(value);
      // print(key);
      // print(value);
    });

    // print(resultList);
    // resultList.forEach((element) {
    //   // print(element.keys);
    //   print(element.keys.toList()[0]);
    //   var values = element.values.toList()[0];
    //   values.forEach((el) {
    //     print(el);
    //   });
    //   // print(element.values);
    // });
    // var tmp = responseBody.toList();
    // print(tmp);
    return resultList;
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
            SizedBox(
              height: 10,
            ),
            Text(
              _transcript,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            ElevatedButton(
              onPressed: playRecording,
              child: const Text('Play Recording'),
            ),
            // ElevatedButton(
            //   onPressed: getNouns,
            //   child: const Text('용례 생성'),
            // ),
            FutureBuilder(
              future: getNouns(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final data = snapshot.data;

                  return Expanded(
                    flex: 1,
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemCount: data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var nouns = data[index].keys.first;
                        List<String> sentences = (data[index][nouns] as List)
                            .map((item) => item as String)
                            .toList();

                        return ListTile(
                          title: Text(nouns),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: sentences
                                .map((item) => Text(item,
                                    style: TextStyle(
                                      fontSize: 10,
                                    )))
                                .toList(),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
