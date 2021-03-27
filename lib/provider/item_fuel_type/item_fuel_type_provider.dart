import 'dart:async';
import 'package:flutteradmotors/repository/item_fuel_type_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/item_fuel_type.dart';

class ItemFuelTypeProvider extends PsProvider {
  ItemFuelTypeProvider(
      {@required ItemFuelTypeRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }

    _repo = repo;

    print('ItemFuelType Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemFuelTypeListStream =
        StreamController<PsResource<List<ItemFuelType>>>.broadcast();
    subscription = itemFuelTypeListStream.stream
        .listen((PsResource<List<ItemFuelType>> resource) {
      updateOffset(resource.data.length);

      _itemFuelTypeList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<PsResource<List<ItemFuelType>>> itemFuelTypeListStream;

  ItemFuelTypeRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<ItemFuelType>> _itemFuelTypeList =
      PsResource<List<ItemFuelType>>(PsStatus.NOACTION, '', <ItemFuelType>[]);

  PsResource<List<ItemFuelType>> get itemFuelTypeList => _itemFuelTypeList;
  StreamSubscription<PsResource<List<ItemFuelType>>> subscription;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('ItemFuelType Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemFuelTypeList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getItemFuelTypeList(itemFuelTypeListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemFuelTypeList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageItemFuelTypeList(itemFuelTypeListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemFuelTypeList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getItemFuelTypeList(itemFuelTypeListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
