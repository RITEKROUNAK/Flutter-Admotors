import 'package:flutteradmotors/viewobject/manufacturer_map.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart';

class ManufacturerMapDao extends PsDao<ManufacturerMap> {
  ManufacturerMapDao._() {
    init(ManufacturerMap());
  }
  static const String STORE_NAME = 'ManufacturerMap';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ManufacturerMapDao _singleton = ManufacturerMapDao._();

  // Singleton accessor
  static ManufacturerMapDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ManufacturerMap object) {
    return object.id;
  }

  @override
  Filter getFilter(ManufacturerMap object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
