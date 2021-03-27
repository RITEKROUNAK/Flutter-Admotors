import 'package:flutteradmotors/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class ItemBuildType extends PsObject<ItemBuildType> {
  ItemBuildType({
    this.id,
    this.carType,
    this.status,
    this.addedDate,
    this.addedUserId,
    this.updatedDate,
    this.updatedUserId,
    this.updatedFlag,
    this.addedDateStr,
  });

  String id;
  String carType;
  String status;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  String addedDateStr;

  @override
  bool operator ==(dynamic other) => other is ItemBuildType && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  ItemBuildType fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ItemBuildType(
        id: dynamicData['id'],
        carType: dynamicData['car_type'],
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
  Map<String, dynamic> toMap(ItemBuildType object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};

      data['id'] = object.id;
      data['car_type'] = object.carType;
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
  List<ItemBuildType> fromMapList(List<dynamic> dynamicDataList) {
    final List<ItemBuildType> transmissionList = <ItemBuildType>[];

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
  List<Map<String, dynamic>> toMapList(List<ItemBuildType> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (ItemBuildType data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
