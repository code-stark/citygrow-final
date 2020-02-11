import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/sub_category.dart';

class SubCategoryVerticalListItem extends StatelessWidget {
  const SubCategoryVerticalListItem({
    Key key,
    @required this.subCategory,
    this.onTap,
  }) : super(key: key);

  final SubCategory subCategory;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    //print("$ps_app_image_thumbs_url${subCategory.defaultPhoto.imgPath}");
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.3,
          margin: const EdgeInsets.symmetric(
              horizontal: ps_space_16, vertical: ps_space_4),
          child: Container(
            padding: const EdgeInsets.all(ps_space_16),
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: ps_space_4,
                ),
                PsNetworkImage(
                  photoKey: '',
                  defaultPhoto: subCategory.defaultPhoto,
                  width: ps_space_44,
                  height: ps_space_44,
                  onTap: () {
                    Utils.psPrint(subCategory.defaultPhoto.imgParentId);
                  },
                ),
                const SizedBox(
                  height: ps_space_8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: ps_space_4,
                    ),
                    Text(
                      subCategory.name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontWeight: FontWeight.bold)
                              .fontWeight),
                    ),
                    const SizedBox(
                      height: ps_space_4,
                    ),
                    Text(subCategory.addedDate,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(
                      height: ps_space_4,
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
