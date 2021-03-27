import 'dart:async';

import 'package:flutteradmotors/repository/model_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/model.dart';

class ModelProvider extends PsProvider {
  ModelProvider({@required ModelRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Model Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    modelListStream = StreamController<PsResource<List<Model>>>.broadcast();
    subscription = modelListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _modelList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<Model>>> modelListStream;
  ModelRepository _repo;

  PsResource<List<Model>> _modelList =
      PsResource<List<Model>>(PsStatus.NOACTION, '', <Model>[]);

  PsResource<List<Model>> get modelList => _modelList;
  StreamSubscription<PsResource<List<Model>>> subscription;

  String manufacturerId = '';
  ProductParameterHolder itemByManufacturerIdParamenterHolder =
      ProductParameterHolder().getItemByManufacturerIdParameterHolder();

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Model Provider Dispose: $hashCode');
    super.dispose();
  }

  // ProductParameterHolder productParameterHolder;
  Future<dynamic> loadModelList(String manufacturerId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getModelListByManufacturerId(
        modelListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        manufacturerId);
  }

  Future<dynamic> loadAllModelList(String manufacturerId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllModelListByManufacturerId(modelListStream,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING, manufacturerId);
  }

  Future<dynamic> nextModelList(String manufacturerId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageModelList(modelListStream, isConnectedToInternet,
          limit, offset, PsStatus.PROGRESS_LOADING, manufacturerId);
    }
  }

  Future<void> resetModelList(String manufacturerId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo.getModelListByManufacturerId(
        modelListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        manufacturerId);

    isLoading = false;
  }
}
