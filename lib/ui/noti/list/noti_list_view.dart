import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_appbar.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/noti_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/noti/noti_provider.dart';
import 'package:digitalproductstore/repository/noti_repository.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/viewobject/category.dart';
import '../item/noti_list_item.dart';

class NotiListView extends StatefulWidget {
  const NotiListView({this.category});
  final Category category;
  @override
  _NotiListViewState createState() {
    return _NotiListViewState();
  }
}

class _NotiListViewState extends State<NotiListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  NotiProvider _notiProvider;

  AnimationController animationController;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        utilsCheckUserLoginId(psValueHolder).then((String loginUserId) async {
          final GetNotiParameterHolder getNotiParameterHolder =
              GetNotiParameterHolder(
            userId: _notiProvider.psValueHolder.loginUserId,
            deviceToken: _notiProvider.psValueHolder.deviceToken,
          );
          _notiProvider.nextNotiList(getNotiParameterHolder.toMap());
        });
      }
    });
  }

  // final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
  //     .animate(CurvedAnimation(
  //         parent: animationController,
  //         curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

  NotiRepository repo1;
  PsValueHolder psValueHolder;
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

    timeDilation = 1.0;
    repo1 = Provider.of<NotiRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<NotiProvider>(
          appBarTitle:
              Utils.getString(context, 'noti_list__toolbar_name') ?? '',
          initProvider: () {
            return NotiProvider(repo: repo1, psValueHolder: psValueHolder);
          },
          onProviderReady: (NotiProvider provider) {
            utilsCheckUserLoginId(psValueHolder)
                .then((String loginUserId) async {
              final GetNotiParameterHolder getNotiParameterHolder =
                  GetNotiParameterHolder(
                userId: provider.psValueHolder.loginUserId,
                deviceToken: provider.psValueHolder.deviceToken,
              );
              provider.getNotiList(getNotiParameterHolder.toMap());
            });

            _notiProvider = provider;
          },
          builder: (BuildContext context, NotiProvider provider, Widget child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: provider.notiList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final int count = provider.notiList.data.length;
                      return NotiListItem(
                        animationController: animationController,
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animationController,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn),
                          ),
                        ),
                        noti: provider.notiList.data[index],
                        onTap: () async {
                          print(provider
                              .notiList.data[index].defaultPhoto.imgPath);

                          final dynamic retrunData = await Navigator.pushNamed(
                            context,
                            RoutePaths.noti,
                            arguments: provider.notiList.data[index],
                          );
                          if (retrunData != null && retrunData) {
                            utilsCheckUserLoginId(psValueHolder)
                                .then((String loginUserId) async {
                              final GetNotiParameterHolder
                                  getNotiParameterHolder =
                                  GetNotiParameterHolder(
                                userId: provider.psValueHolder.loginUserId,
                                deviceToken: provider.psValueHolder.deviceToken,
                              );
                              return _notiProvider.resetNotiList(
                                  getNotiParameterHolder.toMap());
                            });
                          }
                          if (retrunData != null && retrunData) {
                            print('Return data ');
                          } else {
                            print('Return datafalse ');
                          }
                        },
                      );
                    }),
                onRefresh: () async {
                  final GetNotiParameterHolder getNotiParameterHolder =
                      GetNotiParameterHolder(
                    userId: provider.psValueHolder.loginUserId,
                    deviceToken: provider.psValueHolder.deviceToken,
                  );

                  return _notiProvider
                      .resetNotiList(getNotiParameterHolder.toMap());
                },
              )),
              PSProgressIndicator(provider.notiList.status)
            ]);
          }),
    );
  }
}
