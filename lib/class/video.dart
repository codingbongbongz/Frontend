import 'dart:convert';

class Video {
  final int videoId;
  final String? link;
  final String? videoTitle;
  final String? creator;
  final double? duration;
  final bool? isDefault;
  final int? views;
  final DateTime? createdAt;
  // 없애도 될듯
  final int? youtubeViews;

  Video({
    required this.videoId,
    this.link,
    this.duration,
    this.isDefault,
    this.views,
    this.createdAt,
    this.youtubeViews,
    this.videoTitle,
    this.creator,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        // transcriptId: json['transcriptId'],
        videoId: json['videoId'],
        link: json['link'],
        videoTitle: json['videoTitle'],
        creator: json['creator'],
        duration: json['duration'],
        isDefault: json['isDefault'],
        views: json['views'],
        createdAt: json['createdAt'],
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
      duration : $duration
      isDefault: $isDefault
      views : $views,
      createdAt : $createdAt
      youtubeView : $youtubeViews
      videoTitle : $videoTitle
      creator : $creator
    ''';
  }

  List<Video> listVideosFromJson(String json) {
    List<dynamic> parsedJson = jsonDecode(json)["data"];
    // print("parsedJson = $parsedJson");
    List<Video> listVideos = [];
    for (int i = 0; i < parsedJson.length; i++) {
      listVideos.add(Video.fromJson(parsedJson[i]));
    }
    return listVideos;
  }
}
