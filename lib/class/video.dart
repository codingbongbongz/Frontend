class Video {
  final int videoID;
  final String? link;
  final String? videoTitle;
  final String? creator;
  final double? duration;
  final bool? isDefault;
  final int? views;
  final String? createdAt;
  final int? youtubeViews;

  Video({
    required this.videoID,
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
      videoID : $videoID
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
