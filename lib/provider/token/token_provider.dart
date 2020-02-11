import 'dart:async';
import 'package:digitalproductstore/api/ps_api_service.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/api_status.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';
import 'package:flutter/cupertino.dart';

class TokenProvider extends PsProvider {
  TokenProvider({
    @required PsApiService psApiService,
  }) : super(null) {
    _psApiService = psApiService;
    print('Token Provider: $hashCode');

    utilsCheckInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    tokenDataListStream = StreamController<PsResource<ApiStatus>>.broadcast();
    subscription =
        tokenDataListStream.stream.listen((PsResource<ApiStatus> resource) {
      _tokenData = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  PsResource<ApiStatus> _tokenData =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);

  PsResource<ApiStatus> get tokenData => _tokenData;
  StreamSubscription<PsResource<ApiStatus>> subscription;
  StreamController<PsResource<ApiStatus>> tokenDataListStream;
  PsApiService _psApiService;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Token Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadToken() async {
    isLoading = true;
    isConnectedToInternet = await utilsCheckInternetConnectivity();

    if (isConnectedToInternet) {
      final PsResource<ApiStatus> _resource = await _psApiService.getToken();

      if (_resource.status == PsStatus.SUCCESS) {
        tokenDataListStream.sink.add(_resource);
      }
    }
  }
}
