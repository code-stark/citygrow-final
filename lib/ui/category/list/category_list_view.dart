import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/ui/category/item/category_vertical_list_item.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/category_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:digitalproductstore/viewobject/holder/product_parameter_holder.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/category/category_provider.dart';
import 'package:digitalproductstore/repository/category_repository.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';

class CategoryListView extends StatefulWidget {
  @override
  _CategoryListViewState createState() {
    return _CategoryListViewState();
  }
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CategoryProvider _categoryProvider;
  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();

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
        _categoryProvider.nextCategoryList(categoryIconList.toMap());
      }
    });

    animationController =
        AnimationController(duration: animation_duration, vsync: this);

    super.initState();
  }

  CategoryRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
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

    repo1 = Provider.of<CategoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: EasyLocalizationProvider(
            data: data,
            child: ChangeNotifierProvider<CategoryProvider>(
                create: (BuildContext context) {
              final CategoryProvider provider =
                  CategoryProvider(repo: repo1, psValueHolder: psValueHolder);
              provider.loadCategoryList(categoryIconList.toMap());
              _categoryProvider = provider;
              return _categoryProvider;
            }, child: Consumer<CategoryProvider>(builder: (BuildContext context,
                    CategoryProvider provider, Widget child) {
              return Stack(children: <Widget>[
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
                                  if (provider.categoryList.data != null ||
                                      provider.categoryList.data.isNotEmpty) {
                                    final int count =
                                        provider.categoryList.data.length;
                                    return CategoryVerticalListItem(
                                      animationController: animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      category:
                                          provider.categoryList.data[index],
                                      onTap: () {
                                        print(provider.categoryList.data[index]
                                            .defaultPhoto.imgPath);
                                        final ProductParameterHolder
                                            productParameterHolder =
                                            ProductParameterHolder()
                                                .getLatestParameterHolder();
                                        productParameterHolder.catId = provider
                                            .categoryList.data[index].id;
                                        Navigator.pushNamed(context,
                                            RoutePaths.filterProductList,
                                            arguments: ProductListIntentHolder(
                                              appBarTitle: provider.categoryList
                                                  .data[index].name,
                                              productParameterHolder:
                                                  productParameterHolder,
                                            ));
                                      },
                                    );
                                  } else {
                                    return null;
                                  }
                                  // }
                                },
                                childCount: provider.categoryList.data.length,
                              ),
                            ),
                          ]),
                      onRefresh: () {
                        return provider
                            .resetCategoryList(categoryIconList.toMap());
                      },
                    )),
                PSProgressIndicator(provider.categoryList.status)
              ]);
            }))));
  }
}
