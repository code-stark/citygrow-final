import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/viewobject/comment_detail.dart';
import 'package:flutter/material.dart';

class CommetDetailListItemView extends StatelessWidget {
  const CommetDetailListItemView({
    Key key,
    @required this.comment,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final CommentDetail comment;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(comment.addedDateStr,
        style: Theme.of(context).textTheme.caption.copyWith());
    if (comment != null) {
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
                        margin: const EdgeInsets.symmetric(
                            horizontal: ps_space_12, vertical: ps_space_4),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              _ImageAndTextWidget(
                                comment: comment,
                              ),
                              _textWidget
                            ],
                          ),
                        ),
                      ),
                    )));
          });
    } else {
      return Container();
    }
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({
    Key key,
    @required this.comment,
  }) : super(key: key);

  final CommentDetail comment;

  @override
  Widget build(BuildContext context) {
    if (comment != null && comment.user != null) {
      return Row(
        children: <Widget>[
          PsNetworkImageWithUrl(
            width: ps_space_40,
            height: ps_space_40,
            photoKey: '',
            url: comment.user.userProfilePhoto,
          ),
          const SizedBox(
            width: ps_space_8,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: ps_space_8),
                child: Text(
                  comment.user.userName,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              Container(
                width: ps_space_180,
                child: Text(
                  comment.detailComment,
                  style: Theme.of(context).textTheme.body1,
                ),
              )
            ],
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
