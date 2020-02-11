import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';
import 'package:digitalproductstore/repository/language_repository.dart';
import 'package:digitalproductstore/viewobject/common/language.dart';

class LanguageProvider extends PsProvider {
  LanguageProvider({@required LanguageRepository repo}) : super(repo) {
    _repo = repo;
    isDispose = false;
  }

  LanguageRepository _repo;

  List<Language> _languageList = <Language>[];
  List<Language> get languageList => _languageList;

  Language currentLanguage = defaultLanguage;
  String currentCountryCode = '';
  String currentLanguageName = '';

  @override
  void dispose() {
    isDispose = true;
    print('Language Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> addLanguage(Language language) async {
    currentLanguage = language;
    return await _repo.addLanguage(language);
  }

  Language getLanguage() {
    currentLanguage = _repo.getLanguage();
    return currentLanguage;
  }

  List<dynamic> getLanguageList() {
    _languageList = psSupportedLanguageList;
    return _languageList;
  }
}
