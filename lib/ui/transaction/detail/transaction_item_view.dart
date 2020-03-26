import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/transaction_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionItemView extends StatelessWidget {
  const TransactionItemView({
    Key key,
    @required this.transaction,
    this.animationController,
    this.animation,
    this.onTap,
    @required this.transactionList,
  }) : super(key: key);

  final TransactionDetail transaction;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  final DocumentSnapshot transactionList;

  @override
  Widget build(BuildContext context) {
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
                    child: _ItemWidget(
                      transactionList: transactionList,
                      transaction: transaction,
                    ),
                  )));
        });
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    Key key,
    @required this.transaction,
    @required this.transactionList,
  }) : super(key: key);

  final TransactionDetail transaction;
  final DocumentSnapshot transactionList;

  @override
  Widget build(BuildContext context) {
    double subTotal;
    double balancePrice;
    const Widget _dividerWidget = Divider(
      height: ps_space_2,
      color: Colors.grey,
    );
    if (transactionList.data['price'] != 0 &&
        transactionList.data['Orignal Price'] != 0) {
      balancePrice =
          transactionList.data['Orignal Price'] -
              transactionList.data['price'];

      // subTotal = balancePrice * double.parse(transaction.qty);
    } else {
      balancePrice = double.parse(transaction.originalPrice);
      subTotal = double.parse(transaction.originalPrice) *
          double.parse(transaction.qty);
    }
    return Card(
        elevation: 0.3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.loyalty,
                  ),
                  const SizedBox(
                    width: ps_space_16,
                  ),
                  Expanded(
                    child: Text(
                      transactionList['ProductName'] ?? '-',
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(
                              fontSize: ps_space_16,
                              fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            _dividerWidget,
            _TransactionNoTextWidget(
              transationInfoText:
                  transactionList.data['Orignal Price'].toString(),
              title:
                  '${Utils.getString(context, 'transaction_detail__price')} :',
            ),
            // _TransactionNoTextWidget(
            //   transationInfoText:
            //       ' ${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.discountAmount)}',
            //   title:
            //       '${Utils.getString(context, 'transaction_detail__discount_avaiable_amount')} :',
            // ),
            // _TransactionNoTextWidget(
            //   transationInfoText:
            //       '${transaction.currencySymbol} ${Utils.getPriceFormat(balancePrice.toString())}',
            //   title:
            //       '${Utils.getString(context, 'transaction_detail__balance')} :',
            // ),
            // _TransactionNoTextWidget(
            //   transationInfoText: '${transaction.qty}',
            //   title:
            //       '${Utils.getString(context, 'transaction_detail__qty')} :',
            // ),
            // _TransactionNoTextWidget(
            //   transationInfoText:
            //       ' ${transaction.currencySymbol} ${Utils.getPriceFormat(subTotal.toString())}',
            //   title:
            //       '${Utils.getString(context, 'transaction_detail__sub_total')} :',
            // ),
            const SizedBox(
              height: ps_space_12,
            ),
          ],
        ));
  }
}

class _TransactionNoTextWidget extends StatelessWidget {
  const _TransactionNoTextWidget({
    Key key,
    @required this.transationInfoText,
    this.title,
  }) : super(key: key);

  final String transationInfoText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: ps_space_16, right: ps_space_16, top: ps_space_12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            transationInfoText ?? '-',
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}
