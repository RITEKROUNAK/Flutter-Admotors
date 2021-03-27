import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/provider/item_seller_type/item_seller_type_provider.dart';
import 'package:flutteradmotors/repository/item_seller_type_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/item/item_seller_type/item_seller_type_list_item.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/item_seller_type.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ItemSellerTypeListView extends StatefulWidget {
  const ItemSellerTypeListView({Key key, @required this.itemSellerTypeName})
      : super(key: key);
  final String itemSellerTypeName;
  @override
  State<StatefulWidget> createState() {
    return _ItemSellerTypeListViewState();
  }
}

class _ItemSellerTypeListViewState extends State<ItemSellerTypeListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemSellerTypeProvider _itemSellerTypeProvider;
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
        _itemSellerTypeProvider.nextItemSellerTypeList();
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

  ItemSellerTypeRepository itemSellerTypeRepo;
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

    itemSellerTypeRepo = Provider.of<ItemSellerTypeRepository>(context);

    print(
        '............................Build UI Again ............................');
    if (widget.itemSellerTypeName != null && selectedName != '') {
      selectedName = widget.itemSellerTypeName;
    }
    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemSellerTypeProvider>(
          appBarTitle:
              Utils.getString(context, 'item_seller_type_list__app_bar_name') ??
                  '',
          initProvider: () {
            return ItemSellerTypeProvider(
                repo: itemSellerTypeRepo,
                psValueHolder: Provider.of<PsValueHolder>(context));
          },
          onProviderReady: (ItemSellerTypeProvider provider) {
            provider.loadItemSellerTypeList();
            _itemSellerTypeProvider = provider;
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
          builder: (BuildContext context, ItemSellerTypeProvider provider,
              Widget child) {
            return Stack(children: <Widget>[
              // Container(
              //     child:
              RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.itemSellerTypeList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemSellerTypeList.status ==
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
                        final int count =
                            provider.itemSellerTypeList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: ItemSellerTypeListItem(
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              itemSellerType:
                                  provider.itemSellerTypeList.data[index],
                              onTap: () {
                                final ItemSellerType sellerType =
                                    provider.itemSellerTypeList.data[index];
                                Navigator.pop(context, sellerType);
                              },
                              selectedName: selectedName,
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetItemSellerTypeList();
                },
              ),
              // ),
              PSProgressIndicator(provider.itemSellerTypeList.status)
            ]);
          }),
    );
  }
}
