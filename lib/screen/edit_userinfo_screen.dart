import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  }

  @override
  void dispose() {
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
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelText: 'nickname',
                  // hintText: _nickname,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: introduce,
                maxLength: 30,
                maxLines: null,
                decoration: InputDecoration(
                  // prefixIcon: Icon(Icons.link),,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelText: 'introduce',
                  // contentPadding: EdgeInsets.symmetric(vertical: 30.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: patchUserInfo,
              child: const Text('edit UserInfo'),
            )
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    final _imageSize = MediaQuery.of(context).size.width / 4;

    return Center(
        child: Stack(
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
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) => bottomSheet(),
                );
              },
              child: Icon(
                Icons.camera_alt,
                size: 40,
              )),
        )
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