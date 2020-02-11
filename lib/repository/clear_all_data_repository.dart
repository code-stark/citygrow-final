import 'dart:async';

import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/db/basket_dao.dart';
import 'package:digitalproductstore/db/blog_dao.dart';
import 'package:digitalproductstore/db/category_map_dao.dart';
import 'package:digitalproductstore/db/cateogry_dao.dart';
import 'package:digitalproductstore/db/comment_detail_dao.dart';
import 'package:digitalproductstore/db/comment_header_dao.dart';
import 'package:digitalproductstore/db/product_collection_header_dao.dart';
import 'package:digitalproductstore/db/product_dao.dart';
import 'package:digitalproductstore/db/product_map_dao.dart';
import 'package:digitalproductstore/db/rating_dao.dart';
import 'package:digitalproductstore/db/sub_category_dao.dart';
import 'package:digitalproductstore/db/transaction_detail_dao.dart';
import 'package:digitalproductstore/db/transaction_header_dao.dart';
import 'package:digitalproductstore/repository/Common/ps_repository.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/cupertino.dart';

class ClearAllDataRepository extends PsRepository {
  ClearAllDataRepository({
    @required BlogDao blogDao,
  }) {
    _blogDao = blogDao;
  }

  // PsApiService _psApiService;
  String primaryKey = 'id';
  BlogDao _blogDao;

  Future<dynamic> clearAllData(
      StreamController<PsResource<List<Product>>> allListStream) async {
    final ProductDao _productDao = ProductDao.instance;
    final CategoryDao _categoryDao = CategoryDao();
    final CommentHeaderDao _commentHeaderDao = CommentHeaderDao.instance;
    final CommentDetailDao _commentDetailDao = CommentDetailDao.instance;
    final BasketDao _basketDao = BasketDao.instance;
    final CategoryMapDao _categoryMapDao = CategoryMapDao.instance;
    final ProductCollectionDao _productCollectionDao =
        ProductCollectionDao.instance;
    final ProductMapDao _productMapDao = ProductMapDao.instance;
    final RatingDao _ratingDao = RatingDao.instance;
    final SubCategoryDao _subCategoryDao = SubCategoryDao();
    final TransactionHeaderDao _transactionHeaderDao =
        TransactionHeaderDao.instance;
    final TransactionDetailDao _transactionDetailDao =
        TransactionDetailDao.instance;
    await _productDao.deleteAll();
    await _blogDao.deleteAll();
    await _categoryDao.deleteAll();
    await _commentHeaderDao.deleteAll();
    await _commentDetailDao.deleteAll();
    await _basketDao.deleteAll();
    await _categoryMapDao.deleteAll();
    await _productCollectionDao.deleteAll();
    await _productMapDao.deleteAll();
    await _ratingDao.deleteAll();
    await _subCategoryDao.deleteAll();
    await _transactionHeaderDao.deleteAll();
    await _transactionDetailDao.deleteAll();

    allListStream.sink.add(await _productDao.getAll(status: PsStatus.SUCCESS));
  }
}
