import 'package:carousel_slider/carousel_slider.dart';
import 'package:digitalproductstore/config/ps_colors.dart';

import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';

import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class FeatureProductSliderView extends StatefulWidget {
  const FeatureProductSliderView({
    Key key,
    @required this.featuredProductList,
    this.onTap,
  }) : super(key: key);

  final Function onTap;
  final List<Product> featuredProductList;

  @override
  _FeatureProductSliderState createState() => _FeatureProductSliderState();
}

class _FeatureProductSliderState extends State<FeatureProductSliderView> {
  String _currentId;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.featuredProductList != null &&
            widget.featuredProductList.isNotEmpty)
          CarouselSlider(
            enlargeCenterPage: true,
            autoPlay: true,
            viewportFraction: 0.9,
            autoPlayInterval: const Duration(seconds: 5),
            items: widget.featuredProductList.map((Product product) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Utils.isLightMode(context)
                            ? Colors.grey[100]
                            : Colors.grey[900],
                        borderRadius: const BorderRadius.all(
                            Radius.circular(ps_space_4))),
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(ps_space_4),
                          child: PsNetworkImage(
                              photoKey: '',
                              defaultPhoto: product.defaultPhoto,
                              width: MediaQuery.of(context).size.width,
                              height: ps_space_300,
                              boxfit: BoxFit.fitHeight,
                              onTap: () {
                                widget.onTap(product);
                              }),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                textAlign: TextAlign.start,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body1
                                                    .copyWith(
                                                        color: Colors.white),
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
                                    : Container(),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              widget.onTap(product);
                            },
                            child: Container(
                              height: 100,
                              decoration:
                                  const BoxDecoration(color: Colors.black54),
                              padding: const EdgeInsets.only(
                                top: ps_space_4,
                                left: ps_space_8,
                                right: ps_space_8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: ps_space_8,
                                      top: ps_space_4,
                                    ),
                                    child: Text(
                                      product.name,
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context)
                                          .textTheme
                                          .body2
                                          .copyWith(
                                              fontSize: ps_space_16,
                                              color: Colors.white),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: ps_space_8, top: ps_space_4),
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
                                                left: ps_space_4, right: 4),
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
                                      top: ps_space_4,
                                    ),
                                    child: SmoothStarRating(
                                        rating: double.parse(product
                                            .ratingDetail.totalRatingValue),
                                        allowHalfRating: false,
                                        onRatingChanged: (double v) {
                                          widget.onTap(product);
                                        },
                                        starCount: 5,
                                        size: 15.0,
                                        color: Colors.orange,
                                        borderColor: Colors.grey,
                                        spacing: 0.0),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: ps_space_4,
                                        bottom: ps_space_4,
                                        left: ps_space_8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
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
                        )
                      ],
                      // ),
                    ),
                  );
                },
              );
            }).toList(),
            onPageChanged: (int i) {
              setState(() {
                _currentId = widget.featuredProductList[i].id;
              });
            },
          )
        else
          Container(),
        Positioned(
            bottom: 10.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.featuredProductList != null &&
                      widget.featuredProductList.isNotEmpty
                  ? widget.featuredProductList.map((Product product) {
                      return Builder(builder: (BuildContext context) {
                        return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentId == product.id
                                    ? Colors.yellow[800]
                                    : Colors.yellow[100]));
                      });
                    }).toList()
                  : <Widget>[Container()],
            ))
      ],
    );
  }
}
