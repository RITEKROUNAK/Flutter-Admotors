import 'dart:async';

import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/db/about_us_dao.dart';
import 'package:flutteradmotors/db/blog_dao.dart';
import 'package:flutteradmotors/db/cateogry_dao.dart';
import 'package:flutteradmotors/db/chat_history_dao.dart';
import 'package:flutteradmotors/db/chat_history_map_dao.dart';
import 'package:flutteradmotors/db/manufacturer_map_dao.dart';
import 'package:flutteradmotors/db/model_dao.dart';
import 'package:flutteradmotors/db/product_dao.dart';
import 'package:flutteradmotors/db/product_map_dao.dart';
import 'package:flutteradmotors/db/rating_dao.dart';
import 'package:flutteradmotors/db/related_product_dao.dart';
import 'package:flutteradmotors/db/user_unread_message_dao.dart';
import 'package:flutteradmotors/repository/Common/ps_repository.dart';
import 'package:flutteradmotors/viewobject/product.dart';

class ClearAllDataRepository extends PsRepository {
  Future<dynamic> clearAllData(
      StreamController<PsResource<List<Product>>> allListStream) async {
    final ProductDao _productDao = ProductDao.instance;
    final CategoryDao _categoryDao = CategoryDao();
    final ManufacturerMapDao _categoryMapDao = ManufacturerMapDao.instance;
    final ProductMapDao _productMapDao = ProductMapDao.instance;
    final RatingDao _ratingDao = RatingDao.instance;
    final ModelDao _modelDao = ModelDao();
    final BlogDao _blogDao = BlogDao.instance;
    final ChatHistoryDao _chatHistoryDao = ChatHistoryDao.instance;
    final ChatHistoryMapDao _chatHistoryMapDao = ChatHistoryMapDao.instance;
    final UserUnreadMessageDao _userUnreadMessageDao =
        UserUnreadMessageDao.instance;
    final RelatedProductDao _relatedProductDao = RelatedProductDao.instance;
    final AboutUsDao _aboutUsDao = AboutUsDao.instance;
    await _productDao.deleteAll();
    await _blogDao.deleteAll();
    await _categoryDao.deleteAll();
    await _categoryMapDao.deleteAll();
    await _productMapDao.deleteAll();
    await _ratingDao.deleteAll();
    await _modelDao.deleteAll();
    await _chatHistoryDao.deleteAll();
    await _chatHistoryMapDao.deleteAll();
    await _userUnreadMessageDao.deleteAll();
    await _relatedProductDao.deleteAll();
    await _aboutUsDao.deleteAll();

    allListStream.sink.add(await _productDao.getAll(status: PsStatus.SUCCESS));
  }
}
