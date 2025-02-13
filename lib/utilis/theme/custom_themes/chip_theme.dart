import 'package:flutter/material.dart';

class TChipTheme {
  TChipTheme._();
  static ChipThemeData lightChipTheme = ChipThemeData(
   
    disabledColor: Colors.grey.withOpacity(0.4),
    selectedColor: Colors.blue,
    padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 12.0),
    checkmarkColor: Colors.white,
    labelStyle: TextStyle(color: Colors.black),

  );

  static ChipThemeData darkChipTheme = ChipThemeData(
   
    disabledColor: Colors.grey,
    selectedColor: Colors.blue,
     padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 12.0),
    labelStyle: TextStyle(color: Colors.white),
    checkmarkColor: Colors.white,
  );
}