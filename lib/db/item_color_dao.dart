import 'package:flutteradmotors/viewobject/Item_color.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart' show PsDao;

class ItemColorDao extends PsDao<ItemColor> {
  ItemColorDao() {
    init(ItemColor());
  }
  static const String STORE_NAME = 'ItemColor';
  final String _primaryKey = 'id';

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ItemColor object) {
    return object.id;
  }

  @override
  Filter getFilter(ItemColor object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
