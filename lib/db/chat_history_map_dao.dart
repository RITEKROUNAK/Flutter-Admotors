import 'package:flutteradmotors/viewobject/chat_history_map.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart';

class ChatHistoryMapDao extends PsDao<ChatHistoryMap> {
  ChatHistoryMapDao._() {
    init(ChatHistoryMap());
  }
  static const String STORE_NAME = 'ChatHistoryMap';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ChatHistoryMapDao _singleton = ChatHistoryMapDao._();

  // Singleton accessor
  static ChatHistoryMapDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ChatHistoryMap object) {
    return object.id;
  }

  @override
  Filter getFilter(ChatHistoryMap object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
