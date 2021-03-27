import 'dart:async';

import 'package:flutteradmotors/repository/item_condition_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/condition_of_item.dart';

class ItemConditionProvider extends PsProvider {
  ItemConditionProvider({@required ItemConditionRepository repo, int limit = 0})
      : super(repo,limit) {
    _repo = repo;
    print('Item Condition Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemConditionListStream =
        StreamController<PsResource<List<ConditionOfItem>>>.broadcast();
    subscription = itemConditionListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _itemConditionList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<ConditionOfItem>>> itemConditionListStream;
  ItemConditionRepository _repo;

  PsResource<List<ConditionOfItem>> _itemConditionList =
      PsResource<List<ConditionOfItem>>(
          PsStatus.NOACTION, '', <ConditionOfItem>[]);

  PsResource<List<ConditionOfItem>> get itemConditionList => _itemConditionList;
  StreamSubscription<PsResource<List<ConditionOfItem>>> subscription;

  String categoryId = '';

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Item Condition Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemConditionList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getItemConditionList(itemConditionListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemConditionList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageItemConditionList(itemConditionListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemConditionList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo.getItemConditionList(
      itemConditionListStream,
      isConnectedToInternet,
      limit,
      offset,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
