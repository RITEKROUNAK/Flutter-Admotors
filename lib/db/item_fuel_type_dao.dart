import 'package:flutteradmotors/viewobject/item_fuel_type.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart' show PsDao;

class ItemFuelTypeDao extends PsDao<ItemFuelType> {
  ItemFuelTypeDao() {
    init(ItemFuelType());
  }
  static const String STORE_NAME = 'ItemFuelType';
  final String _primaryKey = 'id';

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ItemFuelType object) {
    return object.id;
  }

  @override
  Filter getFilter(ItemFuelType object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
