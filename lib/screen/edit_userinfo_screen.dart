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
  TextEditingController nickname = TextEditingController();
  TextEditingController introduce = TextEditingController();
  String _nickname = '';
  String _introduce = '';
  String _profileImageUrl = '';

  patchUserInfo() async {
    final dio = await authDio(context);
    FormData formData = FormData.fromMap({
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nickname,
                maxLength: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: blueColor),
                  ),
                  labelText: 'nickname',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: introduce,
                maxLength: 30,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: blueColor),
                  ),
                  labelText: 'introduce',
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
                'Edit User Info',
                style: TextStyle(
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
        if (_imageFile == null)
          const CircleAvatar(
            radius: 80,
            backgroundColor: Colors.transparent,
          )
        else
          CircleAvatar(
            radius: 80,
            backgroundImage: FileImage(File(_imageFile!.path)),
          ),
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
            'Edit Profile Picture',
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
                  onPressed: () => takePhoto(ImageSource.camera),
                  child: Icon(
                    Icons.camera,
                    size: 50,
                  ),
                ),
                TextButton(
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
}
