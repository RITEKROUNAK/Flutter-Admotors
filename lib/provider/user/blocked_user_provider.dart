import 'dart:async';
import 'package:flutteradmotors/repository/blocked_user_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/blocked_user.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';

class BlockedUserProvider extends PsProvider {
  BlockedUserProvider({@required BlockedUserRepository repo, this.valueHolder,int limit = 0}) : super(repo,limit) {
    if (limit != 0) {
      super.limit = limit;
    }
    _repo = repo;

    print('BlockedUser Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    blockedUserListStream = StreamController<PsResource<List<BlockedUser>>>.broadcast();
    subscription =
        blockedUserListStream.stream.listen((PsResource<List<BlockedUser>> resource) {
      updateOffset(resource.data.length);

      _blockedUserList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  BlockedUserRepository _repo;
  PsValueHolder valueHolder;

  PsResource<List<BlockedUser>> _blockedUserList =
      PsResource<List<BlockedUser>>(PsStatus.NOACTION, '', <BlockedUser>[]);

  PsResource<List<BlockedUser>> get blockedUserList => _blockedUserList;
  StreamSubscription<PsResource<List<BlockedUser>>> subscription;
  StreamController<PsResource<List<BlockedUser>>> blockedUserListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('BlockedUser Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadBlockedUserList(String loginUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllBlockedUserList(blockedUserListStream, isConnectedToInternet,loginUserId, limit,
        offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextBlockedUserList(String loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageBlockedUserList(blockedUserListStream, isConnectedToInternet,loginUserId,
          limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetBlockedUserList(String loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllBlockedUserList(blockedUserListStream, isConnectedToInternet,loginUserId, limit,
        offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> deleteUserFromDB(String loginUserId) async {
    isLoading = true;

    await _repo.postDeleteUserFromDB(
        blockedUserListStream,loginUserId, PsStatus.PROGRESS_LOADING);
  }

}
