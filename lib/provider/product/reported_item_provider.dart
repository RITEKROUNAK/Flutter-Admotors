import 'dart:async';

import 'package:flutteradmotors/repository/reported_item_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/reported_item.dart';

class ReportedItemProvider extends PsProvider {
  ReportedItemProvider({@required ReportedItemRepository repo,this.valueHolder, int limit = 0}) : super(repo,limit) {
    _repo = repo;
    print('ReportedItem Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemTypeListStream =
        StreamController<PsResource<List<ReportedItem>>>.broadcast();
    subscription = itemTypeListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _itemTypeList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<ReportedItem>>> itemTypeListStream;
  ReportedItemRepository _repo;
  PsValueHolder valueHolder;

  PsResource<List<ReportedItem>> _itemTypeList =
      PsResource<List<ReportedItem>>(PsStatus.NOACTION, '', <ReportedItem>[]);

  PsResource<List<ReportedItem>> get reportedItem => _itemTypeList;
  StreamSubscription<PsResource<List<ReportedItem>>> subscription;

  String categoryId = '';

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Item Type Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadReportedItemList(String loginUserId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getReportedItemList(itemTypeListStream, isConnectedToInternet,loginUserId,
        limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextReportedItemList(String loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageReportedItemList(itemTypeListStream,
          isConnectedToInternet, loginUserId,limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetReportedItemList(String loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo.getReportedItemList(
      itemTypeListStream,
      isConnectedToInternet,
      loginUserId,
      limit,
      offset,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
