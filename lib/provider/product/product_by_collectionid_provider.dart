import 'dart:async';

import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/cupertino.dart';

class ProductByCollectionIdProvider extends PsProvider {
  ProductByCollectionIdProvider(
      {@required ProductRepository repo, @required this.psValueHolder})
      : super(repo) {
    _repo = repo;

    print('Product By Collection Provider: $hashCode');

    utilsCheckInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productCollectionListStream =
        StreamController<PsResource<List<Product>>>.broadcast();
    subscription = productCollectionListStream.stream
        .listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _productCollectionList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<Product>>> productCollectionListStream;

  ProductRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<Product>> _productCollectionList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get productCollectionList => _productCollectionList;
  StreamSubscription<PsResource<List<Product>>> subscription;

  @override
  void dispose() {
    subscription.cancel();
    productCollectionListStream.close();
    isDispose = true;
    print('Product By Collection Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductListByCollectionId(String collectionId) async {
    isLoading = true;

    isConnectedToInternet = await utilsCheckInternetConnectivity();
    await _repo.getAllproductListByCollectionId(
        productCollectionListStream,
        isConnectedToInternet,
        collectionId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextProductListByCollectionId(String collectionId) async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageproductListByCollectionId(
          productCollectionListStream,
          isConnectedToInternet,
          collectionId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetProductListByCollectionId(String collectionId) async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllproductListByCollectionId(
        productCollectionListStream,
        isConnectedToInternet,
        collectionId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
