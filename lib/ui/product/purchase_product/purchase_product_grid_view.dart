import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/product/purchased_product_provider.dart';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/ui/product/item/product_vertical_list_item.dart';

import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class PurchasedProductGridView extends StatefulWidget {
//   const PurchasedProductGridView({Key key, @required this.animationController})
//       : super(key: key);
//   final AnimationController animationController;
//   @override
//   _PurchasedProductGridView createState() => _PurchasedProductGridView();
// }

// class _PurchasedProductGridView extends State<PurchasedProductGridView>
//     with TickerProviderStateMixin {
//   ProductRepository repo1;
//   PsValueHolder psValueHolder;
//   dynamic data;
//   final ScrollController _scrollController = ScrollController();
//   PurchasedProductProvider _purchasedProductProvider;
//   Animation<double> animation;
//   @override
//   void initState() {
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         _purchasedProductProvider.nextPurchasedProductList();
//       }
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     animation = null;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     repo1 = Provider.of<ProductRepository>(context);
//     data = EasyLocalizationProvider.of(context).data;
//     psValueHolder = Provider.of<PsValueHolder>(context);
//     print(
//         '............................Build UI Again ............................');
//     return EasyLocalizationProvider(
//       data: data,
//       child: ChangeNotifierProvider<PurchasedProductProvider>(
//         create: (BuildContext context) {
//           final PurchasedProductProvider provider = PurchasedProductProvider(
//               repo: repo1, psValueHolder: psValueHolder);
//           provider.loadPurchasedProductList();
//           _purchasedProductProvider = provider;
//           return _purchasedProductProvider;
//         },
//         child: Consumer<PurchasedProductProvider>(
//           builder: (BuildContext context, PurchasedProductProvider provider,
//               Widget child) {
//             return Stack(children: <Widget>[
//               Container(
//                   margin: const EdgeInsets.only(
//                       left: ps_space_4,
//                       right: ps_space_4,
//                       top: ps_space_4,
//                       bottom: ps_space_4),
//                   child: RefreshIndicator(
//                     child: CustomScrollView(
//                         controller: _scrollController,
//                         scrollDirection: Axis.vertical,
//                         shrinkWrap: true,
//                         slivers: <Widget>[
//                           SliverGrid(
//                             gridDelegate:
//                                 const SliverGridDelegateWithMaxCrossAxisExtent(
//                                     maxCrossAxisExtent: ps_space_220,
//                                     childAspectRatio: 0.6),
//                             delegate: SliverChildBuilderDelegate(
//                               (BuildContext context, int index) {
//                                 widget.animationController.forward();

//                                 if (provider.purchasedProductList.data !=
//                                         null ||
//                                     provider
//                                         .purchasedProductList.data.isNotEmpty) {
//                                   final int count =
//                                       provider.purchasedProductList.data.length;
//                                   return ProductVeticalListItem(
//                                     animationController:
//                                         widget.animationController,
//                                     animation:
//                                         Tween<double>(begin: 0.0, end: 1.0)
//                                             .animate(
//                                       CurvedAnimation(
//                                         parent: widget.animationController,
//                                         curve: Interval(
//                                             (1 / count) * index, 1.0,
//                                             curve: Curves.fastOutSlowIn),
//                                       ),
//                                     ),
//                                     product: provider
//                                         .purchasedProductList.data[index],
//                                     onTap: () async {
//                                       print(provider.purchasedProductList
//                                           .data[index].defaultPhoto.imgPath);
//                                       Navigator.pushNamed(
//                                           context, RoutePaths.productDetail,
//                                           arguments: provider
//                                               .purchasedProductList
//                                               .data[index]);

//                                       // return provider
//                                       //     .resetPurchasedProductList();
//                                     },
//                                   );
//                                 } else {
//                                   return null;
//                                 }
//                               },
//                               childCount:
//                                   provider.purchasedProductList.data.length,
//                             ),
//                           ),
//                         ]),
//                     onRefresh: () {
//                       return provider.resetPurchasedProductList();
//                     },
//                   )),
//               PSProgressIndicator(provider.purchasedProductList.status)
//             ]);
//           },
//         ),
//       ),
//     );
//   }
// }
class PurchasedProductGridView extends StatefulWidget {
  const PurchasedProductGridView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _PurchasedProductGridView createState() => _PurchasedProductGridView();
}

class _PurchasedProductGridView extends State<PurchasedProductGridView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  PurchasedProductProvider _purchasedProductProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _purchasedProductProvider.nextPurchasedProductList();
      }
    });

    super.initState();
  }

  ProductRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    return EasyLocalizationProvider(
        data: data,
        child: ChangeNotifierProvider<PurchasedProductProvider>(
          create: (BuildContext context) {
            final PurchasedProductProvider provider = PurchasedProductProvider(
                repo: repo1, psValueHolder: psValueHolder);
            provider.loadPurchasedProductList();
            _purchasedProductProvider = provider;
            return _purchasedProductProvider;
          },
          child: Consumer<PurchasedProductProvider>(
            builder: (BuildContext context, PurchasedProductProvider provider,
                Widget child) {
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
                                  if (provider.purchasedProductList.data !=
                                          null ||
                                      provider.purchasedProductList.data
                                          .isNotEmpty) {
                                    final int count = provider
                                        .purchasedProductList.data.length;
                                    return ProductVeticalListItem(
                                      animationController:
                                          widget.animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: widget.animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      product: provider
                                          .purchasedProductList.data[index],
                                      onTap: () async {
                                        // final dynamic returnData =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.productDetail,
                                            arguments: provider
                                                .purchasedProductList
                                                .data[index]);

                                        await provider
                                            .resetPurchasedProductList();
                                      },
                                    );
                                  } else {
                                    return null;
                                  }
                                },
                                childCount:
                                    provider.purchasedProductList.data.length,
                              ),
                            ),
                          ]),
                      onRefresh: () {
                        return provider.resetPurchasedProductList();
                      },
                    )),
                PSProgressIndicator(provider.purchasedProductList.status)
              ]);
            },
          ),
        ));
  }
}
