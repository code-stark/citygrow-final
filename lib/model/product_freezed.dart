import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'product_freezed.freezed.dart';

@freezed
abstract class Product implements _$Product {
  const Product._();
  const factory Product(
      {@required double sellingPrice,
      @required double originalPrice,
      @required int discountPrd,
      @required String sellerUid,
      @required String prdName,
      @required String prdref,
      @required String brand,
      @required String category,
      @required String uploderName,
      @required List<String> images}) = _Product;
  static Product empty() {
    return Product(
        brand: '',
        category: '',
        discountPrd: 0,
        images: <String>[],
        originalPrice: 0,
        prdref: '',
        prdName: '',
        sellerUid: '',
        sellingPrice: 0,
        uploderName: '');
  }

  static List<Product> fromDocument(QuerySnapshot document) {
    if (document == null || document == null) return null;
    return document.documents.map((e) {
      return Product(
          brand: null,
          category: null,
          discountPrd: null,
          images: <String>[],
          originalPrice: null,
          prdName: null,
          prdref: null,
          sellerUid: null,
          sellingPrice: null,
          uploderName: null);
    });
  }

  // List<Product> datarefer(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((doc) {
  //     return Product(
  //         brand: null,
  //         category: null,
  //         discountPrd: null,
  //         images: <String>[],
  //         originalPrice: null,
  //         prdName: null,
  //         prdref: null,
  //         sellerUid: null,
  //         sellingPrice: null,
  //         uploderName: null);
  //   }).toList();
  // }

  // Stream<List<Product>> get documentSnapshot {
  //   return Firestore.instance
  //       .collection("ProductListID")
  //       .snapshots()
  //       .map(datarefer);
  // }
}
