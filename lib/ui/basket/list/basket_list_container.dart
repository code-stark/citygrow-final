import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/material.dart';
import 'basket_list_view.dart';

class BasketListContainerView extends StatefulWidget {
  @override
  _CityBasketListContainerViewState createState() =>
      _CityBasketListContainerViewState();
}
// final DocumentSnapshot productSnapshot;
class _CityBasketListContainerViewState extends State<BasketListContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Utils.isLightMode(context)
                  ? ps_ctheme__color_speical
                  : Colors.white),
          title: Text(
            Utils.getString(context, 'basket_list_container__app_bar_name'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title.copyWith(
                fontWeight: FontWeight.bold,
                color: Utils.isLightMode(context)
                    ? ps_ctheme__color_speical
                    : Colors.white),
          ),
          elevation: 0,
        ),
        body: BasketListView(
          animationController: animationController,
        ),
      ),
    );
  }
}
