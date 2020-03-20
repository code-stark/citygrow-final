import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/cupertino.dart';

class CheckoutIntentHolder {
  const CheckoutIntentHolder({
    @required this.productList,
    @required this.cartList,
    @required this.publishKey,
  });
  final List<Product> productList;
  final List<DocumentSnapshot> cartList;
  final String publishKey;
}
