import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/basket/basket_provider.dart';
import 'package:digitalproductstore/provider/category/trending_category_provider.dart';
import 'package:digitalproductstore/repository/basket_repository.dart';
import 'package:digitalproductstore/repository/category_repository.dart';
import 'package:digitalproductstore/ui/category/item/category_vertical_list_item.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/category_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:digitalproductstore/viewobject/holder/product_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrendingCategoryListView extends StatefulWidget {
  @override
  _TrendingCategoryListViewState createState() {
    return _TrendingCategoryListViewState();
  }
}

class _TrendingCategoryListViewState extends State<TrendingCategoryListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  TrendingCategoryProvider _trendingCategoryProvider;
  PsValueHolder psValueHolder;
  final CategoryParameterHolder trendingCategoryParameterHolder =
      CategoryParameterHolder().getTrendingParameterHolder();

  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _trendingCategoryProvider
            .nextTrendingCategoryList(trendingCategoryParameterHolder.toMap());
      }
    });

    animationController =
        AnimationController(duration: animation_duration, vsync: this);

    super.initState();
  }

  CategoryRepository categoryRepository;
  BasketRepository basketRepository;
  BasketProvider basketProvider;
  TrendingCategoryProvider trendingCategoryProvider;

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    categoryRepository = Provider.of<CategoryRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    //var data = EasyLocalizationProvider.of(context).data;
    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithMultiProvider(
            child: MultiProvider(
                providers: <SingleChildCloneableWidget>[
              ChangeNotifierProvider<TrendingCategoryProvider>(
                  create: (BuildContext context) {
                trendingCategoryProvider = TrendingCategoryProvider(
                    repo: categoryRepository, psValueHolder: psValueHolder);
                trendingCategoryProvider.loadTrendingCategoryList(
                    trendingCategoryParameterHolder.toMap());
                return trendingCategoryProvider;
              }),
              ChangeNotifierProvider<BasketProvider>(
                  create: (BuildContext context) {
                basketProvider = BasketProvider(repo: basketRepository);
                return basketProvider;
              }),
            ],
                //  PsWidgetWithAppBar<TrendingCategoryProvider>(
                //     appBarTitle:
                //         Utils.getString(context, 'tranding_category__app_bar_name'),
                //     initProvider: () {
                //       return TrendingCategoryProvider(
                //           repo: repo1,
                //           psValueHolder: Provider.of<PsValueHolder>(context));
                //     },
                //     onProviderReady: (TrendingCategoryProvider provider) {
                //
                //       _trendingCategoryProvider = provider;
                //     },
                child: Consumer<TrendingCategoryProvider>(builder:
                    (BuildContext context, TrendingCategoryProvider provider,
                        Widget child) {
                  ///
                  /// Load Basket List
                  ///
                  basketProvider = Provider.of<BasketProvider>(context,
                      listen: false); // Listen : False is important.

                  basketProvider.loadBasketList();
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Theme.of(context).appBarTheme.color,
                      title: Text(
                        Utils.getString(
                            context, 'tranding_category__app_bar_name'),
                        style: Theme.of(context).textTheme.title.copyWith(
                              fontWeight: FontWeight.bold,
                              //Theme.of(context).appBarTheme.color,
                            ),
                      ),
                      titleSpacing: 0,
                      elevation: 0,
                      iconTheme: const IconThemeData(),
                      textTheme: Theme.of(context).textTheme,
                      brightness: Utils.getBrightnessForAppBar(context),
                      actions: <Widget>[
                        Consumer<BasketProvider>(builder: (BuildContext context,
                            BasketProvider basketProvider, Widget child) {
                          return Stack(
                            children: <Widget>[
                              Container(
                                width: ps_space_40,
                                height: ps_space_40,
                                margin: const EdgeInsets.only(
                                    top: ps_space_8,
                                    left: ps_space_8,
                                    right: ps_space_8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black38,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.shopping_basket,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                  child: Container(
                                    width: ps_space_40,
                                    height: ps_space_40,
                                    margin: const EdgeInsets.only(
                                        top: ps_space_8,
                                        left: ps_space_8,
                                        right: ps_space_8),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black54,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        basketProvider.basketList.data.length >
                                                99
                                            ? '99+'
                                            : basketProvider
                                                .basketList.data.length
                                                .toString(),
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline
                                            .copyWith(
                                                fontSize: ps_space_16,
                                                color: Colors.white),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RoutePaths.basketList,
                                    );
                                  }),
                            ],
                          );
                        }),
                      ],
                    ),
                    body: Stack(children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(
                              left: ps_space_8,
                              right: ps_space_8,
                              top: ps_space_8,
                              bottom: ps_space_8),
                          child: RefreshIndicator(
                            child: CustomScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                slivers: <Widget>[
                                  SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 200,
                                            childAspectRatio: 0.8),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        if (provider.categoryList.data !=
                                                null ||
                                            provider
                                                .categoryList.data.isNotEmpty) {
                                          final int count =
                                              provider.categoryList.data.length;
                                          return CategoryVerticalListItem(
                                            animationController:
                                                animationController,
                                            animation: Tween<double>(
                                                    begin: 0.0, end: 1.0)
                                                .animate(
                                              CurvedAnimation(
                                                parent: animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn),
                                              ),
                                            ),
                                            category: provider
                                                .categoryList.data[index],
                                            onTap: () {
                                              utilsCheckUserLoginId(
                                                      psValueHolder)
                                                  .then((String
                                                      loginUserId) async {
                                                final TouchCountParameterHolder
                                                    touchCountParameterHolder =
                                                    TouchCountParameterHolder(
                                                        typeId: provider
                                                            .categoryList
                                                            .data[index]
                                                            .id,
                                                        typeName:
                                                            FILTERING_TYPE_NAME_CATEGORY,
                                                        userId: provider
                                                            .psValueHolder
                                                            .loginUserId);

                                                provider.postTouchCount(
                                                    touchCountParameterHolder
                                                        .toMap());
                                              });
                                              print(provider
                                                  .categoryList
                                                  .data[index]
                                                  .defaultPhoto
                                                  .imgPath);
                                              final ProductParameterHolder
                                                  productParameterHolder =
                                                  ProductParameterHolder()
                                                      .getTrendingParameterHolder();
                                              productParameterHolder.catId =
                                                  provider.categoryList
                                                      .data[index].id;
                                              Navigator.pushNamed(context,
                                                  RoutePaths.filterProductList,
                                                  arguments:
                                                      ProductListIntentHolder(
                                                    appBarTitle: provider
                                                        .categoryList
                                                        .data[index]
                                                        .name,
                                                    productParameterHolder:
                                                        productParameterHolder,
                                                  ));
                                            },
                                          );
                                        } else {
                                          return null;
                                        }
                                      },
                                      childCount:
                                          provider.categoryList.data.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              return provider.resetTrendingCategoryList(
                                  trendingCategoryParameterHolder.toMap());
                            },
                          )),
                      PSProgressIndicator(provider.categoryList.status)
                    ]),
                  );
                }))));
  }
}
