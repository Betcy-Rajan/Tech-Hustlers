import 'package:flutter/material.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  //light theme
  static final  lightElevatedButtonTheme = ElevatedButtonThemeData (style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: Colors.blue,
    disabledBackgroundColor: Colors.grey,
    disabledForegroundColor: Colors.grey,
    side: BorderSide(
      color: Colors.blue,   
    ),
    padding: EdgeInsets.symmetric(vertical: 18),
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  )
  );
   static final  darkElevatedButtonTheme = ElevatedButtonThemeData (style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: Colors.blue,
    disabledBackgroundColor: Colors.grey,
    disabledForegroundColor: Colors.grey,
    side: BorderSide(
      color: Colors.blue,   
    ),
    padding: EdgeInsets.symmetric(vertical: 18),
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  )
  );
}