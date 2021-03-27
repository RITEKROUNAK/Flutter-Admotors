import 'dart:async';
import 'package:flutteradmotors/repository/bunner_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/bunner.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';

class BunnerProvider extends PsProvider {
  BunnerProvider({@required BunnerRepository repo, int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }
    _repo = repo;

    print('Bunner Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    bunnerListStream = StreamController<PsResource<List<Bunner>>>.broadcast();
    subscription =
        bunnerListStream.stream.listen((PsResource<List<Bunner>> resource) {
      updateOffset(resource.data.length);

      _bunnerList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  BunnerRepository _repo;

  PsResource<List<Bunner>> _bunnerList =
      PsResource<List<Bunner>>(PsStatus.NOACTION, '', <Bunner>[]);

  PsResource<List<Bunner>> get bunnerList => _bunnerList;
  StreamSubscription<PsResource<List<Bunner>>> subscription;
  StreamController<PsResource<List<Bunner>>> bunnerListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Bunner Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadBunnerList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllBunnerList(bunnerListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextBunnerList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageBunnerList(bunnerListStream, isConnectedToInternet,
          limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetBunnerList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllBunnerList(bunnerListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
