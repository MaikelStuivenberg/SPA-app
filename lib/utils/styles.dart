import 'package:flutter/material.dart';
import 'package:spa_app/utils/app_colors.dart';

class Styles {
  Styles._();

  static const TextStyle pageTitle = TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
    fontWeight: FontWeight.w500,
    fontSize: 24,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );
  static const TextStyle pageSubTitle = TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
    fontWeight: FontWeight.w400,
    fontSize: 22,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );
  static const TextStyle pageSubTitleDark = TextStyle(
    color: Color.fromARGB(255, 80, 80, 80),
    fontWeight: FontWeight.w400,
    fontSize: 22,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );
  static const TextStyle weatherDate = TextStyle(
    color: Color.fromARGB(255, 80, 80, 80),
    fontWeight: FontWeight.normal,
    fontSize: 14,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );
  static const TextStyle weatherCelcius = TextStyle(
    color: Color.fromARGB(255, 80, 80, 80),
    fontWeight: FontWeight.bold,
    fontSize: 14,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );

  static const TextStyle textTitleStyle = TextStyle(
    color: Color.fromARGB(255, 80, 80, 80),
    fontWeight: FontWeight.w600,
    fontSize: 16,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );
  static const TextStyle textSubTitleStyle = TextStyle(
    color: Color.fromARGB(255, 80, 80, 80),
    fontWeight: FontWeight.w400,
    fontSize: 12,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );

  static const TextStyle textStyle = TextStyle(
    color: Color.fromARGB(255, 80, 80, 80),
    fontWeight: FontWeight.w400,
    fontSize: 14,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );
  static const TextStyle textStyleHandwritten = TextStyle(
    color: Color.fromARGB(255, 80, 80, 80),
    fontWeight: FontWeight.w400,
    fontSize: 14,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );

  static const TextStyle textStyleMedium = TextStyle(
    color: Color.fromARGB(255, 80, 80, 80),
    fontWeight: FontWeight.w400,
    fontSize: 16,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );

  static const TextStyle textStyleMediumDark = TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
    fontWeight: FontWeight.w400,
    fontSize: 16,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );

  static const TextStyle textStyleLarge = TextStyle(
    color: Color.fromARGB(255, 80, 80, 80),
    fontWeight: FontWeight.w600,
    fontSize: 20,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );

  static const TextStyle textTitleStyleLight = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );
  static const TextStyle textSubTitleStyleLight = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );
  static const TextStyle textStyleLight = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );

  static const TextStyle textNumber = TextStyle(
    color: Color.fromARGB(200, 255, 255, 255),
    fontWeight: FontWeight.w600,
    fontSize: 18,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );

  static const TextStyle textInput = TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
    fontWeight: FontWeight.w400,
    fontSize: 18,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );

  static const TextStyle buttonText = TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
    fontWeight: FontWeight.w600,
    fontSize: 16,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.none,
  );

  static const InputDecoration textInputDecoration = InputDecoration(
    labelStyle: TextStyle(
      color: Color.fromARGB(200, 255, 255, 255),
      fontWeight: FontWeight.w600,
      fontSize: 16,
      fontFamily: 'Montserrat',
      decoration: TextDecoration.none,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );

  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonColor,
    foregroundColor: Colors.white,
  );
}
