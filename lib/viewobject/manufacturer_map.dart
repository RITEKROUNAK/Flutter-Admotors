import 'package:quiver/core.dart';
import 'package:flutteradmotors/viewobject/common/ps_map_object.dart';

class ManufacturerMap extends PsMapObject<ManufacturerMap> {
  ManufacturerMap(
      {this.id,
      this.mapKey,
      this.manufacturerId,
      int sorting,
      this.addedDate}) {
    super.sorting = sorting;
  }

  String id;
  String mapKey;
  String manufacturerId;
  String addedDate;

  @override
  bool operator ==(dynamic other) => other is ManufacturerMap && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  ManufacturerMap fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ManufacturerMap(
          id: dynamicData['id'],
          mapKey: dynamicData['map_key'],
          manufacturerId: dynamicData['manufacturer_id'],
          sorting: dynamicData['sorting'],
          addedDate: dynamicData['added_date']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['map_key'] = object.mapKey;
      data['manufacturer_id'] = object.manufacturerId;
      data['sorting'] = object.sorting;
      data['added_date'] = object.addedDate;

      return data;
    } else {
      return null;
    }
  }

  @override
  List<ManufacturerMap> fromMapList(List<dynamic> dynamicDataList) {
    final List<ManufacturerMap> manufacturerMapList = <ManufacturerMap>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          manufacturerMapList.add(fromMap(dynamicData));
        }
      }
    }
    return manufacturerMapList;
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

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  List<String> getIdList(List<dynamic> mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (dynamic manufacturer in mapList) {
        if (manufacturer != null) {
          idList.add(manufacturer.manufacturerId);
        }
      }
    }
    return idList;
  }
}
