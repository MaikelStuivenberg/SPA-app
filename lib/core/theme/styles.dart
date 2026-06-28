import 'package:flutter/material.dart';

class Styles {
  static TextStyle textStyleHandwritten(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      fontFamily: 'Montserrat',
      decoration: TextDecoration.none,
    );
  }
}
