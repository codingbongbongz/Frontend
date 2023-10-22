import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:k_learning/class/categorie.dart';
import 'package:k_learning/class/login_platform.dart';
import 'package:k_learning/layout/my_app_bar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../class/token.dart';
import '../const/key.dart';
import '../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var email = TextEditingController();
  var name = TextEditingController();
  var nickname = TextEditingController();
  var introduce = TextEditingController();
  var country = TextEditingController();
  var password = TextEditingController();

  final _countryList = ["English", "Vitenamese", "Korean"];
  String _selectCountry = "English";

  LoginPlatform _loginPlatform = LoginPlatform.none;

  static final List<Categorie> _countries = [
    Categorie(id: 1, name: "English"),
    Categorie(id: 2, name: "Vietnamese"),
    Categorie(id: 3, name: "Korean"),
    Categorie(id: 4, name: "Japanese"),
    Categorie(id: 5, name: "Chinese"),
  ];
  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      setState(() {
        _loginPlatform = LoginPlatform.google;
      });
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

      setState(() {
        _loginPlatform = LoginPlatform.apple;
      });
    } catch (error) {
      print('error = $error');
    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        break;
      default:
        break;
    }
    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    return Card(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage('assets/images/$path.png'),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(35.0),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Input('email', email),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Input('name', name),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Input('nickname', nickname),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Input('introduce', introduce),
          ),
          const SizedBox(
            height: 20,
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Input('country', country),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: DropdownButton<String>(
                value: _selectCountry,
                items: _countryList
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectCountry = value!;
                  });
                }),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Input('password', password),
          ),
          // const SizedBox(
          //   height: 50,
          // ),
          ElevatedButton(
              onPressed: () async {
                // var dio = await authDio(context);
                var dio = Dio();
                dio.options.baseUrl = baseURL;
                var param = {
                  'email': email.text,
                  'name': name.text,
                  'nickname': nickname.text,
                  'introduce': introduce.text,
                  'country': _selectCountry,
                  'password': password.text
                };

                final response = await dio.post(
                  'auth/signup',
                  data: param,
                );

                if (response.statusCode == 200) {
                  var accessToken = response.data['data']['accessToken'];
                  var refreshToken = response.data['data']['refreshToken'];
                  print(accessToken);
                  print(refreshToken);
                  final storage = FlutterSecureStorage();

                  var val = jsonEncode(Token(
                      accessToken: accessToken, refreshToken: refreshToken));
                  await storage.write(key: 'login', value: val);

                  // await storage.write(key: 'ACCESS_TOKEN', value: accessToken);
                  // await storage.write(
                  //     key: 'REFRESH_TOKEN', value: refreshToken);

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(),
                      ),
                      (route) => false);
                }
              },
              child: Text('SIGN UP')),
          if (Platform.isIOS) _loginButton('apple_logo', signInWithApple),
          if (Platform.isAndroid) _loginButton('google_logo', signInWithGoogle),
        ],
      ),
    );
  }

  TextField Input(text, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.link),,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.blue),
        ),
        labelText: text,
      ),
    );
  }
}
