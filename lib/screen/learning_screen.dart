import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:k_learning/class/evaluation.dart';
import 'package:k_learning/const/color.dart';
import 'package:k_learning/layout/my_app_bar.dart';
import 'package:k_learning/main.dart';
import 'package:k_learning/screen/voice_input_screen.dart';
import 'package:k_learning/screen/voice_listen_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../class/transcript.dart';
import '../const/key.dart';

class LearningScreen extends StatefulWidget {
  final String link;
  final int videoID;
  const LearningScreen({super.key, required this.link, required this.videoID});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _ChartData {
  final String x;
  final int y;

  _ChartData(this.x, this.y);
}

class _LearningScreenState extends State<LearningScreen> {
  String link = '';
  int videoId = 1;
  int currentDuration = 0;
  bool isWholeCaption = true;
  bool isPartCaption = false;
  String currentTranscript = '';
  int currentTrasncriptId = 0;
  int currentIndex = 0;
  late List<bool> isSelected;

  late StreamController<List<_ChartData>> _data;

  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  var currentValue = YoutubePlayerValue();

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  // double _volume = 100;
  // bool _muted = false;
  bool _isPlayerReady = false;

  List<Transcript> _transcripts = [];
  List<Evaluation> _evaluations = [];
  late TooltipBehavior _tooltip;

  bool learnedPreviously(currentCaptionEvaluation) {
    if (currentCaptionEvaluation.overall == 0 &&
        currentCaptionEvaluation.pronunciation == 0 &&
        currentCaptionEvaluation.fluency == 0 &&
        currentCaptionEvaluation.integrity == 0 &&
        currentCaptionEvaluation.rhythm == 0 &&
        currentCaptionEvaluation.speed == 0) {
      return false;
    }
    return true;
  }

  Future<dynamic> getTranslation(transcriptID) async {
    var dio = await authDio(context);

    final response = await dio.get('translations/$transcriptID');

    dynamic responseBody = response.data['data'];
    print(responseBody);
    // 임시요
    return responseBody[0]['text'];
  }

  void getTranscripts() async {
    var dio = await authDio(context);
    final response = await dio.get('videos/$videoId/transcripts');
    List<dynamic> responseBody = response.data['data']['transcripts'];
    _transcripts = responseBody.map((e) => Transcript.fromJson(e)).toList();
  }

  void getEvaluation() async {
    var dio = await authDio(context);
    // FormData formData = FormData.fromMap({
    //   "Authorization": accessToken,
    // });
    final response = await dio.get(
      'videos/$videoId/audio/previous',
      // data: formData,
      // options: Options(
      //   headers: {"Content-Type": "multipart/form-data"},
      //   // contentType: Headers.multipartFormDataContentType,
      // ),
    );

    if (response.data['status'] == 404) {
      _data.add([]);
    } else {
      List<dynamic> responseBody = response.data['data']['evaluations'];
      _evaluations = responseBody
          .map((e) => Evaluation.fromJson(e))
          .toList(); // map을 오브젝트로 변환
    }
  }

  @override
  void initState() {
    isSelected = [isWholeCaption, isPartCaption];

    _data = StreamController<List<_ChartData>>.broadcast();
    _data.add([
      _ChartData('overall', 0),
      _ChartData('pronunciation', 0),
      _ChartData('fluency', 0),
      _ChartData('integrity', 0),
      _ChartData('rhythm', 0),
      _ChartData('speed', 0),
    ]);

    link = widget.link;
    videoId = widget.videoID;

    getTranscripts();
    getEvaluation();

    _controller = YoutubePlayerController(
      initialVideoId: link,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    _tooltip = TooltipBehavior(enable: true);

    super.initState();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    Future.delayed(const Duration(milliseconds: 50)).then((_) {
      _controller.dispose();
      _idController.dispose();
      _seekToController.dispose();
    });
    _data.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: false,
        progressIndicatorColor: blueColor,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: ((data) {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height *
                      0.3, // 원하는 height로 조절
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Are you sure you want to end the learning?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Your learning will not be saved.',
                          style: TextStyle(
                            color: greyColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  // horizontal:
                                  //     MediaQuery.of(context).size.width / 6,
                                  vertical:
                                      MediaQuery.of(context).size.width / 15,
                                ),
                                backgroundColor: Color(0xFFE0E0E0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  // horizontal:
                                  //     MediaQuery.of(context).size.width / 6,
                                  vertical:
                                      MediaQuery.of(context).size.width / 15,
                                ),
                                backgroundColor: blueColor,
                                //     isTextEmpty ? Colors.grey : blueColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MainScreen(),
                                    ),
                                    (route) => false);
                              },
                              child: const Text('Finish Learning',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );

                // return AlertDialog(
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10.0)),
                //   content: const Column(
                //     mainAxisSize: MainAxisSize.min,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       Text(
                //         "Finish Learning?",
                //       ),
                //     ],
                //   ),
                //   actions: <Widget>[
                //     ElevatedButton(
                //       child: const Text("No"),
                //       onPressed: () {
                //         Navigator.pop(context);
                //       },
                //     ),
                //     ElevatedButton(
                //       child: const Text("Yes"),
                //       onPressed: () {
                //         Navigator.of(context).pushAndRemoveUntil(
                //             MaterialPageRoute(
                //               builder: (BuildContext context) => MainScreen(),
                //             ),
                //             (route) => false);
                //       },
                //     ),
                //   ],
                // );
              });
        }),
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          backgroundColor: getPlatformDependentColor(
              context, Colors.white, Colors.grey[850]),
          elevation: 0,
          iconTheme: IconThemeData(
            color: blueColor, //색변경
          ),
        ),
        body: ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ToggleButtons(
                    isSelected: isSelected,
                    onPressed: toggleSelect,
                    constraints: const BoxConstraints(
                      minHeight: 30,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    fillColor: Colors.black,
                    selectedColor: Colors.white,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text('Full Caption'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text('Real-time Caption'),
                      ),
                    ],
                  ),
                  // _space,
                  if (isWholeCaption &&
                      _transcripts.isNotEmpty &&
                      _evaluations.isNotEmpty)
                    SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemCount: _transcripts.length,
                        itemBuilder: (BuildContext context, int index) {
                          var inkWell = InkWell(
                            onTap: () {
                              int sec = _transcripts[index].startTime.floor();
                              int milliSec =
                                  ((_transcripts[index].startTime - sec) * 1000)
                                      .toInt();

                              _controller.seekTo(Duration(
                                  seconds: sec, milliseconds: milliSec));
                              toggleSelect(1);
                            },
                            child: (isCurrentCaption(context, index))
                                ? (learnedPreviously(_evaluations[index])
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                          _transcripts[index].sentence,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                          _transcripts[index].sentence,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ))
                                : ((learnedPreviously(_evaluations[index])
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                          _transcripts[index].sentence,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                            _transcripts[index].sentence,
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ))),
                          );
                          return Row(
                            children: [
                              inkWell,
                            ],
                          );
                        },
                      ),
                    ),
                  if (isPartCaption &&
                      _transcripts.isNotEmpty &&
                      _evaluations.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            itemCount: _transcripts.length,
                            itemBuilder: (BuildContext context, int index) {
                              Widget inkWell = Container();
                              if (isCurrentCaption(context, index)) {
                                inkWell = InkWell(
                                  onTap: () {},
                                  child:
                                      (learnedPreviously(_evaluations[index]))
                                          ? Text(
                                              _transcripts[index].sentence,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                  fontSize: 20),
                                            )
                                          : Text(
                                              _transcripts[index].sentence,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                );
                                currentTranscript =
                                    _transcripts[index].sentence;
                                currentTrasncriptId =
                                    _transcripts[index].transcriptId;
                                currentIndex = index;

                                // 현재 자막에 해당하는 학습 결과 출력
                                // print(_evaluations[index].overall);
                                _data.add([
                                  _ChartData(
                                      'overall', _evaluations[index].overall),
                                  _ChartData('pronunciation',
                                      _evaluations[index].pronunciation),
                                  _ChartData(
                                      'fluency', _evaluations[index].fluency),
                                  _ChartData('integrity',
                                      _evaluations[index].integrity),
                                  _ChartData(
                                      'rhythm', _evaluations[index].rhythm),
                                  _ChartData(
                                      'speed', _evaluations[index].speed),
                                ]);
                              }
                              return inkWell;
                            },
                          ),
                        ),
                        OutlinedButton.icon(
                          icon: Icon(
                            Icons.volume_up_outlined,
                            color: getPlatformDependentColor(
                                context, Colors.black, Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                            // padding: EdgeInsets.symmetric(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            //   horizontal: MediaQuery.of(context).size.width / 3,
                            // ),
                            // backgroundColor:
                            //     isTextEmpty ? Colors.grey : blueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            _controller.pause();
                            // var translation =
                            //     await getTranslation(currentTrasncriptId);
                            // print(translation);
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(36.0),
                                      topRight: Radius.circular(36.0)),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.94,
                                    child: VoiceListenScreen(
                                      currentTranscript: currentTranscript,
                                      transcriptID: currentTrasncriptId,
                                      videoID: videoId,
                                      // accessToken: accessToken,
                                    ),

                                    // insetPadding: const EdgeInsets.all(8.0),
                                    // actions: [
                                    //   TextButton(
                                    //     onPressed: () {
                                    //       Navigator.of(context).pop();
                                    //     },
                                    //     child: const Text('확인'),
                                    //   ),
                                    // ],
                                  ),
                                );
                              },
                            );
                          },
                          label: Text(
                            'Listen The Exact Pronunciation',
                            style: TextStyle(
                              color: getPlatformDependentColor(
                                  context, Colors.black, Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (isPartCaption)
                    StreamBuilder(
                        stream: _data.stream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LinearProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final data = snapshot.data;
                            return barChart(data);
                          }
                        }),
                  if (isPartCaption)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          // padding: EdgeInsets.symmetric(
                          //   horizontal: MediaQuery.of(context).size.width / 3,
                          // ),
                          backgroundColor: blueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {
                          _controller.pause();
                          // var translation =
                          //     await getTranslation(currentTrasncriptId);
                          // print(translation);
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36.0),
                            ),
                            isScrollControlled: true,
                            // isDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(36.0),
                                    topRight: Radius.circular(36.0)),
                                child: VoiceInputScreen(
                                  currentTranscript: currentTranscript,
                                  transcriptID: currentTrasncriptId,
                                  videoID: videoId,
                                  // accessToken: accessToken,
                                ),
                              );
                            },
                          ).whenComplete(() {
                            setState(() {
                              getEvaluation();
                            });
                            _controller.play();
                          });
                        },
                        icon: Icon(Icons.mic, color: Colors.white),
                        label: const Text(
                          'Practice Pronunciation',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);

  Widget barChart(data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          width: MediaQuery.of(context).size.width * 1.5,
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            border: Border.all(
              color: lightGreyColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SfCartesianChart(
              // borderColor: lightGreyColor,
              primaryXAxis: CategoryAxis(
                labelStyle: const TextStyle(
                  fontSize: 16,
                ),
                majorGridLines: MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 100,
                interval: 25,
                // isVisible: false,
              ),
              // primaryYAxis: CategoryAxis(),
              tooltipBehavior: _tooltip,
              margin: EdgeInsets.all(10),
              // plotAreaBorderWidth: 0,
              series: <ChartSeries<_ChartData, String>>[
                ColumnSeries<_ChartData, String>(
                  dataSource: data!,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  name: 'evaulation',
                  color: blueColor,
                  width: 0.5,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6)),
                )
              ]),
        ),
      ),
    );
  }

  void toggleSelect(value) {
    if (value == 0) {
      isWholeCaption = true;
      isPartCaption = false;
    } else {
      isWholeCaption = false;
      isPartCaption = true;
    }

    setState(() {
      isSelected = [isWholeCaption, isPartCaption];
    });
  }

  bool isCurrentCaption(BuildContext context, int index) {
    if (_transcripts[index].startTime > _controller.value.position.inSeconds) {
      return false;
    }
    if (index < _transcripts.length - 1 &&
        _transcripts[index + 1].startTime <=
            _controller.value.position.inSeconds) {
      return false;
    }
    return true;
  }
}
