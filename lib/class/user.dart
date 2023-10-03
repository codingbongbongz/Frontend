// import 'dart:convert';

// "userId": 117,
//         "name": "111",
//         "password": "234",
//         "email": "123123",
//         "nickname": "21321",
//         "country": import 'package:k_learning/class/evaluation.dart';
// import 'package:k_learning/class/video.dart';

// null,
//         "social": null,
//         "profileImageUrl": null,
//         "introduce": "11245",
//         "totalScore": 0,
//         "createdAt": "2023-09-27T14:19:47.701367",
//         "userVideos": [],
//         "evaluations": []

import 'package:k_learning/class/evaluation.dart';
import 'package:k_learning/class/video.dart';

class User {
  final int userId;
  final String name;
  final String email;
  final String nickname;
  final String country;
  final String social;
  final String profileImageUrl;
  final String introduce;
  final int totalScore;
  final Video userVideos;
  final Evaluation evaluations;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.nickname,
    required this.country,
    required this.social,
    required this.profileImageUrl,
    required this.introduce,
    required this.totalScore,
    required this.userVideos,
    required this.evaluations,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['userId'],
        name: json['name'],
        email: json['email'],
        nickname: json['nickname'],
        country: json['country'],
        social: json['social'],
        profileImageUrl: json['profileImageUrl'],
        introduce: json['introduce'],
        totalScore: json['totalScore'],
        userVideos: json['userVideos'],
        evaluations: json['evaluations'],
      );

  // @override
  // String toString() {
  //   return '''
  //     overall : $overall,
  //     pronunciation : $pronunciation,
  //     fluency : $fluency,
  //     integrity : $integrity,
  //     rhythm: $rhythm,
  //     speed : $speed
  //   ''';
  // }
}

// Evaluation evaluationsFromJson(String json) {
//   dynamic parsedJson = jsonDecode(json)["data"]["evaluation"];
//   // print("parsedJson = $parsedJson");
//   Evaluation evaluations = (Evaluation.fromJson(parsedJson));

//   return evaluations;
// }
