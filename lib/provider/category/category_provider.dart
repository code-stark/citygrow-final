import 'dart:async';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/api_status.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/category_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';
import 'package:digitalproductstore/repository/category_repository.dart';
import 'package:digitalproductstore/viewobject/category.dart';

class CategoryProvider extends PsProvider {
  CategoryProvider(
      {@required CategoryRepository repo, @required this.psValueHolder})
      : super(repo) {
    _repo = repo;

    //isDispose = false;
    print('Category Provider: $hashCode');

    utilsCheckInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    categoryListStream =
        StreamController<PsResource<List<Category>>>.broadcast();
    subscription =
        categoryListStream.stream.listen((PsResource<List<Category>> resource) {
      updateOffset(resource.data.length);

      _categoryList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<PsResource<List<Category>>> categoryListStream;
  final CategoryParameterHolder category = CategoryParameterHolder();

  CategoryRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<Category>> _categoryList =
      PsResource<List<Category>>(PsStatus.NOACTION, '', <Category>[]);

  PsResource<List<Category>> get categoryList => _categoryList;
  StreamSubscription<PsResource<List<Category>>> subscription;

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;
  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    isDispose = true;
    print('Category Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadCategoryList(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await utilsCheckInternetConnectivity();

    await _repo.getCategoryList(
        categoryListStream,
        isConnectedToInternet,
        limit,
        offset,
        CategoryParameterHolder().getLatestParameterHolder(),
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> loadAllCategoryList(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await utilsCheckInternetConnectivity();

    await _repo.getAllCategoryList(
        categoryListStream,
        isConnectedToInternet,
        CategoryParameterHolder().getLatestParameterHolder(),
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextCategoryList(Map<dynamic, dynamic> jsonMap) async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageCategoryList(
          categoryListStream,
          isConnectedToInternet,
          limit,
          offset,
          CategoryParameterHolder().getLatestParameterHolder(),
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetCategoryList(Map<dynamic, dynamic> jsonMap) async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getCategoryList(
        categoryListStream,
        isConnectedToInternet,
        limit,
        offset,
        CategoryParameterHolder().getLatestParameterHolder(),
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> postTouchCount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await utilsCheckInternetConnectivity();

    _apiStatus = await _repo.postTouchCount(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
