import 'dart:async';

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
  final String accessToken;

  const HomeScreen({super.key, required this.accessToken});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String accessToken = '';
  Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();
  late StreamController<List<Video>> _events;

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
  late List<Video> _popularVideos = [];
  List<Video> _categoryVideos = [];
  final _items = _categories
      .map((categorie) =>
          MultiSelectItem<Categorie>(categorie, categorie.name ?? 'No Named'))
      .toList();

  Future<List<Video>> getPopularVideos() async {
    final response = await dio.get('videos/popular');

    List<dynamic> responseBody = response.data['data']['popularVideo'];
    print(responseBody);
    _popularVideos =
        responseBody.map((e) => Video.fromJson(e)).toList(); // map을 오브젝트로 변환

    return responseBody.map((e) => Video.fromJson(e)).toList();
  }

  void getCategorieVideos(results) async {
    if (results.isEmpty) {
      _categoryVideos.clear();
      _events.add([]);
      return;
    }
    FormData formData = FormData.fromMap({
      "categoryId": results[0].id,
    });

    final response = await dio.get(
      'videos/category',
      data: formData,
      options: Options(
        headers: {"Content-Type": "multipart/form-data"},
        // contentType: Headers.multipartFormDataContentType,
      ),
    );

    // if (kDebugMode) {
    //   print("response : $response");
    // }
    List<dynamic> responseBody = response.data['data']['categoryVideo'];
    _categoryVideos = responseBody.map((e) => Video.fromJson(e)).toList();
    _events.add(_categoryVideos);
  }

  @override
  void initState() {
    super.initState();
    _events = StreamController<List<Video>>();
    _events.add([]);

    accessToken = widget.accessToken;
    dio.options.baseUrl = baseURL;
    dio.options.headers = {"Authorization": accessToken};

    dio.interceptors.add(CustomInterceptors());

    getPopularVideos();
  }

  @override
  void dispose() {
    _events.close();
    super.dispose();
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
          child: FutureBuilder(
              future: getPopularVideos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final data = snapshot.data;
                  // print(data![0].link);
                  // var length = _popularVideos.length;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var inkWell = InkWell(
                        onTap: () {
                          {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LearningScreen(
                                  accessToken: accessToken,
                                  link: data[index].link,
                                  videoID: data[index].videoId,
                                ),
                              ),
                            );
                          }
                        },
                        child: Image.network(
                          YoutubeThumbnail(
                            youtubeId: _popularVideos[index].link,
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
                                _popularVideos[index].videoTitle,
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
                  );
                }
              }),
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
                            getCategorieVideos(results);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                    stream: _events.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final data = snapshot.data!;
                        return ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: data.length,
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
                                                accessToken: accessToken,
                                                link: data[index].link,
                                                videoID: data[index].videoId,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Image.network(YoutubeThumbnail(
                                        youtubeId: data[index].link,
                                      ).small()),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'videoTitle : ${_categoryVideos[index].videoTitle}',
                                      ),
                                      Text(
                                        'creator : ${_categoryVideos[index].creator!}',
                                      ),
                                      Text(
                                        'duration : ${_categoryVideos[index].duration!}',
                                      ),
                                      Text(
                                        'views : ${_categoryVideos[index].views!}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
