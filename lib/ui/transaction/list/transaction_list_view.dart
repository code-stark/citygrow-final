import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/model/user_model.dart';
import 'package:digitalproductstore/provider/transaction/transaction_header_provider.dart';
import 'package:digitalproductstore/repository/transaction_header_repository.dart';
import 'package:digitalproductstore/ui/transaction/item/transaction_list_item.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';

class TransactionListView extends StatefulWidget {
  const TransactionListView(
      {Key key,
      @required this.animationController,
      @required this.scaffoldKey})
      : super(key: key);
  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _TransactionListViewState createState() =>
      _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  TransactionHeaderProvider _transactionProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _transactionProvider.nextTransactionList();
      }
    });

    super.initState();
  }

  TransactionHeaderRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<TransactionHeaderRepository>(context);
    data = EasyLocalizationProvider.of(context).data;
    psValueHolder = Provider.of<PsValueHolder>(context);
    final Users users = Provider.of<Users>(context);

    print(
        '............................Build UI Again ............................');
    return EasyLocalizationProvider(
      // key: widget.scaffoldKey,
      data: data,
      child: ChangeNotifierProvider<TransactionHeaderProvider>(
        create: (BuildContext context) {
          final TransactionHeaderProvider provider =
              TransactionHeaderProvider(
                  repo: repo1, psValueHolder: psValueHolder);
          provider.loadTransactionList(psValueHolder.loginUserId);
          _transactionProvider = provider;
          return _transactionProvider;
        },
        child: Consumer<TransactionHeaderProvider>(builder:
            (BuildContext context, TransactionHeaderProvider provider,
                Widget child) {
          return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('AppUsers')
                  .document(users.uid)
                  .collection('order')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.documents != null &&
                    snapshot.data.documents.isNotEmpty) {
                  return Stack(
                    children: <Widget>[
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
                                  SliverList(
                                    delegate:
                                        SliverChildBuilderDelegate(
                                      (BuildContext context,
                                          int index) {
                                        final int count = snapshot
                                            .data.documents.length;
                                        return TransactionListItem(
                                          transactionList: snapshot
                                              .data.documents[index],
                                          scaffoldKey:
                                              widget.scaffoldKey,
                                          animationController: widget
                                              .animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0,
                                                  end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent: widget
                                                  .animationController,
                                              curve: Interval(
                                                  (1 / count) * index,
                                                  1.0,
                                                  curve: Curves
                                                      .fastOutSlowIn),
                                            ),
                                          ),
                                          // transaction: provider
                                          //     .transactionList
                                          // .data[index],
                                          // onTap: () {
                                          //   Navigator.pushNamed(
                                          //       context,
                                          //       RoutePaths
                                          //           .transactionDetail,
                                          //       arguments: snapshot
                                          //               .data
                                          //               .documents[
                                          //           index]);
                                          // },
                                        );
                                      },
                                      childCount: snapshot
                                          .data.documents.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              return provider.resetTransactionList();
                            },
                          )),
                      PSProgressIndicator(
                          provider.transactionList.status)
                    ],
                  );
                } else {
                  return Container();
                }
              });
        }),
      ),
    );
  }
}
