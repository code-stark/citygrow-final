import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';

import 'package:digitalproductstore/viewobject/holder/tag_object_holder.dart';
import 'package:flutter/material.dart';

class RelatedTagsHorizontalListItem extends StatelessWidget {
  const RelatedTagsHorizontalListItem({
    Key key,
    @required this.tagParameterHolder,
    @required this.onTap,
  }) : super(key: key);

  final TagParameterHolder tagParameterHolder;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      // child:
      // Card(
      //   elevation: 0,
      // shape: const BeveledRectangleBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(7.0)),
      // ),
      child: Card(
        elevation: 0,
        shape: const BeveledRectangleBorder(
            side: BorderSide(color: ps_ctheme__color_speical, width: 0.6),
            borderRadius: BorderRadius.all(Radius.circular(7.0))),
        child: Container(
          margin: const EdgeInsets.all(ps_space_4),
          padding: const EdgeInsets.only(left: ps_space_8, right: ps_space_8),

          // decoration:
          //     UnderlineTabIndicator(borderSide: BorderSide(color: Colors.red), ),

          // foregroundDecoration: ShapeDecoration(
          //   shape: const BeveledRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(7.0)),
          //   ),
          // ),
          // decoration: ShapeDecoration(
          //   shape:
          // )
          // // BoxDecoration(
          // color: Utils.isLightMode(context) ? Colors.white : Colors.black12,

          // borderRadius: const BeveledRectangleBorder(
          //     left: Radius.circular(ps_space_8)),
          // shape: BoxShape.circle,
          //borderRadius: BorderRadiusTween(begin: const BorderRadius.only(topLeft: Radius.circular(ps_space_8))),
          // border: Border.all(
          //     color: ps_ctheme__color_speical, width: ps_space_1)
          // ),
          child: Center(
            child: Text(
              tagParameterHolder.tagName,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: ps_ctheme__color_speical),
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
