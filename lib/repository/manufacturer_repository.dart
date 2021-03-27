import 'dart:async';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/manufacturer_dao.dart';
import 'package:flutteradmotors/viewobject/api_status.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'Common/ps_repository.dart';

class ManufacturerRepository extends PsRepository {
  ManufacturerRepository(
      {@required PsApiService psApiService,
      @required ManufacturerDao manufacturerDao}) {
    _psApiService = psApiService;
    _manufacturerDao = manufacturerDao;
  }

  String primaryKey = 'cat_id';
  String mapKey = 'map_key';
  PsApiService _psApiService;
  ManufacturerDao _manufacturerDao;

  void sinkManufacturerListStream(
      StreamController<PsResource<List<Manufacturer>>> manufacturerListStream,
      PsResource<List<Manufacturer>> dataList) {
    if (dataList != null && manufacturerListStream != null) {
      manufacturerListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(Manufacturer manufacturer) async {
    return _manufacturerDao.insert(primaryKey, manufacturer);
  }

  Future<dynamic> update(Manufacturer manufacturer) async {
    return _manufacturerDao.update(manufacturer);
  }

  Future<dynamic> delete(Manufacturer manufacturer) async {
    return _manufacturerDao.delete(manufacturer);
  }

  Future<dynamic> getManufacturerList(
      StreamController<PsResource<List<Manufacturer>>> manufacturerListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      // ManufacturerParameterHolder holder,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkManufacturerListStream(
        manufacturerListStream, await _manufacturerDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Manufacturer>> _resource =
          await _psApiService.getManufacturerList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Delete and Insert Map Dao
        await _manufacturerDao.deleteAll();

        // Insert Manufacturer
        await _manufacturerDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _manufacturerDao.deleteAll();
        }
      }

      // Load updated Data from Db and Send to UI
      sinkManufacturerListStream(
          manufacturerListStream, await _manufacturerDao.getAll());
    }
  }

  Future<dynamic> getNextPageManufacturerList(
      StreamController<PsResource<List<Manufacturer>>> manufacturerListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkManufacturerListStream(
        manufacturerListStream, await _manufacturerDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Manufacturer>> _resource =
          await _psApiService.getManufacturerList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _manufacturerDao.getAll();

        await _manufacturerDao.insertAll(primaryKey, _resource.data);
      }
      sinkManufacturerListStream(
          manufacturerListStream, await _manufacturerDao.getAll());
    }
  }

  Future<PsResource<ApiStatus>> postTouchCount(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postTouchCount(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
