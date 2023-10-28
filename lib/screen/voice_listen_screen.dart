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
    // getNouns();
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  Future<dynamic> getTranslation() async {
    var dio = await authDio(context);

    final response = await dio.get('translations/$_transcriptID');

    dynamic responseBody = response.data['data'];
    print(responseBody);
    // 임시요
    return responseBody[0]['text'];
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
    // print(tmp);

    dynamic responseBody = response.data['data']['nounsAndExamples'];
    // print(responseBody);
    // print(responseBody.runtimeType);

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
    // return Scaffold(
    //   // appBar: AppBar(),
    //   body:
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
              "정확한 발음 듣기",
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
        // SizedBox(
        //   height: 10,
        // ),
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
        // SizedBox(
        //   height: 10,
        // ),
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
            // height: 40,
            child: ElevatedButton.icon(
              onPressed: playRecording,
              icon: Icon(
                Icons.volume_up,
                color: Colors.white,
              ),
              label: const Text(
                '정확한 발음 듣기',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: blueColor,
                // padding: EdgeInsets.symmetric(
                padding: EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                //   horizontal: MediaQuery.of(context).size.width / 3,
                // ),
                // backgroundColor:
                //     isTextEmpty ? Colors.grey : blueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        // ElevatedButton(
        //   onPressed: getNouns,
        //   child: const Text('용례 생성'),
        // ),
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
                  // separatorBuilder: (BuildContext context, int index) =>
                  //     const Divider(
                  //   thickness: 0.0,
                  // ),
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    var nouns = data[index].keys.first;
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
