import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/provider/subcategory/sub_category_provider.dart';
import 'package:digitalproductstore/repository/sub_category_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digitalproductstore/ui/common/expansion_tile.dart' as custom;

class FilterExpantionTileView extends StatefulWidget {
  const FilterExpantionTileView(
      {Key key, this.selectedData, this.category, this.onSubCategoryClick})
      : super(key: key);
  final dynamic selectedData;
  final Category category;
  final Function onSubCategoryClick;
  @override
  State<StatefulWidget> createState() => _FilterExpantionTileView();
}

class _FilterExpantionTileView extends State<FilterExpantionTileView> {
  SubCategoryRepository subCategoryRepository;
  bool isExpanded = false;

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
    subCategoryRepository = Provider.of<SubCategoryRepository>(context);

    return ChangeNotifierProvider<SubCategoryProvider>(
        create: (BuildContext context) {
      final SubCategoryProvider provider =
          SubCategoryProvider(repo: subCategoryRepository);
      provider.loadAllSubCategoryList(widget.category.id);
      return provider;
    }, child: Consumer<SubCategoryProvider>(builder:
            (BuildContext context, SubCategoryProvider provider, Widget child) {
      return Container(
          child: custom.ExpansionTile(
        initiallyExpanded: false,
        headerBackgroundColor:
            Utils.isLightMode(context) ? Colors.grey[200] : Colors.black54,
        title: Container(
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.category.name,
                  style: Theme.of(context).textTheme.subhead,
                ),
                Container(
                    child: widget.category.id ==
                            widget.selectedData[CATEGORY_ID]
                        ? IconButton(
                            icon: Icon(Icons.playlist_add_check,
                                color: Theme.of(context)
                                    .iconTheme
                                    .copyWith(color: ps_ctheme__color_speical)
                                    .color),
                            onPressed: () {})
                        : Container())
              ]),
        ),
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.subCategoryList.data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: ps_space_16),
                          child: index == 0
                              ? Text(
                                  Utils.getString(context,
                                          'product_list__category_all') ??
                                      '',
                                  style: Theme.of(context).textTheme.body1,
                                )
                              : Text(
                                  provider.subCategoryList.data[index - 1].name,
                                  style: Theme.of(context).textTheme.body1),
                        ),
                      ),
                      Container(
                          child: index == 0 &&
                                  widget.category.id ==
                                      widget.selectedData[CATEGORY_ID] &&
                                  widget.selectedData[SUB_CATEGORY_ID] == ''
                              ? IconButton(
                                  icon: Icon(Icons.check_circle,
                                      color: Theme.of(context)
                                          .iconTheme
                                          .copyWith(
                                              color: ps_ctheme__color_speical)
                                          .color),
                                  onPressed: () {})
                              : index != 0 &&
                                      widget.selectedData[SUB_CATEGORY_ID] ==
                                          provider.subCategoryList
                                              .data[index - 1].id
                                  ? IconButton(
                                      icon: Icon(Icons.check_circle,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      onPressed: () {})
                                  : Container())
                    ],
                  ),
                  onTap: () {
                    final Map<String, String> dataHolder = <String, String>{};
                    if (index == 0) {
                      // widget.onSubCategoryClick(dataHolder);
                      dataHolder[CATEGORY_ID] = widget.category.id;
                      dataHolder[SUB_CATEGORY_ID] = '';
                      widget.onSubCategoryClick(dataHolder);
                    } else {
                      // widget.onSubCategoryClick(
                      //     provider.subCategoryList.data[index - 1]);
                      dataHolder[CATEGORY_ID] = widget.category.id;
                      dataHolder[SUB_CATEGORY_ID] =
                          provider.subCategoryList.data[index - 1].id;
                      widget.onSubCategoryClick(dataHolder);
                    }
                  },
                );
              }),
        ],
        onExpansionChanged: (bool expanding) =>
            setState(() => isExpanded = expanding),
      ));
    }));
  }
}
