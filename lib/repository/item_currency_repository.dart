import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/item_currency_dao.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/repository/Common/ps_repository.dart';
import 'package:flutteradmotors/viewobject/item_currency.dart';

class ItemCurrencyRepository extends PsRepository {
  ItemCurrencyRepository(
      {@required PsApiService psApiService,
      @required ItemCurrencyDao itemCurrencyDao}) {
    _psApiService = psApiService;
    _itemConditionDao = itemCurrencyDao;
  }

  PsApiService _psApiService;
  ItemCurrencyDao _itemConditionDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(ItemCurrency itemCurrency) async {
    return _itemConditionDao.insert(_primaryKey, itemCurrency);
  }

  Future<dynamic> update(ItemCurrency itemCurrency) async {
    return _itemConditionDao.update(itemCurrency);
  }

  Future<dynamic> delete(ItemCurrency itemCurrency) async {
    return _itemConditionDao.delete(itemCurrency);
  }

  Future<dynamic> getItemCurrencyList(
      StreamController<PsResource<List<ItemCurrency>>> itemConditionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    itemConditionListStream.sink
        .add(await _itemConditionDao.getAll(status: status));

    final PsResource<List<ItemCurrency>> _resource =
        await _psApiService.getItemCurrencyList(limit, offset);

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

  Future<dynamic> getNextPageItemCurrencyList(
      StreamController<PsResource<List<ItemCurrency>>> itemConditionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemConditionListStream.sink
        .add(await _itemConditionDao.getAll(status: status));

    final PsResource<List<ItemCurrency>> _resource =
        await _psApiService.getItemCurrencyList(limit, offset);

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
