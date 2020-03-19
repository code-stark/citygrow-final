import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/Service/firestore_loc.dart';
import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/locator.dart';
import 'package:digitalproductstore/model/user_model.dart';
import 'package:digitalproductstore/provider/basket/basket_provider.dart';
import 'package:digitalproductstore/repository/basket_repository.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/holder/intent_holder/checkout_intent_holder.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../item/basket_list_item.dart';

class BasketListView extends StatefulWidget {
  const BasketListView({
    Key key,
    @required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;
  @override
  _BasketListViewState createState() => _BasketListViewState();
}

class _BasketListViewState extends State<BasketListView>
    with SingleTickerProviderStateMixin {
  BasketRepository basketRepo;
  dynamic data;

  @override
  Widget build(BuildContext context) {
    data = EasyLocalizationProvider.of(context).data;
    basketRepo = Provider.of<BasketRepository>(context);
    final Users users = Provider.of<Users>(context);
    return EasyLocalizationProvider(
        data: data,
        child: ChangeNotifierProvider<BasketProvider>(
          create: (BuildContext context) {
            final BasketProvider provider = BasketProvider(repo: basketRepo);
            provider.loadBasketList();
            return provider;
          },
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('AppUsers')
                  .document(users.uid)
                  .collection('cart')
                  .snapshots(),
              builder: (context, snapshot) {
                return Consumer<BasketProvider>(builder: (BuildContext context,
                    BasketProvider provider, Widget child) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data.documents != null &&
                      snapshot.data.documents.length != null) {
                    if (snapshot.data.documents.isNotEmpty) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                final int count =
                                    snapshot.data.documents.length;
                                widget.animationController.forward();
                                return BasketListItemView(
                                    cartList: snapshot.data.documents[index],
                                    animationController:
                                        widget.animationController,
                                    animation:
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: widget.animationController,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    // basket: provider.basketList.data[index],
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments:
                                              snapshot.data.documents[index]);
                                    },
                                    onDeleteTap: () {
                                      sl.get<FirebaseBloc>().deleteBasket(
                                          snapshot
                                              .data.documents[index].documentID,
                                          users.uid);
                                    });
                              },
                            )),
                          ),
                          _CheckoutButtonWidget(provider: provider),
                        ],
                      );
                    } else {
                      widget.animationController.forward();
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: widget.animationController,
                                  curve: const Interval(0.5 * 1, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                      return AnimatedBuilder(
                        animation: widget.animationController,
                        builder: (BuildContext context, Widget child) {
                          return FadeTransition(
                              opacity: animation,
                              child: Transform(
                                transform: Matrix4.translationValues(
                                    0.0, 100 * (1.0 - animation.value), 0.0),
                                child: SingleChildScrollView(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height,
                                    padding: const EdgeInsets.only(
                                        bottom: ps_space_120),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/images/empty_basket.png',
                                          height: 150,
                                          width: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(
                                          height: ps_space_32,
                                        ),
                                        Text(
                                          Utils.getString(context,
                                              'basket_list__empty_cart_title'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .body2
                                              .copyWith(),
                                        ),
                                        const SizedBox(
                                          height: ps_space_20,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              Utils.getString(context,
                                                  'basket_list__empty_cart_description'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(),
                                              textAlign: TextAlign.center),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                        },
                      );
                    }
                  } else {
                    return Container();
                  }
                });
              }),
        ));
  }
}

class _CheckoutButtonWidget extends StatelessWidget {
  const _CheckoutButtonWidget({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final BasketProvider provider;
  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    for (int i = 0; i < provider.basketList.data.length; i++) {
      totalPrice += double.parse(provider.basketList.data[i].unitPrice);
    }

    return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(ps_space_8),
        decoration: BoxDecoration(
          color:
              Utils.isLightMode(context) ? Colors.grey[100] : Colors.grey[850],
          border: Border.all(
              color: Utils.isLightMode(context)
                  ? Colors.grey[200]
                  : Colors.grey[900]),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(ps_space_12),
              topRight: Radius.circular(ps_space_12)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Utils.isLightMode(context)
                  ? Colors.grey[500]
                  : Colors.grey[900],
              blurRadius: 17.0, // has the effect of softening the shadow
              spreadRadius: 4.0, // has the effect of extending the shadow
              offset: const Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ],
        ),
        // margin: const EdgeInsets.only(
        //     left: ps_space_10, right: ps_space_10, bottom: ps_space_24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: ps_space_4),
            Text(
              '${Utils.getString(context, 'checkout__price')} \$ ${Utils.getPriceFormat(totalPrice.toString())}',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: ps_ctheme__color_speical),
            ),
            const SizedBox(height: ps_space_8),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.payment, color: Colors.white),
                  const SizedBox(
                    width: ps_space_8,
                  ),
                  Text(
                    Utils.getString(
                        context, 'basket_list__checkout_button_name'),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
              color: ps_ctheme__color_speical,
              onPressed: () async {
                if (await utilsCheckInternetConnectivity()) {
                  utilsNavigateOnUserVerificationView(context, () async {
                    await Navigator.pushNamed(context, RoutePaths.checkout,
                        arguments: CheckoutIntentHolder(
                            productList: provider.basketList.data,
                            publishKey: provider.psValueHolder.publishKey));
                    provider.loadBasketList();
                  });
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: Utils.getString(
                              context, 'error_dialog__no_internet'),
                        );
                      });
                }
              },
            ),
          ],
        ));
  }
}
