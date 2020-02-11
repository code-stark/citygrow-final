import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/utils/utils.dart';
// import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/material.dart';

class CheckoutSuccessView extends StatelessWidget {
  final Widget _imageWidget = Container(
    width: 90,
    height: 90,
    child: Image.asset(
      'assets/images/digital_product_logo_white.png',
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Utils.isLightMode(context) ? Colors.white : Colors.black54,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: ps_space_80,
            ),
            _imageWidget,
            const SizedBox(
              height: ps_space_16,
            ),
            Text(
              Utils.getString(context, 'checkout_success__title'),
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(color: Colors.deepOrange),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(
                  height: ps_space_32,
                ),
                Text(
                    Utils.getString(context, 'checkout_success__thank_message'),
                    style: Theme.of(context).textTheme.title),
                const SizedBox(
                  height: ps_space_8,
                ),
                Text(
                  Utils.getString(context, 'checkout_success__description'),
                  style: Theme.of(context).textTheme.body1,
                ),
                const SizedBox(
                  height: ps_space_32,
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      left: ps_space_12, right: ps_space_12),
                  child: MaterialButton(
                    color: ps_ctheme__color_speical,
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    child: Text(
                      Utils.getString(
                          context, 'checkout_success__pruchased_button_name'),
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RoutePaths.purchasedProduct,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: ps_space_8,
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  margin: const EdgeInsets.only(
                      left: ps_space_12, right: ps_space_12),
                  child: MaterialButton(
                    color: ps_ctheme__color_speical,
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    child: Text(
                      Utils.getString(
                          context, 'checkout_success__continue_shopping'),
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
