import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/Item_color.dart';
import 'package:flutteradmotors/viewobject/build_type.dart';
import 'package:flutteradmotors/viewobject/condition_of_item.dart';
import 'package:flutteradmotors/viewobject/fuel_type.dart';
import 'package:flutteradmotors/viewobject/item_currency.dart';
import 'package:flutteradmotors/viewobject/item_location.dart';
import 'package:flutteradmotors/viewobject/item_price_type.dart';
import 'package:flutteradmotors/viewobject/item_type.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'package:flutteradmotors/viewobject/model.dart';
import 'package:flutteradmotors/viewobject/seller_type.dart';
import 'package:flutteradmotors/viewobject/transmission.dart';
import 'package:flutteradmotors/viewobject/user.dart';
import 'package:quiver/core.dart';
import 'package:flutteradmotors/viewobject/common/ps_object.dart';
import 'default_photo.dart';

class Product extends PsObject<Product> {
  Product(
      {this.id,
      this.itemTypeId,
      this.itemPriceTypeId,
      this.itemCurrencyId,
      this.itemLocationId,
      this.conditionOfItemId,
      this.colorId,
      this.fuelTypeId,
      this.buildTypeId,
      this.modelId,
      this.manufacturerId,
      this.sellerTypeId,
      this.transmissionId,
      this.description,
      this.highlightInformation,
      this.price,
      this.brand,
      this.businessMode,
      this.isSoldOut,
      this.title,
      this.address,
      this.lat,
      this.lng,
      this.status,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.updatedFlag,
      this.touchCount,
      this.favouriteCount,
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
      this.licenseExpirationDate,
      this.isPaid,
      this.dynamicLink,
      this.addedDateStr,
      this.paidStatus,
      this.photoCount,
      this.defaultPhoto,
      this.manufacturer,
      this.model,
      this.itemType,
      this.itemPriceType,
      this.itemCurrency,
      this.itemLocation,
      this.conditionOfItem,
      this.itemColor,
      this.fuelType,
      this.buildType,
      this.sellerType,
      this.transmission,
      this.user,
      this.isFavourited,
      this.isOwner});

  String id;
  String itemTypeId;
  String itemPriceTypeId;
  String itemCurrencyId;
  String itemLocationId;
  String conditionOfItemId;
  String colorId;
  String fuelTypeId;
  String buildTypeId;
  String modelId;
  String manufacturerId;
  String sellerTypeId;
  String transmissionId;
  String description;
  String highlightInformation;
  String price;
  String brand;
  String businessMode;
  String isSoldOut;
  String title;
  String address;
  String lat;
  String lng;
  String status;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  String touchCount;
  String favouriteCount;
  String plateNumber;
  String enginePower;
  String steeringPosition;
  String noOfOwner;
  String trimName;
  String vehicleId;
  String priceUnit;
  String year;
  String licenceStatus;
  String maxPassengers;
  String noOfDoors;
  String mileage;
  String licenseExpirationDate;
  String isPaid;
  String dynamicLink;
  String addedDateStr;
  String paidStatus;
  String photoCount;
  String isFavourited;
  String isOwner;
  DefaultPhoto defaultPhoto;
  Manufacturer manufacturer;
  Model model;
  ItemType itemType;
  ItemPriceType itemPriceType;
  ItemCurrency itemCurrency;
  ItemLocation itemLocation;
  ConditionOfItem conditionOfItem;
  ItemColor itemColor;
  FuelType fuelType;
  BuildType buildType;
  SellerType sellerType;
  Transmission transmission;
  User user;
  @override
  bool operator ==(dynamic other) => other is Product && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Product fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Product(
        id: dynamicData['id'],
        itemTypeId: dynamicData['item_type_id'],
        itemPriceTypeId: dynamicData['item_price_type_id'],
        itemCurrencyId: dynamicData['item_currency_id'],
        itemLocationId: dynamicData['item_location_id'],
        conditionOfItemId: dynamicData['condition_of_item_id'],
        colorId: dynamicData['color_id'],
        fuelTypeId: dynamicData['fuel_type_id'],
        buildTypeId: dynamicData['build_type_id'],
        modelId: dynamicData['model_id'],
        manufacturerId: dynamicData['manufacturer_id'],
        sellerTypeId: dynamicData['seller_type_id'],
        transmissionId: dynamicData['transmission_id'],
        description: dynamicData['description'],
        highlightInformation: dynamicData['highlight_info'],
        price: dynamicData['price'],
        brand: dynamicData['brand'],
        businessMode: dynamicData['business_mode'],
        isSoldOut: dynamicData['is_sold_out'],
        title: dynamicData['title'],
        address: dynamicData['address'],
        lat: dynamicData['lat'],
        lng: dynamicData['lng'],
        status: dynamicData['status'],
        addedDate: dynamicData['added_date'],
        addedUserId: dynamicData['added_user_id'],
        updatedDate: dynamicData['updated_date'],
        updatedUserId: dynamicData['updated_user_id'],
        updatedFlag: dynamicData['updated_flag'],
        touchCount: dynamicData['touch_count'],
        favouriteCount: dynamicData['favourite_count'],
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
        licenseExpirationDate: dynamicData['license_expiration_date'],
        isPaid: dynamicData['is_paid'],
        dynamicLink : dynamicData['dynamic_link'],
        addedDateStr: dynamicData['added_date_str'],
        paidStatus: dynamicData['paid_status'],
        photoCount: dynamicData['photo_count'],
        isFavourited: dynamicData['is_favourited'],
        isOwner: dynamicData['is_owner'],
        defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
        manufacturer: Manufacturer().fromMap(dynamicData['manufacturer']),
        model: Model().fromMap(dynamicData['model']),
        itemType: ItemType().fromMap(dynamicData['item_type']),
        itemPriceType: ItemPriceType().fromMap(dynamicData['item_price_type']),
        itemCurrency: ItemCurrency().fromMap(dynamicData['item_currency']),
        itemLocation: ItemLocation().fromMap(dynamicData['item_location']),
        conditionOfItem:
            ConditionOfItem().fromMap(dynamicData['condition_of_item']),
        itemColor: ItemColor().fromMap(dynamicData['color']),
        fuelType: FuelType().fromMap(dynamicData['fuel_type']),
        buildType: BuildType().fromMap(dynamicData['build_type']),
        sellerType: SellerType().fromMap(dynamicData['seller_type']),
        transmission: Transmission().fromMap(dynamicData['transmission']),
        user: User().fromMap(dynamicData['user']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['item_type_id'] = object.itemTypeId;
      data['item_price_type_id'] = object.itemPriceTypeId;
      data['item_currency_id'] = object.itemCurrencyId;
      data['item_location_id'] = object.itemLocationId;
      data['condition_of_item_id'] = object.conditionOfItemId;
      data['description'] = object.description;
      data['color_id'] = object.colorId;
      data['fuel_type_id'] = object.fuelTypeId;
      data['build_type_id'] = object.buildTypeId;
      data['model_id'] = object.modelId;
      data['manufacturer_id'] = object.manufacturerId;
      data['seller_type_id'] = object.sellerTypeId;
      data['transmission_id'] = object.transmissionId;
      data['highlight_info'] = object.highlightInformation;
      data['price'] = object.price;
      data['brand'] = object.brand;
      data['business_mode'] = object.businessMode;
      data['is_sold_out'] = object.isSoldOut;
      data['title'] = object.title;
      data['address'] = object.address;
      data['lat'] = object.lat;
      data['lng'] = object.lng;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['touch_count'] = object.touchCount;
      data['favourite_count'] = object.favouriteCount;
      data['plate_number'] = object.plateNumber;
      data['engine_power'] = object.enginePower;
      data['steering_position'] = object.steeringPosition;
      data['no_of_owner'] = object.noOfOwner;
      data['trim_name'] = object.trimName;
      data['vehicle_id'] = object.vehicleId;
      data['price_unit'] = object.priceUnit;
      data['year'] = object.year;
      data['licence_status'] = object.licenceStatus;
      data['max_passengers'] = object.maxPassengers;
      data['no_of_doors'] = object.noOfDoors;
      data['mileage'] = object.mileage;
      data['license_expiration_date'] = object.licenseExpirationDate;
      data['is_paid'] = object.isPaid;
       data['dynamic_link'] = object.dynamicLink;
      data['added_date_str'] = object.addedDateStr;
      data['paid_status'] = object.paidStatus;
      data['photo_count'] = object.photoCount;
      data['is_favourited'] = object.isFavourited;
      data['is_owner'] = object.isOwner;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['manufacturer'] = Manufacturer().toMap(object.manufacturer);
      data['model'] = Model().toMap(object.model);
      data['item_type'] = ItemType().toMap(object.itemType);
      data['item_price_type'] = ItemPriceType().toMap(object.itemPriceType);
      data['item_currency'] = ItemCurrency().toMap(object.itemCurrency);
      data['item_location'] = ItemLocation().toMap(object.itemLocation);
      data['condition_of_item'] =
          ConditionOfItem().toMap(object.conditionOfItem);
      data['color'] = ItemColor().toMap(object.itemColor);
      data['fuel_type'] = FuelType().toMap(object.fuelType);
      data['build_type'] = BuildType().toMap(object.buildType);
      data['seller_type'] = SellerType().toMap(object.sellerType);
      data['transmission'] = Transmission().toMap(object.transmission);
      data['user'] = User().toMap(object.user);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Product> fromMapList(List<dynamic> dynamicDataList) {
    final List<Product> newFeedList = <Product>[];
    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          newFeedList.add(fromMap(json));
        }
      }
    }
    return newFeedList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];

    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }
    return dynamicList;
  }

  List<Product> checkDuplicate(List<Product> dataList) {
    final Map<String, String> idCache = <String, String>{};
    final List<Product> _tmpList = <Product>[];
    for (int i = 0; i < dataList.length; i++) {
      if (idCache[dataList[i].id] == null) {
        _tmpList.add(dataList[i]);
        idCache[dataList[i].id] = dataList[i].id;
      } else {
        Utils.psPrint('Duplicate');
      }
    }

    return _tmpList;
  }

  bool isSame(List<Product> cache, List<Product> newList) {
    if (cache.length == newList.length) {
      bool status = true;
      for (int i = 0; i < cache.length; i++) {
        if (cache[i].id != newList[i].id) {
          status = false;
          break;
        }
      }

      return status;
    } else {
      return false;
    }
  }
}
