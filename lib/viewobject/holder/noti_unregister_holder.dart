import 'package:digitalproductstore/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class NotiUnRegisterParameterHolder
    extends PsHolder<NotiUnRegisterParameterHolder> {
  NotiUnRegisterParameterHolder(
      {@required this.platformName, @required this.deviceId});

  final String platformName;
  final String deviceId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['platform_name'] = platformName;
    map['device_id'] = deviceId;

    return map;
  }

  @override
  NotiUnRegisterParameterHolder fromMap(dynamic dynamicData) {
    return NotiUnRegisterParameterHolder(
      platformName: dynamicData['platform_name'],
      deviceId: dynamicData['device_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (platformName != '') {
      key += platformName;
    }
    if (deviceId != '') {
      key += deviceId;
    }
    return key;
  }
}
