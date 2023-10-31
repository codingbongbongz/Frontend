import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k_learning/const/color.dart';

import '../const/key.dart';

class EditUserInfoScreen extends StatefulWidget {
  final String profileImageUrl;
  final String nickname;
  final String introduce;

  const EditUserInfoScreen({
    super.key,
    required this.nickname,
    required this.introduce,
    required this.profileImageUrl,
  });

  @override
  State<EditUserInfoScreen> createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  var nickname = TextEditingController();
  var introduce = TextEditingController();
  String _nickname = '';
  String _introduce = '';
  String _profileImageUrl = '';
  // Map my_map = {};

  // 수정된 nickname과 introduce를 반환하는 메서드
  // Future<Map<String, dynamic>> getEditedUserInfo() async {
  //   // 수정된 nickname과 introduce를 Map에 담아서 반환합니다.
  //   return {
  //     'nickname': nickname.text,
  //     'introduce': introduce.text,
  //   };
  // }

  patchUserInfo() async {
    var dio = await authDio(context);
    FormData formData = FormData.fromMap({
      // "Authorization": accessToken,
      "nickname": nickname.text,
      "introduce": introduce.text,
    });
    final response = await dio.patch(
      'mypage',
      data: formData,
      options: Options(
        headers: {"Content-Type": "multipart/form-data"},
      ),
    );

    dynamic responseBody = response.data['data'];
    // print(responseBody);
  }

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname;
    _introduce = widget.introduce;
    _profileImageUrl = widget.profileImageUrl;
    nickname.text = _nickname;
    introduce.text = _introduce;

    // my_map['nickname'] = nickname.text;
    // my_map['introduce'] = introduce.text;
  }

  @override
  void dispose() {
    // patchUserInfo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 4;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            imageProfile(),
            // _profileImageUrl != ''
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nickname,
                maxLength: 10,
                decoration: InputDecoration(
                  // prefixIcon: Icon(Icons.link),,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: blueColor),
                  ),
                  labelText: 'nickname',
                  // hintText: _nickname,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: introduce,
                maxLength: 30,
                maxLines: null,
                decoration: InputDecoration(
                  // prefixIcon: Icon(Icons.link),,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: blueColor),
                  ),
                  labelText: 'introduce',
                  // contentPadding: EdgeInsets.symmetric(vertical: 30.0),
                ),
              ),
            ),
            TextButton(
              onPressed: patchUserInfo,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  getPlatformDependentColor(
                      context, Color(0xFFF7F7F7), Colors.grey),
                ),
              ),
              child: Text(
                'edit UserInfo',
                style: TextStyle(
                  // color: Colors.white,
                  color: getPlatformDependentColor(
                      context, Colors.black, Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    final _imageSize = MediaQuery.of(context).size.width / 4;

    return Center(
        child: Column(
      children: [
        // if (_imageFile == null)
        //   Container(
        //     constraints: BoxConstraints(
        //       minHeight: _imageSize,
        //       minWidth: _imageSize,
        //     ),
        //     childe:
        //   )
        // else
        //   Container(
        //     width: _imageSize,
        //     height: _imageSize,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       border: Border.all(
        //           width: 2, color: Theme.of(context).colorScheme.primary),
        //       image: DecorationImage(
        //           image: FileImage(File(_imageFile!.path)), fit: BoxFit.cover),
        //     ),
        //   ),
        if (_imageFile == null)
          CircleAvatar(
            radius: 80,
            // backgroundImage: AssetImage(
            //   'assets/images/defaultProfile.png',
            // ),
            backgroundColor: Colors.transparent,
          )
        else
          CircleAvatar(
            radius: 80,
            backgroundImage: FileImage(File(_imageFile!.path)),
          ),
        // Positioned(
        //   bottom: 10,
        //   right: 10,
        //   child: InkWell(
        //       onTap: () {
        //         showModalBottomSheet(
        //           context: context,
        //           builder: (builder) => bottomSheet(),
        //         );
        //       },
        //       child: Icon(
        //         Icons.camera_alt,
        //         size: 40,
        //       )),
        // ),
        TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (builder) => bottomSheet(),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              getPlatformDependentColor(
                  context, Color(0xFFF7F7F7), Colors.grey),
            ),
          ),
          child: Text(
            '프로필 사진 변경',
            style: TextStyle(
              color: getPlatformDependentColor(
                  context, Colors.black, Colors.white),
            ),
          ),
        ),
      ],
    ));
  }

  Widget bottomSheet() {
    return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              'Choose Profile Photo',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  // onPressed: () {},
                  onPressed: () => takePhoto(ImageSource.camera),
                  child: Icon(
                    Icons.camera,
                    size: 50,
                  ),
                ),
                TextButton(
                  // onPressed: () {},
                  onPressed: () => takePhoto(ImageSource.gallery),
                  child: Icon(
                    Icons.photo_library,
                    size: 50,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  takePhoto(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    } else {
      print('이미지 선택안함');
    }
  }
  //   if (pickedFile != null) {
  //     setState(() {
  //       _pickedFile = pickedFile;
  //     });
  //   } else {
  //     print('이미지 선택안함');
  //   }
  // }
}
