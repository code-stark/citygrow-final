import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';
import 'package:digitalproductstore/repository/ps_theme_repository.dart';

class PsThemeProvider extends PsProvider {
  PsThemeProvider({@required PsThemeRepository repo}) : super(repo) {
    _repo = repo;
  }
  PsThemeRepository _repo;

  Future<dynamic> updateTheme(bool isDarkTheme) {
    return _repo.updateTheme(isDarkTheme);
  }

  ThemeData getTheme() {
    return _repo.getTheme();
  }
}
