import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart' show PsDao;

class ManufacturerDao extends PsDao<Manufacturer> {
  ManufacturerDao() {
    init(Manufacturer());
  }
  static const String STORE_NAME = 'Manufacturer';
  final String _primaryKey = 'id';

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(Manufacturer object) {
    return object.id;
  }

  @override
  Filter getFilter(Manufacturer object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
