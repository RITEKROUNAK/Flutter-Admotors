import 'package:flutteradmotors/viewobject/deal_option.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart';

class ItemDealOptionDao extends PsDao<DealOption> {
  ItemDealOptionDao() {
    init(DealOption());
  }

  static const String STORE_NAME = 'DealOption';
  final String _primaryKey = 'id';

  @override
  String getPrimaryKey(DealOption object) {
    return object.id;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(DealOption object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
