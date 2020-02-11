import 'dart:async';
import 'package:digitalproductstore/repository/blog_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/blog.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';

class BlogProvider extends PsProvider {
  BlogProvider({@required BlogRepository repo}) : super(repo) {
    _repo = repo;

    print('Blog Provider: $hashCode');

    utilsCheckInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    blogListStream = StreamController<PsResource<List<Blog>>>.broadcast();
    subscription =
        blogListStream.stream.listen((PsResource<List<Blog>> resource) {
      updateOffset(resource.data.length);

      _blogList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  BlogRepository _repo;

  PsResource<List<Blog>> _blogList =
      PsResource<List<Blog>>(PsStatus.NOACTION, '', <Blog>[]);

  PsResource<List<Blog>> get blogList => _blogList;
  StreamSubscription<PsResource<List<Blog>>> subscription;
  StreamController<PsResource<List<Blog>>> blogListStream;
  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    blogListStream.close();
    isDispose = true;
    print('Blog Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadBlogList() async {
    isLoading = true;

    isConnectedToInternet = await utilsCheckInternetConnectivity();
    await _repo.getAllBlogList(blogListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextBlogList() async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageBlogList(blogListStream, isConnectedToInternet,
          limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetBlogList() async {
    isConnectedToInternet = await utilsCheckInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllBlogList(blogListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
