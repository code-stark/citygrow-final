import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/history/history_provider.dart';
import 'package:digitalproductstore/repository/history_repsitory.dart';
import 'package:digitalproductstore/ui/history/item/history_list_item.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _HistoryListViewState createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView>
    with SingleTickerProviderStateMixin {
  HistoryRepository historyRepo;
  dynamic data;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    data = EasyLocalizationProvider.of(context).data;
    historyRepo = Provider.of<HistoryRepository>(context);
    return EasyLocalizationProvider(
        data: data,
        child: ChangeNotifierProvider<HistoryProvider>(
            create: (BuildContext context) {
          final HistoryProvider provider = HistoryProvider(
            repo: historyRepo,
          );
          provider.loadHistoryList();
          return provider;
        }, child: Consumer<HistoryProvider>(
          builder:
              (BuildContext context, HistoryProvider provider, Widget child) {
            if (provider.historyList != null &&
                provider.historyList.data != null) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: ps_space_10),
                      child: CustomScrollView(slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final int count =
                                  provider.historyList.data.length;
                              return HistoryListItem(
                                animationController: widget.animationController,
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: widget.animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                                history: provider.historyList.data.reversed
                                    .toList()[index],
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: provider
                                          .historyList.data.reversed
                                          .toList()[index]);
                                },
                              );
                            },
                            childCount: provider.historyList.data.length,
                          ),
                        )
                      ]),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        )));
  }
}
