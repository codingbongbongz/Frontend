import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:k_learning/screen/learning_screen.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:youtube/youtube_thumbnail.dart';

import '../class/categorie.dart';
import '../class/video.dart';
import '../const/key.dart';

class HomeScreen extends StatefulWidget {
  final int userID;

  const HomeScreen({super.key, required this.userID});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int userID = 0;
  Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();

  List<Categorie> _selectedCategories = [];
  // link 수정
  static final List<Categorie> _categories = [
    Categorie(id: 1, name: "BTS"),
    Categorie(id: 2, name: "BlackPink"),
    Categorie(id: 3, name: "LifeStyle"),
    Categorie(id: 4, name: "Music"),
    Categorie(id: 5, name: "Dance"),
    Categorie(id: 6, name: "Beauty"),
    Categorie(id: 7, name: "Fashion"),
    Categorie(id: 8, name: "Movie"),
    Categorie(id: 9, name: "Animation"),
    Categorie(id: 10, name: "Kids"),
    Categorie(id: 11, name: "Travel"),
    Categorie(id: 12, name: "Sports"),
    Categorie(id: 13, name: "Health"),
    Categorie(id: 14, name: "Politics"),
  ];
  static final List<Video> _popularVideos = [
    // 추후에 초기화 해야 함
    Video(
      videoId: 1,
      link: "https://www.youtube.com/watch?v=YRygn_pfSIo",
      videoTitle: "[#올탁구나] 15년 차 일본 선수",
      creator: "tvN D ENT",
      duration: 5.59,
      isDefault: true,
      views: 9125,
      createdAt: DateTime.parse("2022-02-24T09:00:00.594Z"),
      youtubeViews: 91253,
    ),
    Video(
      videoId: 1,
      link: "https://www.youtube.com/watch?v=FwAf4mbaVis",
      videoTitle: "사이좋게 나눠먹는 분식",
      creator: "침착맨",
      duration: 30.25,
      isDefault: true,
      views: 2571232,
      createdAt: DateTime.parse("2022-10-31T09:00:00.594Z"),
      youtubeViews: 1203123,
    ),
    Video(
      videoId: 2,
      link: "https://www.youtube.com/watch?v=ZFrya-B0VQo",
      videoTitle: "새마을금고 초유의 뱅크런 사태",
      creator: "슈카월드",
      duration: 23.16,
      isDefault: true,
      views: 90326,
      createdAt: DateTime.parse("2022-10-31T09:00:00.594Z"),
      youtubeViews: 903265,
    ),
    Video(
      videoId: 3,
      link: "https://www.youtube.com/watch?v=4ActM8eu6Lg",
      videoTitle: "HEADACHE pills , not sweet.",
      creator: "데이먼스 이어 Damons year",
      duration: 34.10,
      isDefault: true,
      views: 20311,
      createdAt: DateTime.parse("2021-10-26T09:00:00.594Z"),
      youtubeViews: 203113,
    ),
    Video(
      videoId: 1,
      link: "https://www.youtube.com/watch?v=FwAf4mbaVis",
      videoTitle: "사이좋게 나눠먹는 분식",
      creator: "침착맨",
      duration: 30.25,
      isDefault: true,
      views: 2571232,
      createdAt: DateTime.parse("2022-10-31T09:00:00.594Z"),
      youtubeViews: 1203123,
    ),
    Video(
      videoId: 2,
      link: "https://www.youtube.com/watch?v=ZFrya-B0VQo",
      videoTitle: "새마을금고 초유의 뱅크런 사태",
      creator: "슈카월드",
      duration: 23.16,
      isDefault: true,
      views: 90326,
      createdAt: DateTime.parse("2022-10-31T09:00:00.594Z"),
      youtubeViews: 903265,
    ),
    Video(
      videoId: 3,
      link: "https://www.youtube.com/watch?v=4ActM8eu6Lg",
      videoTitle: "HEADACHE pills , not sweet.",
      creator: "데이먼스 이어 Damons year",
      duration: 34.10,
      isDefault: true,
      views: 20311,
      createdAt: DateTime.parse("2021-10-26T09:00:00.594Z"),
      youtubeViews: 203113,
    ),
    Video(
      videoId: 1,
      link: "https://www.youtube.com/watch?v=FwAf4mbaVis",
      videoTitle: "사이좋게 나눠먹는 분식",
      creator: "침착맨",
      duration: 30.25,
      isDefault: true,
      views: 2571232,
      createdAt: DateTime.parse("2022-10-31T09:00:00.594Z"),
      youtubeViews: 1203123,
    ),
    Video(
      videoId: 2,
      link: "https://www.youtube.com/watch?v=ZFrya-B0VQo",
      videoTitle: "새마을금고 초유의 뱅크런 사태",
      creator: "슈카월드",
      duration: 23.16,
      isDefault: true,
      views: 90326,
      createdAt: DateTime.parse("2022-10-31T09:00:00.594Z"),
      youtubeViews: 903265,
    ),
    Video(
      videoId: 3,
      link: "https://www.youtube.com/watch?v=4ActM8eu6Lg",
      videoTitle: "HEADACHE pills , not sweet.",
      creator: "데이먼스 이어 Damons year",
      duration: 34.10,
      isDefault: true,
      views: 20311,
      createdAt: DateTime.parse("2021-10-26T09:00:00.594Z"),
      youtubeViews: 203113,
    ),
  ];
  static final List<Video> _categorieVideos = [
    // 추후에 초기화 해야 함
    Video(
      videoId: 1,
      link: "https://www.youtube.com/watch?v=YRygn_pfSIo",
      videoTitle: "[#올탁구나] 15년 차 일본 선수",
      creator: "tvN D ENT",
      duration: 5.59,
      isDefault: true,
      views: 9125,
      createdAt: DateTime.parse("2022-02-24T09:00:00.594Z"),
      youtubeViews: 91253,
    ),
    Video(
      videoId: 1,
      link: "https://www.youtube.com/watch?v=FwAf4mbaVis",
      videoTitle: "사이좋게 나눠먹는 분식",
      creator: "침착맨",
      duration: 30.25,
      isDefault: true,
      views: 2571232,
      createdAt: DateTime.parse("2022-10-31T09:00:00.594Z"),
      youtubeViews: 1203123,
    ),
    Video(
      videoId: 2,
      link: "https://www.youtube.com/watch?v=ZFrya-B0VQo",
      videoTitle: "새마을금고 초유의 뱅크런 사태",
      creator: "슈카월드",
      duration: 23.16,
      isDefault: true,
      views: 90326,
      createdAt: DateTime.parse("2022-10-31T09:00:00.594Z"),
      youtubeViews: 903265,
    ),
    Video(
      videoId: 3,
      link: "https://www.youtube.com/watch?v=4ActM8eu6Lg",
      videoTitle: "HEADACHE pills , not sweet.",
      creator: "데이먼스 이어 Damons year",
      duration: 34.10,
      isDefault: true,
      views: 20311,
      createdAt: DateTime.parse("2021-10-26T09:00:00.594Z"),
      youtubeViews: 203113,
    ),
    Video(
      videoId: 1,
      link: "https://www.youtube.com/watch?v=FwAf4mbaVis",
      videoTitle: "사이좋게 나눠먹는 분식",
      creator: "침착맨",
      duration: 30.25,
      isDefault: true,
      views: 2571232,
      createdAt: DateTime.parse("2022-10-31T09:00:00.594Z"),
      youtubeViews: 1203123,
    ),
    Video(
      videoId: 2,
      link: "https://www.youtube.com/watch?v=ZFrya-B0VQo",
      videoTitle: "새마을금고 초유의 뱅크런 사태",
      creator: "슈카월드",
      duration: 23.16,
      isDefault: true,
      views: 90326,
      createdAt: DateTime.parse("2022-10-31T09:00:00.594Z"),
      youtubeViews: 903265,
    ),
    Video(
      videoId: 3,
      link: "https://www.youtube.com/watch?v=4ActM8eu6Lg",
      videoTitle: "HEADACHE pills , not sweet.",
      creator: "데이먼스 이어 Damons year",
      duration: 34.10,
      isDefault: true,
      views: 20311,
      createdAt: DateTime.parse("2021-10-26T09:00:00.594Z"),
      youtubeViews: 203113,
    ),
    Video(
      videoId: 1,
      link: "https://www.youtube.com/watch?v=FwAf4mbaVis",
      videoTitle: "사이좋게 나눠먹는 분식",
      creator: "침착맨",
      duration: 30.25,
      isDefault: true,
      views: 2571232,
      createdAt: DateTime.parse("2022-10-31T09:00:00.594Z"),
      youtubeViews: 1203123,
    ),
    Video(
      videoId: 2,
      link: "https://www.youtube.com/watch?v=ZFrya-B0VQo",
      videoTitle: "새마을금고 초유의 뱅크런 사태",
      creator: "슈카월드",
      duration: 23.16,
      isDefault: true,
      views: 90326,
      createdAt: DateTime.parse("2022-10-31T09:00:00.594Z"),
      youtubeViews: 903265,
    ),
    Video(
      videoId: 3,
      link: "https://www.youtube.com/watch?v=4ActM8eu6Lg",
      videoTitle: "HEADACHE pills , not sweet.",
      creator: "데이먼스 이어 Damons year",
      duration: 34.10,
      isDefault: true,
      views: 20311,
      createdAt: DateTime.parse("2021-10-26T09:00:00.594Z"),
      youtubeViews: 203113,
    ),
  ];
  final _items = _categories
      .map((categorie) =>
          MultiSelectItem<Categorie>(categorie, categorie.name ?? 'No Named'))
      .toList();

  void getPopularVideos() async {
    final response = await dio.get('videos/popular');

    print("response : $response");
    // _popularVideos 초기화
    // link도 수정
  }

  void getCategorieVideos(results) async {
    final response = await dio.post('videos/categories');
    //
    print("response : $response");
  }

  @override
  void initState() {
    super.initState();
    dio.options.baseUrl = baseURL;
    dio.options.headers = {"userId": 1};
    getPopularVideos();
    userID = widget.userID;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50,
          child: Center(
            widthFactor: 2.0,
            child: Text(
              '인기순',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _popularVideos.length,
            itemBuilder: (BuildContext context, int index) {
              var inkWell = InkWell(
                onTap: () {
                  {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => LearningScreen(
                          userID: userID,
                          link: _popularVideos[index].link!.substring(
                                _popularVideos[index].link!.indexOf('=') + 1,
                              ),
                          videoID: _popularVideos[index].videoId,
                        ),
                      ),
                    );
                  }
                },
                child: Image.network(
                  YoutubeThumbnail(
                    youtubeId: _popularVideos[index].link!.substring(
                          _popularVideos[index].link!.indexOf('=') + 1,
                        ),
                  ).small(),
                ),
              );
              return Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 3,
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    inkWell,
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        _popularVideos[index].videoTitle!,
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: MultiSelectDialogField(
                          items: _items,
                          title: const Text(
                            "Select Categories",
                          ),
                          selectedColor: Colors.blue,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          buttonIcon: const Icon(
                            Icons.arrow_downward,
                            color: Colors.blue,
                          ),
                          buttonText: Text(
                            "Favorite Categories",
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 15,
                            ),
                          ),
                          onConfirm: (results) {
                            _selectedCategories = results;
                            print(results);
                            print(_selectedCategories
                                .map((categorie) => (categorie.name))
                                .toList());
                            // getCategorieVideos(results);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: _categorieVideos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LearningScreen(
                                        userID: userID,
                                        link: _categorieVideos[index]
                                            .link!
                                            .substring(
                                              _categorieVideos[index]
                                                      .link!
                                                      .indexOf('=') +
                                                  1,
                                            ),
                                        videoID:
                                            _categorieVideos[index].videoId,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Image.network(YoutubeThumbnail(
                                youtubeId:
                                    _categorieVideos[index].link!.substring(
                                          _categorieVideos[index]
                                                  .link!
                                                  .indexOf('=') +
                                              1,
                                        ),
                              ).small()),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'videoTitle : ${_categorieVideos[index].videoTitle!}',
                              ),
                              Text(
                                'creator : ${_categorieVideos[index].creator!}',
                              ),
                              Text(
                                'duration : ${_categorieVideos[index].duration!}',
                              ),
                              Text(
                                'views : ${_categorieVideos[index].views!}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
