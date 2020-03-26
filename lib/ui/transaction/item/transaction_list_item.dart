import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/transaction_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    Key key,
    @required this.transaction,
    this.animationController,
    this.animation,
    this.onTap,
    @required this.scaffoldKey,
    @required this.transactionList,
  }) : super(key: key);

  final TransactionHeader transaction;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final DocumentSnapshot transactionList;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    if (transactionList != null &&
        transactionList.documentID != null) {
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
                        horizontal: ps_space_4, vertical: ps_space_4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _TransactionNoWidget(
                          transactionList: transactionList,
                          transaction: transaction,
                          scaffoldKey: scaffoldKey,
                        ),
                        const Divider(
                          height: ps_space_1,
                          color: ps_ctheme__color_line,
                        ),
                        _TransactionTextWidget(
                          transactionID: transactionList,
                          transaction: transaction,
                        ),
                      ],
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

class _TransactionNoWidget extends StatelessWidget {
  const _TransactionNoWidget({
    Key key,
    @required this.transaction,
    @required this.scaffoldKey,
    @required this.transactionList,
  }) : super(key: key);

  final TransactionHeader transaction;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final DocumentSnapshot transactionList;

  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      'Transaction No : ${transactionList['transactionID']}' ?? '-',
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.subtitle2,
    );

    final Widget _iconWidget = Icon(
      Icons.settings_backup_restore,
      size: 24,
    );

    return Padding(
      padding: const EdgeInsets.only(
          left: ps_space_12,
          right: ps_space_4,
          top: ps_space_4,
          bottom: ps_space_4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _iconWidget,
              const SizedBox(
                width: ps_space_8,
              ),
              _textWidget,
            ],
          ),
          IconButton(
            icon: Icon(Icons.content_copy),
            iconSize: 24,
            onPressed: () {
              Clipboard.setData(ClipboardData(
                  text: transactionList['transactionID']));
              scaffoldKey.currentState.showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).iconTheme.color,
                content: Tooltip(
                  message: Utils.getString(
                      context, 'transaction_detail__copy'),
                  child: Text(
                    Utils.getString(
                        context, 'transaction_detail__copied_data'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.orange),
                  ),
                  showDuration: const Duration(seconds: 5),
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}

class _TransactionTextWidget extends StatelessWidget {
  const _TransactionTextWidget({
    Key key,
    @required this.transaction,
    @required this.transactionID,
  }) : super(key: key);

  final TransactionHeader transaction;
  final DocumentSnapshot transactionID;
  @override
  Widget build(BuildContext context) {
    const EdgeInsets _paddingEdgeInsetWidget = EdgeInsets.only(
      left: ps_space_16,
      right: ps_space_16,
      top: ps_space_8,
    );
    final Widget _productTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'Product Name :'),
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          ' ${transactionID['ProductName']}' ?? '-',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: ps_ctheme__color_speical,
              fontWeight: FontWeight.normal),
        )
      ],
    );
    final Widget _refeTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'Reference No :'),
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          ' ${transactionID['Reference']}' ?? '-',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: ps_ctheme__color_speical,
              fontWeight: FontWeight.normal),
        )
      ],
    );
    final Widget _timeTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'Buy Time:'),
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          DateFormat('y-MM-EEEE-d  hh:mm:ss')
                  .format(transactionID['timestamp'].toDate())
                  .toString() ??
              '-',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: ps_ctheme__color_speical,
              fontWeight: FontWeight.normal),
        )
      ],
    );
    final Widget _totalAmountTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'transaction_list__total_amount'),
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          ' ${transactionID['price']}' ?? '-',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: ps_ctheme__color_speical,
              fontWeight: FontWeight.normal),
        )
      ],
    );
    final Widget _catergoryTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'Category :'),
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          ' ${transactionID['category']}' ?? '-',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: ps_ctheme__color_speical,
              fontWeight: FontWeight.normal),
        )
      ],
    );
    final Widget _statusTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'transaction_detail__status'),
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          transactionID['status'] ?? '-',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.normal),
        )
      ],
    );

    final Widget _viewDetailTextWidget = Text(
      Utils.getString(context, 'transaction_detail__view_details'),
      style: Theme.of(context).textTheme.bodyText1.copyWith(
          color: ps_ctheme__color_application,
          fontWeight: FontWeight.normal),
      // textAlign: TextAlign.left,
    );
    if (transactionID != null && transactionID.data != null) {
      return Column(
        children: <Widget>[
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _productTextWidget),
          ),Padding(
            padding: _paddingEdgeInsetWidget,
            child: _catergoryTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _refeTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _totalAmountTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _statusTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _timeTextWidget,
          ),
          // Padding(
          //   padding: _paddingEdgeInsetWidget,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: <Widget>[
          //       _viewDetailTextWidget,
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: ps_space_8,
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
