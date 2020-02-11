import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/provider/category/category_provider.dart';
import 'package:digitalproductstore/repository/category_repository.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_appbar.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/category_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'filter_expantion_tile_view.dart';

class FilterListView extends StatefulWidget {
  const FilterListView({this.selectedData});

  final dynamic selectedData;

  @override
  State<StatefulWidget> createState() => _FilterListViewState();
}

class _FilterListViewState extends State<FilterListView> {
  final ScrollController _scrollController = ScrollController();

  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();
  CategoryRepository categoryRepository;
  PsValueHolder psValueHolder;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSubCategoryClick(Map<String, String> subCategory) {
    Navigator.pop(context, subCategory);
  }

  @override
  Widget build(BuildContext context) {
    categoryRepository = Provider.of<CategoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    return PsWidgetWithAppBar<CategoryProvider>(
        appBarTitle:
            Utils.getString(context, 'item_filter__filtered_by_product_type') ??
                '',
        initProvider: () {
          return CategoryProvider(
              repo: categoryRepository, psValueHolder: psValueHolder);
        },
        onProviderReady: (CategoryProvider provider) {
          provider.loadAllCategoryList(categoryIconList.toMap());
        },
        actions: <Widget>[
          IconButton(
            icon: Icon(MaterialCommunityIcons.filter_remove_outline,
                color: ps_ctheme__color_speical),
            onPressed: () {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[CATEGORY_ID] = '';
              dataHolder[SUB_CATEGORY_ID] = '';
              onSubCategoryClick(dataHolder);
            },
          )
        ],
        builder:
            (BuildContext context, CategoryProvider provider, Widget child) {
          return Container(
            child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: provider.categoryList.data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (provider.categoryList.data != null ||
                      provider.categoryList.data.isEmpty) {
                    return FilterExpantionTileView(
                        selectedData: widget.selectedData,
                        category: provider.categoryList.data[index],
                        onSubCategoryClick: onSubCategoryClick);
                  } else {
                    return null;
                  }
                }),
          );
        });
  }
}
