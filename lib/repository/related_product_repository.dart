// import 'dart:async';
// import 'package:digitalproductstore/db/related_product_dao.dart';
// import 'package:digitalproductstore/viewobject/product.dart';
// import 'package:flutter/material.dart';
// import 'package:digitalproductstore/api/common/ps_resource.dart';
// import 'package:digitalproductstore/api/common/ps_status.dart';
// import 'package:digitalproductstore/api/ps_api_service.dart';

// import 'Common/ps_repository.dart';

// class RelatedProductRepository extends PsRepository {
//   RelatedProductRepository(
//       {@required PsApiService psApiService,
//       @required RelatedProductDao relatedProductDao}) {
//     _psApiService = psApiService;
//     _relatedProductDao = relatedProductDao;
//   }

//   String primaryKey = 'id';
//   PsApiService _psApiService;
//   RelatedProductDao _relatedProductDao;

//   void sinkRelatedProductListStream(
//       StreamController<PsResource<List<Product>>> relatedProductListStream,
//       PsResource<List<Product>> dataList) {
//     if (dataList != null) {
//       relatedProductListStream.sink.add(dataList);
//     }
//   }

//   Future<dynamic> insert(Product relatedProduct) async {
//     return _relatedProductDao.insert(primaryKey, relatedProduct);
//   }

//   Future<dynamic> update(Product relatedProduct) async {
//     return _relatedProductDao.update(relatedProduct);
//   }

//   Future<dynamic> delete(Product relatedProduct) async {
//     return _relatedProductDao.delete(relatedProduct);
//   }

//   Future<dynamic> getRelatedProductList(
//       StreamController<PsResource<List<Product>>> relatedProductListStream,
//       String productId,
//       String categoryId,
//       bool isConnectedToInternet,
//       int limit,
//       int offset,
//       PsStatus status,
//       {bool isLoadFromServer = true}) async {
//     sinkRelatedProductListStream(relatedProductListStream,
//         await _relatedProductDao.getAll(status: status));

//     if (isConnectedToInternet) {
//       final PsResource<List<Product>> _resource = await _psApiService
//           .getRelatedProductList(productId, categoryId, limit, offset);

//       if (_resource.status == PsStatus.SUCCESS) {
//         await _relatedProductDao.deleteAll();
//         await _relatedProductDao.insertAll(primaryKey, _resource.data);
//         sinkRelatedProductListStream(
//             relatedProductListStream, await _relatedProductDao.getAll());
//       }
//     }
//   }

//   Future<dynamic> getNextRelatedProductList(
//       StreamController<PsResource<List<Product>>> relatedProductListStream,
//       String productId,
//       String categoryId,
//       bool isConnectedToInternet,
//       int limit,
//       int offset,
//       PsStatus status,
//       {bool isLoadFromServer = true}) async {
//     sinkRelatedProductListStream(relatedProductListStream,
//         await _relatedProductDao.getAll(status: status));

//     if (isConnectedToInternet) {
//       final PsResource<List<Product>> _resource = await _psApiService
//           .getRelatedProductList(productId, categoryId, limit, offset);

//       if (_resource.status == PsStatus.SUCCESS) {
//         await _relatedProductDao.insertAll(primaryKey, _resource.data);
//       }
//       sinkRelatedProductListStream(
//           relatedProductListStream, await _relatedProductDao.getAll());
//     }
//   }
// }
