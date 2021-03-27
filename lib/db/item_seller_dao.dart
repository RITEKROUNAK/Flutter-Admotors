import 'package:flutteradmotors/viewobject/item_seller_type.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart' show PsDao;

class ItemSellerTypeDao extends PsDao<ItemSellerType> {
  ItemSellerTypeDao() {
    init(ItemSellerType());
  }
  static const String STORE_NAME = 'ItemSellerType';
  final String _primaryKey = 'id';

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ItemSellerType object) {
    return object.id;
  }

  @override
  Filter getFilter(ItemSellerType object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
