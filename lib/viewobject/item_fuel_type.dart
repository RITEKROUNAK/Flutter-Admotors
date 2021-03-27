import 'package:flutteradmotors/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class ItemFuelType extends PsObject<ItemFuelType> {
  ItemFuelType({
    this.id,
    this.fuelName,
    this.status,
    this.addedDate,
    this.addedUserId,
    this.updatedDate,
    this.updatedUserId,
    this.updatedFlag,
    this.addedDateStr,
  });

  String id;
  String fuelName;
  String status;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  String addedDateStr;

  @override
  bool operator ==(dynamic other) => other is ItemFuelType && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  ItemFuelType fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ItemFuelType(
        id: dynamicData['id'],
        fuelName: dynamicData['fuel_name'],
        status: dynamicData['status'],
        addedDate: dynamicData['added_date'],
        addedUserId: dynamicData['added_user_id'],
        updatedDate: dynamicData['updated_date'],
        updatedUserId: dynamicData['updated_user_id'],
        updatedFlag: dynamicData['updated_flag'],
        addedDateStr: dynamicData['added_date_str'],
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ItemFuelType object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};

      data['id'] = object.id;
      data['fuel_name'] = object.fuelName;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['added_date_str'] = object.addedDateStr;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ItemFuelType> fromMapList(List<dynamic> dynamicDataList) {
    final List<ItemFuelType> transmissionList = <ItemFuelType>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          transmissionList.add(fromMap(dynamicData));
        }
      }
    }
    return transmissionList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<ItemFuelType> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (ItemFuelType data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
