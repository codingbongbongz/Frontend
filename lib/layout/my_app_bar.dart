import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_learning/const/color.dart';
import 'package:k_learning/main.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.white
              : Colors.grey[850],
      iconTheme: const IconThemeData(
        color: blueColor, //색변경
      ),
      elevation: 0,
      leadingWidth: 70,
      toolbarHeight: 140,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/k-learning_logo.png',
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
