import 'package:flutteradmotors/viewobject/bunner.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart' show PsDao;

class BunnerDao extends PsDao<Bunner> {
  BunnerDao._() {
    init(Bunner());
  }
  static const String STORE_NAME = 'Bunner';
  final String _primaryKey = 'id';

  // Singleton instance
  static final BunnerDao _singleton = BunnerDao._();

  // Singleton accessor
  static BunnerDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(Bunner object) {
    return object.id;
  }

  @override
  Filter getFilter(Bunner object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
