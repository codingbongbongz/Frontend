import 'dart:convert';

class Evaluation {
  final int overall;
  final int pronunciation;
  final int fluency;
  final int integrity;
  final int rhythm;
  final int speed;

  Evaluation({
    required this.overall,
    required this.pronunciation,
    required this.fluency,
    required this.integrity,
    required this.rhythm,
    required this.speed,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) => Evaluation(
        overall: json['overall'],
        pronunciation: json['pronunciation'],
        fluency: json['fluency'],
        integrity: json['integrity'],
        rhythm: json['rhythm'],
        speed: json['speed'],
      );

  Map<String, dynamic> toJson() => {
        'overall': overall,
        'pronunciation': pronunciation,
        'fluency': fluency,
        'integrity': integrity,
        'rhythm': rhythm,
        'speed': speed
      };

  @override
  String toString() {
    return '''
      overall : $overall,
      pronunciation : $pronunciation,
      fluency : $fluency,
      integrity : $integrity,
      rhythm: $rhythm,
      speed : $speed
    ''';
  }
}

Evaluation evaluationsFromJson(String json) {
  dynamic parsedJson = jsonDecode(json)["data"]["evaluation"];
  // print("parsedJson = $parsedJson");
  Evaluation evaluations = (Evaluation.fromJson(parsedJson));

  return evaluations;
}
