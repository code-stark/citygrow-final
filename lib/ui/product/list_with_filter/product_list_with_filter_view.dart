import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/config/ps_colors.dart';

import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/provider/product/search_product_provider.dart';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/ui/product/item/product_vertical_list_item.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/product_parameter_holder.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';

class ProductListWithFilterView extends StatefulWidget {
  const ProductListWithFilterView(
      {Key key,
      @required this.productParameterHolder,
      @required this.animationController})
      : super(key: key);

  final ProductParameterHolder productParameterHolder;
  final AnimationController animationController;

  @override
  _ProductListWithFilterViewState createState() =>
      _ProductListWithFilterViewState();
}

class _ProductListWithFilterViewState extends State<ProductListWithFilterView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  SearchProductProvider _searchProductProvider;
  bool isVisible = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _offset = 0;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _searchProductProvider.nextProductListByKey(
            _searchProductProvider.productParameterHolder);
      }
      setState(() {
        final double offset = _scrollController.offset;
        _delta += offset - _oldOffset;
        if (_delta > _containerMaxHeight)
          _delta = _containerMaxHeight;
        else if (_delta < 0) {
          _delta = 0;
        }
        _oldOffset = offset;
        _offset = -_delta;
      });

      print(' Offset $_offset');
    });
  }

  final double _containerMaxHeight = 60;
  double _offset, _delta = 0, _oldOffset = 0;
  ProductRepository repo1;
  dynamic data;
  PsValueHolder valueHolder;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<ProductRepository>(context);
    data = EasyLocalizationProvider.of(context).data;
    valueHolder = Provider.of<PsValueHolder>(context);

    print(
        '............................Build UI Again ............................');
    return
        // EasyLocalizationProvider(
        //     data: data,
        //     child:
        ChangeNotifierProvider<SearchProductProvider>(
            create: (BuildContext context) {
      final SearchProductProvider provider = SearchProductProvider(repo: repo1);
      provider.loadProductListByKey(widget.productParameterHolder);
      _searchProductProvider = provider;
      _searchProductProvider.productParameterHolder =
          widget.productParameterHolder;
      return _searchProductProvider;
    }, child: Consumer<SearchProductProvider>(builder: (BuildContext context,
                SearchProductProvider provider, Widget child) {
      // print(provider.productList.data.isEmpty);
      // if (provider.productList.data.isNotEmpty) {
      return Container(
        color: Utils.isLightMode(context) ? Colors.grey[100] : Colors.grey[900],
        child: Stack(children: <Widget>[
          if (provider.productList.data.isNotEmpty &&
              provider.productList.data != null)
            Container(
                margin: const EdgeInsets.only(
                    left: ps_space_4,
                    right: ps_space_4,
                    top: ps_space_4,
                    bottom: ps_space_4),
                child: RefreshIndicator(
                  child: CustomScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      slivers: <Widget>[
                        SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 220,
                                  childAspectRatio: 0.6),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (provider.productList.data != null ||
                                  provider.productList.data.isNotEmpty) {
                                final int count =
                                    provider.productList.data.length;
                                return ProductVeticalListItem(
                                  animationController:
                                      widget.animationController,
                                  animation: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: widget.animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  product: provider.productList.data[index],
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutePaths.productDetail,
                                        arguments:
                                            provider.productList.data[index]);
                                  },
                                );
                              } else {
                                return null;
                              }
                            },
                            childCount: provider.productList.data.length,
                          ),
                        ),
                      ]),
                  onRefresh: () {
                    return provider.resetLatestProductList(
                        _searchProductProvider.productParameterHolder);
                  },
                ))
          else if (provider.productList.status != PsStatus.PROGRESS_LOADING &&
              provider.productList.status != PsStatus.BLOCK_LOADING &&
              provider.productList.status != PsStatus.NOACTION)
            Align(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/baseline_empty_item_grey_24.png',
                      height: 100,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      height: ps_space_32,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: ps_space_20, right: ps_space_20),
                      child: Text(
                        Utils.getString(
                            context, 'procuct_list__no_result_data'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title.copyWith(),
                      ),
                    ),
                    const SizedBox(
                      height: ps_space_20,
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: _offset,
            width: MediaQuery.of(context).size.width,
            child: Container(
              margin: const EdgeInsets.only(
                  left: ps_space_12,
                  top: ps_space_8,
                  right: ps_space_12,
                  bottom: ps_space_16),
              child: Container(
                  width: double.infinity,
                  height: _containerMaxHeight,
                  child: BottomNavigationImageAndText(
                      searchProductProvider: _searchProductProvider)),
            ),
          ),
          PSProgressIndicator(provider.productList.status),
        ]),
      );
      // }
      // else {
      // return Align(
      //   child: Container(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisSize: MainAxisSize.min,
      //       children: <Widget>[
      //         Image.asset(
      //           'assets/images/baseline_empty_item_grey_24.png',
      //           height: 100,
      //           width: 150,
      //           fit: BoxFit.cover,
      //         ),
      //         const SizedBox(
      //           height: ps_space_32,
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.only(
      //               left: ps_space_20, right: ps_space_20),
      //           child: Text(
      //             AppLocalizations.of(context)
      //                 .tr('procuct_list__no_result_data'),
      //             textAlign: TextAlign.center,
      //             style: Theme.of(context).textTheme.title.copyWith(),
      //           ),
      //         ),
      //         const SizedBox(
      //           height: ps_space_20,
      //         ),
      //       ],
      //     ),
      //   ),
      // );
      // }
    }));
  }
}

class BottomNavigationImageAndText extends StatefulWidget {
  const BottomNavigationImageAndText({this.searchProductProvider});
  final SearchProductProvider searchProductProvider;

  @override
  _BottomNavigationImageAndTextState createState() =>
      _BottomNavigationImageAndTextState();
}

class _BottomNavigationImageAndTextState
    extends State<BottomNavigationImageAndText> {
  bool isClickBaseLineList = false;
  bool isClickBaseLineTune = false;

  @override
  Widget build(BuildContext context) {
    if (widget.searchProductProvider.productParameterHolder.isFiltered()) {
      isClickBaseLineTune = true;
    }

    if (widget.searchProductProvider.productParameterHolder
        .isCatAndSubCatFiltered()) {
      isClickBaseLineList = true;
    }

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Utils.isLightMode(context)
                  ? Colors.grey[300]
                  : Colors.grey[900]),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Utils.isLightMode(context)
                  ? Colors.grey[200]
                  : Colors.grey[900],
              blurRadius: 0.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: const Offset(
                0.1, // Move to right 10  horizontally
                0.1, // Move to bottom 10 Vertically
              ),
            )
          ],
          color: Utils.isLightMode(context) ? Colors.grey[200] : Colors.black,
          borderRadius: const BorderRadius.all(Radius.circular(ps_space_8))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: MaterialCommunityIcons.format_list_bulleted_type,
                  color: isClickBaseLineList
                      ? ps_ctheme__color_speical
                      : Colors.grey,
                ),
                Text(Utils.getString(context, 'search__category'),
                    style: Theme.of(context).textTheme.body2.copyWith(
                        color: isClickBaseLineList
                            ? ps_ctheme__color_speical
                            : Theme.of(context).textTheme.body2.color)),
              ],
            ),
            onTap: () async {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[CATEGORY_ID] =
                  widget.searchProductProvider.productParameterHolder.catId;
              dataHolder[SUB_CATEGORY_ID] =
                  widget.searchProductProvider.productParameterHolder.subCatId;
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.filterExpantion,
                  arguments: dataHolder);

              if (result != null) {
                widget.searchProductProvider.productParameterHolder.catId =
                    result[CATEGORY_ID];
                widget.searchProductProvider.productParameterHolder.subCatId =
                    result[SUB_CATEGORY_ID];
                widget.searchProductProvider.resetLatestProductList(
                    widget.searchProductProvider.productParameterHolder);

                if (result[CATEGORY_ID] == '' &&
                    result[SUB_CATEGORY_ID] == '') {
                  isClickBaseLineList = false;
                } else {
                  isClickBaseLineList = true;
                }
              }
            },
          ),
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: Icons.filter_list,
                  color: isClickBaseLineTune
                      ? ps_ctheme__color_speical
                      : Colors.grey,
                ),
                Text(Utils.getString(context, 'search__filter'),
                    style: Theme.of(context).textTheme.body2.copyWith(
                        color: isClickBaseLineTune
                            ? ps_ctheme__color_speical
                            : Theme.of(context).textTheme.body2.color))
              ],
            ),
            onTap: () async {
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.itemSearch,
                  arguments:
                      widget.searchProductProvider.productParameterHolder);
              if (result != null) {
                widget.searchProductProvider.productParameterHolder = result;
                widget.searchProductProvider.resetLatestProductList(
                    widget.searchProductProvider.productParameterHolder);

                if (widget.searchProductProvider.productParameterHolder
                    .isFiltered()) {
                  isClickBaseLineTune = true;
                } else {
                  isClickBaseLineTune = false;
                }
              }
            },
          ),
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: Icons.sort,
                  color: ps_ctheme__color_speical,
                ),
                Text(Utils.getString(context, 'search__sort'),
                    style: Theme.of(context).textTheme.body2.copyWith(
                        color: isClickBaseLineTune
                            ? ps_ctheme__color_speical
                            : Theme.of(context).textTheme.body2.color))
              ],
            ),
            onTap: () async {
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.itemSort,
                  arguments:
                      widget.searchProductProvider.productParameterHolder);
              if (result != null) {
                widget.searchProductProvider.productParameterHolder = result;
                widget.searchProductProvider.resetLatestProductList(
                    widget.searchProductProvider.productParameterHolder);
              }
            },
          ),
        ],
      ),
    );
  }
}

class PsIconWithCheck extends StatelessWidget {
  const PsIconWithCheck({Key key, this.icon, this.color = Colors.grey})
      : super(key: key);
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color);
  }
}
