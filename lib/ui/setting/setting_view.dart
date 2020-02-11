import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController.forward();
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 100 * (1.0 - animation.value), 0.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _SettingPrivacyWidget(),
                  _SettingNotificationWidget(),
                  _SettingDarkAndWhiteModeWidget(
                      animationController: widget.animationController),
                  Divider(
                    height: ps_space_1,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _SettingAppVersionWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SettingPrivacyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('App Info');
        Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 1);
      },
      child: Container(
        color: Utils.isLightMode(context) ? Colors.white : Colors.black12,
        padding: const EdgeInsets.all(ps_space_16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'setting__privacy_policy'),
                  style: Theme.of(context).textTheme.subhead,
                ),
                const SizedBox(
                  height: ps_space_10,
                ),
                Text(
                  Utils.getString(context, 'setting__policy_statement'),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.orange,
              size: ps_space_12,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingNotificationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Notification Setting');
        Navigator.pushNamed(context, RoutePaths.notiSetting);
      },
      child: Container(
        color: Utils.isLightMode(context) ? Colors.white : Colors.black12,
        padding: const EdgeInsets.all(ps_space_16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'setting__notification_setting'),
                  style: Theme.of(context).textTheme.subhead,
                ),
                const SizedBox(
                  height: ps_space_10,
                ),
                Text(
                  Utils.getString(context, 'setting__control_setting'),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.orange,
              size: ps_space_12,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingDarkAndWhiteModeWidget extends StatefulWidget {
  const _SettingDarkAndWhiteModeWidget({Key key, this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  __SettingDarkAndWhiteModeWidgetState createState() =>
      __SettingDarkAndWhiteModeWidgetState();
}

class __SettingDarkAndWhiteModeWidgetState
    extends State<_SettingDarkAndWhiteModeWidget> {
  bool checkClick = false;
  bool isDarkOrWhite = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Utils.isLightMode(context) ? Colors.white : Colors.black12,
        padding: const EdgeInsets.only(
            left: ps_space_16, bottom: ps_space_12, right: ps_space_12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              Utils.getString(context, 'setting__change_mode'),
              style: Theme.of(context).textTheme.subhead,
            ),
            if (checkClick)
              Switch(
                value: isDarkOrWhite,
                onChanged: (bool value) {
                  setState(() {
                    isDarkOrWhite = value;
                    changeBrightness(context);
                  });
                },
                activeTrackColor: ps_ctheme__color_speical,
                activeColor: ps_ctheme__color_speical,
              )
            else
              Switch(
                value: isDarkOrWhite,
                onChanged: (bool value) {
                  setState(() {
                    isDarkOrWhite = value;
                    changeBrightness(context);
                  });
                },
                activeTrackColor: ps_ctheme__color_speical,
                activeColor: ps_ctheme__color_speical,
              ),
          ],
        ));
  }
}

void changeBrightness(BuildContext context) {
  DynamicTheme.of(context).setBrightness(
      Utils.isLightMode(context) ? Brightness.dark : Brightness.light);
}

class _SettingAppVersionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('App Info');
      },
      child: Container(
        width: double.infinity,
        color: Utils.isLightMode(context) ? Colors.white : Colors.black12,
        padding: const EdgeInsets.all(ps_space_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Utils.getString(context, 'setting__app_version'),
              style: Theme.of(context).textTheme.subhead,
            ),
            const SizedBox(
              height: ps_space_10,
            ),
            Text(
              app_version,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ),
    );
  }
}
