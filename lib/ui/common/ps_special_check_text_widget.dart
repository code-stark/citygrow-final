import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/provider/product/search_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpecialCheckTextWidget extends StatefulWidget {
  const SpecialCheckTextWidget({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.checkTitle,
    this.size = ps_space_20,
    @required this.booleanls,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final int checkTitle;
  final double size;
  final Function booleanls;

  @override
  _SpecialCheckTextWidgetState createState() =>
      _SpecialCheckTextWidgetState();
}

class _SpecialCheckTextWidgetState
    extends State<SpecialCheckTextWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchProductProvider provider =
        Provider.of<SearchProductProvider>(context);

    return Container(
        width: double.infinity,
        height: ps_space_52,
        decoration: const BoxDecoration(
            // color: Colors.white,
            ),
        child: Container(
          margin: const EdgeInsets.all(ps_space_12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      width: widget.size < ps_space_20
                          ? ps_space_20
                          : widget.size,
                      child: Icon(
                        widget.icon,
                        size: widget.size,
                        // color: ps_wtheme_icon_color,
                      )),
                  const SizedBox(
                    width: ps_space_12,
                  ),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              if (widget.checkTitle == 1)
                Switch(
                  value: provider.isSwitchedFeaturedProduct,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedFeaturedProduct = value;
                    });
                  },
                  activeTrackColor: ps_ctheme__color_speical,
                  activeColor: ps_ctheme__color_speical,
                )
              else if (widget.checkTitle == 2)
                Switch(
                  value: provider.isSwitchedDiscountPrice,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedDiscountPrice = value;
                    });
                  },
                  activeTrackColor: ps_ctheme__color_speical,
                  activeColor: ps_ctheme__color_speical,
                )
              else
                Switch(
                  value: provider.isSwitchedFreeProduct,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedFreeProduct = value;
                    });
                  },
                  activeTrackColor: ps_ctheme__color_speical,
                  activeColor: ps_ctheme__color_speical,
                )
            ],
          ),
        ));
  }
}
