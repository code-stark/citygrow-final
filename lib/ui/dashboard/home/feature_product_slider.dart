import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    @required this.productList,
  }) : super(key: key);

  final Function onTap;
  final List<DocumentSnapshot> productList;
  final List<Product> featuredProductList;

  @override
  _FeatureProductSliderState createState() => _FeatureProductSliderState();
}

class _FeatureProductSliderState extends State<FeatureProductSliderView> {
  String _currentId;
  List<double> onestar = [];
  List<double> twostar = [];
  List<double> threestar = [];
  List<double> fourstar = [];
  List<double> fivestar = [];
  int hi;
  @override
  Widget build(BuildContext context) {
    stars(product) {
      Firestore.instance
          .collection('rating')
          .where('reference', isEqualTo: product)
          .where('rating', isEqualTo: 1)
          .snapshots()
          .listen((event) =>
              event.documents.forEach((e) => onestar.add(e['rating'])));

      Firestore.instance
          .collection('rating')
          .where('reference', isEqualTo: product)
          .where('rating', isEqualTo: 2)
          .snapshots()
          .listen((event) =>
              event.documents.forEach((e) => twostar.add(e['rating'])));

      Firestore.instance
          .collection('rating')
          .where('reference', isEqualTo: product)
          .where('rating', isEqualTo: 3)
          .snapshots()
          .listen((event) =>
              event.documents.forEach((e) => threestar.add(e['rating'])));

      Firestore.instance
          .collection('rating')
          .where('reference', isEqualTo: product)
          .where('rating', isEqualTo: 4)
          .snapshots()
          .listen((event) =>
              event.documents.forEach((e) => fourstar.add(e['rating'])));

      Firestore.instance
          .collection('rating')
          .where('reference', isEqualTo: product)
          .where('rating', isEqualTo: 5)
          .snapshots()
          .listen((event) =>
              event.documents.forEach((e) => fivestar.add(e['rating'])));
      final numbers = (5 * fivestar.length +
              4 * fourstar.length +
              3 * threestar.length +
              2 * twostar.length +
              1 * onestar.length) /
          (fivestar.length +
                  fourstar.length +
                  threestar.length +
                  twostar.length +
                  onestar.length)
              .toDouble();
      return numbers;
    }

    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('rating').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: <Widget>[
              if (widget.productList != null && widget.productList.isNotEmpty)
                CarouselSlider(
                  enlargeCenterPage: true,
                  autoPlay: true,
                  viewportFraction: 0.9,
                  autoPlayInterval: const Duration(seconds: 5),
                  items: widget.productList.map((DocumentSnapshot product) {
                    // var index = widget.productList.indexOf(product);
                    // print(index);
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
                                    firebasePhoto: product['images'][0],
                                    photoKey: '',
                                    // defaultPhoto: product.defaultPhoto,
                                    width: MediaQuery.of(context).size.width,
                                    height: ps_space_300,
                                    boxfit: BoxFit.fitHeight,
                                    onTap: () {
                                      widget.onTap(product);
                                    }),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      child: product['Discount'] != null &&
                                              product['Discount'] != 0
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
                                                      '-${product["Discount"].toString().replaceAll(".", " ").substring(0, 2)}%',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
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
                                      child: product['Featured Product'] == true
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
                                    decoration: const BoxDecoration(
                                        color: Colors.black54),
                                    padding: const EdgeInsets.only(
                                      top: ps_space_4,
                                      left: ps_space_8,
                                      right: ps_space_8,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: ps_space_8,
                                            top: ps_space_4,
                                          ),
                                          child: Text(
                                            product['ProductName'],
                                            textAlign: TextAlign.left,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    fontSize: ps_space_16,
                                                    color: Colors.white),
                                            maxLines: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: ps_space_8,
                                              top: ps_space_4),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                  product['price'] != 0
                                                      ? '₹${product['price']}'
                                                      : Utils.getString(context,
                                                          'global_product__free'),
                                                  textAlign: TextAlign.start,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2
                                                      .copyWith(
                                                          color:
                                                              ps_ctheme__color_speical)),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: ps_space_4,
                                                          right: 4),
                                                  child: product['Discount'] !=
                                                              null &&
                                                          product['Orignal Price'] !=
                                                              product['price']
                                                      ? Text(
                                                          '₹${product["Orignal Price"]}',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText1
                                                              .copyWith(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough))
                                                      : Container()),
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //     left: ps_space_8,
                                        //     top: ps_space_4,
                                        //   ),
                                        //   child: SmoothStarRating(
                                        //       rating: stars(
                                        //                   product['Reference'])
                                        //               .isNaN
                                        //           ? 0
                                        //           : stars(product['Reference'])
                                        //       // double.parse(product
                                        //       //     .ratingDetail.totalRatingValue)
                                        //       ,
                                        //       allowHalfRating: false,
                                        //       onRatingChanged: (double v) {
                                        //         widget.onTap(product);
                                        //       },
                                        //       starCount: 5,
                                        //       size: 15.0,
                                        //       color: Colors.orange,
                                        //       borderColor: Colors.grey,
                                        //       spacing: 0.0),
                                        // ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       top: ps_space_4,
                                        //       bottom: ps_space_4,
                                        //       left: ps_space_8),
                                        //   child: Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: <Widget>[
                                        //       Text(
                                        //           '${snapshot.data.documents.length} ${Utils.getString(context, 'feature_slider__rating')}',
                                        //           textAlign: TextAlign.start,
                                        //           style: Theme.of(context)
                                        //               .textTheme
                                        //               .caption),
                                        //       Expanded(
                                        //         child: Text(
                                        //             '( ${snapshot.data.documents.length} ${Utils.getString(context, 'feature_slider__reviewer')} )',
                                        //             textAlign: TextAlign.start,
                                        //             style: Theme.of(context)
                                        //                 .textTheme
                                        //                 .caption),
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),
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
                      // i = hi;
                      _currentId = widget.productList[i]['Reference'];
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
                    children: widget.productList != null &&
                            widget.productList.isNotEmpty
                        ? widget.productList.map((DocumentSnapshot product) {
                            return Builder(builder: (BuildContext context) {
                              return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentId ==
                                              product.data['Reference']
                                          ? Colors.yellow[800]
                                          : Colors.yellow[100]));
                            });
                          }).toList()
                        : <Widget>[Container()],
                  ))
            ],
          );
        });
  }
}
