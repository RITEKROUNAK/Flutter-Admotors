import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/item_build_type_dao.dart';
import 'package:flutteradmotors/viewobject/item_build_type.dart';
import 'Common/ps_repository.dart';

class ItemBuildTypeRepository extends PsRepository {
  ItemBuildTypeRepository(
      {@required PsApiService psApiService,
      @required ItemBuildTypeDao itemBuildTypeDao}) {
    _psApiService = psApiService;
    _itemBuildTypeDao = itemBuildTypeDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ItemBuildTypeDao _itemBuildTypeDao;

  void sinkItemBuildTypeListStream(
      StreamController<PsResource<List<ItemBuildType>>> itemBuildTypeListStream,
      PsResource<List<ItemBuildType>> dataList) {
    if (dataList != null && itemBuildTypeListStream != null) {
      itemBuildTypeListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(ItemBuildType itemBuildType) async {
    return _itemBuildTypeDao.insert(primaryKey, itemBuildType);
  }

  Future<dynamic> update(ItemBuildType itemBuildType) async {
    return _itemBuildTypeDao.update(itemBuildType);
  }

  Future<dynamic> delete(ItemBuildType itemBuildType) async {
    return _itemBuildTypeDao.delete(itemBuildType);
  }

  Future<dynamic> getItemBuildTypeList(
      StreamController<PsResource<List<ItemBuildType>>> itemBuildTypeListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkItemBuildTypeListStream(itemBuildTypeListStream,
        await _itemBuildTypeDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemBuildType>> _resource =
          await _psApiService.getItemBuildTypeList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Delete and Insert Map Dao
        await _itemBuildTypeDao.deleteAll();

        // Insert ItemBuildType
        await _itemBuildTypeDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _itemBuildTypeDao.deleteAll();
        }
      }

      // Load updated Data from Db and Send to UI
      sinkItemBuildTypeListStream(
          itemBuildTypeListStream, await _itemBuildTypeDao.getAll());
    }
  }

  Future<dynamic> getNextPageItemBuildTypeList(
      StreamController<PsResource<List<ItemBuildType>>> itemBuildTypeListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkItemBuildTypeListStream(itemBuildTypeListStream,
        await _itemBuildTypeDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemBuildType>> _resource =
          await _psApiService.getItemBuildTypeList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemBuildTypeDao.getAll();

        await _itemBuildTypeDao.insertAll(primaryKey, _resource.data);
      }
      sinkItemBuildTypeListStream(
          itemBuildTypeListStream, await _itemBuildTypeDao.getAll());
    }
  }
}
