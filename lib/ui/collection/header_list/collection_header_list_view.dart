import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/productcollection/product_collection_provider.dart';
import 'package:digitalproductstore/repository/product_collection_repository.dart';
import 'package:digitalproductstore/ui/collection/item/collection_header_list_item.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/ui/product/collection_product/product_list_by_collection_id_view.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionHeaderListView extends StatefulWidget {
  const CollectionHeaderListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  State<StatefulWidget> createState() => _CollectionHeaderListItem();
}

class _CollectionHeaderListItem extends State<CollectionHeaderListView> {
  final ScrollController _scrollController = ScrollController();
  ProductCollectionProvider _productCollectionProvider;
  ProductCollectionRepository productCollectionRepository;
  PsValueHolder psValueHolder;
  dynamic data;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _productCollectionProvider.nextProductCollectionList();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = EasyLocalizationProvider.of(context).data;
    productCollectionRepository =
        Provider.of<ProductCollectionRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return EasyLocalizationProvider(
      data: data,
      child: ChangeNotifierProvider<ProductCollectionProvider>(
        create: (BuildContext context) {
          final ProductCollectionProvider provider =
              ProductCollectionProvider(repo: productCollectionRepository);
          provider.loadProductCollectionList();
          _productCollectionProvider = provider;
          return _productCollectionProvider;
        },
        child: Consumer<ProductCollectionProvider>(builder:
            (BuildContext context, ProductCollectionProvider provider,
                Widget child) {
          return Stack(
            children: <Widget>[
              Container(
                child: RefreshIndicator(
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: provider.productCollectionList.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (provider.productCollectionList.data != null ||
                            provider.productCollectionList.data.isEmpty) {
                          final int count =
                              provider.productCollectionList.data.length;
                          return CollectionHeaderListItem(
                            animationController: widget.animationController,
                            animation:
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn),
                              ),
                            ),
                            productCollectionHeader:
                                provider.productCollectionList.data[index],
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.productListByCollectionId,
                                  arguments: ProductListByCollectionIdView(
                                    productCollectionHeader: provider
                                        .productCollectionList.data[index],
                                    appBarTitle: provider
                                        .productCollectionList.data[index].name,
                                  ));
                            },
                          );
                        } else {
                          return null;
                        }
                      }),
                  onRefresh: () {
                    return provider.resetProductCollectionList();
                  },
                ),
              ),
              PSProgressIndicator(provider.productCollectionList.status)
            ],
          );
        }),
      ),
    );
  }
}
