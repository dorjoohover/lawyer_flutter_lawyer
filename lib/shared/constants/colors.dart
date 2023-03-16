import 'package:flutter/material.dart';

// 459FD3,1F8ED5,59CCEF,8EE2F3,01010D
/// dark [ThemeData] colors
const darkPrimary = Color(0xFFEF518B);
const darkSecondary = Color(0xFF7852A2);
const secondaryPurple = Color(0xFF755BAB);
const darkBackground = Color(0xFF121212);
const darkSurface = Color(0xFF121212);
const darkError = Color(0xFFCF6679);
const darkOnPrimary = Color(0xFF000000);
const darkOnSecondary = Color(0xFF000000);
const darkOnBackground = Color(0xFFFFFFFF);
const darkOnSurface = Color(0xFFFFFFFF);
const darkOnError = Color(0xFF000000);

// const shadow = Color(0xFF121212);

/// light [ThemeData] colors

const onBoardColor = Color(0xFF292929);
const primary = Color(0xFFEF518B);
const mediumDark = Color.fromARGB(255, 149, 149, 149);

const green = Color(0xff55C595);
const blue = Color(0xff5090EF);
const red = Color(0xffED4756);
const grey = Color(0xffFCFCFC);

const mainPurple = Color(0xff772594);

const secondary = Color(0xFF772594);
const secondryVariant = Color(0xFF018786);
const divider = Color(0xFFBDBDBD);
const background = Color(0xFFFFFFFF);
const surface = Color(0xFFFFFFFF);
const error = Color(0xFFB00020);
const onPrimary = Color(0xFFFFFFFF);
const onSecondary = Color(0xFF000000);
const onBackground = Color(0xFF000000);
const onSurface = Color(0xFF000000);
const onError = Color(0xFFFFFFFF);

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
