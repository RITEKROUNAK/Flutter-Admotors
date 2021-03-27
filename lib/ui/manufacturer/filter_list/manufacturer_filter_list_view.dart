import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/provider/manufacturer/manufacturer_provider.dart';
import 'package:flutteradmotors/repository/manufacturer_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/manufacturer/item/manufacturer_search_list_item.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ManufacturerFilterListView extends StatefulWidget {
  const ManufacturerFilterListView({Key key, @required this.manufacturerName})
      : super(key: key);
  final String manufacturerName;
  @override
  State<StatefulWidget> createState() {
    return _ManufacturerFilterListViewState();
  }
}

class _ManufacturerFilterListViewState extends State<ManufacturerFilterListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _categoryProvider.nextManufacturerList();
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
  String selectedName = 'selectedName';

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          if (selectedName == '') {
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context, false);
          }
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    repo1 = Provider.of<ManufacturerRepository>(context);

    print(
        '............................Build UI Again ............................');
    if (widget.manufacturerName != null && selectedName != '') {
      selectedName = widget.manufacturerName;
    }
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
            _categoryProvider = provider;
          },
          actions: <Widget>[
            IconButton(
                icon: Icon(MaterialCommunityIcons.filter_remove_outline,
                    color: PsColors.mainColor),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      selectedName = '';
                    });
                  }
                }),
          ],
          builder: (BuildContext context, ManufacturerProvider provider,
              Widget child) {
            return Stack(children: <Widget>[
              // Container(
              //     child:
              RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
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
                            child: ManufacturerFilterListItem(
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              selectedName: selectedName,
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
              PSProgressIndicator(provider.manufacturerList.status,
              message: provider.manufacturerList.message,)
            ]);
          }),
    );
  }
}
