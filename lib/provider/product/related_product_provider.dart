import 'dart:async';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';

class RelatedProductProvider extends PsProvider {
  RelatedProductProvider(
      {@required ProductRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('RelatedProductProvider : $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    relatedProductListStream =
        StreamController<PsResource<List<Product>>>.broadcast();
    subscription = relatedProductListStream.stream
        .listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _relatedProductList = resource;
      _relatedProductList.data = Product().checkDuplicate(resource.data);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  PsValueHolder psValueHolder;
  ProductRepository _repo;

  PsResource<List<Product>> _relatedProductList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get relatedProductList => _relatedProductList;
  StreamSubscription<PsResource<List<Product>>> subscription;
  StreamController<PsResource<List<Product>>> relatedProductListStream;

  @override
  void dispose() {
    subscription.cancel();
    print('Related Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadRelatedProductList(
    String productId,
    String categoryId,
    String loginUserId,
  ) async {
    isLoading = true;

    limit = 10;
    offset = 0;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getRelatedProductList(
        relatedProductListStream,
        productId,
        categoryId,
        loginUserId,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }
}
