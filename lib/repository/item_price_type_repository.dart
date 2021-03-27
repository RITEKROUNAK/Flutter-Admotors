import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/item_price_type_dao.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/repository/Common/ps_repository.dart';
import 'package:flutteradmotors/viewobject/item_price_type.dart';

class ItemPriceTypeRepository extends PsRepository {
  ItemPriceTypeRepository(
      {@required PsApiService psApiService,
      @required ItemPriceTypeDao itemPriceTypeDao}) {
    _psApiService = psApiService;
    _itemPriceTypeDao = itemPriceTypeDao;
  }

  PsApiService _psApiService;
  ItemPriceTypeDao _itemPriceTypeDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(ItemPriceType itemPriceType) async {
    return _itemPriceTypeDao.insert(_primaryKey, itemPriceType);
  }

  Future<dynamic> update(ItemPriceType itemPriceType) async {
    return _itemPriceTypeDao.update(itemPriceType);
  }

  Future<dynamic> delete(ItemPriceType itemPriceType) async {
    return _itemPriceTypeDao.delete(itemPriceType);
  }

  Future<dynamic> getItemPriceTypeList(
      StreamController<PsResource<List<ItemPriceType>>> itemConditionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemConditionListStream.sink
        .add(await _itemPriceTypeDao.getAll(status: status));

    final PsResource<List<ItemPriceType>> _resource =
        await _psApiService.getItemPriceTypeList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      await _itemPriceTypeDao.deleteAll();
      await _itemPriceTypeDao.insertAll(_primaryKey, _resource.data);
    }else{
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _itemPriceTypeDao.deleteAll();
      }
    }
    itemConditionListStream.sink.add(await _itemPriceTypeDao.getAll());
  }

  Future<dynamic> getNextPageItemPriceTypeList(
      StreamController<PsResource<List<ItemPriceType>>> itemConditionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemConditionListStream.sink
        .add(await _itemPriceTypeDao.getAll(status: status));

    final PsResource<List<ItemPriceType>> _resource =
        await _psApiService.getItemPriceTypeList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _itemPriceTypeDao
          .insertAll(_primaryKey, _resource.data)
          .then((dynamic data) async {
        itemConditionListStream.sink.add(await _itemPriceTypeDao.getAll());
      });
    } else {
      itemConditionListStream.sink.add(await _itemPriceTypeDao.getAll());
    }
  }
}
