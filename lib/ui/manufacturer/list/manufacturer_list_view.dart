import 'package:flutteradmotors/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/provider/manufacturer/manufacturer_provider.dart';
import 'package:flutteradmotors/repository/manufacturer_repository.dart';
import 'package:flutteradmotors/ui/manufacturer/item/manufacturer_vertical_list_item.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:provider/provider.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';

class ManufacturerListView extends StatefulWidget {
  const ManufacturerListView(this.scrollController);

  final ScrollController scrollController;
  @override
  _ManufacturerListViewState createState() {
    return _ManufacturerListViewState();
  }
}

class _ManufacturerListViewState extends State<ManufacturerListView>
    with TickerProviderStateMixin {
  ManufacturerProvider _categoryProvider;

  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        _categoryProvider.nextManufacturerList();
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  ManufacturerRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    repo1 = Provider.of<ManufacturerRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: ChangeNotifierProvider<ManufacturerProvider>(
            lazy: false,
            create: (BuildContext context) {
              final ManufacturerProvider provider = ManufacturerProvider(
                  repo: repo1, psValueHolder: psValueHolder);
              provider.loadManufacturerList();
              _categoryProvider = provider;
              return _categoryProvider;
            },
            child: Consumer<ManufacturerProvider>(builder:
                (BuildContext context, ManufacturerProvider provider,
                    Widget child) {
              return Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(),
                  Expanded(
                    child: Stack(children: <Widget>[
                      Container(
                          margin: const EdgeInsets.all(PsDimens.space8),
                          child: RefreshIndicator(
                            child: CustomScrollView(
                                controller: widget.scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                slivers: <Widget>[
                                  SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 240.0,
                                            childAspectRatio: 1.4),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        if (provider.manufacturerList.data !=
                                                null ||
                                            provider.manufacturerList.data
                                                .isNotEmpty) {
                                          final int count = provider
                                              .manufacturerList.data.length;
                                          return ManufacturerVerticalListItem(
                                              animationController:
                                                  animationController,
                                              animation: Tween<double>(
                                                      begin: 0.0, end: 1.0)
                                                  .animate(CurvedAnimation(
                                                parent: animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn),
                                              )),
                                              manufacturer: provider
                                                  .manufacturerList.data[index],
                                              onTap: () {
                                                if (PsConfig.isShowModel) {
                                                  Navigator.pushNamed(context,
                                                      RoutePaths.modelGrid,
                                                      arguments: provider
                                                          .manufacturerList
                                                          .data[index]);
                                                } else {
                                                  final String loginUserId =
                                                      Utils.checkUserLoginId(
                                                          psValueHolder);
                                                  final TouchCountParameterHolder
                                                      touchCountParameterHolder =
                                                      TouchCountParameterHolder(
                                                          itemId: provider
                                                              .manufacturerList
                                                              .data[index]
                                                              .id,
                                                          userId: loginUserId);
                                                  provider.postTouchCount(
                                                      touchCountParameterHolder
                                                          .toMap());
                                                  final ProductParameterHolder
                                                      productParameterHolder =
                                                      ProductParameterHolder()
                                                          .getLatestParameterHolder();
                                                  productParameterHolder
                                                          .manufacturerId =
                                                      provider.manufacturerList
                                                          .data[index].id;
                                                  Navigator.pushNamed(
                                                      context,
                                                      RoutePaths
                                                          .filterProductList,
                                                      arguments:
                                                          ProductListIntentHolder(
                                                        appBarTitle: provider
                                                            .manufacturerList
                                                            .data[index]
                                                            .name,
                                                        productParameterHolder:
                                                            productParameterHolder,
                                                      ));
                                                }
                                              });
                                        } else {
                                          return null;
                                        }
                                      },
                                      childCount:
                                          provider.manufacturerList.data.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              return provider.resetManufacturerList();
                            },
                          )),
                      PSProgressIndicator(
                        provider.manufacturerList.status,
                        message: provider.manufacturerList.message,
                      )
                    ]),
                  )
                ],
              );
            })));
  }
}
