import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/provider/item_build_type/item_build_type_provider.dart';
import 'package:flutteradmotors/repository/item_build_type_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/item/item_build_type/item_build_type_list_item.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/item_build_type.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ItemBuildTypeListView extends StatefulWidget {
  const ItemBuildTypeListView({Key key, @required this.buildTypeName})
      : super(key: key);
  final String buildTypeName;
  @override
  State<StatefulWidget> createState() {
    return _ItemBuildTypeListViewState();
  }
}

class _ItemBuildTypeListViewState extends State<ItemBuildTypeListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemBuildTypeProvider _itemBuildTypeProvider;
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
        _itemBuildTypeProvider.nextItemBuildTypeList();
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

  ItemBuildTypeRepository itemBuildTypeRepo;
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

    itemBuildTypeRepo = Provider.of<ItemBuildTypeRepository>(context);

    print(
        '............................Build UI Again ............................');
    if (widget.buildTypeName != null && selectedName != '') {
      selectedName = widget.buildTypeName;
    }
    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemBuildTypeProvider>(
          appBarTitle:
              Utils.getString(context, 'item_build_type_list__app_bar_name') ??
                  '',
          initProvider: () {
            return ItemBuildTypeProvider(
                repo: itemBuildTypeRepo,
                psValueHolder: Provider.of<PsValueHolder>(context));
          },
          onProviderReady: (ItemBuildTypeProvider provider) {
            provider.loadItemBuildTypeList();
            _itemBuildTypeProvider = provider;
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
              (BuildContext context, ItemBuildTypeProvider provider, Widget child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.itemBuildTypeList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemBuildTypeList.status == PsStatus.BLOCK_LOADING) {
                        return Shimmer.fromColors(
                            baseColor: PsColors.grey,
                            highlightColor: PsColors.white,
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
                        final int count = provider.itemBuildTypeList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: ItemBuildTypeListItem(
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              itemBuildType: provider.itemBuildTypeList.data[index],
                              onTap: () {
                                final ItemBuildType buildType =
                                    provider.itemBuildTypeList.data[index];
                                Navigator.pop(context, buildType);
                              },
                              selectedName: selectedName,
                             
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetItemBuildTypeList();
                },
              )),
              PSProgressIndicator(provider.itemBuildTypeList.status,
              message: provider.itemBuildTypeList.message,)
            ]);
          }),
    );
  }
}