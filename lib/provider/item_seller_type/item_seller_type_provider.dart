import 'dart:async';
import 'package:flutteradmotors/repository/item_seller_type_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/item_seller_type.dart';

class ItemSellerTypeProvider extends PsProvider {
  ItemSellerTypeProvider(
      {@required ItemSellerTypeRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }

    _repo = repo;

    print('ItemSellerType Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemSellerTypeListStream =
        StreamController<PsResource<List<ItemSellerType>>>.broadcast();
    subscription = itemSellerTypeListStream.stream
        .listen((PsResource<List<ItemSellerType>> resource) {
      updateOffset(resource.data.length);

      _itemSellerTypeList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<PsResource<List<ItemSellerType>>> itemSellerTypeListStream;

  ItemSellerTypeRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<ItemSellerType>> _itemSellerTypeList =
      PsResource<List<ItemSellerType>>(
          PsStatus.NOACTION, '', <ItemSellerType>[]);

  PsResource<List<ItemSellerType>> get itemSellerTypeList =>
      _itemSellerTypeList;
  StreamSubscription<PsResource<List<ItemSellerType>>> subscription;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('ItemSellerType Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemSellerTypeList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getItemSellerTypeList(itemSellerTypeListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemSellerTypeList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageItemSellerTypeList(itemSellerTypeListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemSellerTypeList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getItemSellerTypeList(itemSellerTypeListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
