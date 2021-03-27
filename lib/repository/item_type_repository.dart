import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/item_type_dao.dart';
import 'package:flutteradmotors/viewobject/item_type.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/repository/Common/ps_repository.dart';

class ItemTypeRepository extends PsRepository {
  ItemTypeRepository(
      {@required PsApiService psApiService,
      @required ItemTypeDao itemTypeDao}) {
    _psApiService = psApiService;
    _itemTypeDao = itemTypeDao;
  }

  PsApiService _psApiService;
  ItemTypeDao _itemTypeDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(ItemType itemType) async {
    return _itemTypeDao.insert(_primaryKey, itemType);
  }

  Future<dynamic> update(ItemType itemType) async {
    return _itemTypeDao.update(itemType);
  }

  Future<dynamic> delete(ItemType itemType) async {
    return _itemTypeDao.delete(itemType);
  }

  Future<dynamic> getItemTypeList(
      StreamController<PsResource<List<ItemType>>> itemTypeListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    itemTypeListStream.sink.add(await _itemTypeDao.getAll(status: status));

    final PsResource<List<ItemType>> _resource =
        await _psApiService.getItemTypeList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      await _itemTypeDao.deleteAll();
      await _itemTypeDao.insertAll(_primaryKey, _resource.data);
    }else{
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _itemTypeDao.deleteAll();
      }
    }
    itemTypeListStream.sink.add(await _itemTypeDao.getAll());
  }

  Future<dynamic> getNextPageItemTypeList(
      StreamController<PsResource<List<ItemType>>> itemTypeListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemTypeListStream.sink.add(await _itemTypeDao.getAll(status: status));

    final PsResource<List<ItemType>> _resource =
        await _psApiService.getItemTypeList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _itemTypeDao
          .insertAll(_primaryKey, _resource.data)
          .then((dynamic data) async {
        itemTypeListStream.sink.add(await _itemTypeDao.getAll());
      });
    } else {
      itemTypeListStream.sink.add(await _itemTypeDao.getAll());
    }
  }
}
