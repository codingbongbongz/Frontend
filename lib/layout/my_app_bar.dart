import 'package:flutter/material.dart';
import 'package:k_learning/const/color.dart';
import 'package:k_learning/main.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // title: const Text(
      //   'K-Learning',
      //   style: TextStyle(
      //     color: Colors.white,
      //     fontSize: 25,
      //   ),
      // ),
      iconTheme: IconThemeData(
        color: blueColor, //색변경
      ),
      // centerTitle: false,
      elevation: 0,
      // leading: Image.asset(
      //   'assets/images/k-learning_logo.png',
      //   height: 40,
      // ),
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(),
              ),
              (route) => false);
        },
        child: Image.asset(
          'assets/images/k-learning_logo.png',
          height: 40,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
