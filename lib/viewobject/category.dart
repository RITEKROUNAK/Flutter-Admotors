import 'package:flutteradmotors/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';
import 'default_icon.dart';
import 'default_photo.dart';

class Category extends PsObject<Category> {
  Category(
      {this.catId,
      this.catName,
      this.catOrdering,
      this.status,
      this.addedDate,
      this.addedDateStr,
      this.defaultPhoto,
      this.defaultIcon});
  String catId;
  String catName;
  String catOrdering;
  String status;
  String addedDate;
  String addedDateStr;
  DefaultPhoto defaultPhoto;
  DefaultIcon defaultIcon;

  @override
  bool operator ==(dynamic other) => other is Category && catId == other.catId;

  @override
  int get hashCode {
    return hash2(catId.hashCode, catId.hashCode);
  }

  @override
  String getPrimaryKey() {
    return catId;
  }

  @override
  Category fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Category(
          catId: dynamicData['cat_id'],
          catName: dynamicData['cat_name'],
          catOrdering: dynamicData['cat_ordering'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedDateStr: dynamicData['added_date_str'],
          defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
          defaultIcon: DefaultIcon().fromMap(dynamicData['default_icon']));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Category object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['cat_id'] = object.catId;
      data['cat_name'] = object.catName;
      data['cat_ordering'] = object.catOrdering;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_date_str'] = object.addedDateStr;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['default_icon'] = DefaultIcon().toMap(object.defaultIcon);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Category> fromMapList(List<dynamic> dynamicDataList) {
    final List<Category> subCategoryList = <Category>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData));
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Category> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Category data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
