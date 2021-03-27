import 'dart:async';
import 'package:flutteradmotors/repository/item_color_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/Item_color.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';

class ItemColorProvider extends PsProvider {
  ItemColorProvider(
      {@required ItemColorRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }

    _repo = repo;

    print('ItemColor Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemColorListStream =
        StreamController<PsResource<List<ItemColor>>>.broadcast();
    subscription = itemColorListStream.stream
        .listen((PsResource<List<ItemColor>> resource) {
      updateOffset(resource.data.length);

      _itemColorList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<PsResource<List<ItemColor>>> itemColorListStream;

  ItemColorRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<ItemColor>> _itemColorList =
      PsResource<List<ItemColor>>(PsStatus.NOACTION, '', <ItemColor>[]);

  PsResource<List<ItemColor>> get itemColorList => _itemColorList;
  StreamSubscription<PsResource<List<ItemColor>>> subscription;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('ItemColor Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemColorList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getItemColorList(itemColorListStream, isConnectedToInternet,
        limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemColorList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageItemColorList(itemColorListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemColorList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getItemColorList(itemColorListStream, isConnectedToInternet,
        limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
