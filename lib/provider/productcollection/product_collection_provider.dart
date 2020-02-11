import 'dart:async';

import 'package:digitalproductstore/repository/product_collection_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/product_collection_header.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';

class ProductCollectionProvider extends PsProvider {
  ProductCollectionProvider({@required ProductCollectionRepository repo})
      : super(repo) {
    _repo = repo;
    print('ProductCollection Provider: $hashCode');
    utilsCheckInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productCollectionListStream =
        StreamController<PsResource<List<ProductCollectionHeader>>>.broadcast();
    subscription =
        productCollectionListStream.stream.listen((dynamic resource) {
      //Utils.psPrint("ProductCollectionHeader Provider : ");

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

    productCollectionStream =
        StreamController<PsResource<ProductCollectionHeader>>.broadcast();
    subscriptionById =
        productCollectionStream.stream.listen((dynamic resource) {
      _productCollection = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ProductCollectionRepository _repo;

  PsResource<List<ProductCollectionHeader>> _productCollectionList =
      PsResource<List<ProductCollectionHeader>>(
          PsStatus.NOACTION, '', <ProductCollectionHeader>[]);

  PsResource<ProductCollectionHeader> _productCollection =
      PsResource<ProductCollectionHeader>(PsStatus.NOACTION, '', null);

  PsResource<List<ProductCollectionHeader>> get productCollectionList =>
      _productCollectionList;

  PsResource<ProductCollectionHeader> get productCollection =>
      _productCollection;

  StreamSubscription<PsResource<List<ProductCollectionHeader>>> subscription;
  StreamController<PsResource<List<ProductCollectionHeader>>>
      productCollectionListStream;

  StreamSubscription<PsResource<ProductCollectionHeader>> subscriptionById;
  StreamController<PsResource<ProductCollectionHeader>> productCollectionStream;
  @override
  void dispose() {
    subscription.cancel();
    subscriptionById.cancel();
    isDispose = true;
    print('Product Collection Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductCollectionList() async {
    isLoading = true;
    isConnectedToInternet = await utilsCheckInternetConnectivity();
    await _repo.getProductCollectionList(productCollectionListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextProductCollectionList() async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageProductCollectionList(productCollectionListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetProductCollectionList() async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getProductCollectionList(productCollectionListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
