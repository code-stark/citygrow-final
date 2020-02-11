import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/productcollection/product_collection_provider.dart';
import 'package:digitalproductstore/ui/common/ps_frame_loading_widget.dart';
import 'package:digitalproductstore/ui/product/item/product_horizontal_list_item.dart';
import 'package:digitalproductstore/viewobject/product_collection_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductCollectionHorizontalListView extends StatelessWidget {
  const ProductCollectionHorizontalListView({
    Key key,
    @required this.product,
    this.onTap,
  }) : super(key: key);

  final ProductCollectionHeader product;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductCollectionProvider>(builder: (BuildContext context,
        ProductCollectionProvider productProvider, Widget child) {
      return Container(
          height: ps_space_300,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: product.productList.length,
              itemBuilder: (BuildContext context, int index) {
                if (productProvider.productCollectionList.status ==
                    PsStatus.BLOCK_LOADING) {
                  return Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.white,
                      child: Row(children: const <Widget>[
                        PsFrameUIForLoading(),
                      ]));
                } else {
                  return ProductHorizontalListItem(
                    product: product.productList[index],
                    onTap: () {
                      Navigator.pushNamed(context, RoutePaths.productDetail,
                          arguments: product.productList[index]);
                    },
                  );
                }
              }));
    });
  }
}
