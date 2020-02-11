import 'dart:async';
import 'package:digitalproductstore/repository/contact_us_repository.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/api_status.dart';
import 'package:flutter/material.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/provider/common/ps_provider.dart';

class ContactUsProvider extends PsProvider {
  ContactUsProvider({@required ContactUsRepository repo}) : super(repo) {
    _repo = repo;
    print('ContactUs Provider: $hashCode');

    utilsCheckInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  ContactUsRepository _repo;

  PsResource<ApiStatus> _contactUs =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _contactUs;

  @override
  void dispose() {
    isDispose = true;
    print('ContactUs Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postContactUs(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await utilsCheckInternetConnectivity();

    _contactUs = await _repo.postContactUs(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _contactUs;
  }
}
