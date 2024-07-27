import 'package:chat/theme/dark_mode.dart';
import 'package:chat/theme/light_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themdata = lightmode;

  ThemeData get themedata => _themdata;
  bool get isdarkmode => _themdata == darkmode;

  set themedata(ThemeData Themedata) {
    _themdata = Themedata;
    notifyListeners();
  }

  void toggletheme() {
    if (_themdata == lightmode) {
      themedata = darkmode;
    } else {
      themedata = lightmode;
    }
  }
}
