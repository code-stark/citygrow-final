import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/viewobject/category.dart';

class CategoryHorizontalListItem extends StatelessWidget {
  const CategoryHorizontalListItem({
    Key key,
    @required this.category,
    this.onTap,
  }) : super(key: key);

  final Category category;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.0,
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(
              horizontal: ps_space_4, vertical: ps_space_4),
          child: Container(
            width: ps_space_84,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                PsNetworkCircleIconImage(
                  photoKey: '',
                  defaultIcon: category.defaultIcon,
                  width: ps_space_64,
                  height: ps_space_64,
                  boxfit: BoxFit.fitHeight,
                ),
                const SizedBox(
                  height: ps_space_8,
                ),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}
