import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/provider/item_color/item_color_provider.dart';
import 'package:flutteradmotors/repository/item_color_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/item/item_color/item_color_list_item.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/Item_color.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ItemColorListView extends StatefulWidget {
  const ItemColorListView({Key key, @required this.itemColorName})
      : super(key: key);
  final String itemColorName;
  @override
  State<StatefulWidget> createState() {
    return _ItemColorListViewState();
  }
}

class _ItemColorListViewState extends State<ItemColorListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemColorProvider _itemColorProvider;
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
        _itemColorProvider.nextItemColorList();
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

  ItemColorRepository itemColorRepo;
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

    itemColorRepo = Provider.of<ItemColorRepository>(context);

    print(
        '............................Build UI Again ............................');
    if (widget.itemColorName != null && selectedName != '') {
      selectedName = widget.itemColorName;
    }
    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemColorProvider>(
          appBarTitle:
              Utils.getString(context, 'item_color_list__app_bar_name') ?? '',
          initProvider: () {
            return ItemColorProvider(
                repo: itemColorRepo,
                psValueHolder: Provider.of<PsValueHolder>(context));
          },
          onProviderReady: (ItemColorProvider provider) {
            provider.loadItemColorList();
            _itemColorProvider = provider;
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
          builder:
              (BuildContext context, ItemColorProvider provider, Widget child) {
            return Stack(children: <Widget>[
              // Container(
              //     child:
              RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.itemColorList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemColorList.status ==
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
                        final int count = provider.itemColorList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: ItemColorListItem(
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              itemColor: provider.itemColorList.data[index],
                              onTap: () {
                                final ItemColor colorValue =
                                    provider.itemColorList.data[index];
                                Navigator.pop(context, colorValue);
                              },
                              selectedName: selectedName,
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetItemColorList();
                },
              ),
              // ),
              PSProgressIndicator(provider.itemColorList.status)
            ]);
          }),
    );
  }
}
