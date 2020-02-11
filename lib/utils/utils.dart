import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

mixin Utils {
  static String getString(BuildContext context, String key) {
    return AppLocalizations.of(context).tr(key) ?? '';
  }

  static DateTime previous;
  static void psPrint(String msg) {
    final DateTime now = DateTime.now();
    int min = 0;
    if (previous == null) {
      previous = now;
    } else {
      min = now.difference(previous).inMilliseconds;
      previous = now;
    }

    print('$now ($min)- $msg');
  }

  static String getPriceFormat(String price) {
    return psFormat.format(double.parse(price));
  }

  static bool isLightMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }

  static Brightness getBrightnessForAppBar(BuildContext context) {
    if (Platform.isAndroid) {
      return Brightness.dark;
    } else {
      return Theme.of(context).brightness;
    }
  }
}

Future<bool> utilsCheckInternetConnectivity() async {
  final ConnectivityResult connectivityResult =
      await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile) {
    // print('Mobile');
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // print('Wifi');
    return true;
  } else if (connectivityResult == ConnectivityResult.none) {
    print('No Connection');
    return false;
  } else {
    return false;
  }
}

dynamic utilsLaunchURL() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  print(packageInfo.packageName);
  final String url =
      'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

dynamic utilsLaunchAppStoreURL({String iOSAppId}) async {
  LaunchReview.launch(writeReview: false, iOSAppId: iOSAppId);
}

dynamic utilsNavigateOnUserVerificationView(
    dynamic provider, BuildContext context, Function onLoginSuccess) async {
  provider.psValueHolder = Provider.of<PsValueHolder>(context);

  if (provider == null ||
      provider.psValueHolder.userIdToVerify == null ||
      provider.psValueHolder.userIdToVerify == '') {
    if (provider == null ||
        provider.psValueHolder == null ||
        provider.psValueHolder.loginUserId == null ||
        provider.psValueHolder.loginUserId == '') {
      final dynamic returnData = await Navigator.pushNamed(
        context,
        RoutePaths.login_container,
      );

      if (returnData != null && returnData is User) {
        final User user = returnData;
        provider.psValueHolder = Provider.of<PsValueHolder>(context);
        provider.psValueHolder.loginUserId = user.userId;
      }
    } else {
      onLoginSuccess();
    }
  } else {
    Navigator.pushNamed(
      context,
      RoutePaths.user_verify_email_container,
    );
  }
}

// Future<String> utilsCheckUserLoginId(
//   BuildContext context,
// ) async {
//   final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context);
//   if (psValueHolder.loginUserId == null) {
//     return 'nologinuser';
//   } else {
//     return psValueHolder.loginUserId;
//   }
// }

Future<String> utilsCheckUserLoginId(PsValueHolder psValueHolder) async {
  if (psValueHolder.loginUserId == null) {
    return 'nologinuser';
  } else {
    return psValueHolder.loginUserId;
  }
}
