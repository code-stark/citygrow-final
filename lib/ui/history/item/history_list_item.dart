import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/material.dart';

class HistoryListItem extends StatelessWidget {
  const HistoryListItem(
      {Key key,
      @required this.history,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Product history;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    if (history != null) {
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
                        margin: const EdgeInsets.symmetric(
                            horizontal: ps_space_12, vertical: ps_space_4),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _ImageAndTextWidget(
                            history: history,
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
    @required this.history,
  }) : super(key: key);

  final Product history;

  @override
  Widget build(BuildContext context) {
    if (history != null && history.name != null) {
      return Row(
        children: <Widget>[
          PsNetworkImage(
            photoKey: '',
            width: ps_space_60,
            height: ps_space_60,
            defaultPhoto: history.defaultPhoto,
            boxfit: BoxFit.fitHeight,
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
                  history.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
              const SizedBox(
                height: ps_space_8,
              ),
              Text(
                history.addedDate,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.grey),
              ),
            ],
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
