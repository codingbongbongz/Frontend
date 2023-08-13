import 'dart:convert';

class Transcript {
  final int transcriptId;
  final num duration;
  final num start;
  final String sentence;

  Transcript(
      {required this.transcriptId,
      required this.duration,
      required this.start,
      required this.sentence});

  factory Transcript.fromJson(Map<String, dynamic> json) => Transcript(
        // transcriptId: json['transcriptId'],
        transcriptId: 1,
        duration: json['duration'],
        start: json['start'],
        sentence: json['sentence'],
      );

  Map<String, dynamic> toJson() => {
        'transcriptId': transcriptId,
        'duration': duration,
        'start': start,
        'sentence': sentence
      };

  @override
  String toString() {
    return '''
      transcriptId: $transcriptId
      duration : $duration
      start : $start
      sentence : $sentence
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
