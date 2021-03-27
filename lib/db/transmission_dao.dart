import 'package:flutteradmotors/viewobject/transmission.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart' show PsDao;

class TransmissionDao extends PsDao<Transmission> {
  TransmissionDao() {
    init(Transmission());
  }
  static const String STORE_NAME = 'Transmission';
  final String _primaryKey = 'id';

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(Transmission object) {
    return object.id;
  }

  @override
  Filter getFilter(Transmission object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
