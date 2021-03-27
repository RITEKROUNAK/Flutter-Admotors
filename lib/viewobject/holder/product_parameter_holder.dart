import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/viewobject/common/ps_holder.dart';

class ProductParameterHolder extends PsHolder<dynamic> {
  ProductParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemTypeName = '';
    itemPriceTypeId = '';
    itemPriceTypeName = '';
    itemCurrencyId = '';
    itemLocationId = '';
    conditionOfItemId = '';
    itemConditionName = '';
    colorId = '';
    colorName = '';
    fuelTypeId = '';
    fuelTypeName = '';
    buildTypeId = '';
    buildTypeName = '';
    sellerTypeId = '';
    sellerTypeName = '';
    transmissionId = '';
    transmissionName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    status = '1';
  }

  String searchTerm;
  String manufacturerId;
  String modelId;
  String itemTypeId;
  String itemTypeName;
  String itemPriceTypeId;
  String itemPriceTypeName;
  String itemCurrencyId;
  String itemLocationId;
  String conditionOfItemId;
  String itemConditionName;
  String colorId;
  String colorName;
  String fuelTypeId;
  String fuelTypeName;
  String buildTypeId;
  String buildTypeName;
  String sellerTypeId;
  String sellerTypeName;
  String transmissionId;
  String transmissionName;
  String maxPrice;
  String minPrice;
  String brand;
  String lat;
  String lng;
  String mile;
  String orderBy;
  String orderType;
  String addedUserId;
  String isPaid;
  String status;

  bool isFiltered() {
    return !(
        // isAvailable == '' &&
        //   (isDiscount == '0' || isDiscount == '') &&
        //   (isFeatured == '0' || isFeatured == '') &&
        orderBy == '' &&
            orderType == '' &&
            minPrice == '' &&
            maxPrice == '' &&
            itemTypeId == '' &&
            conditionOfItemId == '' &&
            itemPriceTypeId == '' &&
            fuelTypeId == '' &&
            buildTypeId == '' &&
            sellerTypeId == '' &&
            transmissionId == '' &&
            searchTerm == '');
  }

  bool isCatAndSubCatFiltered() {
    return !(manufacturerId == '' && modelId == '');
  }

  ProductParameterHolder getRecentParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    conditionOfItemId = '';
    colorId = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = PsConst.PAID_ITEM_FIRST;
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder getPendingItemParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    conditionOfItemId = '';
    colorId = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '0';

    return this;
  }

  ProductParameterHolder getRejectedItemParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    conditionOfItemId = '';
    colorId = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '3';

    return this;
  }

  ProductParameterHolder getDisabledProductParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    conditionOfItemId = '';
    colorId = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '2';

    return this;
  }


  ProductParameterHolder getItemByManufacturerIdParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    conditionOfItemId = '';
    colorId = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder getPopularParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    conditionOfItemId = '';
    colorId = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING_TRENDING;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder getLatestParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    conditionOfItemId = '';
    colorId = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = PsConst.PAID_ITEM_FIRST;
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder resetParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    conditionOfItemId = '';
    colorId = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['searchterm'] = searchTerm;
    map['manufacturer_id'] = manufacturerId;
    map['model_id'] = modelId;
    map['item_type_id'] = itemTypeId;
    map['item_price_type_id'] = itemPriceTypeId;
    map['item_currency_id'] = itemCurrencyId;
    map['item_location_id'] = itemLocationId;
    map['condition_of_item_id'] = conditionOfItemId;
    map['color_id'] = colorId;
    map['fuel_type_id'] = fuelTypeId;
    map['build_type_id'] = buildTypeId;
    map['seller_type_id'] = sellerTypeId;
    map['transmission_id'] = transmissionId;
    map['max_price'] = maxPrice;
    map['min_price'] = minPrice;
    map['lat'] = lat;
    map['lng'] = lng;
    map['miles'] = mile;
    map['added_user_id'] = addedUserId;
    map['is_paid'] = isPaid;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['status'] = status;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    conditionOfItemId = '';
    colorId = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '';

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (searchTerm != '') {
      result += searchTerm + ':';
    }
    if (manufacturerId != '') {
      result += manufacturerId + ':';
    }
    if (modelId != '') {
      result += modelId + ':';
    }
    if (itemTypeId != '') {
      result += itemTypeId + ':';
    }
    if (itemPriceTypeId != '') {
      result += itemPriceTypeId + ':';
    }
    if (itemCurrencyId != '') {
      result += itemCurrencyId + ':';
    }
    if (itemLocationId != '') {
      result += itemLocationId + ':';
    }
    if (conditionOfItemId != '') {
      result += conditionOfItemId + ':';
    }
    if (colorId != '') {
      result += colorId + ':';
    }
    if (fuelTypeId != '') {
      result += fuelTypeId + ':';
    }
    if (buildTypeId != '') {
      result += buildTypeId + ':';
    }
    if (sellerTypeId != '') {
      result += sellerTypeId + ':';
    }
    if (transmissionId != '') {
      result += transmissionId + ':';
    }
    if (maxPrice != '') {
      result += maxPrice + ':';
    }
    if (minPrice != '') {
      result += minPrice + ':';
    }
    if (brand != '') {
      result += brand + ':';
    }
    if (lat != '') {
      result += lat + ':';
    }
    if (lng != '') {
      result += lng + ':';
    }
    if (mile != '') {
      result += mile + ':';
    }
    if (addedUserId != '') {
      result += addedUserId + ':';
    }
    if (isPaid != '') {
      result += isPaid + ':';
    }
    if (status != '') {
      result += status + ':';
    }
    if (orderBy != '') {
      result += orderBy + ':';
    }
    if (orderType != '') {
      result += orderType;
    }

    return result;
  }
}
