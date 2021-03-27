import 'dart:async';
import 'package:flutteradmotors/repository/transmission_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/transmission.dart';

class TransmissionProvider extends PsProvider {
  TransmissionProvider(
      {@required TransmissionRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }

    _repo = repo;

    print('Transmission Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    transmissionListStream =
        StreamController<PsResource<List<Transmission>>>.broadcast();
    subscription = transmissionListStream.stream
        .listen((PsResource<List<Transmission>> resource) {
      updateOffset(resource.data.length);

      _transmissionList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<PsResource<List<Transmission>>> transmissionListStream;

  TransmissionRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<Transmission>> _transmissionList =
      PsResource<List<Transmission>>(PsStatus.NOACTION, '', <Transmission>[]);

  PsResource<List<Transmission>> get transmissionList => _transmissionList;
  StreamSubscription<PsResource<List<Transmission>>> subscription;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Transmission Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadTransmissionList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getTransmissionList(transmissionListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextTransmissionList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageTransmissionList(transmissionListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetTransmissionList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getTransmissionList(transmissionListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
