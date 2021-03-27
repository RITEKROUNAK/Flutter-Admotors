import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/provider/item_fuel_type/item_fuel_type_provider.dart';
import 'package:flutteradmotors/repository/item_fuel_type_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/item/item_fuel_type/item_fuel_type_list_item.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/item_fuel_type.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ItemFuelTypeListView extends StatefulWidget {
  const ItemFuelTypeListView({Key key, @required this.itemFuelTypeName})
      : super(key: key);
  final String itemFuelTypeName;
  @override
  State<StatefulWidget> createState() {
    return _ItemFuelTypeListViewState();
  }
}

class _ItemFuelTypeListViewState extends State<ItemFuelTypeListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemFuelTypeProvider _itemFuelTypeProvider;
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
        _itemFuelTypeProvider.nextItemFuelTypeList();
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

  ItemFuelTypeRepository itemFuelTypeRepo;
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

    itemFuelTypeRepo = Provider.of<ItemFuelTypeRepository>(context);

    print(
        '............................Build UI Again ............................');
    if (widget.itemFuelTypeName != null && selectedName != '') {
      selectedName = widget.itemFuelTypeName;
    }
    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemFuelTypeProvider>(
          appBarTitle:
              Utils.getString(context, 'item_fuel_type_list__app_bar_name') ??
                  '',
          initProvider: () {
            return ItemFuelTypeProvider(
                repo: itemFuelTypeRepo,
                psValueHolder: Provider.of<PsValueHolder>(context));
          },
          onProviderReady: (ItemFuelTypeProvider provider) {
            provider.loadItemFuelTypeList();
            _itemFuelTypeProvider = provider;
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
          builder: (BuildContext context, ItemFuelTypeProvider provider,
              Widget child) {
            return Stack(children: <Widget>[
              // Container(
              //     child:
              RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.itemFuelTypeList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemFuelTypeList.status ==
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
                        final int count = provider.itemFuelTypeList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: ItemFuelTypeListItem(
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              itemFuelType:
                                  provider.itemFuelTypeList.data[index],
                              onTap: () {
                                final ItemFuelType fuelName =
                                    provider.itemFuelTypeList.data[index];
                                Navigator.pop(context, fuelName);
                              },
                              selectedName: selectedName,
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetItemFuelTypeList();
                },
              ),
              // ),
              PSProgressIndicator(provider.itemFuelTypeList.status)
            ]);
          }),
    );
  }
}
