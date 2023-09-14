import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:k_learning/layout/my_app_bar.dart';
import 'package:k_learning/screen/sign_up_screen.dart';

import '../class/token.dart';
import '../const/key.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Dio dio = Dio()..httpClientAdapter = IOHttpClientAdapter();
  // String ID = '';
  // String PW = '';
  var username = TextEditingController(); // id 입력 저장
  var password = TextEditingController(); // PW 저장
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';

  @override
  void initState() {
    super.initState();

    dio.options.baseUrl = baseURL;
    dio.interceptors.add(CustomInterceptors());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key: 'login');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      Navigator.pushNamed(context, '/main');
    } else {
      print('로그인이 필요합니다');
    }
  }

  loginAction(accountName, password) async {
    try {
      var dio = Dio();
      var param = {'account_name': '$accountName', 'password': '$password'};
      // final rawString = '$username:$password';

      // Codec<String, String> stringToBase64 = utf8.fuse(base64);
      // String token = stringToBase64.encode(rawString);
      // final response = await dio.get('auth/signin',
      //     options: Options(headers: {
      //       'Authorization': 'Basic $token',
      //     }));
      Response response = await dio.post('로그인 API URL', data: param);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.data['user_id'].toString());
        // 직렬화를 이용하여 데이터를 입출력하기 위해 model.dart에 Login 정의 참고
        var val = jsonEncode(
            Token(accessToken: 'accessToken', refreshToken: 'refreshoken'));

        await storage.write(
          key: 'login',
          value: val,
        );
        print('접속 성공!');
        return true;
      } else {
        print('error');
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            color: Colors.blue.shade100,
            width: 100,
            height: 100,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[350]),
              'K-learning'),
          SizedBox(
            height: 10,
          ),
          Text('K-컨텐츠를 통해 쉽고 재밌게 한국어를 학습해보세요!'),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: username,
              decoration: const InputDecoration(
                // prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelText: 'username',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: password,
              decoration: const InputDecoration(
                // prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelText: 'password',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SignUpScreen(),
                ),
              );
            },
            child: Text('SIGN UP'),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () async {
                if (await loginAction(username.text, password.text) == true) {
                  print('로그인 성공');
                  // Navigator.pop(context, '/service'); // 로그인 이후 서비스 화면으로 이동
                  Navigator.pop(context);
                } else {
                  print('로그인 실패');
                }
              },
              child: Text('LOGIN')),
        ],
      ),
    );
  }
}
