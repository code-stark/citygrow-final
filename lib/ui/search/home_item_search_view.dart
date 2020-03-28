import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/product/search_product_provider.dart';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/ui/common/ps_dropdown_base_widget.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/ui/common/ps_special_check_text_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/category.dart';
import 'package:digitalproductstore/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:digitalproductstore/viewobject/holder/product_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/sub_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:digitalproductstore/ui/common/ps_textfield_widget.dart';

class HomeItemSearchView extends StatefulWidget {
  const HomeItemSearchView({
    @required this.productParameterHolder,
    @required this.animation,
    @required this.animationController,
  });

  final ProductParameterHolder productParameterHolder;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  _ItemSearchViewState createState() => _ItemSearchViewState();
}

class _ItemSearchViewState extends State<HomeItemSearchView> {
  ProductRepository repo1;
  SearchProductProvider _searchProductProvider;

  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();
  final TextEditingController userInputMaximunPriceEditingController =
      TextEditingController();
  final TextEditingController userInputMinimumPriceEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');

    final Widget _searchButtonWidget = Container(
        // color: ps_ctheme__color_green,
        margin: const EdgeInsets.only(
            left: ps_space_16,
            right: ps_space_16,
            top: ps_space_16,
            bottom: ps_space_48),
        width: double.infinity,
        height: ps_space_44,
        child: RaisedButton(
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          child: Text(Utils.getString(context, 'home_search__search')),
          onPressed: () async {
            // if (userInputItemNameTextEditingController.text != null &&
            //     userInputItemNameTextEditingController.text != '') {
            //   _searchProductProvider.productParameterHolder.searchTerm =
            //       userInputItemNameTextEditingController.text;
            // } else {
            //   _searchProductProvider.productParameterHolder.searchTerm = '';
            // }
            // if (userInputMaximunPriceEditingController.text != null) {
            //   _searchProductProvider.productParameterHolder.maxPrice =
            //       userInputMaximunPriceEditingController.text;
            // } else {
            //   _searchProductProvider.productParameterHolder.maxPrice = '';
            // }
            // if (userInputMinimumPriceEditingController.text != null) {
            //   _searchProductProvider.productParameterHolder.minPrice =
            //       userInputMinimumPriceEditingController.text;
            // } else {
            //   _searchProductProvider.productParameterHolder.minPrice = '';
            // }
            // if (_searchProductProvider.isfirstRatingClicked) {
            //   _searchProductProvider.productParameterHolder.overallRating =
            //       RATING_ONE;
            // }

            // if (_searchProductProvider.isSecondRatingClicked) {
            //   _searchProductProvider.productParameterHolder.overallRating =
            //       RATING_TWO;
            // }

            // if (_searchProductProvider.isThirdRatingClicked) {
            //   _searchProductProvider.productParameterHolder.overallRating =
            //       RATING_THREE;
            // }

            // if (_searchProductProvider.isfouthRatingClicked) {
            //   _searchProductProvider.productParameterHolder.overallRating =
            //       RATING_FOUR;
            // }

            // if (_searchProductProvider.isFifthRatingClicked) {
            //   _searchProductProvider.productParameterHolder.overallRating =
            //       RATING_FIVE;
            // }

            // if (_searchProductProvider.isSwitchedFeaturedProduct) {
            //   _searchProductProvider.productParameterHolder.isFeatured =
            //       IS_FEATURED;
            // } else {
            //   _searchProductProvider.productParameterHolder.isFeatured = ZERO;
            // }
            // if (_searchProductProvider.isSwitchedDiscountPrice) {
            //   _searchProductProvider.productParameterHolder.isDiscount =
            //       IS_DISCOUNT;
            // } else {
            //   _searchProductProvider.productParameterHolder.isDiscount = ZERO;
            // }
            // if (_searchProductProvider.isSwitchedFreeProduct) {
            //   _searchProductProvider.productParameterHolder.isFree = IS_FREE;
            // } else {
            //   _searchProductProvider.productParameterHolder.isFree = ZERO;
            // }
            // if (_searchProductProvider.categoryId != null) {
            //   _searchProductProvider.productParameterHolder.catId =
            //       _searchProductProvider.categoryId;
            // }
            // if (_searchProductProvider.subCategoryId != null) {
            //   _searchProductProvider.productParameterHolder.subCatId =
            //       _searchProductProvider.subCategoryId;
            // }
            // print(
            //     'userInputText' + userInputItemNameTextEditingController.text);
            // final dynamic result =
            //     await Navigator.pushNamed(context, RoutePaths.filterProductList,
            //         arguments: ProductListIntentHolder(
            //           appBarTitle: Utils.getString(
            //               context, 'home_search__app_bar_title'),
            //           productParameterHolder:
            //               _searchProductProvider.productParameterHolder,
            //         ));
            // if (result != null && result is ProductParameterHolder) {
            //   _searchProductProvider.productParameterHolder = result;
            // }
          },
          color: ps_ctheme__color_speical,
          textColor: Colors.white,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          splashColor: Colors.grey,
        ));

    repo1 = Provider.of<ProductRepository>(context);
    // productParameterHolder = Provider.of<ProductParameterHolder>(context);
    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<SearchProductProvider>(
            create: (BuildContext content) {
      _searchProductProvider = SearchProductProvider(repo: repo1);
      _searchProductProvider.productParameterHolder =
          widget.productParameterHolder;
      _searchProductProvider
          .loadProductListByKey(_searchProductProvider.productParameterHolder);

      return _searchProductProvider;
    }, child: Consumer<SearchProductProvider>(
      builder:
          (BuildContext context, SearchProductProvider provider, Widget child) {
        if (_searchProductProvider.productList != null &&
            _searchProductProvider.productList.data != null) {
          widget.animationController.forward();
          return SingleChildScrollView(
            child: AnimatedBuilder(
                animation: widget.animationController,
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                      opacity: widget.animation,
                      child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, 100 * (1.0 - widget.animation.value), 0.0),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                _ProductNameWidget(
                                  userInputItemNameTextEditingController:
                                      userInputItemNameTextEditingController,
                                ),
                                _PriceWidget(
                                  userInputMinimumPriceEditingController:
                                      userInputMinimumPriceEditingController,
                                  userInputMaximunPriceEditingController:
                                      userInputMaximunPriceEditingController,
                                ),
                                _RatingRangeWidget(),
                                _SpecialCheckWidget(),
                                _searchButtonWidget,
                              ],
                            ),
                          )));
                }),
          );
        } else {
          return Container();
        }
      },
    )));
  }
}

class _ProductNameWidget extends StatefulWidget {
  const _ProductNameWidget({this.userInputItemNameTextEditingController});

  final TextEditingController userInputItemNameTextEditingController;

  @override
  __ProductNameWidgetState createState() => __ProductNameWidgetState();
}

class __ProductNameWidgetState extends State<_ProductNameWidget> {
  @override
  Widget build(BuildContext context) {
    print('*****' + widget.userInputItemNameTextEditingController.text);
    return Column(
      children: <Widget>[
        PsTextFieldWidget(
            titleText: Utils.getString(context, 'home_search__product_name'),
            textAboutMe: false,
            hintText:
                Utils.getString(context, 'home_search__product_name_hint'),
            textEditingController:
                widget.userInputItemNameTextEditingController),
        PsDropdownBaseWidget(
            title: Utils.getString(context, 'search__category'),
            selectedText: Provider.of<SearchProductProvider>(context)
                .selectedCategoryName,
            onTap: () async {
              final SearchProductProvider provider =
                  Provider.of<SearchProductProvider>(context);

              final dynamic categoryResult =
                  await Navigator.pushNamed(context, RoutePaths.searchCategory);

              if (categoryResult != null && categoryResult is Category) {
                provider.categoryId = categoryResult.id;
                provider.subCategoryId = '';

                setState(() {
                  provider.selectedCategoryName = categoryResult.name;
                  provider.selectedSubCategoryName = '';
                });
              }
            }),
        PsDropdownBaseWidget(
            title: Utils.getString(context, 'search__sub_category'),
            selectedText: Provider.of<SearchProductProvider>(context)
                .selectedSubCategoryName,
            onTap: () async {
              final SearchProductProvider provider =
                  Provider.of<SearchProductProvider>(context);
              if (provider.categoryId != '') {
                final dynamic subCategoryResult = await Navigator.pushNamed(
                    context, RoutePaths.searchSubCategory,
                    arguments: provider.categoryId);
                if (subCategoryResult != null &&
                    subCategoryResult is SubCategory) {
                  provider.subCategoryId = subCategoryResult.id;

                  provider.selectedSubCategoryName = subCategoryResult.name;
                }
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'home_search__choose_category_first'),
                      );
                    });
                const ErrorDialog(message: 'Choose Category first');
              }
            }),
      ],
    );
  }
  // @override
  // void dispose() {
  //   userInputValueController.dispose();
  //   super.dispose();
  // }
}

class _ChangeRatingColor extends StatelessWidget {
  const _ChangeRatingColor({
    Key key,
    @required this.title,
    @required this.checkColor,
  }) : super(key: key);

  final String title;
  final bool checkColor;

  @override
  Widget build(BuildContext context) {
    final Color defaultBackgroundColor =
        Utils.isLightMode(context) ? Colors.grey[200] : Colors.black54;
    return Container(
      width: MediaQuery.of(context).size.width / 5.5,
      height: ps_space_104,
      decoration: BoxDecoration(
        color: checkColor ? defaultBackgroundColor : ps_ctheme__color_speical,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              Icons.star,
              color: checkColor ? ps_wtheme_icon_color : ps_wtheme_white_color,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: checkColor
                        ? ps_wtheme_icon_color
                        : ps_wtheme_white_color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingRangeWidget extends StatefulWidget {
  @override
  __RatingRangeWidgetState createState() => __RatingRangeWidgetState();
}

class __RatingRangeWidgetState extends State<_RatingRangeWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchProductProvider provider =
        Provider.of<SearchProductProvider>(context);

    dynamic _firstRatingRangeSelected() {
      if (!provider.isfirstRatingClicked) {
        // isfirstRatingClicked = true;
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__one_and_higher'),
          checkColor: true,
        );
      } else {
        // isfirstRatingClicked = false;
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__one_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _secondRatingRangeSelected() {
      if (!provider.isSecondRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__two_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__two_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _thirdRatingRangeSelected() {
      if (!provider.isThirdRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__three_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__three_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _fouthRatingRangeSelected() {
      if (!provider.isfouthRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__four_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__four_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _fifthRatingRangeSelected() {
      if (!provider.isFifthRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__five'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__five'),
          checkColor: false,
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(ps_space_12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString(context, 'home_search__rating_range'),
                  style: Theme.of(context).textTheme.body2),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  if (!provider.isfirstRatingClicked) {
                    provider.isfirstRatingClicked = true;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _firstRatingRangeSelected(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(ps_space_4),
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  if (!provider.isSecondRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = true;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _secondRatingRangeSelected(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  if (!provider.isThirdRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = true;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _thirdRatingRangeSelected(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(ps_space_4),
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  if (!provider.isfouthRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = true;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _fouthRatingRangeSelected(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(
                  // color: Colors.white,
                  ),
              child: InkWell(
                onTap: () {
                  if (!provider.isFifthRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = true;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _fifthRatingRangeSelected(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

dynamic setAllRatingFalse(SearchProductProvider provider) {
  provider.isfirstRatingClicked = false;
  provider.isSecondRatingClicked = false;
  provider.isThirdRatingClicked = false;
  provider.isfouthRatingClicked = false;
  provider.isFifthRatingClicked = false;
}

class _PriceWidget extends StatelessWidget {
  const _PriceWidget(
      {this.userInputMinimumPriceEditingController,
      this.userInputMaximunPriceEditingController});
  final TextEditingController userInputMinimumPriceEditingController;
  final TextEditingController userInputMaximunPriceEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(ps_space_12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString(context, 'home_search__price'),
                  style: Theme.of(context).textTheme.body2),
            ],
          ),
        ),
        _PriceTextWidget(
            title: Utils.getString(context, 'home_search__lowest_price'),
            textField: TextField(
                maxLines: null,
                style: Theme.of(context).textTheme.body1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: ps_space_8, bottom: ps_space_12),
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'home_search__not_set'),
                ),
                keyboardType: TextInputType.number,
                controller: userInputMinimumPriceEditingController)),
        const Divider(
          height: ps_space_1,
        ),
        _PriceTextWidget(
            title: Utils.getString(context, 'home_search__highest_price'),
            textField: TextField(
                maxLines: null,
                style: Theme.of(context).textTheme.body1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: ps_space_8, bottom: ps_space_12),
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'home_search__not_set'),
                ),
                keyboardType: TextInputType.number,
                controller: userInputMaximunPriceEditingController)),
      ],
    );
  }
}

class _PriceTextWidget extends StatelessWidget {
  const _PriceTextWidget({
    Key key,
    @required this.title,
    @required this.textField,
  }) : super(key: key);

  final String title;
  final TextField textField;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(ps_space_12),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.body1),
            Container(
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(ps_space_4),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]
                          : Colors.black87),
                ),
                width: ps_space_120,
                height: ps_space_36,
                child: textField),
          ],
        ),
      ),
    );
  }
}

class _SpecialCheckWidget extends StatefulWidget {
  @override
  __SpecialCheckWidgetState createState() => __SpecialCheckWidgetState();
}

class __SpecialCheckWidgetState extends State<_SpecialCheckWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(ps_space_12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString(context, 'home_search__special_check'),
                  style: Theme.of(context).textTheme.body2),
            ],
          ),
        ),
        SpecialCheckTextWidget(
            title: Utils.getString(context, 'home_search__featured_product'),
            icon: FontAwesome5.gem,
            checkTitle: 1,
            size: ps_space_18),
        const Divider(
          height: ps_space_1,
        ),
        SpecialCheckTextWidget(
            title: Utils.getString(context, 'home_search__discount_price'),
            icon: Feather.percent,
            checkTitle: 2,
            size: ps_space_18),
        const Divider(
          height: ps_space_1,
        ),
        SpecialCheckTextWidget(
          title: Utils.getString(context, 'home_search__free_product'),
          icon: Octicons.gift,
          checkTitle: 3,
        ),
      ],
    );
  }
}

class _SpecialCheckTextWidget extends StatefulWidget {
  const _SpecialCheckTextWidget({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.checkTitle,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool checkTitle;

  @override
  __SpecialCheckTextWidgetState createState() =>
      __SpecialCheckTextWidgetState();
}

class __SpecialCheckTextWidgetState extends State<_SpecialCheckTextWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchProductProvider provider =
        Provider.of<SearchProductProvider>(context);

    return Container(
        width: double.infinity,
        height: ps_space_52,
        decoration: const BoxDecoration(
            // color: Colors.white,
            ),
        child: Container(
          margin: const EdgeInsets.all(ps_space_12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    widget.icon,
                    size: ps_space_20,
                    // color: ps_wtheme_icon_color,
                  ),
                  const SizedBox(
                    width: ps_space_10,
                  ),
                  Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              if (widget.checkTitle)
                Switch(
                  value: provider.isSwitchedFeaturedProduct,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedFeaturedProduct = value;
                    });
                  },
                  activeTrackColor: ps_ctheme__color_speical,
                  activeColor: ps_ctheme__color_speical,
                )
              else
                Switch(
                  value: provider.isSwitchedDiscountPrice,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedDiscountPrice = value;
                    });
                  },
                  activeTrackColor: ps_ctheme__color_speical,
                  activeColor: ps_ctheme__color_speical,
                ),
            ],
          ),
        ));
  }
}
