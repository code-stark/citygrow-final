import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_config.dart';
// import 'package:digitalproductstore/ui/product/list_with_filter/product_list_with_filter_view.dart';
import 'package:digitalproductstore/ui/product/purchase_product/purchase_product_grid_view.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/material.dart';

class PurchasedProductContainerView extends StatefulWidget {
  // const PurchasedProductContainerView(
  //     {@required this.productParameterHolder, @required this.appBarTitle});
  // final ProductParameterHolder productParameterHolder;
  // final String appBarTitle;
  @override
  _PurchasedProductContainerViewState createState() =>
      _PurchasedProductContainerViewState();
}

class _PurchasedProductContainerViewState
    extends State<PurchasedProductContainerView>
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
            Utils.getString(context, 'home__menu_drawer_purchased_product'),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontWeight: FontWeight.bold)
                .copyWith(
                    color: Utils.isLightMode(context)
                        ? ps_ctheme__color_speical
                        : Colors.white),
          ),
          elevation: 1,
        ),
        body: PurchasedProductGridView(
          animationController: animationController,
        ),
      ),
    );
  }
}
