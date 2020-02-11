import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/viewobject/common/ps_holder.dart';

class CategoryParameterHolder extends PsHolder<dynamic> {
  CategoryParameterHolder() {
    orderBy = FILTERING__ADDED_DATE;
  }

  String orderBy;

  CategoryParameterHolder getTrendingParameterHolder() {
    orderBy = FILTERING__TRENDING;

    return this;
  }

  CategoryParameterHolder getLatestParameterHolder() {
    orderBy = FILTERING__ADDED_DATE;

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['order_by'] = orderBy;

    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    orderBy = FILTERING__ADDED_DATE;

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (orderBy != '') {
      result += orderBy + ':';
    }

    return result;
  }
}
