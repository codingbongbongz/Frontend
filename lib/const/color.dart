import 'dart:ui';

import 'package:flutter/material.dart';

const blueColor = Color(0xFF007AFF);
const greyColor = Color(0xFF999999);
const lightGreyColor = Color(0xFFF0F0F0);
const mediumGreyColor = Color(0xFFFAFAFA);

getPlatformDependentColor(BuildContext context, lightColor, darkColor) {
  return MediaQuery.of(context).platformBrightness == Brightness.light
      ? lightColor
      : darkColor;
}
