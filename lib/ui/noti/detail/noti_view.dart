import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/provider/noti/noti_provider.dart';
import 'package:digitalproductstore/repository/noti_repository.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_appbar.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/noti_post_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/noti.dart';
import 'package:provider/provider.dart';

class NotiView extends StatefulWidget {
  const NotiView({this.noti});
  final Noti noti;

  @override
  _NotiViewState createState() => _NotiViewState();
}

NotiRepository notiRepository;
NotiProvider notiProvider;
PsValueHolder _psValueHolder;
AnimationController animationController;

class _NotiViewState extends State<NotiView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    animationController =
        AnimationController(duration: animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notiRepository = Provider.of<NotiRepository>(context);
    _psValueHolder = Provider.of<PsValueHolder>(context);

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

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBar<NotiProvider>(
            appBarTitle: Utils.getString(context, 'noti__toolbar_name') ?? '',
            initProvider: () {
              return NotiProvider(
                  repo: notiRepository, psValueHolder: _psValueHolder);
            },
            onProviderReady: (NotiProvider provider) {
              if (provider.psValueHolder.loginUserId != null &&
                  provider.psValueHolder.loginUserId != '' &&
                  provider.psValueHolder.deviceToken != null &&
                  provider.psValueHolder.deviceToken != '') {
                final NotiPostParameterHolder notiPostParameterHolder =
                    NotiPostParameterHolder(
                        notiId: widget.noti.id,
                        userId: provider.psValueHolder.loginUserId,
                        deviceToken: provider.psValueHolder.deviceToken);
                provider.postNoti(notiPostParameterHolder.toMap());
              }
              notiProvider = provider;
            },
            builder:
                (BuildContext context, NotiProvider provider, Widget child) {
              if (widget.noti != null) {
                return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: <Widget>[
                      PsNetworkImage(
                        photoKey: '',
                        defaultPhoto: widget.noti.defaultPhoto,
                        width: double.infinity,
                        height: 250,
                        onTap: () {
                          Utils.psPrint(widget.noti.defaultPhoto.imgParentId);
                        },
                      ),
                      const SizedBox(
                        height: ps_space_12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const SizedBox(
                            width: ps_space_16,
                          ),
                          Text(
                            widget.noti.addedDate,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          const SizedBox(
                            width: ps_space_16,
                          ),
                        ],
                      ),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(ps_space_16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Text(widget.noti.title,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(
                                height: ps_space_12,
                              ),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  widget.noti.message ?? '',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(height: 1.5),
                                ),
                              ),
                            ],
                          )),
                    ]));
              } else {
                return Container();
              }
            }));
  }
}
