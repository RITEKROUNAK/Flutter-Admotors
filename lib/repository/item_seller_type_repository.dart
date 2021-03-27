import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/item_seller_dao.dart';
import 'package:flutteradmotors/viewobject/item_seller_type.dart';
import 'Common/ps_repository.dart';

class ItemSellerTypeRepository extends PsRepository {
  ItemSellerTypeRepository(
      {@required PsApiService psApiService,
      @required ItemSellerTypeDao itemSellerTypeDao}) {
    _psApiService = psApiService;
    _itemSellerTypeDao = itemSellerTypeDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ItemSellerTypeDao _itemSellerTypeDao;

  void sinkItemSellerTypeListStream(
      StreamController<PsResource<List<ItemSellerType>>>
          itemSellerTypeListStream,
      PsResource<List<ItemSellerType>> dataList) {
    if (dataList != null && itemSellerTypeListStream != null) {
      itemSellerTypeListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(ItemSellerType itemSellerType) async {
    return _itemSellerTypeDao.insert(primaryKey, itemSellerType);
  }

  Future<dynamic> update(ItemSellerType itemSellerType) async {
    return _itemSellerTypeDao.update(itemSellerType);
  }

  Future<dynamic> delete(ItemSellerType itemSellerType) async {
    return _itemSellerTypeDao.delete(itemSellerType);
  }

  Future<dynamic> getItemSellerTypeList(
      StreamController<PsResource<List<ItemSellerType>>>
          itemSellerTypeListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkItemSellerTypeListStream(itemSellerTypeListStream,
        await _itemSellerTypeDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemSellerType>> _resource =
          await _psApiService.getItemSellerTypeList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Delete and Insert Map Dao
        await _itemSellerTypeDao.deleteAll();

        // Insert ItemSellerType
        await _itemSellerTypeDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          // Delete and Insert Map Dao
          await _itemSellerTypeDao.deleteAll();
        }
      }

      // Load updated Data from Db and Send to UI
      sinkItemSellerTypeListStream(
          itemSellerTypeListStream, await _itemSellerTypeDao.getAll());
    }
  }

  Future<dynamic> getNextPageItemSellerTypeList(
      StreamController<PsResource<List<ItemSellerType>>>
          itemSellerTypeListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkItemSellerTypeListStream(itemSellerTypeListStream,
        await _itemSellerTypeDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemSellerType>> _resource =
          await _psApiService.getItemSellerTypeList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemSellerTypeDao.getAll();

        await _itemSellerTypeDao.insertAll(primaryKey, _resource.data);
      }
      sinkItemSellerTypeListStream(
          itemSellerTypeListStream, await _itemSellerTypeDao.getAll());
    }
  }
}
