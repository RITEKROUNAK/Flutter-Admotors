import 'dart:async';
import 'package:flutteradmotors/repository/item_paid_history_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/item_paid_history.dart';

class ItemPromotionProvider extends PsProvider {
  ItemPromotionProvider(
      {@required ItemPaidHistoryRepository itemPaidHistoryRepository,
      int limit = 0})
      : super(itemPaidHistoryRepository, limit) {
    _repo = itemPaidHistoryRepository;
    isDispose = false;
    print('Item Paid History Provider: $hashCode');

    itemPaidHistoryStream =
        StreamController<PsResource<ItemPaidHistory>>.broadcast();
    subscription = itemPaidHistoryStream.stream
        .listen((PsResource<ItemPaidHistory> resource) {
      if (resource != null && resource.data != null) {
        _itemPaidHistoryEntry = resource;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  String selectedDate;

  ItemPaidHistoryRepository _repo;
  PsResource<ItemPaidHistory> _itemPaidHistoryEntry =
      PsResource<ItemPaidHistory>(PsStatus.NOACTION, '', null);
  PsResource<ItemPaidHistory> get item => _itemPaidHistoryEntry;

  StreamSubscription<PsResource<ItemPaidHistory>> subscription;
  StreamController<PsResource<ItemPaidHistory>> itemPaidHistoryStream;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Item Paid History Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postItemHistoryEntry(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _itemPaidHistoryEntry = await _repo.postItemPaidHistory(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _itemPaidHistoryEntry;
  }
}
