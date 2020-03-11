import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/product/product_provider.dart';
import 'package:digitalproductstore/provider/product/related_product_provider.dart';
import 'package:digitalproductstore/ui/common/ps_expansion_tile.dart';
import 'package:digitalproductstore/ui/product/item/product_horizontal_list_item.dart';
import 'package:digitalproductstore/ui/product/item/related_tags_horizontal_list_item.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:digitalproductstore/viewobject/holder/product_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/holder/tag_object_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RelatedProductsTileView extends StatefulWidget {
  const RelatedProductsTileView({
    Key key,
    @required this.productDetail,
  }) : super(key: key);

  final ProductDetailProvider productDetail;

  @override
  _RelatedProductsTileViewState createState() =>
      _RelatedProductsTileViewState();
}

class _RelatedProductsTileViewState extends State<RelatedProductsTileView> {
  // ProductRepository repo1;
  // RelatedProductProvider provider;

  @override
  Widget build(BuildContext context) {
    // repo1 = Provider.of<ProductRepository>(context);

    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'related_product_tile__related_product'),
        style: Theme.of(context).textTheme.subhead.copyWith());

    // final List<String> tags =
    //     widget.productDetail.productDetail.data.searchTag.split(',');

    // final List<TagParameterHolder> tagObjectList = <TagParameterHolder>[
    //   TagParameterHolder(
    //       fieldName: CONST_CATEGORY,
    //       tagId: widget.productDetail.productDetail.data.category.id,
    //       tagName: widget.productDetail.productDetail.data.category.name),
    //   TagParameterHolder(
    //       fieldName: CONST_SUB_CATEGORY,
    //       tagId: widget.productDetail.productDetail.data.subCategory.id,
    //       tagName: widget.productDetail.productDetail.data.subCategory.name),
    //   for (String tag in tags)
    //     if (tag != null && tag != '')
    //       TagParameterHolder(
    //           fieldName: CONST_PRODUCT, tagId: tag, tagName: tag),
    // ];

    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.only(
          bottom: ps_space_20,
          left: ps_space_4,
          right: ps_space_4,
          top: ps_space_4),
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
                  Utils.getString(context, 'related_product_tile__related_tag'),
                  style: Theme.of(context).textTheme.body2,
                ),
                const SizedBox(
                  height: ps_space_12,
                ),
                // _RelatedTagsWidget(
                //   tagObjectList: tagObjectList,
                //   productDetailProvider: widget.productDetail,
                // ),
                const SizedBox(
                  height: ps_space_12,
                ),
                const _RelatedProductWidget(
                    // productDetail: widget.productDetail,
                    //provider: RelatedProductProvider(repo: repo1),
                    )
              ],
            ),
          )
        ],
        onExpansionChanged: (bool expanding) {
          // setState(() => repo1 = Provider.of<ProductRepository>(context));
        },
      ),
    );
  }
}

class _RelatedTagsWidget extends StatelessWidget {
  const _RelatedTagsWidget({
    Key key,
    @required this.tagObjectList,
    @required this.productDetailProvider,
  }) : super(key: key);

  final List<TagParameterHolder> tagObjectList;
  final ProductDetailProvider productDetailProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ps_space_40,
      child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          slivers: <Widget>[
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                if (tagObjectList != null) {
                  return RelatedTagsHorizontalListItem(
                    tagParameterHolder: tagObjectList[index],
                    onTap: () async {
                      final ProductParameterHolder productParameterHolder =
                          ProductParameterHolder().resetParameterHolder();

                      if (index == 0) {
                        productParameterHolder.catId =
                            productDetailProvider.productDetail.data.catId;
                      } else if (index == 1) {
                        productParameterHolder.catId =
                            productDetailProvider.productDetail.data.catId;
                        productParameterHolder.subCatId =
                            productDetailProvider.productDetail.data.subCatId;
                      } else {
                        productParameterHolder.searchTerm =
                            tagObjectList[index].tagName;
                      }
                      print('productParameterHolder.catId ' +
                          productParameterHolder.catId +
                          'productParameterHolder.subCatId ' +
                          productParameterHolder.subCatId +
                          'productParameterHolder.searchTerm ' +
                          productParameterHolder.searchTerm);
                      Navigator.pushNamed(context, RoutePaths.filterProductList,
                          arguments: ProductListIntentHolder(
                            appBarTitle: tagObjectList[index].tagName,
                            productParameterHolder: productParameterHolder,
                          ));
                    },
                  );
                } else {
                  return null;
                }
              }, childCount: tagObjectList.length),
            ),
          ]),
    );
  }
}

class _RelatedProductWidget extends StatelessWidget {
  const _RelatedProductWidget({
    Key key,
    // @required this.productDetail,
    // @required this.provider,
  }) : super(key: key);

  // final ProductDetailProvider productDetail;
  // final RelatedProductProvider provider;
  @override
  Widget build(BuildContext context) {
    return
        // ChangeNotifierProvider<RelatedProductProvider>(
        //   create: (BuildContext context) {
        //     provider.loadRelatedProductList(productDetail.productDetail.data.id,
        //         productDetail.productDetail.data.catId);
        //     return provider;
        //   },
        //   child:
        Consumer<RelatedProductProvider>(
      builder: (BuildContext context, RelatedProductProvider provider,
          Widget child) {
        return Container(
          height: ps_space_300,
          child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (provider.relatedProductList.data != null ||
                          provider.relatedProductList.data.isNotEmpty) {
                        return ProductHorizontalListItem(
                          product: provider.relatedProductList.data[index],
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutePaths.productDetail,
                                arguments:
                                    provider.relatedProductList.data[index]);
                          },
                        );
                      } else {
                        return null;
                      }
                    },
                    childCount: provider.relatedProductList.data.length,
                  ),
                ),
              ]),
        );
      },
      // ),
    );
  }
}
