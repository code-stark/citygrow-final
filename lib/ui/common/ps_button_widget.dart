import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:flutter/material.dart';

class PSButtonWidget extends StatelessWidget {
  const PSButtonWidget({
    this.onPressed,
    this.titleText = '',
    this.colorData = ps_ctheme__color_speical,
    this.width,
    this.icon,
  });

  final Function onPressed;
  final String titleText;
  final Color colorData;
  final double width;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white),
            const SizedBox(width: ps_space_8),
            Text(
              titleText,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
        color: Colors.yellow,
        onPressed: onPressed());
  }
}
