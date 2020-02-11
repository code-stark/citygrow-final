import 'package:flutter/material.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/viewobject/common/language.dart';

class LanguageListItem extends StatelessWidget {
  const LanguageListItem({
    Key key,
    @required this.language,
    @required this.animation,
    @required this.animationController,
    this.onTap,
  }) : super(key: key);

  final Language language;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

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
                child: Card(
                  elevation: 0.3,
                  margin: const EdgeInsets.symmetric(
                      horizontal: ps_space_16, vertical: ps_space_4),
                  child: Container(
                    padding: const EdgeInsets.all(ps_space_16),
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: ps_space_4,
                        ),
                        Icon(Icons.language),
                        const SizedBox(
                          width: ps_space_12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: ps_space_4,
                            ),
                            Text(
                              language.name,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: ps_space_4,
                            ),
                            Text(
                                '${language.languageCode}_${language.countryCode}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(
                              height: ps_space_4,
                            ),
                          ],
                        )
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
