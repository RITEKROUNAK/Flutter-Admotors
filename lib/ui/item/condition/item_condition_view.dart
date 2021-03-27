import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';

import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/provider/product/item_condition_provider.dart';
import 'package:flutteradmotors/repository/item_condition_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/item/condition/item_condition_list_view_item.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ItemConditionView extends StatefulWidget {
  const ItemConditionView({Key key, @required this.itemConditionName})
      : super(key: key);
  final String itemConditionName;
  @override
  State<StatefulWidget> createState() {
    return ItemConditionViewState();
  }
}

class ItemConditionViewState extends State<ItemConditionView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemConditionProvider _itemConditionProvider;
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
        _itemConditionProvider.nextItemConditionList();
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

  ItemConditionRepository repo1;
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

    repo1 = Provider.of<ItemConditionRepository>(context);

    print(
        '............................Build UI Again ............................');
    if (widget.itemConditionName != null && selectedName != '') {
      selectedName = widget.itemConditionName;
    }
    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemConditionProvider>(
          appBarTitle:
              Utils.getString(context, 'item_condition_list__app_bar_name') ??
                  '',
          initProvider: () {
            return ItemConditionProvider(
              repo: repo1,
            );
          },
          onProviderReady: (ItemConditionProvider provider) {
            provider.loadItemConditionList();
            _itemConditionProvider = provider;
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
          builder: (BuildContext context, ItemConditionProvider provider,
              Widget child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.itemConditionList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemConditionList.status ==
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
                        final int count =
                            provider.itemConditionList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: ItemConditionListViewItem(
                              itemCondition:
                                  provider.itemConditionList.data[index],
                              selectedName: selectedName,
                              onTap: () {
                                Navigator.pop(context,
                                    provider.itemConditionList.data[index]);
                                print(provider
                                    .itemConditionList.data[index].name);
                                // if (index == 0) {
                                //   Navigator.pushNamed(
                                //     context,
                                //     RoutePaths.searchCategory,
                                //   );
                                // }
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
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetItemConditionList();
                },
              )),
              PSProgressIndicator(provider.itemConditionList.status)
            ]);
          }),
    );
  }
}
