import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_learning/const/color.dart';
import 'package:k_learning/main.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.white
              : Colors.grey[850],
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

      leading: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(),
                ),
                (route) => false);
          },
          child: Image.asset(
            'assets/images/k-learning_logo.png',
            height: 50,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
