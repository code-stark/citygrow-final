import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/default_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GalleryGridItem extends StatelessWidget {
  const GalleryGridItem({
    Key key,
    @required this.image,
    this.onImageTap,
  }) : super(key: key);

  final DefaultPhoto image;
  final Function onImageTap;

  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: image,
      width: MediaQuery.of(context).size.width,
      height: double.infinity,
      boxfit: BoxFit.fitHeight,
      onTap: onImageTap,
    );
    return Container(
      decoration: BoxDecoration(
          color: Utils.isLightMode(context) ? Colors.white : Colors.grey[900],
          borderRadius: const BorderRadius.all(Radius.circular(ps_space_4))),
      margin: const EdgeInsets.all(ps_space_4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ps_space_8),
        child: _imageWidget,
      ),
    );
  }
}
