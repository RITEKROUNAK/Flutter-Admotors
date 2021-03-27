import 'dart:async';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/api_status.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';

class ItemDetailProvider extends PsProvider {
  ItemDetailProvider(
      {@required ProductRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('ItemDetailProvider : $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemDetailStream = StreamController<PsResource<Product>>.broadcast();
    subscription =
        itemDetailStream.stream.listen((PsResource<Product> resource) {
      _item = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        if (_item != null) {
          notifyListeners();
        }
      }
    });
  }

  ProductRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<Product> _item = PsResource<Product>(PsStatus.NOACTION, '', null);
  PsResource<Product> get itemDetail => _item;

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get apiStatus => _apiStatus;

  StreamSubscription<PsResource<Product>> subscription;
  StreamController<PsResource<Product>> itemDetailStream;

  dynamic daoSubscription;

  @override
  void dispose() {
    subscription.cancel();
    if (daoSubscription != null) {
    daoSubscription.cancel();
    }
    isDispose = true;
    print('Product Detail Provider Dispose: $hashCode');
    super.dispose();
  }

  void updateProduct(Product product) {
    _item.data = product;
  }

  Future<dynamic> loadProduct(
    String productId,
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    daoSubscription = await _repo.getItemDetail(
      itemDetailStream, 
      productId, 
      loginUserId,
      isConnectedToInternet, 
      PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> loadItemForFav(
    String itemId,
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    daoSubscription = await _repo.getItemDetailForFav(
      itemDetailStream, 
      itemId, 
      loginUserId,
      isConnectedToInternet, 
      PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextProduct(
    String productId,
    String loginUserId,
  ) async {
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      isConnectedToInternet = await Utils.checkInternetConnectivity();
       daoSubscription = await _repo.getItemDetail(
        itemDetailStream, 
        productId, 
        loginUserId,
        isConnectedToInternet, 
        PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetProductDetail(
    String productId,
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    daoSubscription = await _repo.getItemDetail(
      itemDetailStream, 
      productId, 
      loginUserId,
      isConnectedToInternet, 
      PsStatus.BLOCK_LOADING);

    isLoading = false;
  }

  Future<void> deleteLocalProductCacheById(
    String productId,
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    
    daoSubscription = await _repo.deleteLocalProductCacheById(
      itemDetailStream,
      productId,
      loginUserId,
      isConnectedToInternet,
      PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<void> deleteLocalProductCacheByUserId(
    String loginUserId,
    String addedUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    
     daoSubscription = await _repo.deleteLocalProductCacheByUserId(
      itemDetailStream, 
      loginUserId, 
      addedUserId,
      isConnectedToInternet,
      PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> userDeleteItem(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.userDeleteItem(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
