import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:k_learning/class/login_platform.dart';
import 'package:k_learning/const/color.dart';
import 'package:k_learning/layout/my_app_bar.dart';
import 'package:k_learning/main.dart';
import 'package:k_learning/screen/sign_up_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../class/token.dart';
import '../const/key.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var username = TextEditingController(); // id 입력 저장
  var password = TextEditingController(); // PW 저장
  static final storage = FlutterSecureStorage();

  LoginPlatform _loginPlatform = LoginPlatform.none;
  dynamic userInfo = '';

  void signInWithID() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => SignUpScreen(
          isSocial: false,
        ),
      ),
    );
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      setState(() {
        _loginPlatform = LoginPlatform.google;
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => SignUpScreen(
            isSocial: true,
            email: googleUser.email,
            name: googleUser.displayName!,
          ),
        ),
      );
    }
  }

  void signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: "Klearning.example.com",
          redirectUri: Uri.parse(
            "https://magnificent-east-turnip/glitch.me/callbacks/sign_in_with_apple",
          ),
        ),
      );

      print('credential.state = $credential');
      print('credential.state = ${credential.email}');
      print('credential.state = ${credential.userIdentifier}');
      print('credential.state = ${credential.authorizationCode}');

      List<String> jwt = credential.identityToken?.split('.') ?? [];
      String payload = jwt[1];
      payload = base64.normalize(payload);

      final List<int> jsonData = base64.decode(payload);
      final userInfo = jsonDecode(utf8.decode(jsonData));
      print(userInfo);
      String email = userInfo['email'];
      print(email);

      // setState(() {
      //   _loginPlatform = LoginPlatform.apple;
      // });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => SignUpScreen(
            isSocial: true,
            email: credential.email ?? "",
            name: (credential.familyName ?? "") + (credential.givenName ?? ""),
          ),
        ),
      );
    } catch (error) {
      print('error = $error');
    }
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'assets/images/$path.png',
        // height: 60,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

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

  loginAction(username, password) async {
    try {
      var dio = Dio();
      dio.options.baseUrl = baseURL;
      var param = {'account_name': '$username', 'password': '$password'};
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
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'assets/images/k-learning_logo.png',
                  // width: 140,
                  // height: 140,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      // color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    'K-learning'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  """K-컨텐츠를 통해 쉽고 재밌게\n 한국어를 학습해보세요!""",
                  style: TextStyle(color: greyColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 100,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //   child: TextField(
                //     controller: username,
                //     decoration: const InputDecoration(
                //       // prefixIcon: Icon(Icons.link),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(10)),
                //         borderSide: BorderSide(color: Colors.blue),
                //       ),
                //       labelText: 'username',
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //   child: TextField(
                //     controller: password,
                //     decoration: const InputDecoration(
                //       // prefixIcon: Icon(Icons.link),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(10)),
                //         borderSide: BorderSide(color: Colors.blue),
                //       ),
                //       labelText: 'password',
                //     ),
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     TextButton(
                //       onPressed: () async {
                //         if (await loginAction(username.text, password.text) == true) {
                //           print('로그인 성공');
                //           // Navigator.pop(context, '/service'); // 로그인 이후 서비스 화면으로 이동
                //           Navigator.of(context).pushAndRemoveUntil(
                //               MaterialPageRoute(
                //                 builder: (BuildContext context) => MainScreen(),
                //               ),
                //               (route) => false);
                //         } else {
                //           print('로그인 실패');
                //         }
                //       },
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Colors.blueAccent,
                //           borderRadius: BorderRadius.circular(10.0),
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'LOGIN',
                //             style: TextStyle(
                //               fontSize: 30,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     TextButton(
                //       onPressed: () {
                //         Navigator.of(context).push(
                //           MaterialPageRoute(
                //             builder: (BuildContext context) => SignUpScreen(),
                //           ),
                //         );
                //       },
                //       child: Container(
                //         decoration: BoxDecoration(
                //             color: Colors.blueAccent,
                //             borderRadius: BorderRadius.circular(10.0)),
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'SIGN IN',
                //             style: TextStyle(
                //               fontSize: 30,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Column(
                  children: [
                    if (Platform.isIOS)
                      _loginButton('sign_in_with_Apple', signInWithApple),
                    if (Platform.isAndroid)
                      _loginButton('sign_in_with_Google', signInWithGoogle),
                    SizedBox(
                      height: 10,
                    ),
                    _loginButton('sign_in_with_ID', signInWithID),
                  ],
                ),
                // )SizedBox(
                //   height: 50,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
