import 'dart:async';
import 'package:digitalproductstore/repository/coupon_discount_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/coupon_discount.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';

class CouponDiscountProvider extends PsProvider {
  CouponDiscountProvider({@required CouponDiscountRepository repo})
      : super(repo) {
    _repo = repo;
    print('CouponDiscount Provider: $hashCode');

    utilsCheckInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  CouponDiscountRepository _repo;

  PsResource<CouponDiscount> _couponDiscount =
      PsResource<CouponDiscount>(PsStatus.NOACTION, '', null);
  PsResource<CouponDiscount> get user => _couponDiscount;
  @override
  void dispose() {
    isDispose = true;
    print('CouponDiscount Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postCouponDiscount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await utilsCheckInternetConnectivity();

    _couponDiscount = await _repo.postCouponDiscount(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _couponDiscount;
  }
}
