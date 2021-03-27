import 'dart:async';
import 'package:flutteradmotors/repository/manufacturer_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/api_status.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';

class TrendingManufacturerProvider extends PsProvider {
  TrendingManufacturerProvider(
      {@required ManufacturerRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Trending Manufacturer Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    categoryListStream =
        StreamController<PsResource<List<Manufacturer>>>.broadcast();
    subscription = categoryListStream.stream
        .listen((PsResource<List<Manufacturer>> resource) {
      updateOffset(resource.data.length);

      _categoryList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<Manufacturer>>> categoryListStream;
  ManufacturerRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<Manufacturer>> _categoryList =
      PsResource<List<Manufacturer>>(PsStatus.NOACTION, '', <Manufacturer>[]);

  PsResource<List<Manufacturer>> get categoryList => _categoryList;
  StreamSubscription<PsResource<List<Manufacturer>>> subscription;

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Trending Manufacturer Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadTrendingManufacturerList(
      Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getManufacturerList(categoryListStream, isConnectedToInternet,
        limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextTrendingManufacturerList(
      Map<dynamic, dynamic> jsonMap) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageManufacturerList(categoryListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetTrendingManufacturerList(
      Map<dynamic, dynamic> jsonMap) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getManufacturerList(categoryListStream, isConnectedToInternet,
        limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> postTouchCount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postTouchCount(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
