import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/provider/manufacturer/manufacturer_provider.dart';
import 'package:flutteradmotors/repository/manufacturer_repository.dart';
import 'package:flutteradmotors/ui/choose_manufacturer/choose_manufacturer_list_item.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ChooseManufacturerListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChooseManufacturerListViewState();
  }
}

class _ChooseManufacturerListViewState extends State<ChooseManufacturerListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ManufacturerProvider _manufacturerProvider;
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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _manufacturerProvider.nextManufacturerList();
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController);
    super.initState();
  }

  ManufacturerRepository repo1;

  @override
  Widget build(BuildContext context) {
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

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ManufacturerProvider>(
          appBarTitle:
              Utils.getString(context, 'manufacturer_list__app_bar_name') ?? '',
          initProvider: () {
            return ManufacturerProvider(
                repo: repo1,
                psValueHolder: Provider.of<PsValueHolder>(context));
          },
          onProviderReady: (ManufacturerProvider provider) {
            provider.loadManufacturerList();
            _manufacturerProvider = provider;
          },
          builder: (BuildContext context, ManufacturerProvider provider,
              Widget child) {
            return Stack(children: <Widget>[
              // Container(
              //     child:
              RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: provider.manufacturerList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.manufacturerList.status ==
                          PsStatus.BLOCK_LOADING) {
                        return Shimmer.fromColors(
                            baseColor: PsColors.grey,
                            highlightColor: PsColors.white,
                            child: Column(children: const <Widget>[
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                            ]));
                      } else {
                        final int count = provider.manufacturerList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: ChooseManufacturerListItem(
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              manufacturer:
                                  provider.manufacturerList.data[index],
                              onTap: () {
                                final Manufacturer manufacturer =
                                    provider.manufacturerList.data[index];
                                Navigator.pop(context, manufacturer);
                              },
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetManufacturerList();
                },
              ),
              // ),
              PSProgressIndicator(provider.manufacturerList.status)
            ]);
          }),
    );
  }
}
