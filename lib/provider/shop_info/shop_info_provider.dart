import 'dart:async';
import 'package:digitalproductstore/repository/shop_info_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/shop_info.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';

class ShopInfoProvider extends PsProvider {
  ShopInfoProvider(
      {@required ShopInfoRepository repo,
      @required this.psValueHolder,
      @required this.ownerCode})
      : super(repo) {
    _repo = repo;

    print('ShopInfo Provider: $hashCode ($ownerCode) ');

    utilsCheckInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    shopInfoListStream = StreamController<PsResource<ShopInfo>>.broadcast();
    subscription =
        shopInfoListStream.stream.listen((PsResource<ShopInfo> resource) {
      _shopInfo = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        // Update to share preference
        // To submit tax and shipping tax to transaction

        if (_shopInfo != null && shopInfo.data != null) {
          replaceTransactionValueHolderData(
              _shopInfo.data.overallTaxLabel,
              _shopInfo.data.overallTaxValue,
              _shopInfo.data.shippingTaxLabel,
              _shopInfo.data.shippingTaxValue);
          replaceCheckoutEnable(
              _shopInfo.data.paypalEnabled,
              _shopInfo.data.stripeEnabled,
              _shopInfo.data.codEmail,
              _shopInfo.data.banktransferEnabled);
          replacePublishKey(_shopInfo.data.stripePublishableKey);

          notifyListeners();
        }
      }
    });
  }

  ShopInfoRepository _repo;
  PsValueHolder psValueHolder;
  String ownerCode;

  PsResource<ShopInfo> _shopInfo =
      PsResource<ShopInfo>(PsStatus.NOACTION, '', null);

  PsResource<ShopInfo> get shopInfo => _shopInfo;
  StreamSubscription<PsResource<ShopInfo>> subscription;
  StreamController<PsResource<ShopInfo>> shopInfoListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('ShopInfo Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShopInfo() async {
    isLoading = true;
    isConnectedToInternet = await utilsCheckInternetConnectivity();

    await _repo.getShopInfo(
        shopInfoListStream, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextShopInfoList() async {
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      isConnectedToInternet = await utilsCheckInternetConnectivity();
      await _repo.getShopInfo(
          shopInfoListStream, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetShopInfoList() async {
    isLoading = true;
    isConnectedToInternet = await utilsCheckInternetConnectivity();
    await _repo.getShopInfo(
        shopInfoListStream, isConnectedToInternet, PsStatus.BLOCK_LOADING);

    isLoading = false;
  }
}
