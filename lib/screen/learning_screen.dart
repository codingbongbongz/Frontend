import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:k_learning/class/evaluation.dart';
import 'package:k_learning/layout/my_app_bar.dart';
import 'package:k_learning/main.dart';
import 'package:k_learning/screen/voice_input_screen.dart';
import 'package:k_learning/screen/voice_listen_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../class/transcript.dart';
import '../const/key.dart';

class LearningScreen extends StatefulWidget {
  final int userID;
  final String link;
  final int videoID;
  const LearningScreen(
      {super.key,
      required this.userID,
      required this.link,
      required this.videoID});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  int uid = 1;
  String link = '';
  int videoId = 1;
  int currentDuration = 0;
  bool isWholeCaption = true;
  bool isPartCaption = false;
  String currentTranscript = '';
  int currentTrasncriptId = 0;
  late List<bool> isSelected;

  Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();

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
  Evaluation? _evaluations;
  // bool isEvaluated = false;
  List<_ChartData>? data;
  late TooltipBehavior _tooltip;

  Future<List<Transcript>> getTranscripts() async {
    final response = await dio.get('videos/$videoId/transcripts');

    if (kDebugMode) {
      // print("response : $response");
      // print("response.runtimeType : ${response.runtimeType}");

      print(response.data['data']['transcripts']);
    }
    List<dynamic> responseBody = response.data['data']['transcripts'];
    // _popularVideos =
    //     responseBody.map((e) => Video.fromJson(e)).toList(); // map을 오브젝트로 변환

    // return responseBody.map((e) => Video.fromJson(e)).toList();
    // print(_popularVideos.length);
    // print(responseBody);
    _transcripts = responseBody.map((e) => Transcript.fromJson(e)).toList();
    return responseBody.map((e) => Transcript.fromJson(e)).toList();
    // return null;
  }

  @override
  void initState() {
    isSelected = [isWholeCaption, isPartCaption];

    super.initState();

    uid = widget.userID;
    link = widget.link;
    videoId = widget.videoID;

    dio.options.baseUrl = baseURL;
    dio.options.headers = {"userID": 1};
    getTranscripts();
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

    String jsonString2 = '''
    {
    "status": 200,
    "message": "발음을 분석하는데 성공했습니다.",
    "data": {
        "evaluation": {
            "evaluationId": 1,
            "overall": 85,
            "pronunciation": 82,
            "fluency": 100,
            "integrity": 100,
            "rhythm": 86,
            "speed": 189,
            "createdAt": "2023-08-07T06:32:04.592+00:00"
        },
        "transcriptId": 1,
        "userId": 1
        }
    }
    ''';
    // _captions = listTranscriptsFromJson(jsonString);
    _evaluations = evaluationsFromJson(jsonString2);
    // isEvaluated = true;
    // currentTranscript = _transcripts[0].sentence;
    // if (isEvaluated()) {
    //   data = [
    //     _ChartData('overall', _evaluations!.overall),
    //     _ChartData('pronunciation', _evaluations!.pronunciation),
    //     _ChartData('fluency', _evaluations!.fluency),
    //     _ChartData('integrity', _evaluations!.integrity),
    //     _ChartData('rhythm', _evaluations!.rhythm),
    //     _ChartData('speed', _evaluations!.speed),
    //   ];
    // }
    _tooltip = TooltipBehavior(enable: true);
    // print(_evaluations);
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: false,
        progressIndicatorColor: Colors.blueAccent,
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
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Finish Learning?",
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Yes"),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) => MainScreen(
                                userID: uid,
                              ),
                            ),
                            (route) => false);
                      },
                    ),
                  ],
                );
              });
        }),
      ),
      builder: (context, player) => Scaffold(
        appBar: const MyAppBar(),
        body: ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ToggleButtons(
                    isSelected: isSelected,
                    onPressed: toggleSelect,
                    constraints: const BoxConstraints(
                      minHeight: 30,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('전체 자막'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('실시간 자막'),
                      ),
                    ],
                  ),
                  _space,
                  if (isWholeCaption)
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
                                ? Text(
                                    _transcripts[index].sentence,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(_transcripts[index].sentence),
                          );
                          return Row(
                            children: [
                              inkWell,
                            ],
                          );
                        },
                      ),
                    ),
                  if (isPartCaption)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 70,
                          child: ListView.builder(
                            itemCount: _transcripts.length,
                            itemBuilder: (BuildContext context, int index) {
                              Widget inkWell = Container();
                              if (isCurrentCaption(context, index)) {
                                inkWell = InkWell(
                                  onTap: () {},
                                  child: Text(
                                    _transcripts[index].sentence,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                );
                                currentTranscript =
                                    _transcripts[index].sentence;
                                currentTrasncriptId = index;
                              }
                              return inkWell;
                            },
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                _controller.pause();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: VoiceListenScreen(
                                        currentTranscript: currentTranscript,
                                        transcriptID: currentTrasncriptId,
                                        videoID: videoId,
                                      ),
                                      insetPadding: const EdgeInsets.all(8.0),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('확인'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                '정확한 발음 듣기',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _controller.pause();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: VoiceInputScreen(
                                        currentTranscript: currentTranscript,
                                        transcriptID: currentTrasncriptId,
                                        videoID: videoId,
                                      ),
                                      insetPadding: const EdgeInsets.all(8.0),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('확인'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                '발음 연습하기',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (isEvaluated()) barChart(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);

  Widget barChart() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(
            labelStyle: const TextStyle(
          fontSize: 11,
        )),
        primaryYAxis: NumericAxis(minimum: 0, maximum: 200, interval: 10),
        tooltipBehavior: _tooltip,
        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
            dataSource: data!,
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            name: 'evaulation',
            color: const Color.fromRGBO(8, 142, 255, 1),
            width: 0.5,
          )
        ]);
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

  bool isEvaluated() {
    // final response =

    data = [
      _ChartData('overall', _evaluations!.overall),
      _ChartData('pronunciation', _evaluations!.pronunciation),
      _ChartData('fluency', _evaluations!.fluency),
      _ChartData('integrity', _evaluations!.integrity),
      _ChartData('rhythm', _evaluations!.rhythm),
      _ChartData('speed', _evaluations!.speed),
    ];
    return true;
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

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
