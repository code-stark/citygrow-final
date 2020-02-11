import 'dart:async';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/download_product.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';

class ProductDetailProvider extends PsProvider {
  ProductDetailProvider(
      {@required ProductRepository repo, @required this.psValueHolder})
      : super(repo) {
    _repo = repo;
    print('ProductDetailProvider : $hashCode');

    utilsCheckInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productDetailStream = StreamController<PsResource<Product>>.broadcast();
    subscription =
        productDetailStream.stream.listen((PsResource<Product> resource) {
      _product = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ProductRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<Product> _product =
      PsResource<Product>(PsStatus.NOACTION, '', null);

  PsResource<Product> get productDetail => _product;
  StreamSubscription<PsResource<Product>> subscription;
  StreamController<PsResource<Product>> productDetailStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Product Detail Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProduct(
    String productId,
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await utilsCheckInternetConnectivity();

    await _repo.getProductDetail(productDetailStream, productId, loginUserId,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> loadProductForFav(
    String productId,
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await utilsCheckInternetConnectivity();

    await _repo.getProductDetailForFav(productDetailStream, productId,
        loginUserId, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextProduct(
    String productId,
    String loginUserId,
  ) async {
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      isConnectedToInternet = await utilsCheckInternetConnectivity();
      await _repo.getProductDetail(productDetailStream, productId, loginUserId,
          isConnectedToInternet, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetProductDetail(
    String productId,
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await utilsCheckInternetConnectivity();
    await _repo.getProductDetail(productDetailStream, productId, loginUserId,
        isConnectedToInternet, PsStatus.BLOCK_LOADING);

    isLoading = false;
  }

  PsResource<List<DownloadProduct>> _downloadProduct =
      PsResource<List<DownloadProduct>>(PsStatus.NOACTION, '', null);
  PsResource<List<DownloadProduct>> get user => _downloadProduct;

  Future<dynamic> postDownloadProductList(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await utilsCheckInternetConnectivity();

    _downloadProduct = await _repo.postDownloadProductList(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _downloadProduct;
  }
}
