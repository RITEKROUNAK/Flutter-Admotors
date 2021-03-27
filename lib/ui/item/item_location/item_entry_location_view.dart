import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/provider/item_location/item_location_provider.dart';
import 'package:flutteradmotors/repository/item_location_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/location/item_location_view.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'item_entry_location_list_view_item.dart';

class ItemEntryLocationView extends StatefulWidget {
  const ItemEntryLocationView({Key key, @required this.itemLocationName})
      : super(key: key);
  final String itemLocationName;
  @override
  State<StatefulWidget> createState() {
    return ItemEntryLocationViewState();
  }
}

class ItemEntryLocationViewState extends State<ItemEntryLocationView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemLocationProvider _itemLocationProvider;
  AnimationController animationController;
  Animation<double> animation;
  PsValueHolder valueHolder;

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
        _itemLocationProvider.nextItemLocationList(_itemLocationProvider.defaultLocationParameterHolder.toMap(),
            Utils.checkUserLoginId(_itemLocationProvider.psValueHolder));
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

  ItemLocationRepository repo1;
  String selectedName = 'selectedName';

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
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

    repo1 = Provider.of<ItemLocationRepository>(context);

    print(
        '............................Build UI Again ............................');
    if (widget.itemLocationName != null && selectedName != '') {
      selectedName = widget.itemLocationName;
    }
    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemLocationProvider>(
          appBarTitle:
              Utils.getString(context, 'item_location_list__app_bar_name') ??
                  '',
          initProvider: () {
            return ItemLocationProvider(
                repo: repo1, psValueHolder: valueHolder);
          },
          onProviderReady: (ItemLocationProvider provider) {
            provider.defaultLocationParameterHolder.keyword = searchNameController.text;
            provider.loadItemLocationList(provider.defaultLocationParameterHolder.toMap(),
            Utils.checkUserLoginId(provider.psValueHolder));
            _itemLocationProvider = provider;
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
          builder: (BuildContext context, ItemLocationProvider provider,
              Widget child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.itemLocationList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemLocationList.status ==
                          PsStatus.BLOCK_LOADING) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.white,
                            child: Column(children: const <Widget>[
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                            ]));
                      } else {
                        final int count = provider.itemLocationList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: ItemEntryLocationListViewItem(
                              itemLocation:
                                  provider.itemLocationList.data[index],
                              onTap: () {
                                Navigator.pop(context,
                                    provider.itemLocationList.data[index]);
                                print(
                                    provider.itemLocationList.data[index].name);
                              },
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
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetItemLocationList(provider.defaultLocationParameterHolder.toMap(),
                  Utils.checkUserLoginId(provider.psValueHolder));
                },
              )),
              PSProgressIndicator(provider.itemLocationList.status,
              message: provider.itemLocationList.message)
            ]);
          }),
    );
  }
}
