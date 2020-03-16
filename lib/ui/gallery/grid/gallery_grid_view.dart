import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/gallery/gallery_provider.dart';
import 'package:digitalproductstore/repository/gallery_repository.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_appbar.dart';
import 'package:digitalproductstore/ui/gallery/detail/gallery_view.dart';
import 'package:digitalproductstore/ui/gallery/item/gallery_grid_item.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GalleryGridView extends StatefulWidget {
  const GalleryGridView({
    Key key,
    @required this.product,
    this.onImageTap,
    @required this.productList,
  }) : super(key: key);

  final Product product;
  final Function onImageTap;
  final DocumentSnapshot productList;
  @override
  _GalleryGridViewState createState() => _GalleryGridViewState();
}

class _GalleryGridViewState extends State<GalleryGridView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final GalleryRepository productRepo =
        Provider.of<GalleryRepository>(context);
    print(
        '............................Build UI Again ............................');
    return PsWidgetWithAppBar<GalleryProvider>(
        appBarTitle: Utils.getString(context, 'gallery__title') ?? '',
        initProvider: () {
          return GalleryProvider(repo: productRepo);
        },
        // onProviderReady: (GalleryProvider provider) {
        //   provider.loadImageList(
        //     widget.product.defaultPhoto.imgParentId,
        //   );
        // },
        builder:
            (BuildContext context, GalleryProvider provider, Widget child) {
          if (widget.productList['images'] != null &&
              widget.productList['images'] != null) {
            return Container(
              color: Theme.of(context).cardColor,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CustomScrollView(shrinkWrap: true, slivers: <Widget>[
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150, childAspectRatio: 1.0),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return GalleryGridItem(
                            productList: widget.productList['images'][index],
                            onImageTap: () {
                              Navigator.push<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          GalleryView(
                                            indexx: index,
                                            productListss: widget.productList,
                                            // selectedDefaultImage: provider
                                            //     .galleryList.data[index],
                                            productList: widget
                                                .productList['images'][index],
                                          )));
                              // Navigator.pushNamed(
                              //     context, RoutePaths.galleryDetail,
                              //     arguments: provider.galleryList.data[index]);
                            });
                      },
                      childCount: widget.productList['images'].length,
                    ),
                  )
                ]),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
