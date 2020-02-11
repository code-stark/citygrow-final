// Copyright (c) 2019, the Panacea-Soft.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Panacea-Soft license that can be found in the LICENSE file.

import 'package:digitalproductstore/viewobject/common/language.dart';

///
/// AppVersion
/// For your app, you need to change according based on your app version
///
const String app_version = '1.1';

///
/// API Key
/// If you change here, you need to update in server.
///
const String ps_api_key = 'teampsisthebest';

///
/// API URL
/// Change your backend url
///

// const String ps_app_url =
//     'http://192.168.100.173/digital-product-store-admin/index.php/';

// const String ps_app_image_url =
//     'http://192.168.100.173/digital-product-store-admin/uploads/';

// const String ps_app_image_thumbs_url =
//     'http://192.168.100.173/digital-product-store-admin/uploads/thumbnail/';

const String ps_app_url =
    'http://www.panacea-soft.com/digital-product-store-admin/index.php/';

const String ps_app_image_url =
    'http://www.panacea-soft.com/digital-product-store-admin/uploads/';

const String ps_app_image_thumbs_url =
    'http://www.panacea-soft.com/digital-product-store-admin/uploads/thumbnail/';

///
/// Animation Duration
///
const Duration animation_duration = Duration(milliseconds: 1000);

///
/// Fonts Family Config
/// Before you declare you here,
/// 1) You need to add font under assets/fonts/
/// 2) Declare at pubspec.yaml
/// 3) Update your font family name at below
///
const String ps_default_font_family = 'Product Sans';

/// Default Language
// const ps_default_language = 'en';

// const ps_language_list = [Locale('en', 'US'), Locale('ar', 'DZ')];
const String ps_app_db_name = 'ps_db.db';

///
/// For default language change, please check
/// LanguageFragment for language code and country code
/// ..............................................................
/// Language             | Language Code     | Country Code
/// ..............................................................
/// "English"            | "en"              | "US"
/// "Arabic"             | "ar"              | "DZ"
/// "India (Hindi)"      | "hi"              | "IN"
/// Germany              | "de"              | "DE"
/// Spain                | "es"              | "ES"
/// France               | "fr"              | "FR"
/// Indonesia            | "id"              | "ID"
/// Italy                | "it"              | "IT"
/// Japan                | "ja"              | "JP"
/// South Korea          | "ko"              | "KR"
/// Malaysia             | "ms"              | "MY"
/// Portugal             | "pt"              | "PT"
/// Russia               | "ru"              | "RU"
/// Thailand             | "th"              | "TH"
/// Turkey               | "tr"              | "TR"
/// China                | "zh"              | "CN"
/// ..............................................................
///
Language defaultLanguage =
    Language(languageCode: 'en', countryCode: 'US', name: 'English US');

List<Language> psSupportedLanguageList = <Language>[
  Language(languageCode: 'en', countryCode: 'US', name: 'English'),
  // Language(languageCode: 'ar', countryCode: 'DZ', name: 'Arabic'),
  Language(languageCode: 'hi', countryCode: 'IN', name: 'Hindi'),
  // Language(languageCode: 'de', countryCode: 'DE', name: 'German'),
  // Language(languageCode: 'es', countryCode: 'ES', name: 'Spainish'),
  // Language(languageCode: 'fr', countryCode: 'FR', name: 'French'),
  // Language(languageCode: 'id', countryCode: 'ID', name: 'Indonesian'),
  // Language(languageCode: 'it', countryCode: 'IT', name: 'Italian'),
  // Language(languageCode: 'ja', countryCode: 'JP', name: 'Japanese'),
  // Language(languageCode: 'ko', countryCode: 'KR', name: 'Korean'),
  // Language(languageCode: 'ms', countryCode: 'MY', name: 'Malay'),
  // Language(languageCode: 'pt', countryCode: 'PT', name: 'Portuguese'),
  // Language(languageCode: 'ru', countryCode: 'RU', name: 'Russian'),
  // Language(languageCode: 'th', countryCode: 'TH', name: 'Thai'),
  // Language(languageCode: 'tr', countryCode: 'TR', name: 'Turkish'),
  // Language(languageCode: 'zh', countryCode: 'CN', name: 'Chinese'),
];

///
/// Price Format
/// Need to change according to your format that you need
/// E.g.
/// ",##0.00"   => 2,555.00
/// "##0.00"    => 2555.00
/// ".00"       => 2555.00
/// ",##0"      => 2555
/// ",##0.0"    => 2555.0
///
const String priceFormat = ',###.00';

///
/// iOS App No
///
const String iOSAppStoreId = '000000000';
