import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.amber,
                  height: 50,
                  width: 50,
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '김태오',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text('안녕하새요, 저는 한줄소개 입니다! ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ'),
                    ],
                  ),
                ),
              ),
              // Icon(Icons.edit),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit),
                iconSize: 15,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () {},
                child:
                    Text('학습했던 동영상 확인', style: TextStyle(color: Colors.black)),
              ),
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () {},
                child: Text('다크모드', style: TextStyle(color: Colors.black)),
              ),
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () {},
                child: Text('서비스 탈퇴하기', style: TextStyle(color: Colors.black)),
              ),
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () {},
                child: Text('로그 아웃', style: TextStyle(color: Colors.black)),
              ),
              Container(
                height: 1.0,
                // width: 300.0,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
