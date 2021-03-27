import 'package:flutteradmotors/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';
import 'default_photo.dart';

class Bunner extends PsObject<Bunner> {
  Bunner({
    this.id,
    this.name,
    this.status,
    this.addedDate,
    this.addedUserId,
    this.updatedDate,
    this.updatedUserId,
    this.addedDateStr,
    this.updatedFlag,
    this.defaultPhoto,
  });
  String id;
  String name;
  String status;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  String addedDateStr;

  DefaultPhoto defaultPhoto;

  @override
  bool operator ==(dynamic other) => other is Bunner && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Bunner fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Bunner(
        id: dynamicData['id'],
        name: dynamicData['name'],
        status: dynamicData['status'],
        addedDate: dynamicData['added_date'],
        addedUserId: dynamicData['added_user_id'],
        updatedDate: dynamicData['updated_date'],
        updatedUserId: dynamicData['updated_user_id'],
        addedDateStr: dynamicData['added_date_str'],
        updatedFlag: dynamicData['updated_flag'],
        defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Bunner object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_user_id'] = object.updatedUserId;
      data['added_date_str'] = object.addedDateStr;
      data['updated_flag'] = object.updatedFlag;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Bunner> fromMapList(List<dynamic> dynamicDataList) {
    final List<Bunner> bunnerList = <Bunner>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          bunnerList.add(fromMap(dynamicData));
        }
      }
    }
    return bunnerList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Bunner> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Bunner data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
