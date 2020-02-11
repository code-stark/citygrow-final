import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/basket/basket_provider.dart';
import 'package:digitalproductstore/repository/basket_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'category_list_view.dart';

class CategoryListViewContainerView extends StatefulWidget {
  const CategoryListViewContainerView({this.appBarTitle});

  final String appBarTitle;
  @override
  _CategoryListWithFilterContainerViewState createState() =>
      _CategoryListWithFilterContainerViewState();
}

class _CategoryListWithFilterContainerViewState
    extends State<CategoryListViewContainerView>
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
  BasketRepository basketRepository;

  @override
  Widget build(BuildContext context) {
    basketRepository = Provider.of<BasketRepository>(context);
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
          iconTheme: Theme.of(context).iconTheme,
          title: Text(
            widget.appBarTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          actions: <Widget>[
            ChangeNotifierProvider<BasketProvider>(
              create: (BuildContext context) {
                final BasketProvider provider =
                    BasketProvider(repo: basketRepository);
                provider.loadBasketList();
                return provider;
              },
              child: Consumer<BasketProvider>(builder: (BuildContext context,
                  BasketProvider basketProvider, Widget child) {
                return Stack(
                  children: <Widget>[
                    Container(
                      width: ps_space_40,
                      height: ps_space_40,
                      margin: const EdgeInsets.only(
                          top: ps_space_8, left: ps_space_8, right: ps_space_8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black38,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.shopping_basket,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    InkWell(
                        child: Container(
                          width: ps_space_40,
                          height: ps_space_40,
                          margin: const EdgeInsets.only(
                              top: ps_space_8,
                              left: ps_space_8,
                              right: ps_space_8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              basketProvider.basketList.data.length > 99
                                  ? '99+'
                                  : basketProvider.basketList.data.length
                                      .toString(),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline
                                  .copyWith(
                                      fontSize: ps_space_16,
                                      color: Colors.white),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutePaths.basketList,
                          );
                        }),
                  ],
                );
              }),
            )
          ],
        ),
        body: CategoryListView(),
      ),
    );
  }
}
