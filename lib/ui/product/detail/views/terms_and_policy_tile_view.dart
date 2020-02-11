import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/ui/common/ps_expansion_tile.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/material.dart';

class TermsAndPolicyTileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'terms_and_policy_tile__terms_and_policy'),
        style: Theme.of(context).textTheme.subhead);

    return Card(
      elevation: 0.0,
      child: PsExpansionTile(
        initiallyExpanded: true,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RoutePaths.privacyPolicy,
                      arguments: 2);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: ps_space_16,
                      left: ps_space_16,
                      right: ps_space_16,
                      bottom: ps_space_16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        Utils.getString(context,
                            'terms_and_policy_tile__terms_and_condition'),
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: ps_ctheme__color_speical),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutePaths.privacyPolicy,
                                arguments: 2);
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: ps_space_16,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RoutePaths.privacyPolicy,
                      arguments: 3);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: ps_space_16,
                      left: ps_space_16,
                      right: ps_space_16,
                      bottom: ps_space_16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        Utils.getString(
                            context, 'terms_and_policy_tile__refund_policy'),
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: ps_ctheme__color_speical),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutePaths.privacyPolicy,
                                arguments: 3);
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: ps_space_16,
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
