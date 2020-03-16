import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/Service/firestore_loc.dart';
import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/locator.dart';
import 'package:digitalproductstore/model/user_model.dart';
import 'package:digitalproductstore/provider/product/product_provider.dart';
import 'package:digitalproductstore/provider/rating/rating_provider.dart';
import 'package:digitalproductstore/repository/rating_repository.dart';
import 'package:digitalproductstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:digitalproductstore/ui/common/ps_textfield_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingInputDialog extends StatefulWidget {
  const RatingInputDialog({
    Key key,
    @required this.productprovider,
    @required this.productList,
  }) : super(key: key);
  final DocumentSnapshot productList;
  final ProductDetailProvider productprovider;
  @override
  _RatingInputDialogState createState() => _RatingInputDialogState();
}

class _RatingInputDialogState extends State<RatingInputDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  double rating;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RatingRepository ratingRepo = Provider.of<RatingRepository>(context);

    final Widget _headerWidget = Container(
        height: ps_space_52,
        width: double.infinity,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            color: ps_ctheme__color_speical),
        child: Row(
          children: <Widget>[
            const SizedBox(width: ps_space_4),
            Icon(
              Icons.live_help,
              color: Colors.white,
            ),
            const SizedBox(width: ps_space_4),
            Text(
              Utils.getString(context, 'rating_entry__user_rating_entry'),
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ));
   
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)), //this right here
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _headerWidget,
              const SizedBox(
                height: ps_space_16,
              ),
              Column(
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'rating_entry__your_rating'),
                    style: Theme.of(context).textTheme.body1.copyWith(),
                  ),
                  if (rating == null)
                    SmoothStarRating(
                        allowHalfRating: false,
                        rating: 0.0,
                        starCount: 5,
                        size: ps_space_24,
                        color: Colors.yellow,
                        onRatingChanged: (double rating1) {
                          setState(() {
                            rating = rating1;
                          });
                        },
                        borderColor: Colors.blueGrey[200],
                        spacing: 0.0)
                  else
                    SmoothStarRating(
                        allowHalfRating: false,
                        rating: rating,
                        starCount: 5,
                        size: ps_space_24,
                        color: Colors.yellow,
                        onRatingChanged: (double rating1) {
                          setState(() {
                            rating = rating1;
                          });
                        },
                        borderColor: Colors.grey[200],
                        spacing: 0.0),
                  PsTextFieldWidget(
                      titleText:
                          Utils.getString(context, 'rating_entry__title'),
                      hintText: Utils.getString(context, 'rating_entry__title'),
                      textEditingController: titleController),
                  PsTextFieldWidget(
                      titleText:
                          Utils.getString(context, 'rating_entry__message'),
                      hintText:
                          Utils.getString(context, 'rating_entry__message'),
                      textEditingController: descriptionController),
                  const Divider(
                    color: Colors.grey,
                    height: 0.5,
                  ),
                  const SizedBox(
                    height: ps_space_16,
                  ),
                  _ButtonWidget(
                    productList: widget.productList,
                    descriptionController: descriptionController,
                    // provider: provider,
                    productProvider: widget.productprovider,
                    titleController: titleController,
                    rating: rating,
                  ),
                  const SizedBox(
                    height: ps_space_16,
                  )
                ],
              ),
            ],
          ),
        ),
      );
  
    
  }
}

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget(
      {Key key,
      @required this.titleController,
      @required this.descriptionController,
      @required this.provider,
      @required this.productProvider,
      @required this.rating,
      @required this.productList})
      : super(key: key);

  final TextEditingController titleController, descriptionController;
  final RatingProvider provider;
  final ProductDetailProvider productProvider;
  final double rating;
  final DocumentSnapshot productList;

  @override
  Widget build(BuildContext context) {
    final Users users = Provider.of<Users>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: ps_space_8),
      child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('AppUsers')
              .document(users.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: ps_space_36,
                    child: MaterialButton(
                      color: Colors.blueGrey,
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      child: Text(
                        Utils.getString(context, 'rating_entry__cancel'),
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: ps_space_8,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: ps_space_36,
                    child: MaterialButton(
                      child: Text(
                        Utils.getString(context, 'rating_entry__submit'),
                        style: const TextStyle(color: Colors.white),
                      ),
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      color: ps_ctheme__color_speical,
                      onPressed: () async {
                        if (titleController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty &&
                            rating != null &&
                            rating.toString() != '0.0') {
                          // final RatingParameterHolder commentHeaderParameterHolder =
                          //     RatingParameterHolder(
                          //   userId: productProvider.psValueHolder.loginUserId,
                          //   productId: productProvider.productDetail.data.id,
                          //   title: titleController.text,
                          //   description: descriptionController.text,
                          //   rating: rating.toString(),
                          // );

                          // await provider
                          //     .postRating(commentHeaderParameterHolder.toMap());
                          sl.get<FirebaseBloc>().ratingData({
                            'productName': productList['ProductName'],
                            'reference': productList['Reference'],
                            'rating': rating,
                            'uid': users.uid,
                            'image': snapshot.data['ProfileImage'],
                            'createdtime': Timestamp.now(),
                            'name': snapshot.data['name'],
                            'title': titleController.text,
                            'description': descriptionController.text
                          });
                          Navigator.pop(context);
                          // productProvider.resetProductDetail(
                          //   productProvider.productDetail.data.id,
                          //   productProvider.psValueHolder.loginUserId,
                          // );
                          // if (_apiStatus.data != null) {
                          //   provider.resetRatingList(
                          //     productProvider.productDetail.data.id,
                          //   );
                          // } else {
                          //   print('There is no comment');
                          // }
                        } else {
                          print('There is no comment');
                          // if (rating == null ||
                          //     titleController.text == '' ||
                          //     descriptionController.text == '') {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return WarningDialog(
                                  message: Utils.getString(
                                      context, 'rating_entry__error'),
                                );
                              });
                        }
                      },
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
