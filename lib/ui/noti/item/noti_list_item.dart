import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/viewobject/noti.dart';

class NotiListItem extends StatelessWidget {
  const NotiListItem({
    Key key,
    @required this.noti,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final Noti noti;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    //print("$ps_app_image_thumbs_url${noti.defaultPhoto.imgPath}");
    // print('Noti is read value ${noti.isRead}');
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
                      horizontal: ps_space_16, vertical: ps_space_4),
                  child: Container(
                    color: Utils.isLightMode(context)
                        ? noti.isRead != ONE ? null : Colors.grey[200]
                        : noti.isRead != ONE ? Colors.grey[700] : null,
                    padding: const EdgeInsets.all(ps_space_16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(
                          width: ps_space_4,
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              PsNetworkImage(
                                photoKey: '',
                                defaultPhoto: noti.defaultPhoto,
                                width: ps_space_64,
                                height: ps_space_64,
                                onTap: onTap,
                              ),
                              const SizedBox(
                                width: ps_space_12,
                              ),
                              Expanded(
                                child: Text(noti.title,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .copyWith(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        Text(noti.addedDateStr,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
