import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/product.dart';

class ProductHorizontalListItem extends StatelessWidget {
  const ProductHorizontalListItem({
    Key key,
    @required this.productList,
    this.product,
    this.onTap,
  }) : super(key: key);

  final Product product;
  final DocumentSnapshot productList;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    if (productList == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.3,
          child: ClipPath(
            child: Container(
              // color: Colors.white,
              width: ps_space_180,
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: PsNetworkImage(
                          firebasePhoto: productList['images'],
                          photoKey: '',
                          defaultPhoto: product.defaultPhoto,
                          width: ps_space_180,
                          height: double.infinity,
                          boxfit: BoxFit.fitHeight,
                          onTap: () {
                            Utils.psPrint(product.defaultPhoto.imgParentId);
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
                          productList['ProductName'],
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle2,
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
                                productList['price'] != '0'
                                    ? '₹${productList["price"]}'
                                    : Utils.getString(
                                        context, 'global_product__free'),
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(color: ps_ctheme__color_speical)),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: ps_space_8, right: ps_space_8),
                                child: productList['Discount'] != null &&
                                        productList['Orignal Price'] !=
                                            productList['price']
                                    ? Text('₹${productList["Orignal Price"]}',
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                decoration:
                                                    TextDecoration.lineThrough))
                                    : Container()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: ps_space_8,
                            top: ps_space_8,
                            right: ps_space_8),
                        child: SmoothStarRating(
                            rating: double.parse(
                                product.ratingDetail.totalRatingValue),
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
                          right: ps_space_8,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                                '${product.ratingDetail.totalRatingValue} ${Utils.getString(context, 'feature_slider__rating')}',
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.caption),
                            Expanded(
                              child: Text(
                                  '( ${product.ratingDetail.totalRatingCount} ${Utils.getString(context, 'feature_slider__reviewer')} )',
                                  textAlign: TextAlign.start,
                                  softWrap: false,
                                  style: Theme.of(context).textTheme.caption),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: productList['Discount'] != null &&
                                  productList['Discount'] != 0
                              ? Container(
                                  width: ps_space_52,
                                  height: ps_space_24,
                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset(
                                          'assets/images/baseline_percent_tag_orange_24.png',
                                          matchTextDirection: true,
                                          color: ps_ctheme__color_speical),
                                      Center(
                                        child: Text(
                                          '-${productList["Discount"].toString().replaceAll(".", " ").substring(0, 2)}%',
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .body1
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container()),
                      Padding(
                        padding: const EdgeInsets.all(ps_space_4),
                        child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: productList['Featured Product'] == true
                                ? Image.asset(
                                    'assets/images/baseline_feature_circle_24.png',
                                    width: ps_space_32,
                                    height: ps_space_32,
                                    alignment: Alignment.topLeft,
                                  )
                                : Container()),
                      )
                    ],
                  )
                ],
              ),
            ),
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
          ),
        ));
  }
}
