import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/viewobject/rating.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingListItem extends StatelessWidget {
  const RatingListItem({
    Key key,
    @required this.rating,
    this.onTap,
  }) : super(key: key);

  final Rating rating;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0.3,
        margin: const EdgeInsets.symmetric(
            horizontal: ps_space_4, vertical: ps_space_4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _RatingListDataWidget(
              rating: rating,
            ),
            const Divider(
              height: ps_space_1,
            ),
            ImageAndTextWidget(
              rating: rating,
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingListDataWidget extends StatelessWidget {
  const _RatingListDataWidget({
    Key key,
    @required this.rating,
  }) : super(key: key);

  final Rating rating;

  @override
  Widget build(BuildContext context) {
    final Widget _ratingStarsWidget = SmoothStarRating(
        rating: double.parse(rating.rating),
        allowHalfRating: false,
        starCount: 5,
        size: ps_space_16,
        color: Colors.yellow,
        borderColor: Colors.blueGrey[200],
        spacing: 0.0);

    const Widget _spacingWidget = SizedBox(
      height: ps_space_8,
    );
    final Widget _titleTextWidget = Text(
      rating.title,
      style: Theme.of(context)
          .textTheme
          .subhead
          .copyWith(fontWeight: FontWeight.bold),
    );
    final Widget _descriptionTextWidget = Text(
      rating.description,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.body1.copyWith(),
    );
    return Padding(
      padding: const EdgeInsets.all(ps_space_12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _ratingStarsWidget,
          _spacingWidget,
          _titleTextWidget,
          _spacingWidget,
          _descriptionTextWidget,
        ],
      ),
    );
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key key,
    @required this.rating,
  }) : super(key: key);

  final Rating rating;

  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(ps_space_8),
      child: PsNetworkImageWithUrl(
        photoKey: '',
        url: rating.user.userProfilePhoto,
        width: ps_space_40,
        height: ps_space_40,
      ),
    );
    final Widget _personNameTextWidget = Text(rating.user.userName,
        style: Theme.of(context).textTheme.subhead.copyWith());

    final Widget _timeWidget = Text(
      rating.addedDateStr,
      style: Theme.of(context).textTheme.caption.copyWith(),
    );
    return Padding(
      padding: const EdgeInsets.all(ps_space_12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              _imageWidget,
              const SizedBox(
                width: ps_space_12,
              ),
              _personNameTextWidget,
            ],
          ),
          _timeWidget,
        ],
      ),
    );
  }
}
