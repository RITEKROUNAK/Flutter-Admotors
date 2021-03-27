import 'package:flutteradmotors/viewobject/item_build_type.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart' show PsDao;

class ItemBuildTypeDao extends PsDao<ItemBuildType> {
  ItemBuildTypeDao() {
    init(ItemBuildType());
  }
  static const String STORE_NAME = 'ItemBuildType';
  final String _primaryKey = 'id';

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ItemBuildType object) {
    return object.id;
  }

  @override
  Filter getFilter(ItemBuildType object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
