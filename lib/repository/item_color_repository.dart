import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/item_color_dao.dart';
import 'package:flutteradmotors/viewobject/Item_color.dart';
import 'Common/ps_repository.dart';

class ItemColorRepository extends PsRepository {
  ItemColorRepository(
      {@required PsApiService psApiService,
      @required ItemColorDao itemColorDao}) {
    _psApiService = psApiService;
    _itemColorDao = itemColorDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ItemColorDao _itemColorDao;

  void sinkItemColorListStream(
      StreamController<PsResource<List<ItemColor>>> itemColorListStream,
      PsResource<List<ItemColor>> dataList) {
    if (dataList != null && itemColorListStream != null) {
      itemColorListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(ItemColor itemColor) async {
    return _itemColorDao.insert(primaryKey, itemColor);
  }

  Future<dynamic> update(ItemColor itemColor) async {
    return _itemColorDao.update(itemColor);
  }

  Future<dynamic> delete(ItemColor itemColor) async {
    return _itemColorDao.delete(itemColor);
  }

  Future<dynamic> getItemColorList(
      StreamController<PsResource<List<ItemColor>>> itemColorListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkItemColorListStream(
        itemColorListStream, await _itemColorDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemColor>> _resource =
          await _psApiService.getItemColorList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Delete and Insert Map Dao
        await _itemColorDao.deleteAll();

        // Insert ItemColor
        await _itemColorDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _itemColorDao.deleteAll();
        }
      }

      // Load updated Data from Db and Send to UI
      sinkItemColorListStream(
          itemColorListStream, await _itemColorDao.getAll());
    }
  }

  Future<dynamic> getNextPageItemColorList(
      StreamController<PsResource<List<ItemColor>>> itemColorListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkItemColorListStream(
        itemColorListStream, await _itemColorDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemColor>> _resource =
          await _psApiService.getItemColorList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemColorDao.getAll();

        await _itemColorDao.insertAll(primaryKey, _resource.data);
      }
      sinkItemColorListStream(
          itemColorListStream, await _itemColorDao.getAll());
    }
  }
}
