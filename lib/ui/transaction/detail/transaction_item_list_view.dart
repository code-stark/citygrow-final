import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/provider/transaction/transaction_detail_provider.dart';
import 'package:digitalproductstore/repository/tansaction_detail_repository.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/ui/transaction/detail/transaction_item_view.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/transaction_header.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TransactionItemListView extends StatefulWidget {
  const TransactionItemListView({
    Key key,
    @required this.transaction,
    @required this.transactionList,
  }) : super(key: key);

  final TransactionHeader transaction;
  final DocumentSnapshot transactionList;

  @override
  _TransactionItemListViewState createState() =>
      _TransactionItemListViewState();
}

class _TransactionItemListViewState
    extends State<TransactionItemListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  TransactionDetailRepository repo1;
  TransactionDetailProvider _transactionDetailProvider;
  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // _transactionDetailProvider
        //     .nextTransactionDetailList(widget.transaction);
      }
    });

    animationController = AnimationController(
        duration: animation_duration, vsync: this);

    super.initState();
  }

  dynamic data;
  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    final GlobalKey<ScaffoldState> scaffoldKey =
        GlobalKey<ScaffoldState>();
    data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<TransactionDetailRepository>(context);
    return WillPopScope(
        onWillPop: _requestPop,
        child: EasyLocalizationProvider(
            data: data,
            child: ChangeNotifierProvider<TransactionDetailProvider>(
              create: (BuildContext context) {
                // final TransactionDetailProvider provider =
                //     TransactionDetailProvider(repo: repo1);
                // provider
                //     .loadTransactionDetailList(widget.transaction);
                // _transactionDetailProvider = provider;
                // return provider;
              },
              child: Consumer<TransactionDetailProvider>(builder:
                  (BuildContext context,
                      TransactionDetailProvider provider,
                      Widget child) {
                return Scaffold(
                  key: scaffoldKey,
                  appBar: AppBar(
                    brightness: Utils.getBrightnessForAppBar(context),
                    iconTheme: Theme.of(context).iconTheme,
                    title: Text(
                      Utils.getString(
                          context, 'transaction_detail__title'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    elevation: 0,
                  ),
                  body: Stack(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                            left: ps_space_16,
                            right: ps_space_16,
                            top: ps_space_8,
                            bottom: ps_space_8),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverToBoxAdapter(
                                  child: _TransactionNoWidget(
                                      transactionList:
                                          widget.transactionList,
                                      transaction: widget.transaction,
                                      scaffoldKey: scaffoldKey),
                                ),
                                SliverList(
                                  delegate:
                                      SliverChildBuilderDelegate(
                                    (BuildContext context,
                                        int index) {
                                      if (widget.transactionList
                                                  .data !=
                                              null ||
                                          widget.transactionList.data
                                              .isNotEmpty) {
                                        final int count = widget
                                            .transactionList
                                            .data
                                            .length;
                                        return TransactionItemView(
                                          transactionList:
                                              widget.transactionList,
                                          animationController:
                                              animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0,
                                                  end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent:
                                                  animationController,
                                              curve: Interval(
                                                  (1 / count) * index,
                                                  1.0,
                                                  curve: Curves
                                                      .fastOutSlowIn),
                                            ),
                                          ),
                                          // transaction: provider
                                          //     .transactionDetailList
                                          //     .data[index],
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount: widget
                                        .transactionList.data.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return provider
                                .resetTransactionDetailList(
                                    widget.transaction);
                          },
                        )),
                    // PSProgressIndicator(
                    //     // provider.transactionDetailList.status
                    //     )
                  ]),
                );
              }),
            )));
  }
}

class _TransactionNoWidget extends StatelessWidget {
  const _TransactionNoWidget({
    Key key,
    @required this.transaction,
    this.scaffoldKey,
    @required this.transactionList,
  }) : super(key: key);
  final DocumentSnapshot transactionList;
  final TransactionHeader transaction;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    //  final BasketProvider basketProvider = Provider.of<BasketProvider>(context);

    // basketProvider.checkoutCalculationHelper.calculate(
    //     productList: productList,
    //     couponDiscountString: couponDiscount,
    //     psValueHolder: psValueHolder);

    const Widget _dividerWidget = Divider(
      height: ps_space_2,
      color: Colors.grey,
    );
    final Widget _contentCopyIconWidget = IconButton(
      iconSize: ps_space_20,
      icon: Icon(
        Icons.content_copy,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: transaction.transCode));
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Tooltip(
            message:
                Utils.getString(context, 'transaction_detail__copy'),
            child: Text(
              Utils.getString(
                  context, 'transaction_detail__copied_data'),
              style: Theme.of(context).textTheme.title.copyWith(
                    color: Colors.orange,
                  ),
            ),
            showDuration: const Duration(seconds: 5),
          ),
        ));
      },
    );
    return Card(
        elevation: 0.3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.settings_backup_restore,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(
                          width: ps_space_12,
                        ),
                        // Expanded(
                        //   child: Text(
                        //     '${Utils.getString(context, 'transaction_detail__trans_no')} : ${transaction.transCode}',
                        //     textAlign: TextAlign.left,
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .title
                        //         .copyWith(
                        //             fontSize: ps_space_16,
                        //             fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  _contentCopyIconWidget,
                ],
              ),
            ),
            _dividerWidget,
            _TransactionNoTextWidget(
              transationInfoText:
                  transactionList.data.length.toString(),
              title:
                  '${Utils.getString(context, 'transaction_detail__total_item_count')} :',
            ),
            // _TransactionNoTextWidget(
            //   transationInfoText:
            //       '${Utils.getPriceFormat(transaction.totalItemAmount)}',
            //   title:
            //       '${Utils.getString(context, 'transaction_detail__total_item_price')} :',
            // ),
            // _TransactionNoTextWidget(
            //   transationInfoText:
            //       '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.discountAmount)}',
            //   title:
            //       '${Utils.getString(context, 'transaction_detail__discount')} :',
            // ),
            // _TransactionNoTextWidget(
            //   transationInfoText:
            //       '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.cuponDiscountAmount)}',
            //   title:
            //       '${Utils.getString(context, 'transaction_detail__coupon_discount')} :',
            // ),
            const SizedBox(
              height: ps_space_12,
            ),
            _dividerWidget,
            // _TransactionNoTextWidget(
            //   transationInfoText:
            //       '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.subTotalAmount)}',
            //   title:
            //       '${Utils.getString(context, 'transaction_detail__sub_total')} :',
            // ),
            // _TransactionNoTextWidget(
            //   transationInfoText:
            //       '${transaction.currencySymbol} ${transaction.taxAmount}',
            //   title:
            //       '${Utils.getString(context, 'transaction_detail__tax')}(${transaction.taxPercent} %) :',
            // ),
            const SizedBox(
              height: ps_space_12,
            ),
            _dividerWidget,
            // _TransactionNoTextWidget(
            //   transationInfoText:
            //       '${transaction.currencySymbol} ${transaction.balanceAmount}',
            //   title:
            //       '${Utils.getString(context, 'transaction_detail__total')} :',
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
          left: ps_space_12, right: ps_space_12, top: ps_space_12),
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
