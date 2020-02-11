import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/material.dart';

class BasketListItemView extends StatelessWidget {
  const BasketListItemView(
      {Key key,
      @required this.basket,
      this.onTap,
      this.onDeleteTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Product basket;
  final Function onTap;
  final Function onDeleteTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    if (basket != null) {
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
                    child: _ImageAndTextWidget(
                      basket: basket,
                      onDeleteTap: onDeleteTap,
                    ),
                  ),
                ),
              ),
            );
          });
    } else {
      return Container();
    }
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({
    Key key,
    @required this.basket,
    @required this.onDeleteTap,
  }) : super(key: key);

  final Product basket;
  final Function onDeleteTap;
  @override
  Widget build(BuildContext context) {
    if (basket != null && basket != null) {
      return Row(
        children: <Widget>[
          PsNetworkImage(
            photoKey: '',
            width: ps_space_60,
            height: ps_space_60,
            defaultPhoto: basket.defaultPhoto,
            boxfit: BoxFit.fitHeight,
          ),
          const SizedBox(
            width: ps_space_8,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: ps_space_8),
                  child: Text(
                    basket.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subhead.copyWith(),
                  ),
                ),
                Text(
                  'Price  ${basket.currencySymbol} ${Utils.getPriceFormat(basket.unitPrice)}',
                  style: Theme.of(context).textTheme.body1.copyWith(),
                ),
              ],
            ),
          ),
          _DeleteButtonWidget(onDeleteTap: onDeleteTap),
        ],
      );
    } else {
      return Container();
    }
  }
}

class _DeleteButtonWidget extends StatelessWidget {
  const _DeleteButtonWidget({
    Key key,
    @required this.onDeleteTap,
  }) : super(key: key);

  final Function onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDeleteTap,
      child: Container(
        height: ps_space_72,
        padding: const EdgeInsets.all(8.0),
        color: Colors.blueGrey[200],
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.black54,
        ),
      ),
    );
  }
}
