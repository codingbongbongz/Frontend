// import 'dart:convert';

class Transcript {
  final int transcriptId;
  final num duration;
  final num startTime;
  final String sentence;

  Transcript(
      {required this.transcriptId,
      required this.duration,
      required this.startTime,
      required this.sentence});

  factory Transcript.fromJson(Map<String, dynamic> json) => Transcript(
        transcriptId: json['transcriptId'],
        duration: json['duration'],
        startTime: json['startTime'],
        sentence: json['sentence'],
      );

  Map<String, dynamic> toJson() => {
        'transcriptId': transcriptId,
        'duration': duration,
        'start': startTime,
        'sentence': sentence
      };

  @override
  String toString() {
    return '''
      transcriptId: $transcriptId
      duration : $duration
      startTime : $startTime
      sentence : $sentence
    ''';
  }
}

// List<Transcript> listTranscriptsFromJson(String json) {
//   List<dynamic> parsedJson = jsonDecode(json)["transcripts"];
//   // print("parsedJson = $parsedJson");
//   List<Transcript> listTranscripts = [];
//   for (int i = 0; i < parsedJson.length; i++) {
//     listTranscripts.add(Transcript.fromJson(parsedJson[i]));
//   }
//   return listTranscripts;
// }
