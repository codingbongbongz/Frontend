import 'package:flutter/material.dart';
import 'package:k_learning/screen/learning_screen.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:youtube/youtube_thumbnail.dart';

class HomeScreen extends StatefulWidget {
  final int uid;

  const HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Categorie {
  final int? id;
  final String? name;

  Categorie({
    this.id,
    this.name,
  });
}

class Video {
  final int? videoId;
  final String? link;
  final String? videoTitle;
  final String? creator;
  final double? duration;
  final bool? isDefault;
  final int? views;
  final String? createdAt;
  final int? youtubeViews;

  Video({
    this.videoId,
    this.link,
    this.duration,
    this.isDefault,
    this.views,
    this.createdAt,
    this.youtubeViews,
    this.videoTitle,
    this.creator,
  });

  @override
  String toString() {
    return '''
      videoID : $videoId
      link : $link
      duration : $duration
      isDefault: $isDefault
      views : $views,
      createdAt : $createdAt
      youtubeView : $youtubeViews
      videoTitle : $videoTitle
      creator : $creator
    ''';
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int uid = 0;

  @override
  void initState() {
    super.initState();

    uid = widget.uid;
  }

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
      link: "https://www.youtube.com/watch?v=FwAf4mbaVis",
      videoTitle: "사이좋게 나눠먹는 분식",
      creator: "침착맨",
      duration: 30.25,
      isDefault: true,
      views: 2571232,
      createdAt: "2022-10-31T09:00:00.594Z",
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
      createdAt: "2022-10-31T09:00:00.594Z",
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
      createdAt: "2021-10-26T09:00:00.594Z",
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
      createdAt: "2022-10-31T09:00:00.594Z",
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
      createdAt: "2022-10-31T09:00:00.594Z",
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
      createdAt: "2021-10-26T09:00:00.594Z",
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
      createdAt: "2022-10-31T09:00:00.594Z",
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
      createdAt: "2022-10-31T09:00:00.594Z",
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
      createdAt: "2021-10-26T09:00:00.594Z",
      youtubeViews: 203113,
    ),
  ];
  static final List<Video> _categorieVideos = [
    // 추후에 초기화 해야 함
    Video(
      videoId: 1,
      link: "https://www.youtube.com/watch?v=FwAf4mbaVis",
      videoTitle: "사이좋게 나눠먹는 분식",
      creator: "침착맨",
      duration: 30.25,
      isDefault: true,
      views: 2571232,
      createdAt: "2022-10-31T09:00:00.594Z",
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
      createdAt: "2022-10-31T09:00:00.594Z",
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
      createdAt: "2021-10-26T09:00:00.594Z",
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
      createdAt: "2022-10-31T09:00:00.594Z",
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
      createdAt: "2022-10-31T09:00:00.594Z",
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
      createdAt: "2021-10-26T09:00:00.594Z",
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
      createdAt: "2022-10-31T09:00:00.594Z",
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
      createdAt: "2022-10-31T09:00:00.594Z",
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
      createdAt: "2021-10-26T09:00:00.594Z",
      youtubeViews: 203113,
    ),
  ];

  final _items = _categories
      .map((categorie) =>
          MultiSelectItem<Categorie>(categorie, categorie.name ?? 'No Named'))
      .toList();

  List<Categorie> _selectedCategories = [];
  // final _multiSelectKey = GlobalKey<FormFieldState>();

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
                          uid: uid,
                          link: _popularVideos[index].link!.substring(
                                _popularVideos[index].link!.indexOf('=') + 1,
                              ),
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
                            print(_selectedCategories
                                .map((categorie) => (categorie.name))
                                .toList());
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
                                        uid: uid,
                                        link: _categorieVideos[index]
                                            .link!
                                            .substring(
                                              _categorieVideos[index]
                                                      .link!
                                                      .indexOf('=') +
                                                  1,
                                            ),
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

// todo
// API 호출 하여 인기순, 카테고리 순 영상 가져오기