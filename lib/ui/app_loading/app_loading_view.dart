import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/provider/clear_all/clear_all_data_provider.dart';
import 'package:flutteradmotors/repository/clear_all_data_repository.dart';
import 'package:flutteradmotors/ui/common/dialog/version_update_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradmotors/ui/common/ps_square_progress_widget.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/app_info_parameter_holder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/app_info/app_info_provider.dart';
import 'package:flutteradmotors/repository/app_info_repository.dart';
import 'package:flutteradmotors/viewobject/ps_app_info.dart';
import 'package:provider/single_child_widget.dart';

class AppLoadingView extends StatelessWidget {
  Future<dynamic> callDateFunction(AppInfoProvider provider,
      ClearAllDataProvider clearAllDataProvider,
      // DeleteTaskProvider deleteTaskProvider,
      BuildContext context) async {
    String realStartDate = '0';
    String realEndDate = '0';
    if (await Utils.checkInternetConnectivity()) {
      if (provider.psValueHolder == null ||
          provider.psValueHolder.startDate == null) {
        realStartDate =
            DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
      } else {
        realStartDate = provider.psValueHolder.endDate;
      }

      realEndDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
      final AppInfoParameterHolder appInfoParameterHolder =
          AppInfoParameterHolder(
        startDate: realStartDate,
        endDate: realEndDate,
        userId: Utils.checkUserLoginId(provider.psValueHolder)
      );

      final PsResource<PSAppInfo> _psAppInfo =
          await provider.loadDeleteHistory(appInfoParameterHolder.toMap());

      if (_psAppInfo.status == PsStatus.SUCCESS) {
        provider.replaceDate(realStartDate, realEndDate);
        print(Utils.getString(context, 'dialog__cancel'));
        print(Utils.getString(context, 'app_info__update_button_name'));

        if(_psAppInfo.data.userInfo.userStatus == PsConst.USER_BANNED ){
          callLogout(provider,
          // deleteTaskProvider,
          PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,context);
          showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: Utils.getString(context,
                      'user_status__banned'),
              onPressed: (){
                checkVersionNumber(
                context, _psAppInfo.data, provider, clearAllDataProvider);
                realStartDate = realEndDate;
              },
            );
          });
        }else if(_psAppInfo.data.userInfo.userStatus == PsConst.USER_DELECTED){
          callLogout(provider,
          // deleteTaskProvider,
          PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,context);
          showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: Utils.getString(context,
                      'user_status__deleted'),
              onPressed: (){
                checkVersionNumber(
                context, _psAppInfo.data, provider, clearAllDataProvider);
                realStartDate = realEndDate;
              },
            );
          });
        }else if(_psAppInfo.data.userInfo.userStatus == PsConst.USER_UN_PUBLISHED){
          callLogout(provider,
          // deleteTaskProvider,
          PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,context);
          showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: Utils.getString(context,
                      'user_status__unpublished'),
              onPressed: (){
                checkVersionNumber(
                context, _psAppInfo.data, provider, clearAllDataProvider);
                realStartDate = realEndDate;
              },
            );
          });
        }else{
          checkVersionNumber(
                context, _psAppInfo.data, provider, clearAllDataProvider);
                realStartDate = realEndDate;
          
        }

      } else if (_psAppInfo.status == PsStatus.ERROR) {
        if (provider.psValueHolder.locationId != null) {
          Navigator.pushReplacementNamed(
            context,
            RoutePaths.home,
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            RoutePaths.itemLocationList,
          );
        }
      }
    } else {
      if (provider.psValueHolder.locationId != null) {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.home,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.itemLocationList,
        );
      }
    }
  }

  dynamic callLogout(AppInfoProvider appInfoProvider,
  // DeleteTaskProvider deleteTaskProvider,
   int index, BuildContext context) async {
      // updateSelectedIndex( index);
      appInfoProvider.replaceLoginUserId('');
      appInfoProvider.replaceLoginUserName('');
      // await deleteTaskProvider.deleteTask();
      await FacebookLogin().logOut();
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    }


  final Widget _imageWidget = Container(
    width: 90,
    height: 90,
    child: Image.asset(
      'assets/images/flutter_buy_and_sell_logo_light.png',
    ),
  );

  dynamic checkVersionNumber(
      BuildContext context,
      PSAppInfo psAppInfo,
      AppInfoProvider appInfoProvider,
      ClearAllDataProvider clearAllDataProvider) async {
    if (PsConfig.app_version != psAppInfo.psAppVersion.versionNo) {
      if (psAppInfo.psAppVersion.versionNeedClearData == PsConst.ONE) {
        await clearAllDataProvider.clearAllData();
        checkForceUpdate(context, psAppInfo, appInfoProvider);
      } else {
        checkForceUpdate(context, psAppInfo, appInfoProvider);
      }
    } else {
      appInfoProvider.replaceVersionForceUpdateData(false);
      //
      if (appInfoProvider.psValueHolder != null &&
          appInfoProvider.psValueHolder.locationId != null) {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.login_container,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.login_container,
        );
      }
    }
  }

  dynamic checkForceUpdate(BuildContext context, PSAppInfo psAppInfo,
      AppInfoProvider appInfoProvider) {
    if (psAppInfo.psAppVersion.versionForceUpdate == PsConst.ONE) {
      appInfoProvider.replaceAppInfoData(
          psAppInfo.psAppVersion.versionNo,
          true,
          psAppInfo.psAppVersion.versionTitle,
          psAppInfo.psAppVersion.versionMessage);

      Navigator.pushReplacementNamed(
        context,
        RoutePaths.force_update,
        arguments: psAppInfo.psAppVersion,
      );
    } else if (psAppInfo.psAppVersion.versionForceUpdate == PsConst.ZERO) {
      appInfoProvider.replaceVersionForceUpdateData(false);
      callVersionUpdateDialog(context, psAppInfo, appInfoProvider);
    } else {
      if (appInfoProvider.psValueHolder.locationId != null) {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.home,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.itemLocationList,
        );
      }
    }
  }

  dynamic callVersionUpdateDialog(BuildContext context, PSAppInfo psAppInfo,
      AppInfoProvider appInfoProvider) {
    showDialog<dynamic>(
        barrierDismissible: false,
        useRootNavigator: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return;
              },
              child: VersionUpdateDialog(
                title: psAppInfo.psAppVersion.versionTitle,
                description: psAppInfo.psAppVersion.versionMessage,
                leftButtonText:
                    Utils.getString(context, 'app_info__cancel_button_name'),
                rightButtonText:
                    Utils.getString(context, 'app_info__update_button_name'),
                onCancelTap: () {
                  if (appInfoProvider.psValueHolder.locationId != null) {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutePaths.home,
                    );
                  } else {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutePaths.itemLocationList,
                    );
                  }
                },
                onUpdateTap: () async {
                  if (appInfoProvider.psValueHolder.locationId != null) {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutePaths.home,
                    );
                  } else {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutePaths.itemLocationList,
                    );
                  }

                  if (Platform.isIOS) {
                    Utils.launchAppStoreURL(iOSAppId: PsConfig.iOSAppStoreId);
                  } else if (Platform.isAndroid) {
                    Utils.launchURL();
                  }
                },
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    AppInfoRepository repo1;
    AppInfoProvider provider;
    ClearAllDataRepository clearAllDataRepository;
    ClearAllDataProvider clearAllDataProvider;
    // DeleteTaskProvider deleteTaskProvider;
    // DeleteTaskRepository deleteTaskRepository;
    PsValueHolder valueHolder;

    PsColors.loadColor(context);

    repo1 = Provider.of<AppInfoRepository>(context);
    clearAllDataRepository = Provider.of<ClearAllDataRepository>(context);
    // deleteTaskRepository = Provider.of<DeleteTaskRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    if (valueHolder == null) {
      return Container();
    }

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ClearAllDataProvider>(
            lazy: false,
            create: (BuildContext context) {
              clearAllDataProvider = ClearAllDataProvider(
                  repo: clearAllDataRepository, psValueHolder: valueHolder);

              return clearAllDataProvider;
            }),
        // ChangeNotifierProvider<DeleteTaskProvider>(
        //     lazy: false,
        //     create: (BuildContext context) {
        //       deleteTaskProvider = DeleteTaskProvider(
        //           repo: deleteTaskRepository, psValueHolder: valueHolder);

        //       return deleteTaskProvider;
        //     }),
        ChangeNotifierProvider<AppInfoProvider>(
            lazy: false,
            create: (BuildContext context) {
              provider =
                  AppInfoProvider(repo: repo1, psValueHolder: valueHolder);

              callDateFunction(provider, clearAllDataProvider,
              // deleteTaskProvider,
               context);

              return provider;
            }),
      ],
      child: Consumer<AppInfoProvider>(
        builder: (BuildContext context, AppInfoProvider clearAllDataProvider,
            Widget child) {
          return Container(
              height: 400,
              color: PsColors.mainColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Consumer<ClearAllDataProvider>(builder: (BuildContext context,
                  //     ClearAllDataProvider provider, Widget child) {
                  //   if (provider == null)
                  //     return const Text('null');
                  //   else
                  //     return const Text('not null');
                  // }),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _imageWidget,
                      const SizedBox(
                        height: PsDimens.space16,
                      ),
                      Text(
                        Utils.getString(context, 'app_name'),
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold, color: PsColors.white),
                      ),
                      const SizedBox(
                        height: PsDimens.space8,
                      ),
                      Text(
                        Utils.getString(context, 'app_info__splash_name'),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontWeight: FontWeight.bold, color: PsColors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.all(PsDimens.space16),
                         child: PsSquareProgressWidget()
                      ),
                    ],
                  )
                ],
              ));
          // });
        },
      ),
      // ),
    );
  }
}

class PsButtonWidget extends StatefulWidget {
  const PsButtonWidget({
    @required this.provider,
    @required this.text,
  });
  final AppInfoProvider provider;
  final String text;

  @override
  _PsButtonWidgetState createState() => _PsButtonWidgetState();
}

class _PsButtonWidgetState extends State<PsButtonWidget> {
  @override
  Widget build(BuildContext context) {
    // return CircularProgressIndicator(
    //     valueColor: AlwaysStoppedAnimation<Color>(PsColors.loadingCircleColor),
    //     strokeWidth: 5.0);

    return PsSquareProgressWidget();
  }
}
