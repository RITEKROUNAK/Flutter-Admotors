import 'package:flutteradmotors/viewobject/common/ps_object.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'package:quiver/core.dart';
import 'default_icon.dart';
import 'default_photo.dart';

class Model extends PsObject<Model> {
  Model({
    this.id,
    this.name,
    this.manufacturerId,
    this.status,
    this.addedDate,
    this.addedUserId,
    this.updatedDate,
    this.updatedUserId,
    this.updatedFlag,
    this.addedDateStr,
    this.defaultPhoto,
    this.defaultIcon,
    this.manufacturer,
  });

  String id;
  String name;
  String manufacturerId;
  String status;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  String addedDateStr;
  DefaultPhoto defaultPhoto;
  DefaultIcon defaultIcon;
  Manufacturer manufacturer;

  @override
  bool operator ==(dynamic other) => other is Model && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Model fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Model(
          id: dynamicData['id'],
          name: dynamicData['name'],
          manufacturerId: dynamicData['manufacturer_id'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          addedDateStr: dynamicData['added_date_str'],
          manufacturer: Manufacturer().fromMap(dynamicData['manufacturer']),
          defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
          defaultIcon: DefaultIcon().fromMap(dynamicData['default_icon']));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Model object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};

      data['id'] = object.id;
      data['name'] = object.name;
      data['manufacturer_id'] = object.manufacturerId;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['added_date_str'] = object.addedDateStr;
      data['manufacturer'] = Manufacturer().toMap(object.manufacturer);
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['default_icon'] = DefaultIcon().toMap(object.defaultIcon);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Model> fromMapList(List<dynamic> dynamicDataList) {
    final List<Model> subModelList = <Model>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subModelList.add(fromMap(dynamicData));
        }
      }
    }
    return subModelList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Model> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Model data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
