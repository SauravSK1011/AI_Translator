import 'package:flutter/material.dart';

class colorsUsed {
  static final Color color = Colors.grey.shade200;
  static final Color buttoncolor = Colors.grey.shade200;
  static final Color cardcolor = Colors.grey.shade200;
  static final Color appbarbackgroundColor = Colors.grey.shade200;
  static final Color bottomcolor = Colors.grey.shade400;
  static final Color dropdowncolor = Colors.grey.shade200;
  static final Color textcolor = Colors.deepPurpleAccent.shade700;
  static final Color iconcolor = Colors.deepPurple;
}

class iconUsed {
  static final items = <Widget>[
     Icon(
      Icons.camera,
      color: colorsUsed.iconcolor,
    ),
     Icon(Icons.text_fields_rounded, color: colorsUsed.iconcolor),
    Icon(
      Icons.mic_sharp,
      color: colorsUsed.iconcolor,
    ),
  ];
}
