// import 'dart:convert';

class Video {
  final int videoId;
  final String link;
  String videoTitle;
  final String creator;
  final int duration;
  final bool? isDefault;
  final int views;
  DateTime? createdAt = DateTime.now();
  // // 없애도 될듯
  final int youtubeViews;

  Video({
    required this.videoId,
    required this.link,
    required this.duration,
    required this.views,
    required this.youtubeViews,
    required this.videoTitle,
    required this.creator,
    this.isDefault = true,
    this.createdAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        videoId: json['videoId'],
        link: json['videoUrl'],
        videoTitle: json['videoTitle'],
        creator: json['creator'],
        duration: json['duration'],
        // isDefault: json['isDefault'],
        views: json['views'],
        // createdAt: json['createdAt'],
        youtubeViews: json['youtubeViews'],
      );

  Map<String, dynamic> toJson() => {
        'videoId': videoId,
        'link': link,
        'videoTitle': videoTitle,
        'creator': creator,
        'duration': duration,
        'isDefault': isDefault,
        'views': createdAt,
        'youtubeViews': youtubeViews,
      };

  @override
  String toString() {
    return '''
      videoID : $videoId
      link : $link
    ''';
  }
  // duration : $duration
  //     isDefault: $isDefault
  //     views : $views,
  //     createdAt : $createdAt
  //     youtubeView : $youtubeViews
  //     videoTitle : $videoTitle
  //     creator : $creator

  // List<Video> listVideosFromJson(String json) {
  //   List<dynamic> parsedJson = jsonDecode(json)["data"]['popularVideo'];
  //   // print("parsedJson = $parsedJson");
  //   List<Video> listVideos = [];
  //   for (int i = 0; i < parsedJson.length; i++) {
  //     listVideos.add(Video.fromJson(parsedJson[i]));
  //   }
  //   return listVideos;
  // }
}
