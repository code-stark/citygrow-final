import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/provider/product/product_provider.dart';
import 'package:digitalproductstore/provider/rating/rating_provider.dart';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/repository/rating_repository.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_appbar_with_two_provider.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/ui/rating/entry/rating_input_dialog.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../item/rating_list_item.dart';

class RatingListView extends StatefulWidget {
  const RatingListView({
    Key key,
    @required this.productDetailid,
  }) : super(key: key);

  final String productDetailid;
  @override
  _RatingListViewState createState() => _RatingListViewState();
}

class _RatingListViewState extends State<RatingListView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  RatingRepository ratingRepo;
  RatingProvider ratingProvider;
  ProductDetailProvider productDetailProvider;
  ProductRepository productRepository;
  PsValueHolder psValueHolder;

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

    ratingRepo = Provider.of<RatingRepository>(context);
    productRepository = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBarWithTwoProvider<RatingProvider,
                ProductDetailProvider>(
            appBarTitle: Utils.getString(context, 'rating_list__title') ?? '',
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.border_color,
                ),
                onPressed: () async {
                  if (await utilsCheckInternetConnectivity()) {
                    utilsNavigateOnUserVerificationView(
                        productDetailProvider, context, () async {
                      await showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return RatingInputDialog(
                                productprovider: productDetailProvider);
                          });

                      ratingProvider.refreshRatingList(widget.productDetailid);

                      await productDetailProvider.loadProduct(
                          widget.productDetailid,
                          productDetailProvider.psValueHolder.loginUserId);

                      // product = productDetailProvider.productDetail.data;

                      //setState(() {});
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
            initProvider1: () {
              ratingProvider = RatingProvider(repo: ratingRepo);
              return ratingProvider;
            },
            onProviderReady1: (RatingProvider provider) {
              provider.loadRatingList(widget.productDetailid);
            },
            initProvider2: () {
              productDetailProvider = ProductDetailProvider(
                  repo: productRepository, psValueHolder: psValueHolder);
              return productDetailProvider;
            },
            onProviderReady2: (ProductDetailProvider productDetailProvider) {
              productDetailProvider.loadProduct(
                  widget.productDetailid, psValueHolder.loginUserId);
            },
            child: Consumer<RatingProvider>(builder: (BuildContext context,
                RatingProvider ratingProvider, Widget child) {
              return CustomScrollView(
                slivers: <Widget>[
                  HeaderWidget(
                      productDetailId: widget.productDetailid,
                      ratingProvider: ratingProvider),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return RatingListItem(
                          rating: ratingProvider.ratingList.data[index],
                          onTap: () {
                            // Navigator.pushNamed(context, RoutePaths.directory1__ratingList,
                            //     arguments: product);
                          },
                        );
                      },
                      childCount: ratingProvider.ratingList.data.length,
                    ),
                  )
                ],
              );
            })));
  }
}

class HeaderWidget extends StatefulWidget {
  const HeaderWidget(
      {Key key, @required this.productDetailId, @required this.ratingProvider})
      : super(key: key);
  final String productDetailId;
  final RatingProvider ratingProvider;

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  ProductRepository repo;
  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    repo = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    const Widget _spacingWidget = SizedBox(
      height: ps_space_10,
    );
    return SliverToBoxAdapter(
      child: Consumer<ProductDetailProvider>(builder: (BuildContext context,
          ProductDetailProvider productDetailProvider, Widget child) {
        if (productDetailProvider.productDetail != null &&
            productDetailProvider.productDetail.data != null &&
            productDetailProvider.productDetail.data.ratingDetail != null) {
          return Card(
            elevation: 0.3,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: ps_space_12, right: ps_space_12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _spacingWidget,
                  Text(
                      '${productDetailProvider.productDetail.data.ratingDetail.totalRatingCount} ${Utils.getString(context, 'rating_list__customer_reviews')}'),
                  const SizedBox(
                    height: ps_space_4,
                  ),
                  Row(
                    children: <Widget>[
                      SmoothStarRating(
                          rating: double.parse(productDetailProvider
                              .productDetail
                              .data
                              .ratingDetail
                              .totalRatingValue),
                          allowHalfRating: false,
                          starCount: 5,
                          size: ps_space_16,
                          color: Colors.yellow,
                          borderColor: Colors.blueGrey[200],
                          spacing: 0.0),
                      const SizedBox(
                        width: ps_space_100,
                      ),
                      Text(
                          '${productDetailProvider.productDetail.data.ratingDetail.totalRatingValue} ${Utils.getString(context, 'rating_list__out_of_five_stars')}'),
                    ],
                  ),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__five_star'),
                      value: double.parse(productDetailProvider
                          .productDetail.data.ratingDetail.fiveStarCount),
                      percentage:
                          '${productDetailProvider.productDetail.data.ratingDetail.fiveStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__four_star'),
                      value: double.parse(productDetailProvider
                          .productDetail.data.ratingDetail.fourStarCount),
                      percentage:
                          '${productDetailProvider.productDetail.data.ratingDetail.fourStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__three_star'),
                      value: double.parse(productDetailProvider
                          .productDetail.data.ratingDetail.threeStarCount),
                      percentage:
                          '${productDetailProvider.productDetail.data.ratingDetail.threeStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__two_star'),
                      value: double.parse(productDetailProvider
                          .productDetail.data.ratingDetail.twoStarCount),
                      percentage:
                          '${productDetailProvider.productDetail.data.ratingDetail.twoStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__one_star'),
                      value: double.parse(productDetailProvider
                          .productDetail.data.ratingDetail.oneStarCount),
                      percentage:
                          '${productDetailProvider.productDetail.data.ratingDetail.oneStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _spacingWidget,
                  const Divider(
                    height: ps_space_1,
                  ),
                  _WriteReviewButtonWidget(
                    productprovider: productDetailProvider,
                    ratingProvider: widget.ratingProvider,
                    productId: widget.productDetailId,
                  ),
                  const SizedBox(
                    height: ps_space_12,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

class _RatingWidget extends StatelessWidget {
  const _RatingWidget({
    Key key,
    @required this.starCount,
    @required this.value,
    @required this.percentage,
  }) : super(key: key);

  final String starCount;
  final double value;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: ps_space_4),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            starCount,
            style: Theme.of(context).textTheme.subhead,
          ),
          const SizedBox(
            width: ps_space_12,
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: value,
            ),
          ),
          const SizedBox(
            width: ps_space_12,
          ),
          Container(
            width: ps_space_68,
            child: Text(
              percentage,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
        ],
      ),
    );
  }
}

class _WriteReviewButtonWidget extends StatelessWidget {
  const _WriteReviewButtonWidget({
    Key key,
    @required this.productprovider,
    @required this.ratingProvider,
    @required this.productId,
    // @required this.loginUserId,
  }) : super(key: key);

  final ProductDetailProvider productprovider;
  final RatingProvider ratingProvider;
  final String productId;
  // final String loginUserId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: ps_space_10),
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        height: ps_space_36,
        child: MaterialButton(
          child: Text(
            Utils.getString(context, 'rating_list__write_review'),
            style: const TextStyle(color: Colors.white),
          ),
          color: ps_ctheme__color_speical,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () async {
            if (await utilsCheckInternetConnectivity()) {
              utilsNavigateOnUserVerificationView(productprovider, context,
                  () async {
                await showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return RatingInputDialog(
                          productprovider: productprovider);
                    });

                ratingProvider.refreshRatingList(productId);
                await productprovider.loadProduct(
                    productId, productprovider.psValueHolder.loginUserId);
              });
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message:
                          Utils.getString(context, 'error_dialog__no_internet'),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
