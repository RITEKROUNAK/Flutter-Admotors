import 'package:flutteradmotors/viewobject/item_location.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart' show PsDao;

class ItemLocationDao extends PsDao<ItemLocation> {
  ItemLocationDao._() {
    init(ItemLocation());
  }
  static const String STORE_NAME = 'ItemLocation';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ItemLocationDao _singleton = ItemLocationDao._();

  // Singleton accessor
  static ItemLocationDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ItemLocation object) {
    return object.id;
  }

  @override
  Filter getFilter(ItemLocation object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
