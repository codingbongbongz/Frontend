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

  static late List<Transcript> _captions;
  Evaluation? _evaluations;
  // bool isEvaluated = false;
  List<_ChartData>? data;
  late TooltipBehavior _tooltip;

  void getTranscripts() async {
    final response = await dio.get('videos/$videoId/transcripts');
    //
    if (kDebugMode) {
      print("response : $response");
    }
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

    _controller = YoutubePlayerController(
      initialVideoId: link,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
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

    String jsonString = """{
      "transcripts": [
        {"duration": 3.46, "start": 0.48, "sentence": "다한 만큼"},
        {"duration": 4.44, "start": 2.04, "sentence": "에이스가 화 수 있겠지"},
        {"duration": 5.21, "start": 3.94, "sentence": "[박수]"},
        {"duration": 4.8, "start": 6.48, "sentence": "모두 스토 씨가 15년 그러나 강"},
        {"duration": 5.609, "start": 9.15, "sentence": "수유 선수는 8개월 밖에 되지 않아"},
        {"duration": 8.159, "start": 11.28, "sentence": "예 오 d2 싸 우욱 나 볼 짧게"},
        {"duration": 6.371, "start": 14.759, "sentence": "파악하고 아 아 아 아"},
        {"duration": 4.051, "start": 19.439, "sentence": "월 9일 깔"},
        {"duration": 4.94, "start": 21.13, "sentence": "[음악]"},
        {"duration": 4.859, "start": 23.49, "sentence": "to 자 자 파이팅을 외치면서"},
        {"duration": 3.66, "start": 26.07, "sentence": "시작합니다 5기 된 상수는 탕수육에"},
        {"duration": 3.121, "start": 28.349, "sentence": "5기"},
        {"duration": 4.079, "start": 29.73, "sentence": "최대한 한해가 할 수 있는 득점을"},
        {"duration": 3.6, "start": 31.47, "sentence": "많이 이뤄내고 싶다 라는 생각을 좀"},
        {"duration": 4.221, "start": 33.809, "sentence": "많이 했던것"},
        {"duration": 2.96, "start": 35.07, "sentence": "3개의 대결입니다"},
        {"duration": 3.08, "start": 40.079, "sentence": "으 아"},
        {"duration": 3.9, "start": 44.69, "sentence": "털썩 1 대 영웅이"},
        {"duration": 3.239, "start": 47.0, "sentence": "딸의 맥의"},
        {"duration": 3.66, "start": 48.59, "sentence": "간 보는 거니까 지면"},
        {"duration": 4.351, "start": 50.239, "sentence": "와 받았을 때 무리가 미라도 이런"},
        {"duration": 4.68, "start": 52.25, "sentence": "것들이 완전 또 다른 느낌이었고 좀"},
        {"duration": 4.94, "start": 54.59, "sentence": "많이 좀 당황스러운 어머"},
        {"duration": 2.6, "start": 56.93, "sentence": "두번째 서브"},
        {"duration": 3.869, "start": 60.86, "sentence": "넘었어요 아"},
        {"duration": 4.579, "start": 62.48, "sentence": "생후 팩 다 그러나 4s 씬 보단"},
        {"duration": 2.33, "start": 64.729, "sentence": "합니다"},
        {"duration": 4.52, "start": 67.25, "sentence": "아서가 아니었어 이놈"},
        {"duration": 2.57, "start": 69.2, "sentence": "돼요"},
        {"duration": 3.32, "start": 74.76, "sentence": "아"},
        {"duration": 4.56, "start": 76.22, "sentence": "아"},
        {"duration": 5.13, "start": 78.08, "sentence": "들어와서 함께 이렇게 하게 장애 1"},
        {"duration": 6.05, "start": 80.78, "sentence": "할거 에 지금 강 정 씨가 김 자"},
        {"duration": 3.62, "start": 83.21, "sentence": "했어요 5기 선수로 만나서"},
        {"duration": 2.779, "start": 87.77, "sentence": "아 아 아 아 아"},
        {"duration": 3.311, "start": 91.259, "sentence": "아"},
        {"duration": 4.81, "start": 93.01, "sentence": "마리안한테"},
        {"duration": 5.47, "start": 94.57, "sentence": "살아갑니다 얻어도 너무 좋다"},
        {"duration": 4.86, "start": 97.82, "sentence": "자세나 예 아 또 구질이"},
        {"duration": 3.99, "start": 100.04, "sentence": "거의 뭐 손수 급인데 아 그 정도"},
        {"duration": 4.8, "start": 102.68, "sentence": "조예"},
        {"duration": 6.59, "start": 104.03, "sentence": "[음악]"},
        {"duration": 3.14, "start": 107.48, "sentence": "od 선 서브"},
        {"duration": 5.6, "start": 110.69, "sentence": "잘 받았습니다 잘 받았습니다"},
        {"duration": 3.65, "start": 112.64, "sentence": "irs 에 보장합니다 ok"},
        {"duration": 5.64, "start": 118.46, "sentence": "4 3대 2의 추격하는 강승윤"},
        {"duration": 4.95, "start": 121.25, "sentence": "갤럭시 너 역시 밈 가수 좀 나중에"},
        {"duration": 4.1, "start": 124.1, "sentence": "[음악]"},
        {"duration": 2.0, "start": 126.2, "sentence": "5"},
        {"duration": 3.631, "start": 129.039, "sentence": "14살 좋아요 자신을 낮고 상징"},
        {"duration": 4.129, "start": 131.17, "sentence": "하셨소"},
        {"duration": 2.629, "start": 132.67, "sentence": "집중 입증"},
        {"duration": 4.44, "start": 136.37, "sentence": "음"},
        {"duration": 4.97, "start": 137.87, "sentence": "5기 선수에서 둠"},
        {"duration": 2.03, "start": 140.81, "sentence": "아"},
        {"duration": 3.84, "start": 143.36, "sentence": "아이템들이 취기가 살짝"},
        {"duration": 3.099, "start": 145.42, "sentence": "아쉬웠습니다"},
        {"duration": 2.97, "start": 147.2, "sentence": "아 우리 핸디 도 없이 하는 거야"},
        {"duration": 3.271, "start": 148.519, "sentence": "지금 가 사용하는 사랑해 그래 가"},
        {"duration": 2.849, "start": 150.17, "sentence": "될까"},
        {"duration": 3.42, "start": 151.79, "sentence": "[음악]"},
        {"duration": 5.74, "start": 153.019, "sentence": "음"},
        {"duration": 3.549, "start": 155.21, "sentence": "[음악]"},
        {"duration": 3.03, "start": 159.33, "sentence": "싸울 봐라"},
        {"duration": 3.42, "start": 161.19, "sentence": "실제 1"},
        {"duration": 3.12, "start": 162.36, "sentence": "중요 아깐 & 라이크 택 중간에 지성"},
        {"duration": 4.61, "start": 164.61, "sentence": "이었죠"},
        {"duration": 3.74, "start": 165.48, "sentence": "ob 선수가 조 미안하단 표시했습니다"},
        {"duration": 4.98, "start": 172.18, "sentence": "[음악]"},
        {"duration": 4.65, "start": 175.57, "sentence": "와 아"},
        {"duration": 5.16, "start": 177.16, "sentence": "예술이다 이제 보시다 아아 노사 예"},
        {"duration": 4.18, "start": 180.22, "sentence": "이런 표현 해 줬죠 민정을 하잖아요"},
        {"duration": 4.54, "start": 182.32, "sentence": "식스 릭"},
        {"duration": 5.24, "start": 184.4, "sentence": "어 좀 위기감을 많이 느꼈습니다 각성"},
        {"duration": 2.78, "start": 186.86, "sentence": "해야겠다는"},
        {"duration": 4.1, "start": 190.09, "sentence": "아 아"},
        {"duration": 4.96, "start": 192.1, "sentence": "[박수]"},
        {"duration": 4.49, "start": 194.19, "sentence": "으 으"},
        {"duration": 2.97, "start": 197.06, "sentence": "아"},
        {"duration": 2.88, "start": 198.68, "sentence": "co"},
        {"duration": 4.43, "start": 200.03, "sentence": "으"},
        {"duration": 2.9, "start": 201.56, "sentence": "강승윤 4"},
        {"duration": 3.14, "start": 207.6, "sentence": "[음악]"},
        {"duration": 6.2, "start": 213.31, "sentence": "아 지금이 조성주 경기가 애인데"},
        {"duration": 3.771, "start": 215.739, "sentence": "수준이 못 봐요 그러네요 왜"},
        {"duration": 7.14, "start": 225.65, "sentence": "[음악]"},
        {"duration": 6.569, "start": 229.28, "sentence": "떠 써야 소스가 아 뭐야 네 아쉽게도"},
        {"duration": 5.699, "start": 232.79, "sentence": "검색 들어서 흐려서"},
        {"duration": 5.531, "start": 235.849, "sentence": "성으로 바로 공격 자세가 돼야 되는데"},
        {"duration": 6.031, "start": 238.489, "sentence": "한 템포 늦었어요"},
        {"duration": 3.14, "start": 241.38, "sentence": "짜리 10월 자신있게"},
        {"duration": 4.35, "start": 246.65, "sentence": "아"},
        {"duration": 6.12, "start": 247.48, "sentence": "예 자외선이 좀 좋은데 별로 돼서"},
        {"duration": 2.6, "start": 251.0, "sentence": "저도 된"},
        {"duration": 5.899, "start": 256.4, "sentence": "all code 공격합니다 t5 싸이"},
        {"duration": 3.15, "start": 264.68, "sentence": "강승희 했어"},
        {"duration": 3.84, "start": 266.69, "sentence": "액으로"},
        {"duration": 6.38, "start": 267.83, "sentence": "짜 할까요 다른 알았어요 그래서 자해"},
        {"duration": 3.68, "start": 270.53, "sentence": "클라이버 다들 받았어요"},
        {"duration": 4.38, "start": 274.89, "sentence": "강수민 해서 그"},
        {"duration": 4.68, "start": 276.9, "sentence": "액으로 그래서 어차피 크나요"},
        {"duration": 4.11, "start": 279.27, "sentence": "자랑하다 써요 그래서 자의 클라이버"},
        {"duration": 2.4, "start": 281.58, "sentence": "나를 받았어요"},
        {"duration": 1.42, "start": 283.38, "sentence": "아"},
        {"duration": 2.7, "start": 283.98, "sentence": "답합니다"},
        {"duration": 2.57, "start": 284.8, "sentence": "[박수]"},
        {"duration": 3.5, "start": 286.68, "sentence": "아"},
        {"duration": 7.11, "start": 287.37, "sentence": "[박수]"},
        {"duration": 6.88, "start": 290.18, "sentence": "아니 짤 까 그렇게 역의 이거 봐서"},
        {"duration": 5.93, "start": 294.48, "sentence": "오늘 구리 진짜 팥 꼬 존중해주고"},
        {"duration": 3.35, "start": 297.06, "sentence": "아무 봐야될"},
        {"duration": 3.48, "start": 301.47, "sentence": "저가 끌어야 하고 아마추어 에서"},
        {"duration": 3.69, "start": 303.27, "sentence": "거기가 상당히 쉽지 않은데 강력한"},
        {"duration": 4.88, "start": 304.95, "sentence": "100 드라이브 강정에서 그것도 특별"},
        {"duration": 2.87, "start": 306.96, "sentence": "했어요 없습니다"},
        {"duration": 4.47, "start": 309.93, "sentence": "5 얌 충분히 잘하고 있어요 그래서"},
        {"duration": 4.32, "start": 312.57, "sentence": "진짜 잘하고 있다"},
        {"duration": 3.96, "start": 314.4, "sentence": "전쟁 하지 말아야 게 아냐 지 되게"},
        {"duration": 4.63, "start": 316.89, "sentence": "심장입니다"},
        {"duration": 6.05, "start": 318.36, "sentence": "으 아 아 아 꼭 해"},
        {"duration": 4.23, "start": 321.52, "sentence": "갈 사랑 할"},
        {"duration": 4.45, "start": 324.41, "sentence": "다했어"},
        {"duration": 3.11, "start": 325.75, "sentence": "[박수]"},
        {"duration": 4.98, "start": 329.03, "sentence": "자 어떻습니까 이번 게임 어떻겠소 뭐"},
        {"duration": 5.19, "start": 331.37, "sentence": "창당이 안정된 경기력으로 수준 높은"},
        {"duration": 3.69, "start": 334.01, "sentence": "경기력으로 모든 기술 서브의 어떤"},
        {"duration": 4.23, "start": 336.56, "sentence": "회전도"},
        {"duration": 5.76, "start": 337.7, "sentence": "더 수준이 높고 또 드라이브나 스매쉬"},
        {"duration": 4.98, "start": 340.79, "sentence": "모든 어떤 기술들이 굉장히 수준 높은"},
        {"duration": 4.38, "start": 343.46, "sentence": "어떤 플레이를 하고 있습니다 지금까지"},
        {"duration": 3.96, "start": 345.77, "sentence": "우리가 봐왔던 선수들 보다 한 차원"},
        {"duration": 4.28, "start": 347.84, "sentence": "높은 수준의 플레이를 하고 있는"},
        {"duration": 2.39, "start": 349.73, "sentence": "그렇죠"}
      ]
    }""";

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
    _captions = listTranscriptsFromJson(jsonString);
    _evaluations = evaluationsFromJson(jsonString2);
    // isEvaluated = true;
    currentTranscript = _captions[0].sentence;
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
                        itemCount: _captions.length,
                        itemBuilder: (BuildContext context, int index) {
                          var inkWell = InkWell(
                            onTap: () {
                              int sec = _captions[index].start.floor();
                              int milliSec =
                                  ((_captions[index].start - sec) * 1000)
                                      .toInt();

                              _controller.seekTo(Duration(
                                  seconds: sec, milliseconds: milliSec));
                              toggleSelect(1);
                            },
                            child: (isCurrentCaption(context, index))
                                ? Text(
                                    _captions[index].sentence,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(_captions[index].sentence),
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
                            itemCount: _captions.length,
                            itemBuilder: (BuildContext context, int index) {
                              Widget inkWell = Container();
                              if (isCurrentCaption(context, index)) {
                                inkWell = InkWell(
                                  onTap: () {},
                                  child: Text(
                                    _captions[index].sentence,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                );
                                currentTranscript = _captions[index].sentence;
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
    if (_captions[index].start > _controller.value.position.inSeconds) {
      return false;
    }
    if (index < _captions.length - 1 &&
        _captions[index + 1].start <= _controller.value.position.inSeconds) {
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
