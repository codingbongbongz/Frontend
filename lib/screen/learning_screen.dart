import 'package:flutter/material.dart';
import 'package:k_learning/layout/my_app_bar.dart';
import 'package:k_learning/main.dart';
import 'package:k_learning/screen/voice_input_screen.dart';
import 'package:k_learning/screen/voice_listen_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../class/caption.dart';

class LearningScreen extends StatefulWidget {
  final int uid;
  final String link;
  const LearningScreen({super.key, required this.uid, required this.link});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  int uid = 0;
  String link = '';
  int currentDuration = 0;
  bool isWholeCaption = true;
  bool isPartCaption = false;
  late String currentCaption;
  late List<bool> isSelected;

  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  var currentValue = YoutubePlayerValue();

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  // double _volume = 100;
  // bool _muted = false;
  bool _isPlayerReady = false;

  static late List<Caption> _captions;

  @override
  void initState() {
    isSelected = [isWholeCaption, isPartCaption];
    super.initState();

    uid = widget.uid;
    link = widget.link;
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
        {"duration": 3.46, "start": 0.48, "text": "다한 만큼"},
        {"duration": 4.44, "start": 2.04, "text": "에이스가 화 수 있겠지"},
        {"duration": 5.21, "start": 3.94, "text": "[박수]"},
        {"duration": 4.8, "start": 6.48, "text": "모두 스토 씨가 15년 그러나 강"},
        {"duration": 5.609, "start": 9.15, "text": "수유 선수는 8개월 밖에 되지 않아"},
        {"duration": 8.159, "start": 11.28, "text": "예 오 d2 싸 우욱 나 볼 짧게"},
        {"duration": 6.371, "start": 14.759, "text": "파악하고 아 아 아 아"},
        {"duration": 4.051, "start": 19.439, "text": "월 9일 깔"},
        {"duration": 4.94, "start": 21.13, "text": "[음악]"},
        {"duration": 4.859, "start": 23.49, "text": "to 자 자 파이팅을 외치면서"},
        {"duration": 3.66, "start": 26.07, "text": "시작합니다 5기 된 상수는 탕수육에"},
        {"duration": 3.121, "start": 28.349, "text": "5기"},
        {"duration": 4.079, "start": 29.73, "text": "최대한 한해가 할 수 있는 득점을"},
        {"duration": 3.6, "start": 31.47, "text": "많이 이뤄내고 싶다 라는 생각을 좀"},
        {"duration": 4.221, "start": 33.809, "text": "많이 했던것"},
        {"duration": 2.96, "start": 35.07, "text": "3개의 대결입니다"},
        {"duration": 3.08, "start": 40.079, "text": "으 아"},
        {"duration": 3.9, "start": 44.69, "text": "털썩 1 대 영웅이"},
        {"duration": 3.239, "start": 47.0, "text": "딸의 맥의"},
        {"duration": 3.66, "start": 48.59, "text": "간 보는 거니까 지면"},
        {"duration": 4.351, "start": 50.239, "text": "와 받았을 때 무리가 미라도 이런"},
        {"duration": 4.68, "start": 52.25, "text": "것들이 완전 또 다른 느낌이었고 좀"},
        {"duration": 4.94, "start": 54.59, "text": "많이 좀 당황스러운 어머"},
        {"duration": 2.6, "start": 56.93, "text": "두번째 서브"},
        {"duration": 3.869, "start": 60.86, "text": "넘었어요 아"},
        {"duration": 4.579, "start": 62.48, "text": "생후 팩 다 그러나 4s 씬 보단"},
        {"duration": 2.33, "start": 64.729, "text": "합니다"},
        {"duration": 4.52, "start": 67.25, "text": "아서가 아니었어 이놈"},
        {"duration": 2.57, "start": 69.2, "text": "돼요"},
        {"duration": 3.32, "start": 74.76, "text": "아"},
        {"duration": 4.56, "start": 76.22, "text": "아"},
        {"duration": 5.13, "start": 78.08, "text": "들어와서 함께 이렇게 하게 장애 1"},
        {"duration": 6.05, "start": 80.78, "text": "할거 에 지금 강 정 씨가 김 자"},
        {"duration": 3.62, "start": 83.21, "text": "했어요 5기 선수로 만나서"},
        {"duration": 2.779, "start": 87.77, "text": "아 아 아 아 아"},
        {"duration": 3.311, "start": 91.259, "text": "아"},
        {"duration": 4.81, "start": 93.01, "text": "마리안한테"},
        {"duration": 5.47, "start": 94.57, "text": "살아갑니다 얻어도 너무 좋다"},
        {"duration": 4.86, "start": 97.82, "text": "자세나 예 아 또 구질이"},
        {"duration": 3.99, "start": 100.04, "text": "거의 뭐 손수 급인데 아 그 정도"},
        {"duration": 4.8, "start": 102.68, "text": "조예"},
        {"duration": 6.59, "start": 104.03, "text": "[음악]"},
        {"duration": 3.14, "start": 107.48, "text": "od 선 서브"},
        {"duration": 5.6, "start": 110.69, "text": "잘 받았습니다 잘 받았습니다"},
        {"duration": 3.65, "start": 112.64, "text": "irs 에 보장합니다 ok"},
        {"duration": 5.64, "start": 118.46, "text": "4 3대 2의 추격하는 강승윤"},
        {"duration": 4.95, "start": 121.25, "text": "갤럭시 너 역시 밈 가수 좀 나중에"},
        {"duration": 4.1, "start": 124.1, "text": "[음악]"},
        {"duration": 2.0, "start": 126.2, "text": "5"},
        {"duration": 3.631, "start": 129.039, "text": "14살 좋아요 자신을 낮고 상징"},
        {"duration": 4.129, "start": 131.17, "text": "하셨소"},
        {"duration": 2.629, "start": 132.67, "text": "집중 입증"},
        {"duration": 4.44, "start": 136.37, "text": "음"},
        {"duration": 4.97, "start": 137.87, "text": "5기 선수에서 둠"},
        {"duration": 2.03, "start": 140.81, "text": "아"},
        {"duration": 3.84, "start": 143.36, "text": "아이템들이 취기가 살짝"},
        {"duration": 3.099, "start": 145.42, "text": "아쉬웠습니다"},
        {"duration": 2.97, "start": 147.2, "text": "아 우리 핸디 도 없이 하는 거야"},
        {"duration": 3.271, "start": 148.519, "text": "지금 가 사용하는 사랑해 그래 가"},
        {"duration": 2.849, "start": 150.17, "text": "될까"},
        {"duration": 3.42, "start": 151.79, "text": "[음악]"},
        {"duration": 5.74, "start": 153.019, "text": "음"},
        {"duration": 3.549, "start": 155.21, "text": "[음악]"},
        {"duration": 3.03, "start": 159.33, "text": "싸울 봐라"},
        {"duration": 3.42, "start": 161.19, "text": "실제 1"},
        {"duration": 3.12, "start": 162.36, "text": "중요 아깐 & 라이크 택 중간에 지성"},
        {"duration": 4.61, "start": 164.61, "text": "이었죠"},
        {"duration": 3.74, "start": 165.48, "text": "ob 선수가 조 미안하단 표시했습니다"},
        {"duration": 4.98, "start": 172.18, "text": "[음악]"},
        {"duration": 4.65, "start": 175.57, "text": "와 아"},
        {"duration": 5.16, "start": 177.16, "text": "예술이다 이제 보시다 아아 노사 예"},
        {"duration": 4.18, "start": 180.22, "text": "이런 표현 해 줬죠 민정을 하잖아요"},
        {"duration": 4.54, "start": 182.32, "text": "식스 릭"},
        {"duration": 5.24, "start": 184.4, "text": "어 좀 위기감을 많이 느꼈습니다 각성"},
        {"duration": 2.78, "start": 186.86, "text": "해야겠다는"},
        {"duration": 4.1, "start": 190.09, "text": "아 아"},
        {"duration": 4.96, "start": 192.1, "text": "[박수]"},
        {"duration": 4.49, "start": 194.19, "text": "으 으"},
        {"duration": 2.97, "start": 197.06, "text": "아"},
        {"duration": 2.88, "start": 198.68, "text": "co"},
        {"duration": 4.43, "start": 200.03, "text": "으"},
        {"duration": 2.9, "start": 201.56, "text": "강승윤 4"},
        {"duration": 3.14, "start": 207.6, "text": "[음악]"},
        {"duration": 6.2, "start": 213.31, "text": "아 지금이 조성주 경기가 애인데"},
        {"duration": 3.771, "start": 215.739, "text": "수준이 못 봐요 그러네요 왜"},
        {"duration": 7.14, "start": 225.65, "text": "[음악]"},
        {"duration": 6.569, "start": 229.28, "text": "떠 써야 소스가 아 뭐야 네 아쉽게도"},
        {"duration": 5.699, "start": 232.79, "text": "검색 들어서 흐려서"},
        {"duration": 5.531, "start": 235.849, "text": "성으로 바로 공격 자세가 돼야 되는데"},
        {"duration": 6.031, "start": 238.489, "text": "한 템포 늦었어요"},
        {"duration": 3.14, "start": 241.38, "text": "짜리 10월 자신있게"},
        {"duration": 4.35, "start": 246.65, "text": "아"},
        {"duration": 6.12, "start": 247.48, "text": "예 자외선이 좀 좋은데 별로 돼서"},
        {"duration": 2.6, "start": 251.0, "text": "저도 된"},
        {"duration": 5.899, "start": 256.4, "text": "all code 공격합니다 t5 싸이"},
        {"duration": 3.15, "start": 264.68, "text": "강승희 했어"},
        {"duration": 3.84, "start": 266.69, "text": "액으로"},
        {"duration": 6.38, "start": 267.83, "text": "짜 할까요 다른 알았어요 그래서 자해"},
        {"duration": 3.68, "start": 270.53, "text": "클라이버 다들 받았어요"},
        {"duration": 4.38, "start": 274.89, "text": "강수민 해서 그"},
        {"duration": 4.68, "start": 276.9, "text": "액으로 그래서 어차피 크나요"},
        {"duration": 4.11, "start": 279.27, "text": "자랑하다 써요 그래서 자의 클라이버"},
        {"duration": 2.4, "start": 281.58, "text": "나를 받았어요"},
        {"duration": 1.42, "start": 283.38, "text": "아"},
        {"duration": 2.7, "start": 283.98, "text": "답합니다"},
        {"duration": 2.57, "start": 284.8, "text": "[박수]"},
        {"duration": 3.5, "start": 286.68, "text": "아"},
        {"duration": 7.11, "start": 287.37, "text": "[박수]"},
        {"duration": 6.88, "start": 290.18, "text": "아니 짤 까 그렇게 역의 이거 봐서"},
        {"duration": 5.93, "start": 294.48, "text": "오늘 구리 진짜 팥 꼬 존중해주고"},
        {"duration": 3.35, "start": 297.06, "text": "아무 봐야될"},
        {"duration": 3.48, "start": 301.47, "text": "저가 끌어야 하고 아마추어 에서"},
        {"duration": 3.69, "start": 303.27, "text": "거기가 상당히 쉽지 않은데 강력한"},
        {"duration": 4.88, "start": 304.95, "text": "100 드라이브 강정에서 그것도 특별"},
        {"duration": 2.87, "start": 306.96, "text": "했어요 없습니다"},
        {"duration": 4.47, "start": 309.93, "text": "5 얌 충분히 잘하고 있어요 그래서"},
        {"duration": 4.32, "start": 312.57, "text": "진짜 잘하고 있다"},
        {"duration": 3.96, "start": 314.4, "text": "전쟁 하지 말아야 게 아냐 지 되게"},
        {"duration": 4.63, "start": 316.89, "text": "심장입니다"},
        {"duration": 6.05, "start": 318.36, "text": "으 아 아 아 꼭 해"},
        {"duration": 4.23, "start": 321.52, "text": "갈 사랑 할"},
        {"duration": 4.45, "start": 324.41, "text": "다했어"},
        {"duration": 3.11, "start": 325.75, "text": "[박수]"},
        {"duration": 4.98, "start": 329.03, "text": "자 어떻습니까 이번 게임 어떻겠소 뭐"},
        {"duration": 5.19, "start": 331.37, "text": "창당이 안정된 경기력으로 수준 높은"},
        {"duration": 3.69, "start": 334.01, "text": "경기력으로 모든 기술 서브의 어떤"},
        {"duration": 4.23, "start": 336.56, "text": "회전도"},
        {"duration": 5.76, "start": 337.7, "text": "더 수준이 높고 또 드라이브나 스매쉬"},
        {"duration": 4.98, "start": 340.79, "text": "모든 어떤 기술들이 굉장히 수준 높은"},
        {"duration": 4.38, "start": 343.46, "text": "어떤 플레이를 하고 있습니다 지금까지"},
        {"duration": 3.96, "start": 345.77, "text": "우리가 봐왔던 선수들 보다 한 차원"},
        {"duration": 4.28, "start": 347.84, "text": "높은 수준의 플레이를 하고 있는"},
        {"duration": 2.39, "start": 349.73, "text": "그렇죠"}
      ]
    }""";
    // print(ParsedCaptions);
    _captions = listCaptionsFromJson(jsonString);
    currentCaption = _captions[0].text;
    // print(_captions[0].duration);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;

        if (currentDuration != _controller.value.position.inSeconds) {
          currentDuration = _controller.value.position.inSeconds;
        }
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
    // _controller?.dispose();
    _idController?.dispose();
    _seekToController?.dispose();
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
                                uid: uid,
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
            // _space,
            // Text(
            //   'Current Time ${currentDuration ~/ 60} : ${currentDuration % 60 >= 10 ? currentDuration % 60 : '0${currentDuration % 60}'}',
            // ),
            // _space,
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
                    Container(
                      height: 500,
                      child: ListView.builder(
                        itemCount: _captions.length,
                        itemBuilder: (BuildContext context, int index) {
                          var inkWell = InkWell(
                            onTap: () {
                              int sec = _captions[index].start ~/ 1;
                              _controller.seekTo(Duration(seconds: sec));
                              toggleSelect(1);
                            },
                            child: (isCurrentCaption(context, index))
                                ? Text(
                                    _captions[index].text,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : Text(_captions[index].text),
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
                                    _captions[index].text,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                );
                                currentCaption = _captions[index].text;
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
                                        currentCaption: currentCaption,
                                      ),
                                      insetPadding: EdgeInsets.all(8.0),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('확인'),
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
                                        currentCaption: currentCaption,
                                      ),
                                      insetPadding: EdgeInsets.all(8.0),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('확인'),
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

                  // ElevatedButton(
                  //   onPressed: () {
                  //     _controller.seekTo(_controller.value.position +
                  //         Duration(minutes: 1, seconds: 10));
                  //   },
                  //   child: Text('1분 10초 뒤로 이동'),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);

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
