import 'package:flutteradmotors/viewobject/model.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart';

class ModelDao extends PsDao<Model> {
  ModelDao() {
    init(Model());
  }

  static const String STORE_NAME = 'Model';
  final String _primaryKey = 'id';

  @override
  String getPrimaryKey(Model object) {
    return object.id;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(Model object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
