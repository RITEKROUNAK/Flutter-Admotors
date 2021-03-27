import 'dart:async';

import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/product.dart';

class RecentProductProvider extends PsProvider {
  RecentProductProvider({@required ProductRepository repo, int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }
    _repo = repo;
    //isDispose = false;
    print('RecentProductProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        productListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      print('**** RecentProductProvider ${resource.data.length}');
      _productList = resource;
      _productList.data = Product().checkDuplicate(resource.data);

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
  PsResource<List<Product>> _productList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);
  final ProductParameterHolder productRecentParameterHolder =
      ProductParameterHolder().getRecentParameterHolder();
  PsResource<List<Product>> get productList => _productList;
  StreamSubscription<PsResource<List<Product>>> subscription;
  StreamController<PsResource<List<Product>>> productListStream;

  dynamic daoSubscription;

  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Recent Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductList(
      String loginUserId,
      ProductParameterHolder productParameterHolder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    daoSubscription = await _repo.getProductList(
    productListStream, 
    isConnectedToInternet, 
    loginUserId,
    limit, 
    offset, 
    PsStatus.PROGRESS_LOADING, 
    productParameterHolder);
  }

  Future<dynamic> nextProductList(
      String loginUserId,
      ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

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

  Future<dynamic> resetProductList(
      String loginUserId,
      ProductParameterHolder productParameterHolder) async {
    isLoading = true;

    updateOffset(0);

    isConnectedToInternet = await Utils.checkInternetConnectivity();

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
