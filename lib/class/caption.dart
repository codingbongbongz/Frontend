import 'dart:convert';

class Caption {
  final num duration;
  final num start;
  final String text;

  Caption({required this.duration, required this.start, required this.text});

  factory Caption.fromJson(Map<String, dynamic> json) => Caption(
      duration: json['duration'], start: json['start'], text: json['text']);

  Map<String, dynamic> toJson() =>
      {'duration': duration, 'start': start, 'text': text};
}

List<Caption> listCaptionsFromJson(String json) {
  List<dynamic> parsedJson = jsonDecode(json)["transcripts"];
  // print("parsedJson = $parsedJson");
  List<Caption> listcaptions = [];
  for (int i = 0; i < parsedJson.length; i++) {
    listcaptions.add(Caption.fromJson(parsedJson[i]));
  }
  return listcaptions;
}
