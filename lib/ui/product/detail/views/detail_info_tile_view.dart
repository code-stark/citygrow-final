import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/provider/product/product_provider.dart';
import 'package:digitalproductstore/ui/common/ps_expansion_tile.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/material.dart';

class DetailInfoTileView extends StatelessWidget {
  const DetailInfoTileView({
    Key key,
    @required this.productDetail,
  }) : super(key: key);

  final ProductDetailProvider productDetail;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'detail_info_tile__detail_info'),
        style: Theme.of(context).textTheme.subtitle1);
    if (productDetail != null &&
        productDetail.productDetail != null &&
        productDetail.productDetail.data != null) {
      return Card(
        elevation: 0.0,
        child: PsExpansionTile(
          initiallyExpanded: true,
          title: _expansionTileTitleWidget,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: ps_space_16, left: ps_space_16, right: ps_space_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'detail_info_tile__product_name'),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: ps_space_12, left: ps_space_12),
                    child: Text(
                      productDetail.productDetail.data.name ?? '',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
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
