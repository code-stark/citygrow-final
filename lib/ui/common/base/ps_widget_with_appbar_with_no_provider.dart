import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';

class PsWidgetWithAppBarWithNoProvider extends StatefulWidget {
  const PsWidgetWithAppBarWithNoProvider(
      {Key key,
      this.builder,
      @required this.child,
      @required this.appBarTitle,
      this.actions = const <Widget>[]})
      : super(key: key);

  final Widget Function(BuildContext context, Widget child) builder;

  final Widget child;

  final String appBarTitle;
  final List<Widget> actions;

  @override
  _PsWidgetWithAppBarWithNoProviderState createState() =>
      _PsWidgetWithAppBarWithNoProviderState();
}

class _PsWidgetWithAppBarWithNoProviderState
    extends State<PsWidgetWithAppBarWithNoProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
        data: data,
        child: Scaffold(
          appBar: AppBar(
            brightness: Utils.getBrightnessForAppBar(context),
            iconTheme: IconThemeData(
                color: Utils.isLightMode(context)
                    ? ps_ctheme__color_speical
                    : Theme.of(context).iconTheme.color),
            title: Text(widget.appBarTitle,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: FontWeight.bold)
                    .copyWith(
                        color: Utils.isLightMode(context)
                            ? ps_ctheme__color_speical
                            : Colors.white)),
            actions: widget.actions,
            flexibleSpace: Container(
              height: 200,
            ),
            elevation: 0,
          ),
          body: widget.child,
        ));
  }
}
