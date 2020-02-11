import 'dart:io';

import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/ps_app_version.dart';
import 'package:flutter/material.dart';

class ForceUpdateView extends StatelessWidget {
  ForceUpdateView({@required this.psAppVersion});
  final PSAppVersion psAppVersion;
  final Widget _imageWidget = Container(
    width: 90,
    height: 90,
    child: Image.asset(
      'assets/images/digital_product_logo_white.png',
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        color: Utils.isLightMode(context) ? Colors.white : Colors.black54,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: ps_space_80,
                    ),
                    _imageWidget,
                    const SizedBox(
                      height: ps_space_16,
                    ),
                    Text(
                      Utils.getString(context, 'app_name'),
                      style: Theme.of(context).textTheme.headline.copyWith(
                            color: Utils.isLightMode(context)
                                ? Colors.black54
                                : Colors.white,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: ps_space_16, right: ps_space_16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(
                      height: ps_space_32,
                    ),
                    Text(
                      psAppVersion.versionTitle,
                      style: Theme.of(context).textTheme.title.copyWith(
                            color: Utils.isLightMode(context)
                                ? Colors.black54
                                : Colors.white,
                          ),
                    ),
                    const SizedBox(
                      height: ps_space_8,
                    ),
                    Container(
                        height: ps_space_100,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            psAppVersion.versionMessage,
                            maxLines: 9,
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(color: Colors.green),
                          ),
                        )),
                    const SizedBox(
                      height: ps_space_8,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: ps_space_32, right: ps_space_32),
                      child: MaterialButton(
                        color: ps_ctheme__color_speical,
                        height: 45,
                        minWidth: double.infinity,
                        shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        child: Text(
                          Utils.getString(context, 'force_update__update'),
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.white),
                        ),
                        onPressed: () async {
                          // Navigator.pushReplacementNamed(
                          //   context,
                          //   RoutePaths.home,
                          // );

                          if (Platform.isIOS) {
                            utilsLaunchAppStoreURL(iOSAppId: iOSAppStoreId);
                          } else if (Platform.isAndroid) {
                            utilsLaunchURL();
                          }
                        },
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
