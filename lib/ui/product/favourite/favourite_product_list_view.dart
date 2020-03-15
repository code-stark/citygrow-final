import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/model/user_model.dart';
import 'package:digitalproductstore/provider/product/favourite_product_provider.dart';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/ui/product/detail/product_detail_view.dart';
import 'package:digitalproductstore/ui/product/item/product_vertical_list_item.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteProductListView extends StatefulWidget {
  const FavouriteProductListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _FavouriteProductListView createState() => _FavouriteProductListView();
}

class _FavouriteProductListView extends State<FavouriteProductListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  FavouriteProductProvider _favouriteProductProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _favouriteProductProvider.nextFavouriteProductList();
      }
    });

    super.initState();
  }

  ProductRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    final Users users = Provider.of<Users>(context);
    data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    return EasyLocalizationProvider(
        data: data,
        child: ChangeNotifierProvider<FavouriteProductProvider>(
          create: (BuildContext context) {
            final FavouriteProductProvider provider = FavouriteProductProvider(
                repo: repo1, psValueHolder: psValueHolder);
            provider.loadFavouriteProductList();
            _favouriteProductProvider = provider;
            return _favouriteProductProvider;
          },
          child: Consumer<FavouriteProductProvider>(
            builder: (BuildContext context, FavouriteProductProvider provider,
                Widget child) {
              return StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('AppUsers')
                      .document(users.uid)
                      .collection('favorite')
                      .snapshots(),
                  builder: (context, favouriteData) {
                    if (!favouriteData.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final favData = favouriteData.data;
                    return Stack(children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(
                              left: ps_space_4,
                              right: ps_space_4,
                              top: ps_space_4,
                              bottom: ps_space_4),
                          child: RefreshIndicator(
                            child: CustomScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                slivers: <Widget>[
                                  SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 220,
                                            childAspectRatio: 0.6),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        if (favData.documents != null ||
                                            favData.documents.isNotEmpty) {
                                          final int count =
                                              favData.documents.length;
                                          return ProductVeticalListItem(
                                            productList:
                                                favData.documents[index],
                                            animationController:
                                                widget.animationController,
                                            animation: Tween<double>(
                                                    begin: 0.0, end: 1.0)
                                                .animate(
                                              CurvedAnimation(
                                                parent:
                                                    widget.animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn),
                                              ),
                                            ),
                                            // product: provider
                                            //     .favouriteProductList
                                            //     .data[index],
                                            onTap: () async {
                                              // await Navigator.pushNamed(context,
                                              //     RoutePaths.productDetail,
                                              //     arguments: provider
                                              //         .favouriteProductList
                                              //         .data[index]);
                                              Navigator.pushReplacement<dynamic,
                                                      dynamic>(
                                                  context,
                                                  MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProductDetailView(
                                                            // product: provider
                                                            //     .favouriteProductList
                                                            //     .data[index],
                                                            productList: favData
                                                                .documents[
                                                                    index]
                                                                .data[index],
                                                          )));
                                              // await provider
                                              //     .resetFavouriteProductList();
                                            },
                                          );
                                        } else {
                                          return null;
                                        }
                                      },
                                      childCount: favData.documents.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              return provider.resetFavouriteProductList();
                            },
                          )),
                      PSProgressIndicator(provider.favouriteProductList.status)
                    ]);
                  });
            },
          ),
        ));
  }
}
