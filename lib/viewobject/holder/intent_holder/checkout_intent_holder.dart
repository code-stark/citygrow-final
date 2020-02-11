import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/cupertino.dart';

class CheckoutIntentHolder {
  const CheckoutIntentHolder({
    @required this.productList,
    @required this.publishKey,
  });
  final List<Product> productList;
  final String publishKey;
}
