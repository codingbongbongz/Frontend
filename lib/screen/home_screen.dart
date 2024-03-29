import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:k_learning/const/color.dart';
import 'package:k_learning/layout/my_app_bar.dart';
import 'package:k_learning/screen/learning_screen.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:youtube/youtube_thumbnail.dart';

import '../class/categorie.dart';
import '../class/video.dart';
import '../const/key.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamController<List<Video>> _events;

  static final List<Categorie> _categories = [
    Categorie(id: 1, name: "Film & Animation"),
    Categorie(id: 2, name: "Autos & Vehicles"),
    Categorie(id: 10, name: "Music"),
    Categorie(id: 15, name: "Pets & Animals"),
    Categorie(id: 17, name: "Sports"),
    Categorie(id: 18, name: "Short Movies"),
    Categorie(id: 19, name: "Travel & Events"),
    Categorie(id: 20, name: "Gaming"),
    Categorie(id: 21, name: "Videoblogging"),
    Categorie(id: 22, name: "People"),
    Categorie(id: 23, name: "Comedy"),
    Categorie(id: 24, name: "Entertainment"),
    Categorie(id: 25, name: "News & Politics"),
    Categorie(id: 26, name: "Howto & style"),
    Categorie(id: 27, name: "Education"),
    Categorie(id: 28, name: "Science & Technology"),
    Categorie(id: 29, name: "Nonprofits & Activism"),
    Categorie(id: 30, name: "Movies"),
    Categorie(id: 31, name: "Anime/Animation"),
    Categorie(id: 31, name: "Action/Adventure"),
    Categorie(id: 33, name: "Classics"),
    Categorie(id: 34, name: "Comedy"),
    Categorie(id: 35, name: "Documentary"),
    Categorie(id: 36, name: "Drama"),
    Categorie(id: 37, name: "Family"),
    Categorie(id: 38, name: "Foreign"),
    Categorie(id: 39, name: "Horror"),
    Categorie(id: 40, name: "Sci-Fi/Fantasy"),
    Categorie(id: 41, name: "Thriller"),
    Categorie(id: 42, name: "Shorts"),
    Categorie(id: 43, name: "Shows"),
    Categorie(id: 44, name: "Trailers"),
  ];
  late List<Video> _popularVideos = [];
  List<Video> _categoryVideos = [];
  final _items = _categories
      .map((categorie) =>
          MultiSelectItem<Categorie>(categorie, categorie.name ?? 'No Named'))
      .toList();

  Future<List<Video>> getPopularVideos() async {
    final dio = await authDio(context);
    final response = await dio.get('videos/popular');

    List<dynamic> responseBody = response.data['data']['popularVideo'];
    // print(responseBody);
    _popularVideos =
        responseBody.map((e) => Video.fromJson(e)).toList(); // map을 오브젝트로 변환

    return responseBody.map((e) => Video.fromJson(e)).toList();
  }

  void getCategorieVideos(results) async {
    final dio = await authDio(context);
    if (results.isEmpty) {
      _categoryVideos.clear();
      _events.add([]);
      return;
    }

    String param = "";
    for (Categorie result in results) {
      param += "categoryIds=${result.id}&";
    }

    final response = await dio.get(
      'videos/categories?$param',
    );

    List<dynamic> responseBody = response.data['data'];
    _categoryVideos.clear();

    for (Map<String, dynamic> categories in responseBody) {
      List<dynamic> categoryVideoList = categories['categoryVideo'];
      for (Map<String, dynamic> videoData in categoryVideoList) {
        _categoryVideos.add(Video.fromJson(videoData));
      }
    }

    _events.add(_categoryVideos);
  }

  @override
  void initState() {
    super.initState();
    _events = StreamController<List<Video>>();
    _events.add([]);
  }

  @override
  void dispose() {
    _events.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: MyAppBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Popular Videos',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.5,
            child: FutureBuilder(
                future: getPopularVideos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final data = snapshot.data;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        InkWell inkWell = InkWell(
                          onTap: () {
                            {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LearningScreen(
                                    link: data[index].link,
                                    videoID: data[index].videoId,
                                  ),
                                ),
                              );
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              YoutubeThumbnail(
                                youtubeId: _popularVideos[index].link,
                              ).hd(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width / 2.0,
                            ),
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  _popularVideos[index].creator,
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
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
                            itemsTextStyle: TextStyle(
                              color: getPlatformDependentColor(
                                  context, Colors.black, Colors.white),
                            ),
                            unselectedColor: getPlatformDependentColor(
                                context, Colors.white, Colors.white),
                            selectedItemsTextStyle: TextStyle(
                              color: blueColor,
                            ),
                            title: Text(
                              "Select Categories",
                              style: TextStyle(),
                            ),
                            selectedColor: blueColor,
                            decoration: BoxDecoration(
                              color: blueColor.withOpacity(0.1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                color: blueColor,
                                width: 2,
                              ),
                            ),
                            buttonIcon: const Icon(
                              Icons.arrow_downward,
                              color: blueColor,
                            ),
                            buttonText: Text(
                              "Favorite Categories",
                              style: TextStyle(
                                color: blueColor,
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LinearProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final data = snapshot.data!;
                          return ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        LearningScreen(
                                                  link: data[index].link,
                                                  videoID: data[index].videoId,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.network(
                                            YoutubeThumbnail(
                                              youtubeId: data[index].link,
                                            ).hq(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          _categoryVideos[index].videoTitle,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _categoryVideos[index].creator,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              "Time : ${_categoryVideos[index].duration ~/ 60}m ${_categoryVideos[index].duration % 60}s",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
      ),
    );
  }
}
