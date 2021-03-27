import 'dart:async';
import 'package:flutteradmotors/repository/item_currency_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/item_currency.dart';

class ItemCurrencyProvider extends PsProvider {
  ItemCurrencyProvider({@required ItemCurrencyRepository repo, int limit = 0 }) : super(repo,limit) {
    _repo = repo;
    print('Item Currency Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemCurrencyListStream =
        StreamController<PsResource<List<ItemCurrency>>>.broadcast();
    subscription = itemCurrencyListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _itemCurrencyList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<ItemCurrency>>> itemCurrencyListStream;
  ItemCurrencyRepository _repo;

  PsResource<List<ItemCurrency>> _itemCurrencyList =
      PsResource<List<ItemCurrency>>(PsStatus.NOACTION, '', <ItemCurrency>[]);

  PsResource<List<ItemCurrency>> get itemCurrencyList => _itemCurrencyList;
  StreamSubscription<PsResource<List<ItemCurrency>>> subscription;

  String categoryId = '';

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Item Currency Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemCurrencyList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getItemCurrencyList(itemCurrencyListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemCurrencyList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageItemCurrencyList(itemCurrencyListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemCurrencyList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo.getItemCurrencyList(
      itemCurrencyListStream,
      isConnectedToInternet,
      limit,
      offset,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
