import 'dart:async';

import 'package:digitalproductstore/viewobject/common/language_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/db/common/ps_shared_preferences.dart';
import 'package:digitalproductstore/repository/Common/ps_repository.dart';
import 'package:digitalproductstore/viewobject/common/language.dart';

class LanguageRepository extends PsRepository {
  LanguageRepository({@required PsSharedPreferences psSharedPreferences}) {
    _psSharedPreferences = psSharedPreferences;
  }

  final StreamController<PsLanguageValueHolder> _valueController =
      StreamController<PsLanguageValueHolder>();
  Stream<PsLanguageValueHolder> get psValueHolder => _valueController.stream;

  PsSharedPreferences _psSharedPreferences;

  void loadLanguageValueHolder() {
    final String _languageCodeKey =
        _psSharedPreferences.shared.getString(LANGUAGE__LANGUAGE_CODE_KEY);
    final String _countryCodeKey =
        _psSharedPreferences.shared.getString(LANGUAGE__COUNTRY_CODE_KEY);
    final String _languageNameKey =
        _psSharedPreferences.shared.getString(LANGUAGE__LANGUAGE_NAME_KEY);

    _valueController.add(PsLanguageValueHolder(
      languageCode: _languageCodeKey,
      countryCode: _countryCodeKey,
      name: _languageNameKey,
    ));
  }

  Future<void> addLanguage(Language language) async {
    await _psSharedPreferences.shared
        .setString(LANGUAGE__LANGUAGE_CODE_KEY, language.languageCode);
    await _psSharedPreferences.shared
        .setString(LANGUAGE__COUNTRY_CODE_KEY, language.countryCode);
    await _psSharedPreferences.shared
        .setString(LANGUAGE__LANGUAGE_NAME_KEY, language.name);
    loadLanguageValueHolder();
  }

  Language getLanguage() {
    final String languageCode =
        _psSharedPreferences.shared.getString(LANGUAGE__LANGUAGE_CODE_KEY) ??
            defaultLanguage.languageCode;
    final String countryCode =
        _psSharedPreferences.shared.getString(LANGUAGE__COUNTRY_CODE_KEY) ??
            defaultLanguage.countryCode;
    final String languageName =
        _psSharedPreferences.shared.getString(LANGUAGE__LANGUAGE_NAME_KEY) ??
            defaultLanguage.name;

    return Language(
        languageCode: languageCode,
        countryCode: countryCode,
        name: languageName);
  }
}
