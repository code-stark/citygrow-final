import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/provider/product/search_product_provider.dart';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_appbar.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemSortingView extends StatefulWidget {
  const ItemSortingView({@required this.productParameterHolder});

  final ProductParameterHolder productParameterHolder;

  @override
  _ItemSortingViewState createState() => _ItemSortingViewState();
}

class _ItemSortingViewState extends State<ItemSortingView> {
  ProductRepository repo1;
  SearchProductProvider _searchProductProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<ProductRepository>(context);

    return PsWidgetWithAppBar<SearchProductProvider>(
      appBarTitle:
          Utils.getString(context, 'item_filter__filtered_by_product_type') ??
              '',
      initProvider: () {
        return SearchProductProvider(repo: repo1);
      },
      onProviderReady: (SearchProductProvider provider) {
        _searchProductProvider = provider;
        _searchProductProvider.productParameterHolder =
            widget.productParameterHolder;
      },
      builder:
          (BuildContext context, SearchProductProvider provider, Widget child) {
        return Column(
          children: <Widget>[
            GestureDetector(
              child: SortingView(
                  image: 'assets/images/baesline_access_time_black_24.png',
                  titleText: Utils.getString(context, 'item_filter__latest'),
                  checkImage:
                      _searchProductProvider.productParameterHolder.orderBy ==
                              FILTERING__ADDED_DATE
                          ? 'assets/images/baseline_check_green_24.png'
                          : ''),
              onTap: () {
                print('sort by latest product');
                _searchProductProvider.productParameterHolder.orderBy =
                    FILTERING__ADDED_DATE;
                _searchProductProvider.productParameterHolder.orderType =
                    FILTERING__DESC;

                Navigator.pop(
                    context, _searchProductProvider.productParameterHolder);
              },
            ),
            const Divider(
              height: ps_space_1,
            ),
            GestureDetector(
              child: SortingView(
                  image: 'assets/images/baseline_graph_black_24.png',
                  titleText: Utils.getString(context, 'item_filter__popular'),
                  checkImage:
                      _searchProductProvider.productParameterHolder.orderBy ==
                              FILTERING__TRENDING
                          ? 'assets/images/baseline_check_green_24.png'
                          : ''),
              onTap: () {
                print('sort by popular product');
                _searchProductProvider.productParameterHolder.orderBy =
                    FILTERING_TRENDING;
                _searchProductProvider.productParameterHolder.orderType =
                    FILTERING__DESC;

                Navigator.pop(
                    context, _searchProductProvider.productParameterHolder);
              },
            ),
            const Divider(
              height: ps_space_1,
            ),
            GestureDetector(
              child: SortingView(
                  image: 'assets/images/baseline_price_down_black_24.png',
                  titleText:
                      Utils.getString(context, 'item_filter__lowest_price'),
                  checkImage:
                      _searchProductProvider.productParameterHolder.orderBy ==
                                  FILTERING_PRICE &&
                              _searchProductProvider
                                      .productParameterHolder.orderType ==
                                  FILTERING__ASC
                          ? 'assets/images/baseline_check_green_24.png'
                          : ''),
              onTap: () {
                print('sort by lowest price');
                _searchProductProvider.productParameterHolder.orderBy =
                    FILTERING_PRICE;
                _searchProductProvider.productParameterHolder.orderType =
                    FILTERING__ASC;

                Navigator.pop(
                    context, _searchProductProvider.productParameterHolder);
              },
            ),
            const Divider(
              height: ps_space_1,
            ),
            GestureDetector(
              child: SortingView(
                  image: 'assets/images/baseline_price_up_black_24.png',
                  titleText:
                      Utils.getString(context, 'item_filter__highest_price'),
                  checkImage:
                      _searchProductProvider.productParameterHolder.orderBy ==
                                  FILTERING_PRICE &&
                              _searchProductProvider
                                      .productParameterHolder.orderType ==
                                  FILTERING__DESC
                          ? 'assets/images/baseline_check_green_24.png'
                          : ''),
              onTap: () {
                print('sort by highest price ');
                _searchProductProvider.productParameterHolder.orderBy =
                    FILTERING_PRICE;
                _searchProductProvider.productParameterHolder.orderType =
                    FILTERING__DESC;

                Navigator.pop(
                    context, _searchProductProvider.productParameterHolder);
              },
            ),
            const Divider(
              height: ps_space_1,
            ),
          ],
        );
      },
    );
  }
}

class SortingView extends StatefulWidget {
  const SortingView(
      {@required this.image,
      @required this.titleText,
      @required this.checkImage});

  final String titleText;
  final String image;
  final String checkImage;

  @override
  State<StatefulWidget> createState() => _SortingViewState();
}

class _SortingViewState extends State<SortingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: ps_space_60,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(ps_space_16),
                child: Image.asset(
                  widget.image,
                  width: ps_space_24,
                  height: ps_space_24,
                ),
              ),
              const SizedBox(
                width: ps_space_10,
              ),
              Text(widget.titleText,
                  style: Theme.of(context).textTheme.subtitle),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(right: ps_space_20, left: ps_space_20),
            child: Image.asset(
              widget.checkImage,
              width: ps_space_16,
              height: ps_space_16,
            ),
          ),
        ],
      ),
    );
  }
}
