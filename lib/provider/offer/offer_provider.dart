import 'dart:async';
import 'package:flutteradmotors/repository/offer_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/holder/offer_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/offer.dart';

class OfferListProvider extends PsProvider {
  OfferListProvider({@required OfferRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('OfferListProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    offerListStream = StreamController<PsResource<List<Offer>>>.broadcast();

    subscription =
        offerListStream.stream.listen((PsResource<List<Offer>> resource) {
      updateOffset(resource.data.length);

      _offerList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  OfferRepository _repo;
  PsResource<List<Offer>> _offerList =
      PsResource<List<Offer>>(PsStatus.NOACTION, '', <Offer>[]);

  PsResource<List<Offer>> get offerList => _offerList;
  StreamSubscription<PsResource<List<Offer>>> subscription;
  StreamController<PsResource<List<Offer>>> offerListStream;
  dynamic daoSubscription;
  @override
  void dispose() {
    subscription.cancel();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('OfferList Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadOfferList(OfferParameterHolder holder) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    // daoSubscription =
    await _repo.getOfferList(offerListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, holder);
  }

  Future<dynamic> nextOfferList(OfferParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageOfferList(offerListStream, isConnectedToInternet,
          limit, offset, PsStatus.PROGRESS_LOADING, holder);
    }
  }

  Future<void> resetOfferList(OfferParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getOfferList(offerListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, holder);

    isLoading = false;
  }
}
