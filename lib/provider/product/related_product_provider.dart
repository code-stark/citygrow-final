import 'dart:async';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';

class RelatedProductProvider extends PsProvider {
  RelatedProductProvider(
      {@required ProductRepository repo, @required this.psValueHolder})
      : super(repo) {
    _repo = repo;
    print('RelatedProductProvider : $hashCode');

    utilsCheckInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    relatedProductListStream =
        StreamController<PsResource<List<Product>>>.broadcast();
    subscription = relatedProductListStream.stream
        .listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _relatedProductList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  PsValueHolder psValueHolder;
  ProductRepository _repo;

  PsResource<List<Product>> _relatedProductList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get relatedProductList => _relatedProductList;
  StreamSubscription<PsResource<List<Product>>> subscription;
  StreamController<PsResource<List<Product>>> relatedProductListStream;

  @override
  void dispose() {
    subscription.cancel();
    print('Related Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadRelatedProductList(
    String productId,
    String categoryId,
  ) async {
    isLoading = true;

    limit = 10;
    offset = 0;

    isConnectedToInternet = await utilsCheckInternetConnectivity();
    await _repo.getRelatedProductList(
        relatedProductListStream,
        productId,
        categoryId,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  // Future<dynamic> nextRelatedProductList(
  //   String productId,
  //   String categoryId,
  // ) async {
  //   isConnectedToInternet = await utilsCheckInternetConnectivity();

  //   if (!isLoading && !isReachMaxData) {
  //     super.isLoading = true;
  //     _repo.getNextRelatedProductList(
  //         relatedProductListStream,
  //         productId,
  //         categoryId,
  //         isConnectedToInternet,
  //         limit,
  //         offset,
  //         PsStatus.PROGRESS_LOADING);
  //   }
  // }

  // Future<void> resetRelatedProductList(
  //   String productId,
  //   String categoryId,
  // ) async {
  //   isConnectedToInternet = await utilsCheckInternetConnectivity();
  //   isLoading = true;

  //   updateOffset(0);

  //   _repo.getRelatedProductList(relatedProductListStream, productId, categoryId,
  //       isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

  //   isLoading = false;
  // }
}
