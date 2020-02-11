import 'dart:async';
import 'package:digitalproductstore/db/basket_dao.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';

import 'Common/ps_repository.dart';

class BasketRepository extends PsRepository {
  BasketRepository({@required BasketDao basketDao}) {
    _basketDao = basketDao;
  }

  String primaryKey = 'id';
  BasketDao _basketDao;

  Future<dynamic> insert(Product basket) async {
    return _basketDao.insert(primaryKey, basket);
  }

  Future<dynamic> update(Product basket) async {
    return _basketDao.update(basket);
  }

  Future<dynamic> delete(Product basket) async {
    return _basketDao.delete(basket);
  }

  Future<dynamic> getAllBasketList(
      StreamController<PsResource<List<Product>>> basketListStream,
      PsStatus status) async {
    // basketListStream.sink.add(await _basketDao.getAll(status: status));
    final dynamic subscription = _basketDao.getAllWithSubscription(
        status: PsStatus.SUCCESS,
        onDataUpdated: (List<Product> productList) {
          if (status != null && status != PsStatus.NOACTION) {
            print(status);
            basketListStream.sink
                .add(PsResource<List<Product>>(status, '', productList));
          } else {
            print('No Action');
          }
        });

    return subscription;
  }

  Future<dynamic> addAllBasketList(
      StreamController<PsResource<List<Product>>> basketListStream,
      PsStatus status,
      Product product) async {
    await _basketDao.insert(primaryKey, product);
    basketListStream.sink.add(await _basketDao.getAll(status: status));
  }

  Future<dynamic> deleteBasketByProduct(
      StreamController<PsResource<List<Product>>> basketListStream,
      Product product) async {
    await _basketDao.delete(product);
    basketListStream.sink
        .add(await _basketDao.getAll(status: PsStatus.SUCCESS));
  }

  Future<dynamic> deleteWholeBasketList(
      StreamController<PsResource<List<Product>>> basketListStream) async {
    await _basketDao.deleteAll();
    // basketListStream.sink
    //     .add(await _basketDao.getAll(status: PsStatus.SUCCESS));
  }
}
