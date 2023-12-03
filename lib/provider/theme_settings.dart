import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// Change Theme
class ThemeSettings extends ChangeNotifier{
  ThemeData _currentTheme = ThemeData.light();
  ThemeData get currentTheme => _currentTheme;

  // Change Theme
  ThemeSettings(bool isDark){
    if(isDark){
      _currentTheme = ThemeData.dark();
    }else{
      _currentTheme = ThemeData.light();
    }
  }

  // Function Save Theme
  void toggleTheme() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_currentTheme == ThemeData.light()){
      _currentTheme = ThemeData.dark();
      sharedPreferences.setBool('is_dark', true);
    }else{
      _currentTheme = ThemeData.light();
      sharedPreferences.setBool('is_dark', false);

    }
    notifyListeners();
  }

}