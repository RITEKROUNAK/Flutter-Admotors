import 'package:flutteradmotors/viewobject/common/ps_holder.dart'
    show PsHolder;

class ItemEntryParameterHolder extends PsHolder<ItemEntryParameterHolder> {
  ItemEntryParameterHolder({
    this.manufacturerId,
    this.modelId,
    this.itemTypeId,
    this.itemPriceTypeId,
    this.itemCurrencyId,
    this.conditionOfItemId,
    this.itemLocationId,
    // this.dealOptionRemark,
    this.colorId,
    this.fuelTypeId,
    this.buildTypeId,
    this.sellerTypeId,
    this.transmissionId,
    this.description,
    this.highlightInfomation,
    this.price,
    // this.dealOptionId,
    // this.brand,
    this.businessMode,
    this.isSoldOut,
    this.title,
    this.address,
    this.latitude,
    this.longitude,
    this.plateNumber,
    this.enginePower,
    this.steeringPosition,
    this.noOfOwner,
    this.trimName,
    this.vehicleId,
    this.priceUnit,
    this.year,
    this.licenceStatus,
    this.maxPassengers,
    this.noOfDoors,
    this.mileage,
    this.licenseEexpirationDate,
    this.id,
    this.addedUserId,
  });

  final String manufacturerId;
  final String modelId;
  final String itemTypeId;
  final String itemPriceTypeId;
  final String itemCurrencyId;
  final String conditionOfItemId;
  final String itemLocationId;
  // final String dealOptionRemark;
  final String colorId;
  final String fuelTypeId;
  final String buildTypeId;
  final String sellerTypeId;
  final String transmissionId;
  final String description;
  final String highlightInfomation;
  final String price;
  // final String dealOptionId;
  // final String brand;
  final String businessMode;
  final String isSoldOut;
  final String title;
  final String address;
  final String latitude;
  final String longitude;
  final String plateNumber;
  final String enginePower;
  final String steeringPosition;
  final String noOfOwner;
  final String trimName;
  final String vehicleId;
  final String priceUnit;
  final String year;
  final String licenceStatus;
  final String maxPassengers;
  final String noOfDoors;
  final String mileage;
  final String licenseEexpirationDate;
  final String id;
  final String addedUserId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['manufacturer_id'] = manufacturerId;
    map['model_id'] = modelId;
    map['item_type_id'] = itemTypeId;
    map['item_price_type_id'] = itemPriceTypeId;
    map['item_currency_id'] = itemCurrencyId;
    map['condition_of_item_id'] = conditionOfItemId;
    map['item_location_id'] = itemLocationId;
    // map['deal_option_remark'] = dealOptionRemark;
    map['color_id'] = colorId;
    map['fuel_type_id'] = fuelTypeId;
    map['build_type_id'] = buildTypeId;
    map['seller_type_id'] = sellerTypeId;
    map['transmission_id'] = transmissionId;
    map['description'] = description;
    map['highlight_info'] = highlightInfomation;
    map['price'] = price;
    // map['deal_option_id'] = dealOptionId;
    // map['brand'] = brand;
    map['business_mode'] = businessMode;
    map['is_sold_out'] = isSoldOut;
    map['title'] = title;
    map['address'] = address;
    map['lat'] = latitude;
    map['lng'] = longitude;
    map['plate_number'] = plateNumber;
    map['engine_power'] = enginePower;
    map['steering_position'] = steeringPosition;
    map['no_of_owner'] = noOfOwner;
    map['trim_name'] = trimName;
    map['vehicle_id'] = vehicleId;
    map['price_unit'] = priceUnit;
    map['year'] = year;
    map['licence_status'] = licenceStatus;
    map['max_passengers'] = maxPassengers;
    map['no_of_doors'] = noOfDoors;
    map['mileage'] = mileage;
    map['license_expiration_date'] = licenseEexpirationDate;
    map['id'] = id;
    map['added_user_id'] = addedUserId;

    return map;
  }

  @override
  ItemEntryParameterHolder fromMap(dynamic dynamicData) {
    return ItemEntryParameterHolder(
      manufacturerId: dynamicData['manufacturer_id'],
      modelId: dynamicData['model_id'],
      itemTypeId: dynamicData['item_type_id'],
      itemPriceTypeId: dynamicData['item_price_type_id'],
      itemCurrencyId: dynamicData['item_currency_id'],
      conditionOfItemId: dynamicData['condition_of_item_id'],
      itemLocationId: dynamicData['item_location_id'],
      // dealOptionRemark: dynamicData['deal_option_remark'],
      colorId: dynamicData['color_id'],
      fuelTypeId: dynamicData['fuel_type_id'],
      buildTypeId: dynamicData['build_type_id'],
      sellerTypeId: dynamicData['seller_type_id'],
      transmissionId: dynamicData['transmission_id'],
      description: dynamicData['description'],
      highlightInfomation: dynamicData['highlight_info'],
      price: dynamicData['price'],
      businessMode: dynamicData['business_mode'],
      isSoldOut: dynamicData['is_sold_out'],
      title: dynamicData['title'],
      address: dynamicData['address'],
      latitude: dynamicData['lat'],
      longitude: dynamicData['lng'],
      plateNumber: dynamicData['plate_number'],
      enginePower: dynamicData['engine_power'],
      steeringPosition: dynamicData['steering_position'],
      noOfOwner: dynamicData['no_of_owner'],
      trimName: dynamicData['trim_name'],
      vehicleId: dynamicData['vehicle_id'],
      priceUnit: dynamicData['price_unit'],
      year: dynamicData['year'],
      licenceStatus: dynamicData['licence_status'],
      maxPassengers: dynamicData['max_passengers'],
      noOfDoors: dynamicData['no_of_doors'],
      mileage: dynamicData['mileage'],
      licenseEexpirationDate: dynamicData['license_expiration_date'],
      id: dynamicData['id'],
      addedUserId: dynamicData['added_user_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';
    if (manufacturerId != '') {
      key += manufacturerId;
    }
    if (modelId != '') {
      key += modelId;
    }
    if (itemTypeId != '') {
      key += itemTypeId;
    }
    if (itemPriceTypeId != '') {
      key += itemPriceTypeId;
    }
    if (itemCurrencyId != '') {
      key += itemCurrencyId;
    }
    if (conditionOfItemId != '') {
      key += conditionOfItemId;
    }
    if (itemLocationId != '') {
      key += itemLocationId;
    }
    if (colorId != '') {
      key += colorId;
    }
    if (fuelTypeId != '') {
      key += fuelTypeId;
    }
    if (buildTypeId != '') {
      key += buildTypeId;
    }
    if (sellerTypeId != '') {
      key += sellerTypeId;
    }
    if (transmissionId != '') {
      key += transmissionId;
    }
    if (description != '') {
      key += description;
    }

    if (highlightInfomation != '') {
      key += highlightInfomation;
    }
    if (price != '') {
      key += price;
    }
    // if (dealOptionId != '') {
    //   key += dealOptionId;
    // }
    // if (brand != '') {
    //   key += brand;
    // }

    if (businessMode != '') {
      key += businessMode;
    }
    if (isSoldOut != '') {
      key += isSoldOut;
    }
    if (title != '') {
      key += title;
    }
    if (address != '') {
      key += address;
    }
    if (latitude != '') {
      key += latitude;
    }
    if (longitude != '') {
      key += longitude;
    }
    if (plateNumber != '') {
      key += plateNumber;
    }
    if (enginePower != '') {
      key += enginePower;
    }
    if (steeringPosition != '') {
      key += steeringPosition;
    }
    if (noOfOwner != '') {
      key += noOfOwner;
    }
    if (trimName != '') {
      key += trimName;
    }
    if (vehicleId != '') {
      key += vehicleId;
    }
    if (priceUnit != '') {
      key += priceUnit;
    }
    if (year != '') {
      key += year;
    }
    if (licenceStatus != '') {
      key += licenceStatus;
    }
    if (maxPassengers != '') {
      key += maxPassengers;
    }
    if (noOfDoors != '') {
      key += noOfDoors;
    }
    if (mileage != '') {
      key += mileage;
    }
    if (licenseEexpirationDate != '') {
      key += licenseEexpirationDate;
    }
    if (id != '') {
      key += id;
    }
    if (addedUserId != '') {
      key += addedUserId;
    }
    return key;
  }
}
