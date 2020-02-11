import 'dart:async';
import 'package:digitalproductstore/repository/basket_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';
import 'helper/checkout_calculation_helper.dart';

class BasketProvider extends PsProvider {
  BasketProvider({@required BasketRepository repo, this.psValueHolder})
      : super(repo) {
    _repo = repo;
    print('Basket Provider: $hashCode');
    basketListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        basketListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _basketList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<PsResource<List<Product>>> basketListStream;
  BasketRepository _repo;
  PsValueHolder psValueHolder;
  dynamic daoSubscription;

  PsResource<List<Product>> _basketList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get basketList => _basketList;
  StreamSubscription<PsResource<List<Product>>> subscription;

  final CheckoutCalculationHelper checkoutCalculationHelper =
      CheckoutCalculationHelper();

  @override
  void dispose() {
    subscription.cancel();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Basket Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadBasketList() async {
    isLoading = true;
    daoSubscription = await _repo.getAllBasketList(
        basketListStream, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> addBasketList(Product product) async {
    isLoading = true;
    await _repo.addAllBasketList(
      basketListStream,
      PsStatus.PROGRESS_LOADING,
      product,
    );
  }

  Future<dynamic> deleteBasketByProduct(Product product) async {
    isLoading = true;
    await _repo.deleteBasketByProduct(basketListStream, product);
  }

  Future<dynamic> deleteWholeBasketList() async {
    isLoading = true;
    await _repo.deleteWholeBasketList(basketListStream);
  }

  Future<void> resetBasketList() async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    _repo.getAllBasketList(
      basketListStream,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
