import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_expansion_tile.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/material.dart';

class DescriptionTileView extends StatelessWidget {
  const DescriptionTileView({
    Key key,
    @required this.productDetail,
    @required this.productDescription,
  }) : super(key: key);
  final DocumentSnapshot productDescription;
  final Product productDetail;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'description_tile__product_description'),
        style: Theme.of(context).textTheme.subhead);
    if (productDescription != null &&
        productDescription['Product Description'] != null) {
      return Container(
        child: PsExpansionTile(
          initiallyExpanded: true,
          title: _expansionTileTitleWidget,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: ps_space_16, left: ps_space_16, right: ps_space_16),
              child: Text(
                productDescription['Product Description'] ?? '',
                style: Theme.of(context).textTheme.body1.copyWith(
                      height: 1.3,
                      letterSpacing: 0.5,
                    ),
              ),
            )
          ],
        ),
      );
    } else {
      return const Card();
    }
  }
}
