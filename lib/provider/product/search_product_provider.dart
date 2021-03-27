import 'dart:async';

import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/product.dart';

class SearchProductProvider extends PsProvider {
  SearchProductProvider(
      {@required ProductRepository repo, this.psValueHolder, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('SearchProductProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        productListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      // _productList = resource;

      // if (!Product().isSame(_productList.data, resource.data)) {
      //   print('**** ${resource.data.hashCode}');
      //   print('**** Trending Product ${resource.data.length}');
      print('**** SearchProductProvider ${resource.data.length}');
      _productList = resource;
      _productList.data = Product().checkDuplicate(resource.data);
      // } else {
      //   _productList.status = PsStatus.SUCCESS;
      // }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  ProductRepository _repo;
  PsValueHolder psValueHolder;
  PsResource<List<Product>> _productList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get productList => _productList;
  StreamSubscription<PsResource<List<Product>>> subscription;
  StreamController<PsResource<List<Product>>> productListStream;

  dynamic daoSubscription;

  ProductParameterHolder productParameterHolder;

  bool isSwitchedFeaturedProduct = false;
  bool isSwitchedDiscountPrice = false;

  String selectedManufacturerName = '';
  String selectedModelName = '';
  String selectedItemTypeName = '';
  String selectedItemConditionName = '';
  String selectedItemPriceTypeName = '';
  String selectedTransmissionName = '';
  String selectedColorName = '';
  String selectedFuelType = '';
  String selectedBuildType = '';
  String selectedSellerType = '';

  String manufacturerId = '';
  String modelId = '';
  String itemTypeId = '';
  String itemConditionId = '';
  String itemPriceTypeId = '';
  String transmissionId = '';
  String itemColorId = '';
  String fuelTypeId = '';
  String buildTypeId = '';
  String sellerTypeId = '';

  bool isfirstRatingClicked = false;
  bool isSecondRatingClicked = false;
  bool isThirdRatingClicked = false;
  bool isfouthRatingClicked = false;
  bool isFifthRatingClicked = false;

  String _itemLocationId;
  @override
  void dispose() {
    subscription.cancel();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Search Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductListByKey(
      String loginUserId,
      ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    if (PsConfig.noFilterWithLocationOnMap) {
      if (productParameterHolder.lat != '' &&
          productParameterHolder.lng != '' &&
          productParameterHolder.lat != null &&
          productParameterHolder.lng != null) {
        _itemLocationId = productParameterHolder.itemLocationId;
        productParameterHolder.itemLocationId = '';
      } else {
        if (_itemLocationId != null && _itemLocationId != '') {
          productParameterHolder.itemLocationId = _itemLocationId;
        }
      }
    }

     daoSubscription = await _repo.getProductList(
      productListStream, 
      isConnectedToInternet, 
      loginUserId,
      limit, 
      offset, 
      PsStatus.PROGRESS_LOADING,
      productParameterHolder);
  }

  Future<dynamic> nextProductListByKey(
      String loginUserId,
      ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      if (PsConfig.noFilterWithLocationOnMap) {
        if (productParameterHolder.lat != '' &&
            productParameterHolder.lng != '' &&
            productParameterHolder.lat != null &&
            productParameterHolder.lng != null) {
          _itemLocationId = productParameterHolder.itemLocationId;
          productParameterHolder.itemLocationId = '';
        } else {
          if (_itemLocationId != null && _itemLocationId != '') {
            productParameterHolder.itemLocationId = _itemLocationId;
          }
        }
      }

       await _repo.getNextPageProductList(
          productListStream,
          isConnectedToInternet,
          loginUserId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          productParameterHolder);
    }
  }

  Future<void> resetLatestProductList(
      String loginUserId,
      ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (PsConfig.noFilterWithLocationOnMap) {
      if (productParameterHolder.lat != '' &&
          productParameterHolder.lng != '' &&
          productParameterHolder.lat != null &&
          productParameterHolder.lng != null) {
        _itemLocationId = productParameterHolder.itemLocationId;
        productParameterHolder.itemLocationId = '';
      } else {
        if (_itemLocationId != null && _itemLocationId != '') {
          productParameterHolder.itemLocationId = _itemLocationId;
        }
      }
    }

    updateOffset(0);

    isLoading = true;
    daoSubscription = await _repo.getProductList(
      productListStream, 
      isConnectedToInternet, 
      loginUserId,
      limit, 
      offset, 
      PsStatus.PROGRESS_LOADING, 
      productParameterHolder);
  }
}
