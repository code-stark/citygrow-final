import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/viewobject/common/ps_object.dart';

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
  final List<String> images;

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
  Stream<List<ProductList>> get productSnapshot {
    return Firestore.instance
        .collection('ProductListID')
        .snapshots()
        .map(lollol);
  }

  List<ProductList> lollol(QuerySnapshot snapshot) {
    if (snapshot == null) {
      return null;
    }

    return snapshot.documents.map((DocumentSnapshot doc) {
      return ProductList(
        sellingPrice: doc['sellingPrice'] ?? 0.0,
        originalPrice: doc['originalPrice'] ?? 0.0,
        discountPrd: doc['discountPrd'] ?? 1,
        sellerUid: doc['sellerUid'] ?? '',
        prdName: doc['prdName'] ?? '',
        prdref: doc['prdref'] ?? '',
        brand: doc['brand'] ?? '',
        category: doc['category'] ?? '',
        uploderName: doc['uploderName'] ?? '',
        images: List<String>.from(doc['images'] ?? ''),
      );
    }).toList();
  }
}
