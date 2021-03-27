import 'package:flutteradmotors/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/model/model_provider.dart';
import 'package:flutteradmotors/repository/model_repository.dart';
import 'package:flutteradmotors/ui/model/item/model_grid_item.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:shimmer/shimmer.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/utils/utils.dart';

class ModelGridView extends StatefulWidget {
  const ModelGridView({this.manufacturer});
  final Manufacturer manufacturer;
  @override
  _ModelGridViewState createState() {
    return _ModelGridViewState();
  }
}

class _ModelGridViewState extends State<ModelGridView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ModelProvider _subCategoryProvider;

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
        final String categId = widget.manufacturer.id;
        Utils.psPrint('CategoryId number is $categId');

        _subCategoryProvider.nextModelList(widget.manufacturer.id);
      }
    });
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  ModelRepository repo1;
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
    timeDilation = 1.0;
    repo1 = Provider.of<ModelRepository>(context);
    // final dynamic data = EasyLocalizationProvider.of(context).data;

    // return EasyLocalizationProvider(
    //     data: data,
    //     child:
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PsColors.mainColor,
          brightness: Utils.getBrightnessForAppBar(context),
          title: Text(
            widget.manufacturer.name,
            // style: TextStyle(color: PsColors.white),
          ),
          iconTheme: IconThemeData(
            color: PsColors.white,
          ),
        ),
        body: ChangeNotifierProvider<ModelProvider>(
            lazy: false,
            create: (BuildContext context) {
              _subCategoryProvider = ModelProvider(repo: repo1);
              _subCategoryProvider.loadModelList(widget.manufacturer.id);
              return _subCategoryProvider;
            },
            child: Consumer<ModelProvider>(builder:
                (BuildContext context, ModelProvider provider, Widget child) {
              return Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(),
                  Expanded(
                    child: Stack(children: <Widget>[
                      Container(
                          child: RefreshIndicator(
                        onRefresh: () {
                          return _subCategoryProvider
                              .resetModelList(widget.manufacturer.id);
                        },
                        child: CustomScrollView(
                            controller: _scrollController,
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
                                    if (provider.modelList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: PsColors.grey,
                                          highlightColor: PsColors.white,
                                          child:
                                              Column(children: const <Widget>[
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                          ]));
                                    } else {
                                      final int count =
                                          provider.modelList.data.length;
                                      return ModelGridItem(
                                        model: provider.modelList.data[index],
                                        onTap: () {
                                          provider.itemByManufacturerIdParamenterHolder
                                                  .manufacturerId =
                                              provider.modelList.data[index]
                                                  .manufacturer.id;
                                          provider.itemByManufacturerIdParamenterHolder
                                                  .modelId =
                                              provider.modelList.data[index].id;
                                          Navigator.pushNamed(context,
                                              RoutePaths.filterProductList,
                                              arguments: ProductListIntentHolder(
                                                  appBarTitle: provider
                                                      .modelList
                                                      .data[index]
                                                      .name,
                                                  productParameterHolder: provider
                                                      .itemByManufacturerIdParamenterHolder));
                                        },
                                        animationController:
                                            animationController,
                                        animation:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        )),
                                      );
                                    }
                                  },
                                  childCount: provider.modelList.data.length,
                                ),
                              ),
                            ]),
                        //  ListView.builder(
                        //     physics: const AlwaysScrollableScrollPhysics(),
                        //     controller: _scrollController,
                        //     itemCount: provider.modelList.data.length,
                        //     itemBuilder: (BuildContext context, int index) {
                        // if (provider.modelList.status ==
                        //     PsStatus.BLOCK_LOADING) {
                        //   return Shimmer.fromColors(
                        //       baseColor: PsColors.grey,
                        //       highlightColor: PsColors.white,
                        //       child: Column(children: const <Widget>[
                        //         FrameUIForLoading(),
                        //         FrameUIForLoading(),
                        //         FrameUIForLoading(),
                        //         FrameUIForLoading(),
                        //         FrameUIForLoading(),
                        //         FrameUIForLoading(),
                        //       ]));
                        // } else {
                        //   return SubCategoryVerticalListItem(
                        //     subCategory: provider.modelList.data[index],
                        //     onTap: () {
                        //       print(provider.modelList.data[index]
                        //           .defaultPhoto.imgPath);
                        //     },
                        //     // )
                        //   );
                        // }
                        //     }),
                      )),
                      PSProgressIndicator(
                        provider.modelList.status,
                        message: provider.modelList.message,
                      )
                    ]),
                  )
                ],
              );
            }))
        // )
        );
  }
}

class FrameUIForLoading extends StatelessWidget {
  const FrameUIForLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.all(PsDimens.space16),
            decoration: BoxDecoration(color: PsColors.grey)),
        Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
              height: 15,
              margin: const EdgeInsets.all(PsDimens.space8),
              decoration: BoxDecoration(color: Colors.grey[300])),
          Container(
              height: 15,
              margin: const EdgeInsets.all(PsDimens.space8),
              decoration: const BoxDecoration(color: Colors.grey)),
        ]))
      ],
    );
  }
}
