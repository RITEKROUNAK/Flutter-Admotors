import 'dart:async';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/transmission_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/viewobject/transmission.dart';
import 'Common/ps_repository.dart';

class TransmissionRepository extends PsRepository {
  TransmissionRepository(
      {@required PsApiService psApiService,
      @required TransmissionDao transmissionDao}) {
    _psApiService = psApiService;
    _transmissionDao = transmissionDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  TransmissionDao _transmissionDao;

  void sinkTransmissionListStream(
      StreamController<PsResource<List<Transmission>>> transmissionListStream,
      PsResource<List<Transmission>> dataList) {
    if (dataList != null && transmissionListStream != null) {
      transmissionListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(Transmission transmission) async {
    return _transmissionDao.insert(primaryKey, transmission);
  }

  Future<dynamic> update(Transmission transmission) async {
    return _transmissionDao.update(transmission);
  }

  Future<dynamic> delete(Transmission transmission) async {
    return _transmissionDao.delete(transmission);
  }

  Future<dynamic> getTransmissionList(
      StreamController<PsResource<List<Transmission>>> transmissionListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkTransmissionListStream(
        transmissionListStream, await _transmissionDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Transmission>> _resource =
          await _psApiService.getTransmissionList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Delete and Insert Map Dao
        await _transmissionDao.deleteAll();

        // Insert Transmission
        await _transmissionDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _transmissionDao.deleteAll();
        }
      }

      // Load updated Data from Db and Send to UI
      sinkTransmissionListStream(
          transmissionListStream, await _transmissionDao.getAll());
    }
  }

  Future<dynamic> getNextPageTransmissionList(
      StreamController<PsResource<List<Transmission>>> transmissionListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkTransmissionListStream(
        transmissionListStream, await _transmissionDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Transmission>> _resource =
          await _psApiService.getTransmissionList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _transmissionDao.getAll();

        await _transmissionDao.insertAll(primaryKey, _resource.data);
      }
      sinkTransmissionListStream(
          transmissionListStream, await _transmissionDao.getAll());
    }
  }
}
