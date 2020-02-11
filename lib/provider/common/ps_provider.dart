import 'package:flutter/foundation.dart';
import 'package:digitalproductstore/repository/Common/ps_repository.dart';

class PsProvider extends ChangeNotifier {
  // PsProvider({PsRepository psRepository}) {
  //   this.psRepository = psRepository;
  // }
  PsProvider(this.psRepository);

  bool isConnectedToInternet = false;
  bool isLoading = false;
  PsRepository psRepository;

  int offset = 0;
  int limit = 10;
  int _cacheDataLength = 0;
  int maxDataLoadingCount = 0;
  int maxDataLoadingCountLimit = 4;
  bool isReachMaxData = false;
  bool isDispose = false;

  void updateOffset(int dataLength) {
    if (offset == 0) {
      isReachMaxData = false;
      maxDataLoadingCount = 0;
    }
    if (dataLength == _cacheDataLength) {
      maxDataLoadingCount++;
      if (maxDataLoadingCount == maxDataLoadingCountLimit) {
        isReachMaxData = true;
      }
    } else {
      maxDataLoadingCount = 0;
    }

    offset = dataLength;
    _cacheDataLength = dataLength;
  }

  Future<void> loadValueHolder() async {
    psRepository.loadValueHolder();
  }

  Future<void> replaceLoginUserId(String loginUserId) async {
    psRepository.replaceLoginUserId(loginUserId);
  }

  Future<void> replaceNotiToken(String notiToken) async {
    psRepository.replaceNotiToken(notiToken);
  }

  Future<void> replaceNotiSetting(bool notiSetting) async {
    psRepository.replaceNotiSetting(notiSetting);
  }

  Future<void> replaceDate(String startDate, String endDate) async {
    psRepository.replaceDate(startDate, endDate);
  }

  Future<void> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
    psRepository.replaceVerifyUserData(userIdToVerify, userNameToVerify,
        userEmailToVerify, userPasswordToVerify);
  }

  Future<void> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
    psRepository.replaceVersionForceUpdateData(appInfoForceUpdate);
  }

  Future<void> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
    psRepository.replaceAppInfoData(appInfoVersionNo, appInfoForceUpdate,
        appInfoForceUpdateTitle, appInfoForceUpdateMsg);
  }

  Future<void> replaceTransactionValueHolderData(
      String overAllTaxLabel,
      String overAllTaxValue,
      String shippingTaxLabel,
      String shippingTaxValue) async {
    psRepository.replaceTransactionValueHolderData(
        overAllTaxLabel, overAllTaxValue, shippingTaxLabel, shippingTaxValue);
  }

  Future<void> replaceCheckoutEnable(String paypalEnabled, String stripeEnabled,
      String codEnabled, String bankEnabled) async {
    psRepository.replaceCheckoutEnable(
        paypalEnabled, stripeEnabled, codEnabled, bankEnabled);
  }

  Future<void> replacePublishKey(String pubKey) async {
    psRepository.replacePublishKey(pubKey);
  }
}
