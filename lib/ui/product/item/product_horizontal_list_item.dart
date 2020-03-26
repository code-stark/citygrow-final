import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/product.dart';

class ProductHorizontalListItem extends StatefulWidget {
  ProductHorizontalListItem({
    Key key,
    @required this.productList,
    this.product,
    this.onTap,
  }) : super(key: key);

  final Product product;
  final DocumentSnapshot productList;
  final Function onTap;

  @override
  _ProductHorizontalListItemState createState() => _ProductHorizontalListItemState();
}

class _ProductHorizontalListItemState extends State<ProductHorizontalListItem> {
  List<double> onestar = [];

  List<double> twostar = [];

  List<double> threestar = [];

  List<double> fourstar = [];

  List<double> fivestar = [];

  @override
  Widget build(BuildContext context) {
    if (widget.productList == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    Firestore.instance
        .collection('rating')
        .where('reference', isEqualTo: widget.productList['Reference'])
        .where('rating', isEqualTo: 1)
        .snapshots()
        .listen((event) =>
            event.documents.forEach((e) => onestar.add(e['rating'])));

    Firestore.instance
        .collection('rating')
        .where('reference', isEqualTo: widget.productList['Reference'])
        .where('rating', isEqualTo: 2)
        .snapshots()
        .listen((event) =>
            event.documents.forEach((e) => twostar.add(e['rating'])));

    Firestore.instance
        .collection('rating')
        .where('reference', isEqualTo: widget.productList['Reference'])
        .where('rating', isEqualTo: 3)
        .snapshots()
        .listen((event) =>
            event.documents.forEach((e) => threestar.add(e['rating'])));

    Firestore.instance
        .collection('rating')
        .where('reference', isEqualTo: widget.productList['Reference'])
        .where('rating', isEqualTo: 4)
        .snapshots()
        .listen((event) =>
            event.documents.forEach((e) => fourstar.add(e['rating'])));

    Firestore.instance
        .collection('rating')
        .where('reference', isEqualTo: widget.productList['Reference'])
        .where('rating', isEqualTo: 5)
        .snapshots()
        .listen((event) =>
            event.documents.forEach((e) => fivestar.add(e['rating'])));
    int hi;

    return GestureDetector(
        onTap: widget.onTap,
        child: Card(
          elevation: 0.3,
          child: ClipPath(
            child: Container(
              // color: Colors.white,
              width: ps_space_180,
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('rating')
                      .where('reference', isEqualTo: widget.productList['Reference'])
                      .snapshots(),
                  builder: (context, ratingss) {
                    if (!ratingss.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    stars() {
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

                    List.generate(
                        ratingss.data.documents.length, (index) => index = hi);
                    return Stack(
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: PsNetworkImage(
                                firebasePhoto: widget.productList['images'],
                                photoKey: '',
                                // defaultPhoto: product.defaultPhoto,
                                width: ps_space_180,
                                height: double.infinity,
                                boxfit: BoxFit.fitHeight,
                                onTap: () {
                                  // Utils.psPrint(product.defaultPhoto.imgParentId);
                                  widget.onTap();
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
                                widget.productList['ProductName'],
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
                                      widget.productList['price'] != '0'
                                          ? '₹${widget.productList["price"]}'
                                          : Utils.getString(
                                              context, 'global_product__free'),
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                              color: ps_ctheme__color_speical)),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: ps_space_8, right: ps_space_8),
                                      child: widget.productList['Discount'] != null &&
                                              widget.productList['Orignal Price'] !=
                                                  widget.productList['price']
                                          ? Text(
                                              '₹${widget.productList["Orignal Price"]}',
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                      decoration: TextDecoration
                                                          .lineThrough))
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
                                  rating: stars().isNaN ? 0 : stars().toDouble(),
                                  // double.parse(
                                  //     // product.ratingDetail.totalRatingValue
                                  //     ),
                                  allowHalfRating: false,
                                  onRatingChanged: (double v) {
                                    widget.onTap();
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
                                      '${stars().isNaN ? 'No' : stars()} ${Utils.getString(context, 'feature_slider__rating')}',
                                      textAlign: TextAlign.start,
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  Expanded(
                                    child: Text(
                                        '(${ratingss.data.documents.length} ${Utils.getString(context, 'feature_slider__reviewer')})',
                                        textAlign: TextAlign.start,
                                        softWrap: false,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
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
                                child: widget.productList['Discount'] != null &&
                                        widget.productList['Discount'] != 0
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
                                                '-${widget.productList["Discount"].toString().replaceAll(".", " ").substring(0, 2)}%',
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
                              child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: widget.productList['Featured Product'] == true
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
                    );
                  }),
            ),
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
          ),
        ));
  }
}
