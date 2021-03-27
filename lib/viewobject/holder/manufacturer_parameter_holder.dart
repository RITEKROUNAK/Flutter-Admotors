import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/viewobject/common/ps_holder.dart';

class ManufacturerParameterHolder extends PsHolder<dynamic> {
  ManufacturerParameterHolder() {
    orderBy = PsConst.FILTERING__ADDED_DATE;
  }

  String orderBy;

  ManufacturerParameterHolder getTrendingParameterHolder() {
    orderBy = PsConst.FILTERING__TRENDING;

    return this;
  }

  ManufacturerParameterHolder getLatestParameterHolder() {
    orderBy = PsConst.FILTERING__ADDED_DATE;

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
    orderBy = PsConst.FILTERING__ADDED_DATE;

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
