import 'dart:async';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/bunner_dao.dart';
import 'package:flutteradmotors/viewobject/bunner.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';

import 'Common/ps_repository.dart';

class BunnerRepository extends PsRepository {
  BunnerRepository(
      {@required PsApiService psApiService, @required BunnerDao bunnerDao}) {
    _psApiService = psApiService;
    _bunnerDao = bunnerDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  BunnerDao _bunnerDao;

  Future<dynamic> insert(Bunner bunner) async {
    return _bunnerDao.insert(primaryKey, bunner);
  }

  Future<dynamic> update(Bunner bunner) async {
    return _bunnerDao.update(bunner);
  }

  Future<dynamic> delete(Bunner bunner) async {
    return _bunnerDao.delete(bunner);
  }

  Future<dynamic> getAllBunnerList(
      StreamController<PsResource<List<Bunner>>> bunnerListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    bunnerListStream.sink.add(await _bunnerDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Bunner>> _resource =
          await _psApiService.getBunnerList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _bunnerDao.deleteAll();
        await _bunnerDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _bunnerDao.deleteAll();
        }
      }
        bunnerListStream.sink.add(await _bunnerDao.getAll());
    }
  }

  Future<dynamic> getNextPageBunnerList(
      StreamController<PsResource<List<Bunner>>> bunnerListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    bunnerListStream.sink.add(await _bunnerDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Bunner>> _resource =
          await _psApiService.getBunnerList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _bunnerDao.insertAll(primaryKey, _resource.data);
      }
      bunnerListStream.sink.add(await _bunnerDao.getAll());
    }
  }
}
