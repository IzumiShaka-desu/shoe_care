import 'dart:ui';

import '../utils/color_utils.dart';

extension StringExtension on String {
  bool get isCodeValid {
    // example of code : 2212T00252K-AMB2311-10329
    // example of code : 2212T00269K-AMB2311-07693
    // using regex to validate squence of code with minium length is 15
    // and 2 chars at first is digit of year and next 2 chars is digit of month
    // and contains one K- and next of K- is 3 chars is capital letter

    RegExp regExp = RegExp(r"^\d{2}\d{2}T\d{5}K-[A-Z]{3}\d{4}");

    return regExp.hasMatch(trim());
  }

  String get capitalized {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  Color get typeAsColor {
    switch (toLowerCase()) {
      case "bug":
        return fromHex("#A8B820");
      case "dark":
        return fromHex("#705848");
      case "dragon":
        return fromHex("#7038F8");
      case "electric":
        return fromHex("#F8D030");
      case "fairy":
        return fromHex("#EE99AC");
      case "fighting":
        return fromHex("#C03028");
      case "fire":
        return fromHex("#F08030");
      case "flying":
        return fromHex("#A890F0");
      case "ghost":
        return fromHex("#705898");
      case "grass":
        return fromHex("#78C850");
      case "ground":
        return fromHex("#E0C068");
      case "ice":
        return fromHex("#98D8D8");
      case "normal":
        return fromHex("#A8A878");
      case "poison":
        return fromHex("#A040A0");
      case "psychic":
        return fromHex("#F85888");
      case "rock":
        return fromHex("#B8A038");
      case "steel":
        return fromHex("#B8B8D0");
      case "water":
        return fromHex("#6890F0");
      default:
        return fromHex("#A8A77A");
    }
  }

  Color get colorNameAsColor {
    switch (this) {
      case "black":
        return fromHex("#705746");
      case "blue":
        return fromHex("#76BDFE");
      case "brown":
        return fromHex("#B6A136");
      case "gray":
        return fromHex("#B7B7CE");
      case "green":
        return fromHex("#48D0B0");
      case "pink":
        return fromHex("#D685AD");
      case "purple":
        return fromHex("#A33EA1");
      case "red":
        return fromHex("#FB6C6C");
      case "white":
        return fromHex("#A8A77A");
      case "yellow":
        return fromHex("#FFD86F");
      default:
        return fromHex("#A8A77A");
    }
  }
}

String fillStringWith(String string,
    {String fillString = "0", int maxLength = 3}) {
  if (string.length >= maxLength) return string;
  final diff = maxLength - string.length;
  return "${fillString * diff}$string";
}
