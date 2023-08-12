import 'dart:convert';

class Transcript {
  final int transcriptId;
  final num duration;
  final num start;
  final String text;

  Transcript(
      {required this.transcriptId,
      required this.duration,
      required this.start,
      required this.text});

  factory Transcript.fromJson(Map<String, dynamic> json) => Transcript(
        // transcriptId: json['transcriptId'],
        transcriptId: 1,
        duration: json['duration'],
        start: json['start'],
        text: json['text'],
      );

  Map<String, dynamic> toJson() => {
        'transcriptId': transcriptId,
        'duration': duration,
        'start': start,
        'text': text
      };

  @override
  String toString() {
    return '''
      transcriptId: $transcriptId
      duration : $duration
      start : $start
      text : $text
    ''';
  }
}

List<Transcript> listTranscriptsFromJson(String json) {
  List<dynamic> parsedJson = jsonDecode(json)["transcripts"];
  // print("parsedJson = $parsedJson");
  List<Transcript> listTranscripts = [];
  for (int i = 0; i < parsedJson.length; i++) {
    listTranscripts.add(Transcript.fromJson(parsedJson[i]));
  }
  return listTranscripts;
}
