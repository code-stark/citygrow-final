import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/product.dart';

class ProductVeticalListItem extends StatelessWidget {
  const ProductVeticalListItem(
      {Key key,
      @required this.product,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Product product;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    //print("$ps_app_image_thumbs_url${subCategory.defaultPhoto.imgPath}");
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: GestureDetector(
                      onTap: onTap,
                      child: Card(
                        elevation: 0.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(ps_space_4),
                          child: GridTile(
                            header: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      child: product.isDiscount == ONE
                                          ? Container(
                                              width: ps_space_52,
                                              height: ps_space_24,
                                              child: Stack(
                                                children: <Widget>[
                                                  Image.asset(
                                                      'assets/images/baseline_percent_tag_orange_24.png',
                                                      matchTextDirection: true,
                                                      color:
                                                          ps_ctheme__color_speical),
                                                  Center(
                                                    child: Text(
                                                      '-${product.discountPercent}%',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .body1
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container()),
                                  Padding(
                                    padding: const EdgeInsets.all(ps_space_4),
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: product.isFeatured == ONE
                                            ? Image.asset(
                                                'assets/images/baseline_feature_circle_24.png',
                                                width: ps_space_32,
                                                height: ps_space_32,
                                              )
                                            : Container()),
                                  )
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(
                                  child: PsNetworkImage(
                                    photoKey: '',
                                    defaultPhoto: product.defaultPhoto,
                                    // width: ps_space_200,
                                    // height: ps_space_160,
                                    width: MediaQuery.of(context).size.width,
                                    height: double.infinity,

                                    boxfit: BoxFit.fitHeight,
                                    onTap: () {
                                      Utils.psPrint(
                                          product.defaultPhoto.imgParentId);
                                      onTap();
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: ps_space_8,
                                      top: ps_space_12,
                                      right: ps_space_8,
                                      bottom: ps_space_4),
                                  child: Text(
                                    product.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.body2,
                                    maxLines: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: ps_space_8,
                                      top: ps_space_4,
                                      right: ps_space_8),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                          product.unitPrice != '0'
                                              ? '${product.currencySymbol}${Utils.getPriceFormat(product.unitPrice)}'
                                              : Utils.getString(context,
                                                  'global_product__free'),
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle
                                              .copyWith(
                                                  color:
                                                      ps_ctheme__color_speical)),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: ps_space_8,
                                              right: ps_space_8),
                                          child: product.isDiscount == ONE
                                              ? Text(
                                                  '${product.currencySymbol}${Utils.getPriceFormat(product.originalPrice)}',
                                                  textAlign: TextAlign.start,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body1
                                                      .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough))
                                              : Container()),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: ps_space_8,
                                      top: ps_space_8,
                                      right: ps_space_4),
                                  child: SmoothStarRating(
                                      rating: double.parse(product
                                          .ratingDetail.totalRatingValue),
                                      allowHalfRating: false,
                                      onRatingChanged: (double v) {
                                        onTap();
                                      },
                                      starCount: 5,
                                      size: 20.0,
                                      color: Colors.orange,
                                      borderColor: Colors.grey,
                                      spacing: 0.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: ps_space_4,
                                      bottom: ps_space_12,
                                      left: ps_space_12,
                                      right: ps_space_12),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                          '${product.ratingDetail.totalRatingValue} ${Utils.getString(context, 'feature_slider__rating')}',
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      Expanded(
                                        child: Text(
                                            '( ${product.ratingDetail.totalRatingCount} ${Utils.getString(context, 'feature_slider__reviewer')} )',
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))));
        });
  }
}
