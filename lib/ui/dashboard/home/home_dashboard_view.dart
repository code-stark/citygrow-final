import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/model/product_model.dart';
import 'package:digitalproductstore/provider/category/trending_category_provider.dart';
import 'package:digitalproductstore/provider/common/notification_provider.dart';
import 'package:digitalproductstore/provider/product/discount_product_provider.dart';
import 'package:digitalproductstore/provider/product/feature_product_provider.dart';
import 'package:digitalproductstore/provider/product/search_product_provider.dart';
import 'package:digitalproductstore/provider/product/trending_product_provider.dart';
import 'package:digitalproductstore/provider/productcollection/product_collection_provider.dart';
import 'package:digitalproductstore/provider/shop_info/shop_info_provider.dart';
import 'package:digitalproductstore/repository/Common/notification_repository.dart';
import 'package:digitalproductstore/repository/product_collection_repository.dart';
import 'package:digitalproductstore/repository/shop_info_repository.dart';
import 'package:digitalproductstore/ui/category/item/category_horizontal_list_item.dart';
import 'package:digitalproductstore/ui/category/item/category_horizontal_trending_list_item.dart';
import 'package:digitalproductstore/ui/collection/horizontal_list/product_collection_horizontal_list_view.dart';
import 'package:digitalproductstore/ui/common/ps_frame_loading_widget.dart';
import 'package:digitalproductstore/ui/common/dialog/noti_dialog.dart';
import 'package:digitalproductstore/ui/product/collection_product/product_list_by_collection_id_view.dart';
import 'package:digitalproductstore/ui/product/detail/product_detail_view.dart';
import 'package:digitalproductstore/ui/product/item/product_horizontal_list_item.dart';
import 'package:digitalproductstore/ui/product/list_with_filter/product_list_with_filter_container.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/category_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:digitalproductstore/viewobject/holder/noti_register_holder.dart';
import 'package:digitalproductstore/viewobject/holder/product_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:digitalproductstore/viewobject/product_collection_header.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/category/category_provider.dart';
import 'package:digitalproductstore/repository/category_repository.dart';
import 'package:digitalproductstore/repository/product_repository.dart';

import 'feature_product_slider.dart';

class HomeDashboardViewWidget extends StatefulWidget {
  const HomeDashboardViewWidget(
      this._scrollController,
      this.animationController,
      this.context,
      // this.sliverAppBar,
      this.onNotiClicked);
  final ScrollController _scrollController;
  final AnimationController animationController;
  final BuildContext context;

  // final Widget sliverAppBar;
  final Function onNotiClicked;

  @override
  _HomeDashboardViewWidgetState createState() =>
      _HomeDashboardViewWidgetState();
}

class _HomeDashboardViewWidgetState
    extends State<HomeDashboardViewWidget> {
  // var provider2;
  PsValueHolder valueHolder;
  CategoryRepository repo1;
  ProductRepository repo2;
  ProductCollectionRepository repo3;
  ShopInfoRepository shopInfoRepository;
  NotificationRepository notificationRepository;
  CategoryProvider _categoryProvider;
  final int count = 8;
  final CategoryParameterHolder trendingCategory =
      CategoryParameterHolder();
  final CategoryParameterHolder categoryIconList =
      CategoryParameterHolder();

  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    if (_categoryProvider != null) {
      _categoryProvider.loadCategoryList(categoryIconList.toMap());
    }

    widget._scrollController.addListener(() {
      if (widget._scrollController.position.pixels ==
          widget._scrollController.position.maxScrollExtent) {
        _categoryProvider.nextCategoryList(categoryIconList.toMap());
      }
    });

    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
          const IosNotificationSettings());
    }

    _fcm.subscribeToTopic('broadcast');
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        final dynamic data = message['data'] ?? message;
        print('data message : $data');
        final String notiMessage = data['message'];
        print('noti message : $notiMessage');
        //_showNotificationWithDefaultSound(notiMessage);
        onSelectNotification(notiMessage);
      },
      //onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        final dynamic data = message['data'] ?? message;
        final String notiMessage = data['message'];
        //_showNotificationWithDefaultSound(notiMessage);
        onSelectNotification(notiMessage);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        final dynamic data = message['data'] ?? message;
        final String notiMessage = data['message'];
        //_showNotificationWithDefaultSound(notiMessage);
        onSelectNotification(notiMessage);
      },
    );
  }

  Future<void> onSelectNotification(String payload) async {
    if (context == null) {
      widget.onNotiClicked(payload);
    } else {
      return showDialog<dynamic>(
        context: context,
        builder: (_) {
          return NotiDialog(message: '$payload');
        },
      );
    }
  }

  Future<void> _saveDeviceToken(FirebaseMessaging _fcm,
      NotificationProvider notificationProvider) async {
    // Get the current user

    // Get the token for this device
    final String fcmToken = await _fcm.getToken();
    await notificationProvider.replaceNotiToken(fcmToken);

    final NotiRegisterParameterHolder notiRegisterParameterHolder =
        NotiRegisterParameterHolder(
            platformName: PLATFORM, deviceId: fcmToken);
    print('Token Key $fcmToken');
    if (fcmToken != null) {
      await notificationProvider
          .rawRegisterNotiToken(notiRegisterParameterHolder.toMap());
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CategoryRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<ProductCollectionRepository>(context);
    shopInfoRepository = Provider.of<ShopInfoRepository>(context);
    notificationRepository =
        Provider.of<NotificationRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return MultiProvider(
        providers: <SingleChildCloneableWidget>[
          ChangeNotifierProvider<ShopInfoProvider>(
              create: (BuildContext context) {
            final ShopInfoProvider provider = ShopInfoProvider(
                repo: shopInfoRepository,
                psValueHolder: valueHolder,
                ownerCode: 'HomeDashboardViewWidget');
            provider.loadShopInfo();
            return provider;
          }),
          ChangeNotifierProvider<CategoryProvider>(
              create: (BuildContext context) {
            _categoryProvider ??= CategoryProvider(
                repo: repo1, psValueHolder: valueHolder);
            _categoryProvider
                .loadCategoryList(categoryIconList.toMap());
            return _categoryProvider;
          }),
          ChangeNotifierProvider<TrendingCategoryProvider>(
              create: (BuildContext context) {
            final TrendingCategoryProvider provider =
                TrendingCategoryProvider(
                    repo: repo1, psValueHolder: valueHolder);
            provider
                .loadTrendingCategoryList(trendingCategory.toMap());
            return provider;
          }),
          ChangeNotifierProvider<SearchProductProvider>(
              create: (BuildContext context) {
            final SearchProductProvider provider =
                SearchProductProvider(repo: repo2);
            provider.loadProductListByKey(
                ProductParameterHolder().getLatestParameterHolder());
            return provider;
          }),
          ChangeNotifierProvider<DiscountProductProvider>(
              create: (BuildContext context) {
            final DiscountProductProvider provider =
                DiscountProductProvider(repo: repo2);
            provider.loadProductList();
            return provider;
          }),
          ChangeNotifierProvider<TrendingProductProvider>(
              create: (BuildContext context) {
            final TrendingProductProvider provider =
                TrendingProductProvider(repo: repo2);
            provider.loadProductList();
            return provider;
          }),
          ChangeNotifierProvider<FeaturedProductProvider>(
              create: (BuildContext context) {
            final FeaturedProductProvider provider =
                FeaturedProductProvider(repo: repo2);
            provider.loadProductList();
            return provider;
          }),
          ChangeNotifierProvider<ProductCollectionProvider>(
              create: (BuildContext context) {
            final ProductCollectionProvider provider =
                ProductCollectionProvider(repo: repo3);
            provider.loadProductCollectionList();
            return provider;
          }),
          ChangeNotifierProvider<NotificationProvider>(
              create: (BuildContext context) {
            final NotificationProvider provider =
                NotificationProvider(
                    repo: notificationRepository,
                    psValueHolder: valueHolder);

            if (provider.psValueHolder.deviceToken == null ||
                provider.psValueHolder.deviceToken == '') {
              final FirebaseMessaging _fcm = FirebaseMessaging();
              _saveDeviceToken(_fcm, provider);
            } else {
              print(
                  'Notification Token is already registered. Notification Setting : true.');
            }

            return provider;
          }),
        ],
        child: Container(
          color: Utils.isLightMode(context)
              ? Colors.grey[100]
              : Colors.black12,
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              _HomeFeatureProductSliderListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 1, 1.0,
                            curve:
                                Curves.fastOutSlowIn))), //animation
              ),

              ///
              /// category List Widget
              ///
              // _HomeCategoryHorizontalListWidget(
              //   psValueHolder: valueHolder,
              //   animationController:
              //       widget.animationController, //animationController,
              //   animation: Tween<double>(begin: 0.0, end: 1.0)
              //       .animate(CurvedAnimation(
              //           parent: widget.animationController,
              //           curve: Interval((1 / count) * 2, 1.0,
              //               curve:
              //                   Curves.fastOutSlowIn))), //animation
              // ),

              _DiscountProductHorizontalListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 3, 1.0,
                            curve:
                                Curves.fastOutSlowIn))), //animation
              ),

              // _HomeTrendingProductHorizontalListWidget(
              //   animationController:
              //       widget.animationController, //animationController,
              //   animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              //       CurvedAnimation(
              //           parent: widget.animationController,
              //           curve: Interval((1 / count) * 4, 1.0,
              //               curve: Curves.fastOutSlowIn))), //animation
              // ),
              // _HomeSelectingProductTypeWidget(
              //   animationController:
              //       widget.animationController, //animationController,
              //   animation: Tween<double>(begin: 0.0, end: 1.0)
              //       .animate(CurvedAnimation(
              //           parent: widget.animationController,
              //           curve: Interval((1 / count) * 5, 1.0,
              //               curve: Curves.fastOutSlowIn))),
              // ),
              // _HomeTrendingCategoryHorizontalListWidget(
              //   psValueHolder: valueHolder,
              //   animationController:
              //       widget.animationController, //animationController,
              //   animation: Tween<double>(begin: 0.0, end: 1.0)
              //       .animate(CurvedAnimation(
              //           parent: widget.animationController,
              //           curve: Interval((1 / count) * 6, 1.0,
              //               curve:
              //                   Curves.fastOutSlowIn))), //animation
              // ),

              _HomeLatestProductHorizontalListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 7, 1.0,
                            curve:
                                Curves.fastOutSlowIn))), //animation
              ),

              // _HomeCollectionHorizontalListWidget(
              //   animationController:
              //       widget.animationController, //animationController,
              //   animation: Tween<double>(begin: 0.0, end: 1.0)
              //       .animate(CurvedAnimation(
              //           parent: widget.animationController,
              //           curve: Interval((1 / count) * 8, 1.0,
              //               curve:
              //                   Curves.fastOutSlowIn))), //animation
              // ),

              SliverToBoxAdapter(child:
                  Consumer<ProductCollectionProvider>(builder:
                      (BuildContext context,
                          ProductCollectionProvider productProvider,
                          Widget child) {
                return const SizedBox(
                  height: ps_space_20,
                );
              }))
            ],
          ),
        ));
  }
}

class _HomeLatestProductHorizontalListWidget extends StatelessWidget {
  const _HomeLatestProductHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  ProductList get data => ProductList();

// TODO: latest products
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<SearchProductProvider>(
        builder: (BuildContext context,
            SearchProductProvider productProvider, Widget child) {
          return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('ProductListID')
                  .where('ProductReview', isEqualTo: true)
                  .orderBy('TimeStamp', descending: true)
                  .snapshots(),
              builder: (context, latestProduct) {
                if (!latestProduct.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return AnimatedBuilder(
                    animation: animationController,
                    builder: (BuildContext context, Widget child) {
                      return FadeTransition(
                        opacity: animation,
                        child: Transform(
                          transform: Matrix4.translationValues(0.0,
                              100 * (1.0 - animation.value), 0.0),
                          child:
                              (productProvider.productList.data !=
                                          null &&
                                      productProvider.productList.data
                                          .isNotEmpty)
                                  ? Column(children: <Widget>[
                                      _MyHeaderWidget(
                                        headerName: Utils.getString(
                                            context,
                                            'dashboard__latest_product'),
                                        viewAllClicked: () {
                                          // Navigator.pushNamed(
                                          //     context, RoutePaths.filterProductList,
                                          //     arguments: ProductListIntentHolder(
                                          //       appBarTitle: Utils.getString(
                                          //           context,
                                          //           'dashboard__latest_product'),
                                          //       productParameterHolder:
                                          //           ProductParameterHolder()
                                          //               .getLatestParameterHolder(),
                                          //     ));
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => ProductListWithFilterContainerView(
                                                      productParameterHolder:
                                                          ProductParameterHolder()
                                                              .getLatestParameterHolder(),
                                                      appBarTitle: Utils
                                                          .getString(
                                                              context,
                                                              'dashboard__latest_product'),
                                                      productList:
                                                          latestProduct
                                                              .data
                                                              .documents)));
                                        },
                                      ),
                                      Container(
                                          height: ps_space_300,
                                          width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width,
                                          child: ListView.builder(
                                              scrollDirection:
                                                  Axis.horizontal,
                                              itemCount: latestProduct
                                                  .data
                                                  .documents
                                                  .length
                                              // productProvider
                                              //     .productList.data.length
                                              ,
                                              itemBuilder:
                                                  (BuildContext
                                                          context,
                                                      int index) {
                                                if (productProvider
                                                        .productList
                                                        .status ==
                                                    PsStatus
                                                        .BLOCK_LOADING) {
                                                  return Shimmer
                                                      .fromColors(
                                                          baseColor:
                                                              Colors.grey[
                                                                  300],
                                                          highlightColor:
                                                              Colors
                                                                  .white,
                                                          child: Row(
                                                              children: const <
                                                                  Widget>[
                                                                PsFrameUIForLoading(),
                                                              ]));
                                                } else {
                                                  return ProductHorizontalListItem(
                                                    productList:
                                                        latestProduct
                                                                .data
                                                                .documents[
                                                            index],
                                                    // product: productProvider
                                                    //     .productList.data[index],
                                                    onTap: () {
                                                      print(productProvider
                                                          .productList
                                                          .data[index]
                                                          .defaultPhoto
                                                          .imgPath);
                                                      print(latestProduct
                                                                  .data
                                                                  .documents[
                                                              index][
                                                          'ProductName']);
                                                      Navigator.pushNamed(
                                                          context,
                                                          RoutePaths
                                                              .productDetail,
                                                          arguments: latestProduct
                                                                  .data
                                                                  .documents[
                                                              index]);
                                                      // Navigator
                                                      //     .pushReplacement(
                                                      //         context,
                                                      //         MaterialPageRoute<
                                                      //                 dynamic>(
                                                      //             builder: (BuildContext
                                                      //                     context) =>
                                                      //                 ProductDetailView(
                                                      //                   product:
                                                      //                       productProvider.productList.data[index],
                                                      //                   productList:
                                                      //                       snapshot.data.documents[index],
                                                      //                 )));
                                                      // Navigator.pushNamed(
                                                      //     context,
                                                      //     RoutePaths
                                                      //         .productDetail,
                                                      //     arguments: <dynamic>[
                                                      //       productProvider
                                                      //           .productList
                                                      //           .data[index],
                                                      //       snapshot.data
                                                      //           .documents[index]
                                                      //     ]);
                                                    },
                                                  );
                                                }
                                              }))
                                    ])
                                  : Container(),
                        ),
                      );
                    });
              });
        },
      ),
    );
  }
}

class _HomeCollectionHorizontalListWidget extends StatelessWidget {
  const _HomeCollectionHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<ProductCollectionProvider>(builder:
          (BuildContext context,
              ProductCollectionProvider productProvider,
              Widget child) {
        return AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: productProvider
                          .productCollectionList.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (productProvider
                                .productCollectionList.status ==
                            PsStatus.BLOCK_LOADING) {
                          return Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.white,
                              child: Row(children: const <Widget>[
                                PsFrameUIForLoading(),
                              ]));
                        } else {
                          return (productProvider
                                          .productCollectionList
                                          .data !=
                                      null &&
                                  productProvider
                                      .productCollectionList
                                      .data
                                      .isNotEmpty)
                              ? Column(
                                  children: <Widget>[
                                    _MyHeaderWidget(
                                      headerName: productProvider
                                          .productCollectionList
                                          .data[index]
                                          .name,
                                      productCollectionHeader:
                                          productProvider
                                              .productCollectionList
                                              .data[index],
                                      viewAllClicked: () {
                                        animationController.reverse();
                                        Navigator.pushNamed(
                                            context,
                                            RoutePaths
                                                .productListByCollectionId,
                                            arguments:
                                                ProductListByCollectionIdView(
                                              productCollectionHeader:
                                                  productProvider
                                                      .productCollectionList
                                                      .data[index],
                                              appBarTitle: productProvider
                                                  .productCollectionList
                                                  .data[index]
                                                  .name,
                                            ));
                                      },
                                    ),
                                    ProductCollectionHorizontalListView(
                                      product: productProvider
                                          .productCollectionList
                                          .data[index],
                                      onTap: () {
                                        print(productProvider
                                            .productCollectionList
                                            .data[index]
                                            .defaultPhoto
                                            .imgPath);
                                        Navigator.pushNamed(context,
                                            RoutePaths.productDetail,
                                            arguments: productProvider
                                                .productCollectionList
                                                .data[index]);
                                      },
                                    )
                                  ],
                                )
                              : Container();
                        }
                      },
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}

class _HomeTrendingProductHorizontalListWidget
    extends StatelessWidget {
  const _HomeTrendingProductHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<TrendingProductProvider>(
        builder: (BuildContext context,
            TrendingProductProvider productProvider, Widget child) {
          return AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: (productProvider.productList.data != null &&
                          productProvider.productList.data.isNotEmpty)
                      ? Column(
                          children: <Widget>[
                            _MyHeaderWidget(
                              headerName: Utils.getString(context,
                                  'dashboard__trending_product'),
                              viewAllClicked: () {
                                Navigator.pushNamed(context,
                                    RoutePaths.filterProductList,
                                    arguments: ProductListIntentHolder(
                                        appBarTitle: Utils.getString(
                                            context,
                                            'dashboard__trending_product'),
                                        productParameterHolder:
                                            ProductParameterHolder()
                                                .getTrendingParameterHolder()));
                              },
                            ),
                            Container(
                                height: ps_space_300,
                                width:
                                    MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: productProvider
                                        .productList.data.length,
                                    itemBuilder:
                                        (BuildContext context,
                                            int index) {
                                      if (productProvider
                                              .productList.status ==
                                          PsStatus.BLOCK_LOADING) {
                                        return Shimmer.fromColors(
                                            baseColor:
                                                Colors.grey[300],
                                            highlightColor:
                                                Colors.white,
                                            child: Row(
                                                children: const <
                                                    Widget>[
                                                  PsFrameUIForLoading(),
                                                ]));
                                      } else {
                                        return ProductHorizontalListItem(
                                          product: productProvider
                                              .productList
                                              .data[index],
                                          onTap: () {
                                            print(productProvider
                                                .productList
                                                .data[index]
                                                .defaultPhoto
                                                .imgPath);
                                            Navigator.pushNamed(
                                                context,
                                                RoutePaths
                                                    .productDetail,
                                                arguments:
                                                    productProvider
                                                        .productList
                                                        .data[index]);
                                          },
                                        );
                                      }
                                    }))
                          ],
                        )
                      : Container(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeSelectingProductTypeWidget extends StatelessWidget {
  const _HomeSelectingProductTypeWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: ps_space_36,
                    ),
                    Text(
                        Utils.getString(
                            context, 'dashboard__welcome_text'),
                        style: Theme.of(context).textTheme.body1),
                    const SizedBox(
                      height: ps_space_12,
                    ),
                    Text(Utils.getString(context, 'app_name'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(
                                color: ps_ctheme__color_speical)),
                    const SizedBox(
                      height: ps_space_12,
                    ),
                    Container(
                      color: Theme.of(context).brightness ==
                              Brightness.light
                          ? Colors.white
                          : Colors.grey[900],
                      padding: const EdgeInsets.only(top: ps_space_8),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //       Expanded(
                          //         child: _SelectingImageAndTextWidget(
                          //             imagePath:
                          //                 'assets/images/home_icon/free_download.png',
                          //             title: Utils.getString(
                          //                 context, 'dashboard__free_download'),
                          //             description: Utils.getString(context,
                          //                 'dashboard__free_download_description'),
                          //             onTap: () {
                          //               print('free download');
                          //               Navigator.pushNamed(
                          //                   context, RoutePaths.filterProductList,
                          //                   arguments: ProductListIntentHolder(
                          //                       appBarTitle: Utils.getString(context,
                          //                           'dashboard__free_product'),
                          //                       productParameterHolder:
                          //                           ProductParameterHolder()
                          //                               .getFreeParameterHolder()));
                          //             }),
                          //       ),
                          //       Expanded(
                          //         child: _SelectingImageAndTextWidget(
                          //             imagePath:
                          //                 'assets/images/home_icon/easy_payment.png',
                          //             title: Utils.getString(
                          //                 context, 'dashboard__easy_payment'),
                          //             description: Utils.getString(context,
                          //                 'dashboard__easy_payment_description'),
                          //             onTap: () {
                          //               Navigator.pushNamed(
                          //                 context,
                          //                 RoutePaths.basketList,
                          //               );
                          //             }),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   color: Theme.of(context).brightness == Brightness.light
                          //       ? Colors.white
                          //       : Colors.grey[900],
                          //   padding: const EdgeInsets.only(
                          //       top: ps_space_8, bottom: ps_space_8),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: <Widget>[
                          //       Expanded(
                          //         child: _SelectingImageAndTextWidget(
                          //             imagePath:
                          //                 'assets/images/home_icon/featured_products.png',
                          //             title: Utils.getString(
                          //                 context, 'dashboard__feature_product'),
                          //             description: Utils.getString(context,
                          //                 'dashboard__feature_product_description'),
                          //             onTap: () {
                          //               Navigator.pushNamed(
                          //                   context, RoutePaths.filterProductList,
                          //                   arguments: ProductListIntentHolder(
                          //                       appBarTitle: Utils.getString(context,
                          //                           'dashboard__feature_product'),
                          //                       productParameterHolder:
                          //                           ProductParameterHolder()
                          //                               .getFeaturedParameterHolder()));
                          //             }),
                          //       ),
                          //       Expanded(
                          //         child: _SelectingImageAndTextWidget(
                          //             imagePath:
                          //                 'assets/images/home_icon/discount_products.png',
                          //             title: Utils.getString(
                          //                 context, 'dashboard__discount_product'),
                          //             description: Utils.getString(context,
                          //                 'dashboard__discount_product_description'),
                          //             onTap: () {
                          //               Navigator.pushNamed(
                          //                   context, RoutePaths.filterProductList,
                          //                   arguments: ProductListIntentHolder(
                          //                       appBarTitle: Utils.getString(context,
                          //                           'dashboard__discount_product'),
                          //                       productParameterHolder:
                          //                           ProductParameterHolder()
                          //                               .getDiscountParameterHolder()));
                          //             }),
                          //       ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: ps_space_24,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

// class _SelectingImageAndTextWidget extends StatelessWidget {
//   const _SelectingImageAndTextWidget(
//       {Key key,
//       @required this.imagePath,
//       @required this.title,
//       @required this.description,
//       @required this.onTap})
//       : super(key: key);

//   final String imagePath;
//   final String title;
//   final String description;
//   final Function onTap;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(ps_space_12),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Center(
//               child: Image.asset(
//                 imagePath,
//                 width: ps_space_60,
//                 height: ps_space_60,
//               ),
//             ),
//             const SizedBox(
//               height: ps_space_12,
//             ),
//             Text(title,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.subhead),
//             const SizedBox(
//               height: ps_space_12,
//             ),
//             Text(description,
//                 maxLines: 3,
//                 overflow: TextOverflow.ellipsis,
//                 style: Theme.of(context).textTheme.caption),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _HomeTrendingCategoryHorizontalListWidget
    extends StatelessWidget {
  const _HomeTrendingCategoryHorizontalListWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;
  //  List<EcommerceSizes> sizeList = <EcommerceSizes>[];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child:
        Consumer<TrendingCategoryProvider>(builder:
            (BuildContext context,
                TrendingCategoryProvider trendingCategoryProvider,
                Widget child) {
      return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: Consumer<TrendingCategoryProvider>(builder:
                      (BuildContext context,
                          TrendingCategoryProvider
                              trendingCategoryProvider,
                          Widget child) {
                    return (trendingCategoryProvider
                                    .categoryList.data !=
                                null &&
                            trendingCategoryProvider
                                .categoryList.data.isNotEmpty)
                        ? Column(children: <Widget>[
                            _MyHeaderWidget(
                              headerName: Utils.getString(context,
                                  'dashboard__trending_category'),
                              viewAllClicked: () {
                                Navigator.pushNamed(context,
                                    RoutePaths.trendingCategoryList,
                                    arguments: Utils.getString(
                                        context,
                                        'tranding_category__trending_category_list'));
                              },
                            ),
                            Container(
                              height: ps_space_300,
                              width:
                                  MediaQuery.of(context).size.width,
                              child: CustomScrollView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  slivers: <Widget>[
                                    SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 200,
                                              childAspectRatio: 0.8),
                                      delegate:
                                          SliverChildBuilderDelegate(
                                        (BuildContext context,
                                            int index) {
                                          if (trendingCategoryProvider
                                                  .categoryList
                                                  .status ==
                                              PsStatus
                                                  .BLOCK_LOADING) {
                                            return Shimmer.fromColors(
                                                baseColor:
                                                    Colors.grey[300],
                                                highlightColor:
                                                    Colors.white,
                                                child: Row(
                                                    children: const <
                                                        Widget>[
                                                      PsFrameUIForLoading(),
                                                    ]));
                                          } else {
                                            if (trendingCategoryProvider
                                                        .categoryList
                                                        .data !=
                                                    null ||
                                                trendingCategoryProvider
                                                    .categoryList
                                                    .data
                                                    .isNotEmpty) {
                                              return CategoryHorizontalTrendingListItem(
                                                category:
                                                    trendingCategoryProvider
                                                        .categoryList
                                                        .data[index],
                                                animationController:
                                                    animationController,
                                                animation:
                                                    Tween<double>(
                                                            begin:
                                                                0.0,
                                                            end: 1.0)
                                                        .animate(
                                                  CurvedAnimation(
                                                    parent:
                                                        animationController,
                                                    curve: Interval(
                                                        (1 /
                                                                trendingCategoryProvider
                                                                    .categoryList
                                                                    .data
                                                                    .length) *
                                                            index,
                                                        1.0,
                                                        curve: Curves
                                                            .fastOutSlowIn),
                                                  ),
                                                ),
                                                onTap: () {
                                                  utilsCheckUserLoginId(
                                                          psValueHolder)
                                                      .then((String
                                                          loginUserId) async {
                                                    final TouchCountParameterHolder
                                                        touchCountParameterHolder =
                                                        TouchCountParameterHolder(
                                                            typeId: trendingCategoryProvider
                                                                .categoryList
                                                                .data[
                                                                    index]
                                                                .id,
                                                            typeName:
                                                                FILTERING_TYPE_NAME_CATEGORY,
                                                            userId: trendingCategoryProvider
                                                                .psValueHolder
                                                                .loginUserId);

                                                    trendingCategoryProvider
                                                        .postTouchCount(
                                                            touchCountParameterHolder
                                                                .toMap());
                                                  });
                                                  print(trendingCategoryProvider
                                                      .categoryList
                                                      .data[index]
                                                      .defaultPhoto
                                                      .imgPath);
                                                  final ProductParameterHolder
                                                      productParameterHolder =
                                                      ProductParameterHolder()
                                                          .getLatestParameterHolder();
                                                  productParameterHolder
                                                          .catId =
                                                      trendingCategoryProvider
                                                          .categoryList
                                                          .data[index]
                                                          .id;
                                                  Navigator.pushNamed(
                                                      context,
                                                      RoutePaths
                                                          .filterProductList,
                                                      arguments:
                                                          ProductListIntentHolder(
                                                        appBarTitle:
                                                            trendingCategoryProvider
                                                                .categoryList
                                                                .data[
                                                                    index]
                                                                .name,
                                                        productParameterHolder:
                                                            productParameterHolder,
                                                      ));
                                                },
                                              );
                                            } else {
                                              return null;
                                            }
                                          }
                                        },
                                        childCount:
                                            trendingCategoryProvider
                                                .categoryList
                                                .data
                                                .length,
                                      ),
                                    ),
                                  ]),
                            )
                          ])
                        : Container();
                  })));
        },
      );
    }));
  }
}

class _DiscountProductHorizontalListWidget extends StatelessWidget {
  const _DiscountProductHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        // fdfdf
        child: Consumer<DiscountProductProvider>(builder:
            (BuildContext context,
                DiscountProductProvider productProvider,
                Widget child) {
      return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('ProductListID')
              .where('Discount', isGreaterThan: 0)
              .where('ProductReview', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                      opacity: animation,
                      child: Transform(
                          transform: Matrix4.translationValues(0.0,
                              100 * (1.0 - animation.value), 0.0),
                          child: (productProvider.productList.data !=
                                      null &&
                                  productProvider
                                      .productList.data.isNotEmpty)
                              ? Column(children: <Widget>[
                                  _MyHeaderWidget(
                                    headerName: Utils.getString(
                                        context,
                                        'dashboard__discount_product'),
                                    viewAllClicked: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext
                                                      context) =>
                                                  ProductListWithFilterContainerView(
                                                      productParameterHolder:
                                                          ProductParameterHolder()
                                                              .getLatestParameterHolder(),
                                                      appBarTitle: Utils
                                                          .getString(
                                                              context,
                                                              'dashboard__discount_product'),
                                                      productList:
                                                          snapshot
                                                              .data
                                                              .documents)));
                                      // Navigator.pushNamed(
                                      //     context, RoutePaths.filterProductList,
                                      //     arguments: ProductListIntentHolder(
                                      //         appBarTitle: Utils.getString(
                                      //             context,
                                      //             'dashboard__discount_product'),
                                      //         productParameterHolder:
                                      //             ProductParameterHolder()
                                      //                 .getDiscountParameterHolder()));
                                    },
                                  ),
                                  Container(
                                      height: ps_space_300,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      child: ListView.builder(
                                          scrollDirection:
                                              Axis.horizontal,
                                          itemCount: snapshot
                                              .data.documents.length,
                                          itemBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            if (productProvider
                                                    .productList
                                                    .status ==
                                                PsStatus
                                                    .BLOCK_LOADING) {
                                              return Shimmer
                                                  .fromColors(
                                                      baseColor:
                                                          Colors.grey[
                                                              300],
                                                      highlightColor:
                                                          Colors
                                                              .white,
                                                      child: Row(
                                                          children: const <
                                                              Widget>[
                                                            PsFrameUIForLoading(),
                                                          ]));
                                            } else {
                                              return ProductHorizontalListItem(
                                                productList: snapshot
                                                    .data
                                                    .documents[index],
                                                // product: productProvider
                                                //     .productList.data[index],
                                                onTap: () {
                                                  // print(productProvider
                                                  //     .productList
                                                  //     .data[index]
                                                  //     .defaultPhoto
                                                  //     .imgPath);
                                                  Navigator.pushNamed(
                                                      context,
                                                      RoutePaths
                                                          .productDetail,
                                                      arguments: snapshot
                                                              .data
                                                              .documents[
                                                          index]);
                                                  // Navigator.pushReplacement(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (BuildContext
                                                  //                 context) =>
                                                  //             ProductDetailView(
                                                  //               productList: snapshot
                                                  //                       .data
                                                  //                       .documents[
                                                  //                   index],
                                                  //             )));
                                                },
                                              );
                                            }
                                          }))
                                ])
                              : Container()));
                });
          });
    }));
  }
}

class _HomeFeatureProductSliderListWidget extends StatelessWidget {
  const _HomeFeatureProductSliderListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const int count = 6;
    final Animation<double> animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval((1 / count) * 1, 1.0,
                curve: Curves.fastOutSlowIn)));

    return SliverToBoxAdapter(
      child: Consumer<FeaturedProductProvider>(builder:
          (BuildContext context,
              FeaturedProductProvider productProvider, Widget child) {
        return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('ProductListID')
                .where('ProductReview', isEqualTo: true)
                .where('Featured Product', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                        opacity: animation,
                        child: Transform(
                            transform: Matrix4.translationValues(0.0,
                                100 * (1.0 - animation.value), 0.0),
                            child: (productProvider
                                            .productList.data !=
                                        null &&
                                    productProvider
                                        .productList.data.isNotEmpty)
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _MyHeaderWidget(
                                        headerName: Utils.getString(
                                            context,
                                            'dashboard__feature_product'),
                                        viewAllClicked: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => ProductListWithFilterContainerView(
                                                      productParameterHolder:
                                                          ProductParameterHolder()
                                                              .getLatestParameterHolder(),
                                                      appBarTitle: Utils
                                                          .getString(
                                                              context,
                                                              'dashboard__feature_product'),
                                                      productList:
                                                          snapshot
                                                              .data
                                                              .documents)));
                                        },
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                            //color: Colors.grey[200],
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Utils
                                                          .isLightMode(
                                                              context)
                                                      ? Colors.grey
                                                          .withOpacity(
                                                              0.5)
                                                      : Colors.black
                                                          .withOpacity(
                                                              0.5),
                                                  offset:
                                                      const Offset(
                                                          1.1, 1.1),
                                                  blurRadius: 15.0),
                                            ],
                                          ),
                                          margin:
                                              const EdgeInsets.only(
                                                  top: ps_space_8,
                                                  bottom:
                                                      ps_space_20),
                                          width: double.infinity,
                                          child:
                                              // Column(
                                              //   mainAxisSize: MainAxisSize.max,
                                              //   children: <Widget>[
                                              FeatureProductSliderView(
                                            productList: snapshot
                                                .data.documents,
                                            // featuredProductList: productProvider
                                            //     .productList.data,
                                            onTap: (DocumentSnapshot
                                                product) {
                                              Navigator.pushNamed(
                                                  context,
                                                  RoutePaths
                                                      .productDetail,
                                                  arguments: product);
                                            },
                                            //   ),
                                            // ],
                                          ))
                                    ],
                                  )
                                : Container()));
                  });
            });
      }),
    );
  }
}

class _HomeCategoryHorizontalListWidget extends StatefulWidget {
  const _HomeCategoryHorizontalListWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomeCategoryHorizontalListWidgetState createState() =>
      __HomeCategoryHorizontalListWidgetState();
}

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<CategoryProvider>(
      builder: (BuildContext context,
          CategoryProvider categoryProvider, Widget child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(0.0,
                          30 * (1.0 - widget.animation.value), 0.0),
                      child: (categoryProvider.categoryList.data !=
                                  null &&
                              categoryProvider
                                  .categoryList.data.isNotEmpty)
                          ? Column(children: <Widget>[
                              _MyHeaderWidget(
                                headerName: Utils.getString(
                                    context, 'dashboard__categories'),
                                viewAllClicked: () {
                                  Navigator.pushNamed(context,
                                      RoutePaths.categoryList,
                                      arguments: 'Categories');
                                },
                              ),
                              // TODO: category
                              // Container(
                              //   height: ps_space_120,
                              //   margin: const EdgeInsets.only(top: ps_space_4),
                              //   width: MediaQuery.of(context).size.width,
                              //   child: ListView.builder(
                              //       shrinkWrap: true,
                              //       padding: const EdgeInsets.only(
                              //           left: ps_space_16),
                              //       scrollDirection: Axis.horizontal,
                              //       itemCount: categoryProvider
                              //           .categoryList.data.length,
                              //       itemBuilder:
                              //           (BuildContext context, int index) {
                              //         if (categoryProvider
                              //                 .categoryList.status ==
                              //             PsStatus.BLOCK_LOADING) {
                              //           return Shimmer.fromColors(
                              //               baseColor: Colors.grey[300],
                              //               highlightColor: Colors.white,
                              //               child: Row(children: const <Widget>[
                              //                 PsFrameUIForLoading(),
                              //               ]));
                              //         } else {
                              //           return CategoryHorizontalListItem(
                              //             category: categoryProvider
                              //                 .categoryList.data[index],
                              //             onTap: () {
                              //               utilsCheckUserLoginId(
                              //                       widget.psValueHolder)
                              //                   .then(
                              //                       (String loginUserId) async {
                              //                 final TouchCountParameterHolder
                              //                     touchCountParameterHolder =
                              //                     TouchCountParameterHolder(
                              //                         typeId: categoryProvider
                              //                             .categoryList
                              //                             .data[index]
                              //                             .id,
                              //                         typeName:
                              //                             FILTERING_TYPE_NAME_CATEGORY,
                              //                         userId: categoryProvider
                              //                             .psValueHolder
                              //                             .loginUserId);

                              //                 categoryProvider.postTouchCount(
                              //                     touchCountParameterHolder
                              //                         .toMap());
                              //               });
                              //               print(categoryProvider
                              //                   .categoryList
                              //                   .data[index]
                              //                   .defaultPhoto
                              //                   .imgPath);
                              //               final ProductParameterHolder
                              //                   productParameterHolder =
                              //                   ProductParameterHolder()
                              //                       .getLatestParameterHolder();
                              //               productParameterHolder.catId =
                              //                   categoryProvider.categoryList
                              //                       .data[index].id;
                              //               Navigator.pushNamed(context,
                              //                   RoutePaths.filterProductList,
                              //                   arguments:
                              //                       ProductListIntentHolder(
                              //                     appBarTitle: categoryProvider
                              //                         .categoryList
                              //                         .data[index]
                              //                         .name,
                              //                     productParameterHolder:
                              //                         productParameterHolder,
                              //                   ));
                              //             },
                              //             // )
                              //           );
                              //         }
                              //       }),
                              // )
                            ])
                          : Container()));
            });
      },
    ));
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    Key key,
    @required this.headerName,
    this.productCollectionHeader,
    @required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final Function viewAllClicked;
  final ProductCollectionHeader productCollectionHeader;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked,
      child: Padding(
        padding: const EdgeInsets.only(
            top: ps_space_16,
            left: ps_space_16,
            right: ps_space_16,
            bottom: ps_space_20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              //   fit: FlexFit.loose,
              child: Text(widget.headerName,
                  style: Theme.of(context).textTheme.subtitle1),
            ),
            Text(
              Utils.getString(context, 'dashboard__view_all'),
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: ps_ctheme__color_speical),
            ),
          ],
        ),
      ),
    );
  }
}
