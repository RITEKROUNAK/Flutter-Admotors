import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/repository/app_info_repository.dart';
import 'package:flutteradmotors/viewobject/ps_app_info.dart';

class AppInfoProvider extends PsProvider {
  AppInfoProvider({@required AppInfoRepository repo, this.psValueHolder,int limit = 0 })
      : super(repo,limit) {
    _repo = repo;
    print('App Info Provider: $hashCode');
    isDispose = false;
  }

  AppInfoRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<PSAppInfo> _psAppInfo =
      PsResource<PSAppInfo>(PsStatus.NOACTION, '', null);

  PsResource<PSAppInfo> get appInfo => _psAppInfo;

  @override
  void dispose() {
    isDispose = true;
    print('App Info Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadDeleteHistory(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    final PsResource<PSAppInfo> psAppInfo =
        await _repo.postDeleteHistory(jsonMap);

    return psAppInfo;
  }

  Future<void> loadDeleteHistorywithNotifier(
      Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    final PsResource<PSAppInfo> psAppInfo =
        await _repo.postDeleteHistory(jsonMap);
    _psAppInfo = psAppInfo;

    if (!isDispose) {
      notifyListeners();
    }
  }
}
