import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/basket/basket_provider.dart';
import 'package:digitalproductstore/provider/product/product_by_collectionid_provider.dart';
import 'package:digitalproductstore/repository/basket_repository.dart';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/ui/product/item/product_vertical_list_item.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/product_collection_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListByCollectionIdView extends StatefulWidget {
  const ProductListByCollectionIdView(
      {Key key,
      @required this.productCollectionHeader,
      @required this.appBarTitle})
      : super(key: key);

  final ProductCollectionHeader productCollectionHeader;
  final String appBarTitle;
  @override
  State<StatefulWidget> createState() {
    return _ProductListByCollectionIdView();
  }
}

class _ProductListByCollectionIdView
    extends State<ProductListByCollectionIdView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  ProductByCollectionIdProvider _productCollectionProvider;
  AnimationController animationController;
  Animation<double> animation;
  ProductRepository productCollectionRepository;
  BasketRepository basketRepository;
  BasketProvider basketProvider;
  PsValueHolder psValueHolder;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _productCollectionProvider
            .nextProductListByCollectionId(widget.productCollectionHeader.id);
      }
    });

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

    productCollectionRepository = Provider.of<ProductRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithMultiProvider(
        child: MultiProvider(
            providers: <SingleChildCloneableWidget>[
              ChangeNotifierProvider<ProductByCollectionIdProvider>(
                  create: (BuildContext context) {
                _productCollectionProvider = ProductByCollectionIdProvider(
                    repo: productCollectionRepository,
                    psValueHolder: psValueHolder);
                _productCollectionProvider.loadProductListByCollectionId(
                    widget.productCollectionHeader.id);
                return _productCollectionProvider;
              }),
              ChangeNotifierProvider<BasketProvider>(
                  create: (BuildContext context) {
                basketProvider = BasketProvider(repo: basketRepository);

                return basketProvider;
              }),
            ],
            //  PsWidgetWithAppBar<ProductByCollectionIdProvider>(
            //     appBarTitle: widget.appBarTitle,
            //     //  AppLocalizations.of(context)
            //     //         .tr('menu_drawer__collection_header_list') ??
            //     //     '',
            //     initProvider: () {
            //       return ProductByCollectionIdProvider(
            //           repo: productCollectionRepository,
            //           psValueHolder: psValueHolder);
            //     },
            //     onProviderReady: (ProductByCollectionIdProvider provider) {
            //       provider.loadProductListByCollectionId(
            //           widget.productCollectionHeader.id);
            //       _productCollectionProvider = provider;
            //     },
            child: Consumer<ProductByCollectionIdProvider>(builder:
                (BuildContext context, ProductByCollectionIdProvider provider,
                    Widget child) {
              if (provider.productCollectionList != null &&
                  provider.productCollectionList.data != null) {
                ///
                /// Load Basket List
                ///
                basketProvider = Provider.of<BasketProvider>(context,
                    listen: false); // Listen : False is important.

                basketProvider.loadBasketList();
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).appBarTheme.color,
                    title: Text(
                      widget.appBarTitle,
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontWeight: FontWeight.bold,
                            //Theme.of(context).appBarTheme.color,
                          ),
                    ),
                    titleSpacing: 0,
                    elevation: 0,
                    iconTheme: const IconThemeData(),
                    textTheme: Theme.of(context).textTheme,
                    brightness: Utils.getBrightnessForAppBar(context),
                    actions: <Widget>[
                      Consumer<BasketProvider>(builder: (BuildContext context,
                          BasketProvider basketProvider, Widget child) {
                        return Stack(
                          children: <Widget>[
                            Container(
                              width: ps_space_40,
                              height: ps_space_40,
                              margin: const EdgeInsets.only(
                                  top: ps_space_8,
                                  left: ps_space_8,
                                  right: ps_space_8),
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
                                          : basketProvider
                                              .basketList.data.length
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
                    ],
                  ),
                  body: Stack(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(
                              left: ps_space_4,
                              right: ps_space_4,
                              top: ps_space_4,
                              bottom: ps_space_4),
                          child: RefreshIndicator(
                            // child: Column(
                            // children: <Widget>[
                            child: CustomScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: ps_space_8),
                                    child: PsNetworkImage(
                                      photoKey: '',
                                      defaultPhoto: widget
                                          .productCollectionHeader.defaultPhoto,
                                      width: MediaQuery.of(context).size.width,
                                      height: ps_space_240,
                                      boxfit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 300,
                                          childAspectRatio: 0.6),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.productCollectionList.data !=
                                          null) {
                                        final int count = provider
                                            .productCollectionList.data.length;
                                        return ProductVeticalListItem(
                                          animationController:
                                              animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent: animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          product: provider
                                              .productCollectionList
                                              .data[index],
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                RoutePaths.productDetail,
                                                arguments: provider
                                                    .productCollectionList
                                                    .data[index]);
                                          },
                                        );
                                      } else {
                                        return null;
                                      }
                                      // }
                                    },
                                    childCount: provider
                                        .productCollectionList.data.length,
                                  ),
                                ),
                              ],
                            ),
                            onRefresh: () {
                              return provider.resetProductListByCollectionId(
                                  widget.productCollectionHeader.id);
                            },
                          )),
                      PSProgressIndicator(provider.productCollectionList.status)
                    ],
                  ),
                );
              } else {
                return Container();
              }
            })),
      ),
    );
  }
}
