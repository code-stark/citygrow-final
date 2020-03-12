import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';

import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/basket/basket_provider.dart';
import 'package:digitalproductstore/provider/history/history_provider.dart';
import 'package:digitalproductstore/provider/product/favourite_product_provider.dart';
import 'package:digitalproductstore/provider/product/product_provider.dart';
import 'package:digitalproductstore/provider/product/related_product_provider.dart';
import 'package:digitalproductstore/provider/product/touch_count_provider.dart';
import 'package:digitalproductstore/repository/basket_repository.dart';
import 'package:digitalproductstore/repository/history_repsitory.dart';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:digitalproductstore/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:digitalproductstore/ui/common/ps_expansion_tile.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/success_dialog.dart';
import 'package:digitalproductstore/ui/gallery/grid/gallery_grid_view.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/api_status.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/download_product.dart';
import 'package:digitalproductstore/viewobject/holder/download_product_holder.dart';
import 'package:digitalproductstore/viewobject/holder/favourite_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:permission_handler/permission_handler.dart';

import 'views/description_tile_view.dart';
import 'views/detail_info_tile_view.dart';
import 'views/related_products_tile_view.dart';
import 'views/terms_and_policy_tile_view.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({
    @required this.product,
    @required this.productList,
  });
  final DocumentSnapshot productList;
  final Product product;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  ProductRepository productRepo;
  ProductRepository relatedProductRepo;
  HistoryRepository historyRepo;
  HistoryProvider historyProvider;
  TouchCountProvider touchCountProvider;
  BasketProvider basketProvider;
  PsValueHolder psValueHolder;

  AnimationController controller;
  BasketRepository basketRepository;

  static const List<IconData> icons = <IconData>[
    Icons.sms,
    Icons.mail,
    Icons.phone
  ];

  static const List<String> iconsLabel = <String>[
    'Messager',
    'WhatsApp',
    'Phone'
  ];

  @override
  void initState() {
    super.initState();
    viewcounter();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<dynamic> viewcounter() async {
    // final QuerySnapshot results = await Firestore.instance
    //     .collection("ProductListID")
    //     .where("id", isEqualTo: widget.productList.documentID)
    //     .getDocuments();
    // final List<DocumentSnapshot> documents = results.documents;

    // await Future<DocumentSnapshot>.delayed(const Duration(seconds: 5));
    if (widget.productList == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final Map<String, FieldValue> data = {
        'views': FieldValue.increment(1),
      };
      return await Firestore.instance
          .collection('ProductListID')
          .document(widget.productList.documentID)
          .updateData(data);
    }
  }

  List<Product> basketList = <Product>[];

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);
    productRepo = Provider.of<ProductRepository>(context);
    relatedProductRepo = Provider.of<ProductRepository>(context);
    historyRepo = Provider.of<HistoryRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);

    return PsWidgetWithMultiProvider(

        // actions: <Widget>[],
        // initProvider: () {
        //   return ProductDetailProvider(
        //       repo: productRepo, psValueHolder: psValueHolder);
        // },
        // onProviderReady: (ProductDetailProvider provider) {
        //   utilsCheckUserLoginId(context).then((String loginUserId) async {
        //     provider.loadProduct(widget.product.id, loginUserId);

        //     final TouchCountParameterHolder touchCountParameterHolder =
        //         TouchCountParameterHolder(
        //             typeId: widget.product.id,
        //             typeName: FILTERING_TYPE_NAME_PRODUCT,
        //             userId: touchCountProvider.psValueHolder.loginUserId);
        //     final PsResource<ApiStatus> _apiStatus = await touchCountProvider
        //         .postTouchCount(touchCountParameterHolder.toMap());
        //     if (_apiStatus.status == PsStatus.SUCCESS) {
        //       provider.loadProduct(widget.product.id, loginUserId);
        //     }
        //   });
        // },
        child: MultiProvider(
            providers: <SingleChildCloneableWidget>[
          ChangeNotifierProvider<ProductDetailProvider>(
            create: (BuildContext context) {
              final ProductDetailProvider productDetailProvider =
                  ProductDetailProvider(
                      repo: productRepo, psValueHolder: psValueHolder);

              utilsCheckUserLoginId(psValueHolder)
                  .then((String loginUserId) async {
                productDetailProvider.loadProduct(
                    widget.product.id, loginUserId);

                final TouchCountParameterHolder touchCountParameterHolder =
                    TouchCountParameterHolder(
                        typeId: widget.product.id,
                        typeName: FILTERING_TYPE_NAME_PRODUCT,
                        userId: touchCountProvider.psValueHolder.loginUserId);
                final PsResource<ApiStatus> _apiStatus =
                    await touchCountProvider
                        .postTouchCount(touchCountParameterHolder.toMap());
                if (_apiStatus.status == PsStatus.SUCCESS) {
                  // productDetailProvider.loadProduct(
                  //     widget.product.id, loginUserId);
                }
              });

              return productDetailProvider;
            },
          ),
          ChangeNotifierProvider<RelatedProductProvider>(
            create: (BuildContext context) {
              final RelatedProductProvider relatedProductProvider =
                  RelatedProductProvider(
                      repo: relatedProductRepo, psValueHolder: psValueHolder);

              return relatedProductProvider;
            },
          ),
          ChangeNotifierProvider<BasketProvider>(
              create: (BuildContext context) {
            basketProvider = BasketProvider(repo: basketRepository);
            return basketProvider;
          }),
          ChangeNotifierProvider<HistoryProvider>(
            create: (BuildContext context) {
              historyProvider = HistoryProvider(repo: historyRepo);
              return historyProvider;
            },
          ),
          ChangeNotifierProvider<TouchCountProvider>(
            create: (BuildContext context) {
              touchCountProvider = TouchCountProvider(
                  repo: productRepo, psValueHolder: psValueHolder);
              return touchCountProvider;
            },
          )
        ],
            child: Consumer<ProductDetailProvider>(
              builder: (BuildContext context, ProductDetailProvider provider,
                  Widget child) {
                if (widget.productList != null &&
                    widget.productList['images'] != null) {
                  ///
                  /// Add to History
                  ///
                  // historyProvider.addHistoryList(provider.productDetail.data);

                  ///
                  /// Load Related Products
                  ///
                  // final RelatedProductProvider relatedProductProvider =
                  //     Provider.of<RelatedProductProvider>(context,
                  //         listen: false); // Listen : False is important.

                  // relatedProductProvider.loadRelatedProductList(
                  //   provider.productDetail.data.id,
                  //   provider.productDetail.data.catId,
                  // );

                  ///
                  /// Load Basket List
                  ///
                  ///
                  // basketProvider = Provider.of<BasketProvider>(context,
                  //     listen: false); // Listen : False is important.

                  // basketProvider.loadBasketList();

                  return Consumer<BasketProvider>(builder:
                      (BuildContext context, BasketProvider basketProvider,
                          Widget child) {
                    return Stack(
                      children: <Widget>[
                        CustomScrollView(slivers: <Widget>[
                          SliverAppBar(
                            automaticallyImplyLeading: true,
                            brightness: Utils.getBrightnessForAppBar(context),
                            expandedHeight: ps_space_300,
                            iconTheme: Theme.of(context).iconTheme,
                            leading: const PsBackButtonWithCircleBgWidget(),
                            floating: false,
                            pinned: false,
                            stretch: true,
                            actions: <Widget>[
                              Stack(
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
                                            basketProvider.basketList.data
                                                        .length >
                                                    99
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
                              )
                            ],
                            backgroundColor: Utils.isLightMode(context)
                                ? ps_ctheme__color_speical
                                : Colors.black,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                color: Utils.isLightMode(context)
                                    ? Colors.grey[100]
                                    : Colors.grey[900],
                                child: PsNetworkImage(
                                  firebasePhoto: widget.productList['images'],
                                  photoKey: '',
                                  defaultPhoto: widget.product.defaultPhoto,
                                  width: double.infinity,
                                  height: double.infinity,
                                  boxfit: BoxFit.fitHeight,
                                  onTap: () {
                                    Navigator.pushReplacement<dynamic, dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context) =>
                                                GalleryGridView(
                                                  product: widget.product,
                                                  productList:
                                                      widget.productList,
                                                )));
                                    // Navigator.pushNamed(
                                    //     context, RoutePaths.galleryGrid,
                                    //     arguments: widget.product);
                                  },
                                ),
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(<Widget>[
                              Container(
                                color: Utils.isLightMode(context)
                                    ? Colors.grey[100]
                                    : Colors.black87,
                                child: Column(children: <Widget>[
                                  _HeaderBoxWidget(
                                    productList: widget.productList,
                                    productDetail: provider,
                                    product: widget.product,
                                  ),
                                  DetailInfoTileView(
                                    productDetail: provider,
                                  ),
                                  TermsAndPolicyTileView(),
                                  UserCommentTileView(
                                    productDetail: provider,
                                  ),
                                  RelatedProductsTileView(
                                    productDetail: provider,
                                  ),
                                  if (widget.productList['images'] != '0')
                                    const SizedBox(
                                      height: ps_space_40,
                                    ),
                                ]),
                              ) //)
                            ]),
                          )
                        ]),
                        if (widget.productList['price'] != '0')
                          _AddToBasketAndBuyButtonWidget(
                            productProvider: provider,
                            basketProvider: basketProvider,
                            product: widget.product,
                            psValueHolder: psValueHolder,
                          )
                        else
                          Container(),
                      ],
                    );
                  });
                } else {
                  return Container();
                }
              },
            )));
  }
}

class UserCommentTileView extends StatelessWidget {
  const UserCommentTileView({
    Key key,
    @required this.productDetail,
  }) : super(key: key);

  final ProductDetailProvider productDetail;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'user_comment_tile__user_comment'),
        style: Theme.of(context).textTheme.subhead);
    if (productDetail != null) {
      return Card(
        elevation: 0.0,
        child: PsExpansionTile(
          initiallyExpanded: true,
          title: _expansionTileTitleWidget,
          children: <Widget>[
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    final dynamic returnData = await Navigator.pushNamed(
                        context, RoutePaths.commentList,
                        arguments: productDetail.productDetail.data);

                    if (returnData != null && returnData) {
                      productDetail.loadProduct(
                          productDetail.productDetail.data.id,
                          productDetail.psValueHolder.loginUserId);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(ps_space_16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          Utils.getString(
                              context, 'user_comment_tile__view_all_comment'),
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(color: ps_ctheme__color_speical),
                        ),
                        GestureDetector(
                            onTap: () async {
                              final dynamic returnData =
                                  await Navigator.pushNamed(
                                      context, RoutePaths.commentList,
                                      arguments:
                                          productDetail.productDetail.data);

                              if (returnData) {
                                productDetail.loadProduct(
                                    productDetail.productDetail.data.id,
                                    productDetail.psValueHolder.loginUserId);
                              }
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: ps_space_16,
                            )),
                      ],
                    ),
                  ),
                ),
                InkWell(
                    onTap: () async {
                      final dynamic returnData = await Navigator.pushNamed(
                          context, RoutePaths.commentList,
                          arguments: productDetail.productDetail.data);

                      if (returnData != null && returnData) {
                        productDetail.loadProduct(
                            productDetail.productDetail.data.id,
                            productDetail.psValueHolder.loginUserId);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(ps_space_16),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              Utils.getString(
                                  context, 'user_comment_tile__write_comment'),
                              style: Theme.of(context).textTheme.body1.copyWith(
                                    color: ps_ctheme__color_speical,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ],
        ),
      );
    } else {
      return const Card();
    }
  }
}

class _HeaderBoxWidget extends StatefulWidget {
  const _HeaderBoxWidget({
    Key key,
    @required this.productDetail,
    @required this.product,
    @required this.productList,
  }) : super(key: key);
  final DocumentSnapshot productList;

  final ProductDetailProvider productDetail;
  final Product product;

  @override
  __HeaderBoxWidgetState createState() => __HeaderBoxWidgetState();
}

class __HeaderBoxWidgetState extends State<_HeaderBoxWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.product != null &&
        widget.productDetail != null &&
        widget.productDetail.productDetail != null &&
        widget.productDetail.productDetail.data != null) {
      return Card(
        elevation: 0.0,
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(ps_space_16),
                child: Column(
                  children: <Widget>[
                    _FavouriteWidget(
                        productList: widget.productList,
                        productDetail: widget.productDetail,
                        product: widget.product),
                    const SizedBox(
                      height: ps_space_12,
                    ),
                    _HeaderPriceWidget(
                      productPrice: widget.productList,
                      productProvider: widget.productDetail,
                    ),
                    const SizedBox(
                      height: ps_space_12,
                    ),
                    const Divider(
                      height: ps_space_1,
                      color: ps_ctheme__color_speical,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: ps_space_16, bottom: ps_space_4),
                      child: _HeaderRatingWidget(
                        productref: widget.productList,
                        productDetail: widget.productDetail,
                      ),
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(
                  left: ps_space_20, right: ps_space_20, bottom: ps_space_8),
              child: Card(
                elevation: 0.0,
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(ps_space_8)),
                ),
                color: Utils.isLightMode(context)
                    ? Colors.orange[50]
                    : Colors.grey[700],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    widget.productDetail.productDetail.data
                            .highlightInformation ??
                        '',
                    // maxLines: 3,
                    // overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.body1.copyWith(
                        letterSpacing: 0.8,
                        fontSize: 16,
                        color: Utils.isLightMode(context)
                            ? Colors.black45
                            : Colors.white,
                        height: 1.3),
                  ),
                ),
              ),
            ),
            DescriptionTileView(
              productDescription: widget.productList,
              productDetail: widget.productDetail.productDetail.data,
            ),
            Container(
                color: Utils.isLightMode(context)
                    ? Colors.grey[100]
                    : Colors.black87,
                height: ps_space_8),
            // const SizedBox(
            //   height: ps_space_10,
            // ),
            _HeaderButtonWidget(
              productList: widget.productList,
              productDetail: widget.productDetail.productDetail.data,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _FavouriteWidget extends StatefulWidget {
  const _FavouriteWidget({
    Key key,
    @required this.productDetail,
    @required this.product,
    @required this.productList,
  }) : super(key: key);

  final ProductDetailProvider productDetail;
  final Product product;
  final DocumentSnapshot productList;

  @override
  __FavouriteWidgetState createState() => __FavouriteWidgetState();
}

class __FavouriteWidgetState extends State<_FavouriteWidget> {
  Widget icon;
  ProductRepository favouriteRepo;
  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    favouriteRepo = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    if (widget.product != null &&
        widget.productDetail != null &&
        widget.productDetail.productDetail != null &&
        widget.productDetail.productDetail.data != null &&
        widget.productDetail.productDetail.data.isFavourited != null) {
      return ChangeNotifierProvider<FavouriteProductProvider>(
          create: (BuildContext context) {
        final FavouriteProductProvider provider = FavouriteProductProvider(
            repo: favouriteRepo, psValueHolder: psValueHolder);
        // provider.loadFavouriteList('prd9a3bfa2b7ab0f0693e84d834e73224bb');
        return provider;
      }, child: Consumer<FavouriteProductProvider>(builder:
              (BuildContext context, FavouriteProductProvider provider,
                  Widget child) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.productList['ProductName'] ?? '',
                  style: Theme.of(context).textTheme.headline.copyWith(),
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    if (await utilsCheckInternetConnectivity()) {
                      utilsNavigateOnUserVerificationView(provider, context,
                          () async {
                        if (widget.productDetail.productDetail.data
                                .isFavourited ==
                            '0') {
                          setState(() {
                            widget.productDetail.productDetail.data
                                .isFavourited = '1';
                          });
                        } else {
                          setState(() {
                            widget.productDetail.productDetail.data
                                .isFavourited = '0';
                          });
                        }

                        final FavouriteParameterHolder
                            favouriteParameterHolder = FavouriteParameterHolder(
                          userId: provider.psValueHolder.loginUserId,
                          productId: widget.product.id,
                        );

                        final PsResource<Product> _apiStatus = await provider
                            .postFavourite(favouriteParameterHolder.toMap());

                        if (_apiStatus.data != null) {
                          if (_apiStatus.status == PsStatus.SUCCESS) {
                            await widget.productDetail.loadProductForFav(
                                widget.product.id,
                                provider.psValueHolder.loginUserId);
                          }
                          if (widget.productDetail != null &&
                              widget.productDetail.productDetail != null &&
                              widget.productDetail.productDetail.data != null &&
                              widget.productDetail.productDetail.data
                                      .isFavourited ==
                                  '0') {
                            icon = Container(
                              padding: const EdgeInsets.only(
                                  top: ps_space_8,
                                  left: ps_space_8,
                                  right: ps_space_8,
                                  bottom: ps_space_6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ps_ctheme__color_speical,
                                      width: 1),
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.favorite,
                                  color: ps_ctheme__color_speical),
                            );
                          } else {
                            icon = Container(
                              padding: const EdgeInsets.only(
                                  top: ps_space_8,
                                  left: ps_space_8,
                                  right: ps_space_8,
                                  bottom: ps_space_6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ps_ctheme__color_speical,
                                      width: 1),
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.favorite_border,
                                  color: ps_ctheme__color_speical),
                            );
                          }
                        } else {
                          print('There is no comment');
                        }
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
                  child: widget.productDetail.productDetail.data.isFavourited !=
                          null
                      ? widget.productDetail.productDetail.data.isFavourited ==
                              '0'
                          ? icon = Container(
                              padding: const EdgeInsets.only(
                                  top: ps_space_8,
                                  left: ps_space_8,
                                  right: ps_space_8,
                                  bottom: ps_space_6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ps_ctheme__color_speical,
                                      width: 1),
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.favorite_border,
                                  color: ps_ctheme__color_speical),
                            )
                          : icon = Container(
                              padding: const EdgeInsets.only(
                                  top: ps_space_8,
                                  left: ps_space_8,
                                  right: ps_space_8,
                                  bottom: ps_space_6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ps_ctheme__color_speical,
                                      width: 1),
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.favorite,
                                  color: ps_ctheme__color_speical),
                            )
                      : null)
            ]);
      }));
    } else {
      return Container();
    }
  }
}

class _HeaderRatingWidget extends StatelessWidget {
  const _HeaderRatingWidget({
    Key key,
    @required this.productDetail,
    @required this.productref,
  }) : super(key: key);
  final DocumentSnapshot productref;
  final ProductDetailProvider productDetail;

  @override
  Widget build(BuildContext context) {
    dynamic result;
    if (productDetail != null &&
        productDetail.productDetail != null &&
        productDetail.productDetail.data != null &&
        productDetail.productDetail.data.ratingDetail != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SmoothStarRating(
                  rating: double.parse(productDetail
                      .productDetail.data.ratingDetail.totalRatingValue),
                  allowHalfRating: false,
                  starCount: 5,
                  size: ps_space_16,
                  color: Colors.yellow,
                  borderColor: Colors.blueGrey[200],
                  onRatingChanged: (double v) async {
                    print('Click Rating');
                    result = await Navigator.pushNamed(
                        context, RoutePaths.ratingList,
                        arguments: productDetail.productDetail.data.id);

                    if (result != null && result) {
                      productDetail.loadProduct(
                          productDetail.productDetail.data.id,
                          productDetail.psValueHolder.loginUserId);
                    }
                  },
                  spacing: 0.0),
              const SizedBox(
                height: ps_space_10,
              ),
              GestureDetector(
                  onTap: () async {
                    print('Click');
                    result = await Navigator.pushNamed(
                        context, RoutePaths.ratingList,
                        arguments: productDetail.productDetail.data.id);

                    if (result != null && result) {
                      productDetail.loadProduct(
                          productDetail.productDetail.data.id,
                          productDetail.psValueHolder.loginUserId);
                    }
                  },
                  child: (productDetail.productDetail.data.overallRating != '0')
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              productDetail.productDetail.data.ratingDetail
                                      .totalRatingValue ??
                                  '',
                              textAlign: TextAlign.left,
                              style:
                                  Theme.of(context).textTheme.body1.copyWith(),
                            ),
                            const SizedBox(
                              width: ps_space_4,
                            ),
                            Text(
                              '${Utils.getString(context, 'product_detail__out_of_five_stars')}(' +
                                  productDetail.productDetail.data.ratingDetail
                                      .totalRatingCount +
                                  ' ${Utils.getString(context, 'product_detail__reviews')})',
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.body1.copyWith(),
                            ),
                          ],
                        )
                      : const Text('No Rating')),
              const SizedBox(
                height: ps_space_10,
              ),
              if (productDetail.productDetail.data.isAvailable == '1')
                Text(
                  Utils.getString(context, 'product_detail__in_stock'),
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.green),
                )
              else
                Container(),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (productref['Featured Product'] == false)
                  Container()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/baseline_feature_circle_24.png',
                        width: ps_space_32,
                        height: ps_space_32,
                      ),
                      const SizedBox(
                        width: ps_space_8,
                      ),
                      Text(
                        // 'Featured \n Products',
                        Utils.getString(
                            context, 'product_detail__featured_products'),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.body1.copyWith(
                              color: ps_ctheme__color_speical,
                            ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: ps_space_8,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    productref['Reference'] ?? '',
                    textAlign: TextAlign.end,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class _HeaderPriceWidget extends StatefulWidget {
  const _HeaderPriceWidget({
    Key key,
    @required this.productProvider,
    @required this.productPrice,
  }) : super(key: key);
  final DocumentSnapshot productPrice;
  final ProductDetailProvider productProvider;

  @override
  __HeaderPriceWidgetState createState() => __HeaderPriceWidgetState();
}

class __HeaderPriceWidgetState extends State<_HeaderPriceWidget> {
  ProgressDialog downloadProgressDialog;
  final String downloadFolder = 'psdownload';

  Future<bool> requestWritePermission() async {
    final Map<PermissionGroup, PermissionStatus> permissionss =
        await PermissionHandler()
            .requestPermissions(<PermissionGroup>[PermissionGroup.storage]);
    if (permissionss != null &&
        permissionss.isNotEmpty &&
        permissionss[PermissionGroup.storage] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> downloadFile(String name) async {
    Directory dir;
    if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      dir = await getExternalStorageDirectory();
    }

    final String downloadDirectoryPath = '${dir.path}/$downloadFolder';
    final Directory downloadDirectory = Directory(downloadDirectoryPath);

    final bool isThere = downloadDirectory.existsSync();
    if (!isThere) {
      await downloadDirectory.create();
    }

    final Dio dio = Dio();

    // for android

    await dio.download(
        ps_app_image_url + name, '${dir.path}/$downloadFolder/$name', //.jpg
        onReceiveProgress: (int rec, int total) {
      print('Rec: $rec , Total: $total');

      final double progress =
          double.parse(((rec / total) * 100).toStringAsFixed(0));
      print('progress : $progress');
      downloadProgressDialog.update(
          message: Utils.getString(context, 'product_detail__downloading_file'),
          progressWidget: Container(
              padding: const EdgeInsets.all(10.0),
              child: const CircularProgressIndicator()),
          progress: progress,
          maxProgress: 100.0,
          progressTextStyle: const TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.w600));
    });

    downloadProgressDialog.dismiss();

    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return SuccessDialog(
            message:
                Utils.getString(context, 'success_dialog__download_success') +
                    '${dir.path}/$downloadFolder/$name',
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    downloadProgressDialog = ProgressDialog(context,
        type: ProgressDialogType.Download,
        isDismissible: false,
        showLogs: true);
    //Optional
    downloadProgressDialog.style(
      message: Utils.getString(context, 'product_detail__downloading_file'),
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: Container(
          padding: const EdgeInsets.all(10.0),
          child: const CircularProgressIndicator()),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: const TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: const TextStyle(
          color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600),
    );

    if (widget.productPrice['Orignal Price'] != null &&
        widget.productPrice != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (widget.productPrice['Orignal Price'] !=
                      widget.productPrice['price'])
                    Text(
                      '₹${widget.productPrice["Orignal Price"]}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(decoration: TextDecoration.lineThrough),
                    )
                  else
                    Container(),
                  const SizedBox(
                    height: ps_space_4,
                  ),
                  if (widget.productPrice['price'] == ONE)
                    Text(
                      '₹${widget.productPrice["price"]}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(color: ps_ctheme__color_speical),
                    )
                  else
                    Text(
                      widget.productPrice["price"] != '0'
                          ? '₹${widget.productPrice["price"]}'
                          : Utils.getString(context, 'global_product__free'),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(color: ps_ctheme__color_speical),
                    )
                ],
              ),
              const SizedBox(
                width: ps_space_10,
              ),
              if (widget.productPrice['Discount'] != 0)
                Card(
                  elevation: 0,
                  color: ps_ctheme__color_speical,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ps_space_8),
                          bottomLeft: Radius.circular(ps_space_8))),
                  child: Container(
                    width: 60,
                    height: 30,
                    padding: const EdgeInsets.only(
                        left: ps_space_4, right: ps_space_4),
                    child: Align(
                      child: Text(
                        '- ${widget.productPrice['Discount'].toString().replaceAll(".", " ").substring(0, 2)} %',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                )
              else
                Container(),
              const SizedBox(
                width: ps_space_10,
              ),
              if (widget.productProvider.productDetail.data.isPurchased != '' &&
                      widget.productProvider.productDetail.data.isPurchased ==
                          '1' ||
                  widget.productProvider.productDetail.data.unitPrice == '0')
                Container(
                  height: 30,
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(ps_space_4),
                  //     color: ps_ctheme__color_speical),
                  child: RaisedButton.icon(
                      label: Text(Utils.getString(
                          context, 'product_detail__downloading')),
                      icon: Icon(
                        Icons.file_download,
                        color: Colors.white,
                        size: ps_space_20,
                      ),
                      color: ps_ctheme__color_speical,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(ps_space_8),
                      )),
                      textColor: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white)
                          .color,
                      // icon: Icon(
                      //   Icons.file_download,
                      //   color: Colors.white,
                      //   size: ps_space_20,
                      // ),
                      onPressed: () async {
                        utilsNavigateOnUserVerificationView(
                            widget.productProvider, context, () async {
                          final DownloadProductParameterHolder
                              downloadProductParameterHolder =
                              DownloadProductParameterHolder(
                                  userId: widget.productProvider.psValueHolder
                                      .loginUserId,
                                  productId: widget
                                      .productProvider.productDetail.data.id);

                          final PsResource<List<DownloadProduct>> _apiStatus =
                              await widget.productProvider
                                  .postDownloadProductList(
                                      downloadProductParameterHolder.toMap());

                          if (_apiStatus.data != null) {
                            final DownloadProduct downloadProduct =
                                _apiStatus.data[0];
                            requestWritePermission().then((bool status) async {
                              if (status) {
                                downloadFile(downloadProduct.imgPath);
                                downloadProgressDialog.show();
                              } else {
                                downloadProgressDialog.dismiss();
                              }
                            });
                          } else {
                            downloadProgressDialog.dismiss();
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ErrorDialog(
                                    message: _apiStatus.message,
                                  );
                                });
                          }
                        });
                      }),
                ),
            ],
          ),
          // Todo
          // if (widget.productProvider.productDetail.data.isFeatured == '0')
          //   Container()
          // else
          //   Row(
          //     children: <Widget>[
          //       Image.asset(
          //         'assets/images/baseline_feature_circle_24.png',
          //         width: ps_space_32,
          //         height: ps_space_32,
          //       ),
          //       const SizedBox(
          //         width: ps_space_8,
          //       ),
          //       Text(
          //         // 'Featured \n Products',
          //         Utils.getString(context, 'product_detail__featured_products'),
          //         overflow: TextOverflow.ellipsis,
          //         style: Theme.of(context).textTheme.body1.copyWith(
          //               color: ps_ctheme__color_speical,
          //             ),
          //       ),
          //     ],
          //   )
        ],
      );
    } else {
      return Container();
    }
  }
}

class _HeaderButtonWidget extends StatelessWidget {
  const _HeaderButtonWidget({
    Key key,
    @required this.productDetail,
    @required this.productList,
  }) : super(key: key);
  final DocumentSnapshot productList;
  final Product productDetail;
  @override
  Widget build(BuildContext context) {
    if (productDetail != null) {
      return Card(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.only(top: ps_space_10, bottom: ps_space_10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    productDetail.commentHeaderCount ?? '',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  const SizedBox(
                    height: ps_space_8,
                  ),
                  Text(
                    Utils.getString(context, 'product_detail__comments'),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    productDetail.favouriteCount ?? '',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  const SizedBox(
                    height: ps_space_8,
                  ),
                  Text(
                    Utils.getString(context, 'product_detail__whih_list'),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    productList.data['views']?.toString() ?? '0',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  const SizedBox(
                    height: ps_space_8,
                  ),
                  Text(
                    Utils.getString(context, 'product_detail__seen'),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return const Card();
    }
  }
}

class _AddToBasketAndBuyButtonWidget extends StatefulWidget {
  const _AddToBasketAndBuyButtonWidget({
    Key key,
    @required this.productProvider,
    @required this.basketProvider,
    @required this.product,
    @required this.psValueHolder,
  }) : super(key: key);

  final ProductDetailProvider productProvider;
  final BasketProvider basketProvider;
  final Product product;
  final PsValueHolder psValueHolder;
  @override
  __AddToBasketAndBuyButtonWidgetState createState() =>
      __AddToBasketAndBuyButtonWidgetState();
}

class __AddToBasketAndBuyButtonWidgetState
    extends State<_AddToBasketAndBuyButtonWidget> {
  // BasketRepository basketRepo;

  @override
  Widget build(BuildContext context) {
    // basketRepo = Provider.of<BasketRepository>(context);

    if (widget.productProvider != null &&
        widget.productProvider.productDetail != null &&
        widget.productProvider.productDetail.data != null &&
        widget.basketProvider != null &&
        widget.basketProvider.basketList != null &&
        widget.basketProvider.basketList.data != null) {
      // return
      // ChangeNotifierProvider<BasketProvider>(
      //     create: (BuildContext context) {
      //   final BasketProvider provider = BasketProvider(repo: basketRepo);
      //   return provider;
      // }, child:
      // Consumer<BasketProvider>(builder:
      //     (BuildContext context, BasketProvider provider, Widget child) {
      return Container(
        alignment: Alignment.bottomCenter,
        //margin: const EdgeInsets.all(ps_space_12),
        child: SizedBox(
          width: double.infinity,
          height: ps_space_72,
          child: Container(
            decoration: BoxDecoration(
              color: Utils.isLightMode(context)
                  ? Colors.grey[100]
                  : Colors.grey[850],
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
                      ? Colors.grey[400]
                      : Colors.grey[900],
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 0, // has the effect of extending the shadow
                  offset: const Offset(
                    0.0, // horizontal, move right 10
                    0.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(ps_space_8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton.icon(
                      label: Flexible(
                        child: Text(
                          Utils.getString(
                              context, 'product_detail__add_to_basket'),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                      icon: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                        size: ps_space_20,
                      ),
                      color: Colors.grey,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(ps_space_8),
                      )),
                      textColor: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white)
                          .color,
                      onPressed: () async {
                        await widget.basketProvider.addBasketList(
                            widget.productProvider.productDetail.data);
                        await showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return SuccessDialog(
                                message: Utils.getString(context,
                                    'product_detail__success_add_to_basket'),
                              );
                            });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: ps_space_10,
                  ),
                  Expanded(
                    child: RaisedButton.icon(
                      label: Flexible(
                        child: Text(
                          Utils.getString(context, 'product_detail__buy'),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          softWrap: false,
                        ),
                      ),
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: ps_space_20,
                      ),
                      color: ps_ctheme__color_speical,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(ps_space_8),
                      )),
                      textColor: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white)
                          .color,
                      onPressed: () async {
                        await widget.basketProvider.addBasketList(
                            widget.productProvider.productDetail.data);
                        final dynamic result = await Navigator.pushNamed(
                            context, RoutePaths.basketList,
                            arguments:
                                widget.productProvider.productDetail.data);
                        if (result) {
                          widget.productProvider.loadProduct(widget.product.id,
                              widget.psValueHolder.loginUserId);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class _FloatingActionButton extends StatefulWidget {
  const _FloatingActionButton({
    Key key,
    @required this.controller,
    @required this.icons,
    @required this.label,
    // this.onButton
  }) : super(key: key);

  final AnimationController controller;
  final List<IconData> icons;
  final List<String> label;
  @override
  __FloatingActionButtonState createState() => __FloatingActionButtonState();
}

class __FloatingActionButtonState extends State<_FloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(widget.icons.length, (int index) {
        final Widget child = Row(children: <Widget>[
          Container(
              // alignment: FractionalOffset.centerLeft,
              // margin: EdgeInsets.only(right: ps_space_28),
              child: ScaleTransition(
            scale: CurvedAnimation(
              parent: widget.controller,
              curve: Interval(0.0, 1.0 - index / widget.label.length / 1.0,
                  curve: Curves.easeIn),
            ),
            // child: Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(width: 2.0, color: Colors.blueGrey),
            //       borderRadius: BorderRadius.circular(ps_space_8),
            //       shape: BoxShape.rectangle),
            //   height: 40.0,
            //   width: 90.0,
            //   alignment: FractionalOffset.topCenter,
            child: Center(child: Text(widget.label[index])),
            // ),
          )),
          Container(
            height: 70.0,
            width: 56.0,
            // margin: EdgeInsets.only(right: ps_space_20),
            // alignment: FractionalOffset.topLeft,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: widget.controller,
                curve: Interval(0.0, 1.0 - index / widget.icons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                mini: true,
                child: Icon(
                  widget.icons[index],
                ),
                onPressed: () {},
              ),
            ),
          )
        ]);
        return child;
      }).toList()
        ..add(
          FloatingActionButton(
            child: AnimatedBuilder(
              animation: widget.controller,
              builder: (BuildContext context, Widget child) {
                return Transform(
                  transform:
                      Matrix4.rotationZ(widget.controller.value * 0.5 * 2),
                  alignment: FractionalOffset.center,
                  child: Icon(
                      widget.controller.isDismissed ? Icons.mail : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (widget.controller.isDismissed) {
                widget.controller.forward();
              } else {
                widget.controller.reverse();
              }
            },
          ),
        ),
    );
  }
}
