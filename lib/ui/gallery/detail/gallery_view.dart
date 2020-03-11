import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/provider/gallery/gallery_provider.dart';
import 'package:digitalproductstore/repository/gallery_repository.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_appbar.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/default_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({
    Key key,
    @required this.selectedDefaultImage,
    // @required this.index,
    this.onImageTap,
    @required this.productList,
    @required this.productListss,
    @required this.indexx,
  }) : super(key: key);

  // final List<DefaultPhoto> image;
  final DefaultPhoto selectedDefaultImage;
  final Function onImageTap;
  final dynamic productList;
  final dynamic productListss;
  final int indexx;

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  @override
  Widget build(BuildContext context) {
    final GalleryRepository galleryRepo =
        Provider.of<GalleryRepository>(context);
    print(
        '............................Build UI Again ............................');
    return PsWidgetWithAppBar<GalleryProvider>(
      appBarTitle: Utils.getString(context, 'gallery__title') ?? '',
      initProvider: () {
        return GalleryProvider(repo: galleryRepo);
      },
      // onProviderReady: (GalleryProvider provider) {
      //   provider.loadImageList(
      //     widget.productList.imgParentId,
      //   );
      // },
      builder: (BuildContext context, GalleryProvider provider, Widget child) {
        if (widget.productList != null && widget.productList != null) {
          int selectedIndex = 0;
          for (int i = 0;
              i < widget.productListss['images'][widget.indexx].length;
              i++) {
            selectedIndex = i;
            break;
          }
          return PhotoViewGallery.builder(
            itemCount: widget.productListss['images'].length,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions.customChild(
                child: PsNetworkImage(boxfit: BoxFit.contain,
                  firebasePhoto: widget.productListss['images']
                      [(index == 0) ? widget.indexx : index],
                  photoKey: '',
                  // defaultPhoto: provider.galleryList.data[index],
                  onTap: widget.onImageTap,
                ),
                childSize: MediaQuery.of(context).size,
              );
            },
            pageController: PageController(initialPage: selectedIndex),
            scrollPhysics: const BouncingScrollPhysics(),
            loadingChild: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
