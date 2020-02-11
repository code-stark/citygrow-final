import 'dart:async';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/repository/transaction_header_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:digitalproductstore/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';

class TransactionHeaderProvider extends PsProvider {
  TransactionHeaderProvider(
      {@required TransactionHeaderRepository repo,
      @required this.psValueHolder})
      : super(repo) {
    _repo = repo;

    print('Transaction Header Provider: $hashCode');

    utilsCheckInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    transactionListStream =
        StreamController<PsResource<List<TransactionHeader>>>.broadcast();
    subscription = transactionListStream.stream
        .listen((PsResource<List<TransactionHeader>> resource) {
      updateOffset(resource.data.length);

      _transactionList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  TransactionHeaderRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<TransactionHeader> _transactionSubmit =
      PsResource<TransactionHeader>(PsStatus.NOACTION, '', null);

  PsResource<List<TransactionHeader>> _transactionList =
      PsResource<List<TransactionHeader>>(
          PsStatus.NOACTION, '', <TransactionHeader>[]);

  PsResource<List<TransactionHeader>> get transactionList => _transactionList;
  StreamSubscription<PsResource<List<TransactionHeader>>> subscription;
  StreamController<PsResource<List<TransactionHeader>>> transactionListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Transaction Header Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadTransactionList(String userId) async {
    isLoading = true;

    isConnectedToInternet = await utilsCheckInternetConnectivity();
    await _repo.getAllTransactionList(
        transactionListStream,
        isConnectedToInternet,
        userId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextTransactionList() async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageTransactionList(
          transactionListStream,
          isConnectedToInternet,
          psValueHolder.loginUserId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetTransactionList() async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllTransactionList(
        transactionListStream,
        isConnectedToInternet,
        psValueHolder.loginUserId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> postTransactionSubmit(
      String userName,
      String userPhone,
      List<Product> produtList,
      String clientNonce,
      String couponDiscount,
      String taxAmount,
      String totalDiscount,
      String subTotalAmount,
      String balanceAmount,
      String totalItemAmount,
      String isPaypal,
      String isStripe,
      String isBank) async {
    final List<Map<String, dynamic>> detailJson = <Map<String, dynamic>>[];
    for (int i = 0; i < produtList.length; i++) {
      final DetailMap carJson = DetailMap(
        produtList[i].id,
        produtList[i].name,
        produtList[i].unitPrice,
        produtList[i].originalPrice,
        produtList[i].discountAmount,
        produtList[i].discountAmount,
        '1',
        produtList[i].discountValue,
        produtList[i].discountPercent,
        produtList[i].currencyShortForm,
        produtList[i].currencySymbol,
      );
      detailJson.add(carJson.tojsonData());
    }

    final TransactionSubmitMap newPost = TransactionSubmitMap(
      userId: psValueHolder.loginUserId,
      subTotalAmount: subTotalAmount,
      discountAmount: totalDiscount,
      couponDiscountAmount: couponDiscount,
      taxAmount: taxAmount,
      balanceAmount: balanceAmount,
      totalItemAmount: totalItemAmount,
      contactName: userName,
      contactPhone: userPhone,
      isPaypal: isPaypal == ONE ? ONE : ZERO,
      isStripe: isStripe == ONE ? ONE : ZERO,
      isBank: isBank == ONE ? ONE : ZERO,
      paymentMethodNonce: clientNonce,
      transStatusId: '3', // 3 = completed
      currencySymbol: '\$',
      currencyShortForm: 'USD',
      taxPercent: psValueHolder.overAllTaxLabel,
      memo: '',
      details: detailJson,
    );
    isLoading = true;

    isConnectedToInternet = await utilsCheckInternetConnectivity();

    _transactionSubmit = await _repo.postTransactionSubmit(
        newPost.toMap(), isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _transactionSubmit;
  }
}

class DetailMap {
  DetailMap(
    this.productId,
    this.productName,
    this.unitPrice,
    this.originalPrice,
    this.discountPrice,
    this.discountAmount,
    this.qty,
    this.discountValue,
    this.discountPercent,
    this.currencyShortForm,
    this.currencySymbol,
  );
  String productId,
      productName,
      unitPrice,
      originalPrice,
      discountPrice,
      discountAmount,
      qty,
      discountValue,
      discountPercent,
      currencyShortForm,
      currencySymbol;

  Map<String, dynamic> tojsonData() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['product_id'] = productId;
    map['product_name'] = productName;
    map['unit_price'] = unitPrice;
    map['original_price'] = originalPrice;
    map['discount_price'] = discountPrice;
    map['discount_amount'] = discountAmount;
    map['qty'] = qty;
    map['discount_value'] = discountValue;
    map['discount_percent'] = discountPercent;
    map['currency_short_form'] = currencyShortForm;
    map['currency_symbol'] = currencySymbol;
    return map;
  }
}

class TransactionSubmitMap {
  TransactionSubmitMap(
      {this.userId,
      this.subTotalAmount,
      this.discountAmount,
      this.couponDiscountAmount,
      this.taxAmount,
      this.balanceAmount,
      this.totalItemAmount,
      this.contactName,
      this.contactPhone,
      this.isPaypal,
      this.isStripe,
      this.isBank,
      this.paymentMethodNonce,
      this.transStatusId,
      this.currencySymbol,
      this.currencyShortForm,
      this.taxPercent,
      this.memo,
      this.details});

  String userId;
  String subTotalAmount;
  String discountAmount;
  String couponDiscountAmount;
  String taxAmount;
  String balanceAmount;
  String totalItemAmount;
  String contactName;
  String contactPhone;
  String isPaypal;
  String isStripe;
  String isBank;
  String paymentMethodNonce;
  String transStatusId;
  String currencySymbol;
  String currencyShortForm;
  String taxPercent;
  String memo;
  List<Map<String, dynamic>> details;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['user_id'] = userId;
    map['sub_total_amount'] = subTotalAmount;
    map['discount_amount'] = discountAmount;
    map['coupon_discount_amount'] = couponDiscountAmount;
    map['tax_amount'] = taxAmount;
    map['balance_amount'] = balanceAmount;
    map['total_item_amount'] = totalItemAmount;
    map['contact_name'] = contactName;
    map['contact_phone'] = contactPhone;
    map['is_paypal'] = isPaypal;
    map['is_stripe'] = isStripe;
    map['is_bank'] = isBank;
    map['payment_method_nonce'] = paymentMethodNonce;
    map['trans_status_id'] = transStatusId;
    map['currency_symbol'] = currencySymbol;
    map['currency_short_form'] = currencyShortForm;
    map['tax_percent'] = taxPercent;
    map['memo'] = memo;
    map['details'] = details;

    return map;
  }
}
