import 'dart:async';
import 'package:flutteradmotors/repository/rating_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';

class RatingProvider extends PsProvider {
  RatingProvider({@required RatingRepository repo, int limit = 0}) : super(repo, limit) {
    _repo = repo;
    print('Rating Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    ratingStream = StreamController<PsResource<Rating>>.broadcast();
    subscription =
      ratingStream.stream.listen((PsResource<Rating> resource) {

      _ratingList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  RatingRepository _repo;

  PsResource<Rating> _ratingList =
      PsResource<Rating>(PsStatus.NOACTION, '', null);

  PsResource<Rating> get ratingData => _ratingList;
  StreamSubscription<PsResource<Rating>> subscription;
  StreamController<PsResource<Rating>> ratingStream;

  dynamic daoSubscription;

  @override
  void dispose() {
    subscription.cancel();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Rating Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postRating(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    daoSubscription = await _repo.postRating(
        ratingStream, jsonMap, isConnectedToInternet,PsStatus.PROGRESS_LOADING);

    return daoSubscription;
  }
}
