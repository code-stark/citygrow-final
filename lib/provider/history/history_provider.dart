import 'dart:async';
import 'package:digitalproductstore/repository/history_repsitory.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';

class HistoryProvider extends PsProvider {
  HistoryProvider({@required HistoryRepository repo}) : super(repo) {
    _repo = repo;
    print('History Provider: $hashCode');

    historyListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        historyListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _historyList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  HistoryRepository _repo;

  PsResource<List<Product>> _historyList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get historyList => _historyList;
  StreamSubscription<PsResource<List<Product>>> subscription;
  StreamController<PsResource<List<Product>>> historyListStream;
  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    isDispose = true;
    print('History Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadHistoryList() async {
    isLoading = true;
    await _repo.getAllHistoryList(historyListStream, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> addHistoryList(Product product) async {
    isLoading = true;
    await _repo.addAllHistoryList(
        historyListStream, PsStatus.PROGRESS_LOADING, product);
  }

  // Future<dynamic> nextHistoryList() async {
  //   isConnectedToInternet = await utilsCheckInternetConnectivity();

  //   if (!isLoading && !isReachMaxData) {
  //     super.isLoading = true;
  //     _repo.getNextPageHistoryList(
  //         isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  //   }
  // }

  Future<void> resetHistoryList() async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllHistoryList(historyListStream, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
