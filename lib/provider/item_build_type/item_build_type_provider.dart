import 'dart:async';
import 'package:flutteradmotors/repository/item_build_type_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/item_build_type.dart';

class ItemBuildTypeProvider extends PsProvider {
  ItemBuildTypeProvider(
      {@required ItemBuildTypeRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }

    _repo = repo;

    print('ItemBuildType Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemBuildTypeListStream =
        StreamController<PsResource<List<ItemBuildType>>>.broadcast();
    subscription = itemBuildTypeListStream.stream
        .listen((PsResource<List<ItemBuildType>> resource) {
      updateOffset(resource.data.length);

      _itemBuildTypeList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<PsResource<List<ItemBuildType>>> itemBuildTypeListStream;

  ItemBuildTypeRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<ItemBuildType>> _itemBuildTypeList =
      PsResource<List<ItemBuildType>>(PsStatus.NOACTION, '', <ItemBuildType>[]);

  PsResource<List<ItemBuildType>> get itemBuildTypeList => _itemBuildTypeList;
  StreamSubscription<PsResource<List<ItemBuildType>>> subscription;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('ItemBuildType Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemBuildTypeList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getItemBuildTypeList(itemBuildTypeListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemBuildTypeList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageItemBuildTypeList(itemBuildTypeListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemBuildTypeList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getItemBuildTypeList(itemBuildTypeListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
