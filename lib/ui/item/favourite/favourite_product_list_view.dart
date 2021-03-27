import 'package:flutteradmotors/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/product/favourite_item_provider.dart';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/item/item/product_vertical_list_item.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:provider/provider.dart';

class FavouriteProductListView extends StatefulWidget {
  const FavouriteProductListView(
      {Key key, this.scrollController, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  final ScrollController scrollController;
  @override
  _FavouriteProductListView createState() => _FavouriteProductListView();
}

class _FavouriteProductListView extends State<FavouriteProductListView>
    with TickerProviderStateMixin {
  FavouriteItemProvider _favouriteItemProvider;
  // final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // if (widget.scrollController != null) {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        _favouriteItemProvider.nextFavouriteItemList();
      }
    });
    // } else {
    //   _scrollController.addListener(() {
    //     if (_scrollController.position.pixels ==
    //         _scrollController.position.maxScrollExtent) {
    //       _favouriteItemProvider.nextFavouriteItemList();
    //     }
    //   });
    // }

    super.initState();
  }

  ProductRepository repo1;
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
    // data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    // return EasyLocalizationProvider(
    //     data: data,
    //     child:
    return ChangeNotifierProvider<FavouriteItemProvider>(
        lazy: false,
        create: (BuildContext context) {
          final FavouriteItemProvider provider =
              FavouriteItemProvider(repo: repo1, psValueHolder: psValueHolder);
          provider.loadFavouriteItemList();
          _favouriteItemProvider = provider;
          return _favouriteItemProvider;
        },
        child: Consumer<FavouriteItemProvider>(
          builder: (BuildContext context, FavouriteItemProvider provider,
              Widget child) {
            return Column(
              children: <Widget>[
                const PsAdMobBannerWidget(),
                Expanded(
                  child: Stack(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space4,
                            right: PsDimens.space4,
                            top: PsDimens.space4,
                            bottom: PsDimens.space4),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: widget.scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 220.0,
                                          childAspectRatio: 0.6),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.favouriteItemList.data !=
                                              null ||
                                          provider.favouriteItemList.data
                                              .isNotEmpty) {
                                        final int count = provider
                                            .favouriteItemList.data.length;
                                        return ProductVeticalListItem(
                                          coreTagKey:
                                              provider.hashCode.toString() +
                                                  provider.favouriteItemList
                                                      .data[index].id,
                                          animationController:
                                              widget.animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent:
                                                  widget.animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          product: provider
                                              .favouriteItemList.data[index],
                                          onTap: () async {
                                            final Product product = provider
                                                .favouriteItemList.data.reversed
                                                .toList()[index];
                                            final ProductDetailIntentHolder
                                                holder =
                                                ProductDetailIntentHolder(
                                                    productId: provider
                                                        .favouriteItemList
                                                        .data[index].id,
                                                    heroTagImage: provider
                                                            .hashCode
                                                            .toString() +
                                                        product.id +
                                                        PsConst.HERO_TAG__IMAGE,
                                                    heroTagTitle: provider
                                                            .hashCode
                                                            .toString() +
                                                        product.id +
                                                        PsConst
                                                            .HERO_TAG__TITLE);
                                            await Navigator.pushNamed(context,
                                                RoutePaths.productDetail,
                                                arguments: holder);

                                            await provider
                                                .resetFavouriteItemList();
                                          },
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount:
                                        provider.favouriteItemList.data.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return provider.resetFavouriteItemList();
                          },
                        )),
                    PSProgressIndicator(provider.favouriteItemList.status)
                  ]),
                )
              ],
            );
          },
          // ),
        ));
  }
}
