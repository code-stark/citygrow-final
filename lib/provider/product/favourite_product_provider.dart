import 'dart:async';

import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/cupertino.dart';

class FavouriteProductProvider extends PsProvider {
  FavouriteProductProvider(
      {@required ProductRepository repo, @required this.psValueHolder})
      : super(repo) {
    _repo = repo;

    print('Favourite Product Provider: $hashCode');

    utilsCheckInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    favouriteListStream =
        StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        favouriteListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _productList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<Product>>> favouriteListStream;

  ProductRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<Product> _favourite =
      PsResource<Product>(PsStatus.NOACTION, '', null);
  PsResource<Product> get user => _favourite;

  PsResource<List<Product>> _productList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get favouriteProductList => _productList;
  StreamSubscription<PsResource<List<Product>>> subscription;

  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    favouriteListStream.close();
    isDispose = true;
    print('Favourite Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadFavouriteProductList() async {
    isLoading = true;

    isConnectedToInternet = await utilsCheckInternetConnectivity();
    await _repo.getAllFavouritesList(
        favouriteListStream,
        psValueHolder.loginUserId,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextFavouriteProductList() async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageFavouritesList(
          favouriteListStream,
          psValueHolder.loginUserId,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetFavouriteProductList() async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllFavouritesList(
        favouriteListStream,
        psValueHolder.loginUserId,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> postFavourite(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await utilsCheckInternetConnectivity();

    _favourite = await _repo.postFavourite(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _favourite;
  }
}
