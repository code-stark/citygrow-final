import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductList {
  final double sellingPrice;
  final double originalPrice;
  final int discountPrd;
  final String sellerUid;
  final String prdName;
  final String prdref;
  final String brand;
  final String category;
  final String uploderName;
  final List<dynamic> images;

  ProductList({
    this.sellingPrice,
    this.originalPrice,
    this.discountPrd,
    this.sellerUid,
    this.prdName,
    this.prdref,
    this.brand,
    this.category,
    this.uploderName,
    this.images,
  });
}
