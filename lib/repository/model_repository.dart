import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/model_dao.dart';
import 'package:flutteradmotors/viewobject/model.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/repository/Common/ps_repository.dart';

class ModelRepository extends PsRepository {
  ModelRepository(
      {@required PsApiService psApiService, @required ModelDao modelDao}) {
    _psApiService = psApiService;
    _modelDao = modelDao;
  }

  PsApiService _psApiService;
  ModelDao _modelDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(Model model) async {
    return _modelDao.insert(_primaryKey, model);
  }

  Future<dynamic> update(Model model) async {
    return _modelDao.update(model);
  }

  Future<dynamic> delete(Model model) async {
    return _modelDao.delete(model);
  }

  Future<dynamic> getModelListByManufacturerId(
      StreamController<PsResource<List<Model>>> modelListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('manufacturer_id', categoryId));

    modelListStream.sink
        .add(await _modelDao.getAll(finder: finder, status: status));

    final PsResource<List<Model>> _resource =
        await _psApiService.getModelList(limit, offset, categoryId);

    if (_resource.status == PsStatus.SUCCESS) {
      await _modelDao.deleteWithFinder(finder);
      await _modelDao.insertAll(_primaryKey, _resource.data);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _modelDao.deleteWithFinder(finder);
      }
    }
    modelListStream.sink.add(await _modelDao.getAll(finder: finder));
  }

  Future<dynamic> getAllModelListByManufacturerId(
      StreamController<PsResource<List<Model>>> modelListStream,
      bool isConnectedToIntenet,
      PsStatus status,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('manufacturer_id', categoryId));

    modelListStream.sink
        .add(await _modelDao.getAll(finder: finder, status: status));

    final PsResource<List<Model>> _resource =
        await _psApiService.getAllModelList(categoryId);

    if (_resource.status == PsStatus.SUCCESS) {
      await _modelDao.deleteWithFinder(finder);
      await _modelDao.insertAll(_primaryKey, _resource.data);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _modelDao.deleteWithFinder(finder);
      }
    }
    modelListStream.sink.add(await _modelDao.getAll(finder: finder));
  }

  Future<dynamic> getNextPageModelList(
      StreamController<PsResource<List<Model>>> modelListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('manufacturer_id', categoryId));
    modelListStream.sink
        .add(await _modelDao.getAll(finder: finder, status: status));

    final PsResource<List<Model>> _resource =
        await _psApiService.getModelList(limit, offset, categoryId);

    if (_resource.status == PsStatus.SUCCESS) {
      _modelDao
          .insertAll(_primaryKey, _resource.data)
          .then((dynamic data) async {
        modelListStream.sink.add(await _modelDao.getAll(finder: finder));
      });
    } else {
      modelListStream.sink.add(await _modelDao.getAll(finder: finder));
    }
  }
}
