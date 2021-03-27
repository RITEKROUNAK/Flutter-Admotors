import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/item_fuel_type_dao.dart';
import 'package:flutteradmotors/viewobject/item_fuel_type.dart';
import 'Common/ps_repository.dart';

class ItemFuelTypeRepository extends PsRepository {
  ItemFuelTypeRepository(
      {@required PsApiService psApiService,
      @required ItemFuelTypeDao itemFuelTypeDao}) {
    _psApiService = psApiService;
    _itemFuelTypeDao = itemFuelTypeDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ItemFuelTypeDao _itemFuelTypeDao;

  void sinkItemFuelTypeListStream(
      StreamController<PsResource<List<ItemFuelType>>> itemFuelTypeListStream,
      PsResource<List<ItemFuelType>> dataList) {
    if (dataList != null && itemFuelTypeListStream != null) {
      itemFuelTypeListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(ItemFuelType itemFuelType) async {
    return _itemFuelTypeDao.insert(primaryKey, itemFuelType);
  }

  Future<dynamic> update(ItemFuelType itemFuelType) async {
    return _itemFuelTypeDao.update(itemFuelType);
  }

  Future<dynamic> delete(ItemFuelType itemFuelType) async {
    return _itemFuelTypeDao.delete(itemFuelType);
  }

  Future<dynamic> getItemFuelTypeList(
      StreamController<PsResource<List<ItemFuelType>>> itemFuelTypeListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkItemFuelTypeListStream(
        itemFuelTypeListStream, await _itemFuelTypeDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemFuelType>> _resource =
          await _psApiService.getItemFuelTypeList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Delete and Insert Map Dao
        await _itemFuelTypeDao.deleteAll();

        // Insert ItemFuelType
        await _itemFuelTypeDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _itemFuelTypeDao.deleteAll();
        }
      }

      // Load updated Data from Db and Send to UI
      sinkItemFuelTypeListStream(
          itemFuelTypeListStream, await _itemFuelTypeDao.getAll());
    }
  }

  Future<dynamic> getNextPageItemFuelTypeList(
      StreamController<PsResource<List<ItemFuelType>>> itemFuelTypeListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkItemFuelTypeListStream(
        itemFuelTypeListStream, await _itemFuelTypeDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemFuelType>> _resource =
          await _psApiService.getItemFuelTypeList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemFuelTypeDao.getAll();

        await _itemFuelTypeDao.insertAll(primaryKey, _resource.data);
      }
      sinkItemFuelTypeListStream(
          itemFuelTypeListStream, await _itemFuelTypeDao.getAll());
    }
  }
}
