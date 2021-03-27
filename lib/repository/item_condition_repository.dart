import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/item_condition_dao.dart';
import 'package:flutteradmotors/viewobject/condition_of_item.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/repository/Common/ps_repository.dart';

class ItemConditionRepository extends PsRepository {
  ItemConditionRepository(
      {@required PsApiService psApiService,
      @required ItemConditionDao itemConditionDao}) {
    _psApiService = psApiService;
    _itemConditionDao = itemConditionDao;
  }

  PsApiService _psApiService;
  ItemConditionDao _itemConditionDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(ConditionOfItem conditionOfItem) async {
    return _itemConditionDao.insert(_primaryKey, conditionOfItem);
  }

  Future<dynamic> update(ConditionOfItem conditionOfItem) async {
    return _itemConditionDao.update(conditionOfItem);
  }

  Future<dynamic> delete(ConditionOfItem conditionOfItem) async {
    return _itemConditionDao.delete(conditionOfItem);
  }

  Future<dynamic> getItemConditionList(
      StreamController<PsResource<List<ConditionOfItem>>>
          itemConditionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    itemConditionListStream.sink
        .add(await _itemConditionDao.getAll(status: status));

    final PsResource<List<ConditionOfItem>> _resource =
        await _psApiService.getItemConditionList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      await _itemConditionDao.deleteAll();
      await _itemConditionDao.insertAll(_primaryKey, _resource.data);
    }else{
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _itemConditionDao.deleteAll();
      }
    }
    itemConditionListStream.sink.add(await _itemConditionDao.getAll());
  }

  Future<dynamic> getNextPageItemConditionList(
      StreamController<PsResource<List<ConditionOfItem>>>
          itemConditionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemConditionListStream.sink
        .add(await _itemConditionDao.getAll(status: status));

    final PsResource<List<ConditionOfItem>> _resource =
        await _psApiService.getItemConditionList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _itemConditionDao
          .insertAll(_primaryKey, _resource.data)
          .then((dynamic data) async {
        itemConditionListStream.sink.add(await _itemConditionDao.getAll());
      });
    } else {
      itemConditionListStream.sink.add(await _itemConditionDao.getAll());
    }
  }
}
