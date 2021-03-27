import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';

import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/provider/model/model_provider.dart';
import 'package:flutteradmotors/repository/model_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/model/item/sub_category_search_list_item.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SubCategorySearchListView extends StatefulWidget {
  const SubCategorySearchListView(
      {@required this.modelName, @required this.categoryId});

  final String categoryId;
  final String modelName;
  @override
  State<StatefulWidget> createState() {
    return _SubCategorySearchListViewState();
  }
}

class _SubCategorySearchListViewState extends State<SubCategorySearchListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ModelProvider _modelProvider;
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
        _modelProvider.nextModelList(widget.categoryId);
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

  ModelRepository repo1;
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

    repo1 = Provider.of<ModelRepository>(context);

    print(
        '............................Build UI Again ............................');
    if (widget.modelName != null && selectedName != '') {
      selectedName = widget.modelName;
    }
    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ModelProvider>(
          appBarTitle:
              Utils.getString(context, 'model_list__app_bar_name') ?? '',
          initProvider: () {
            return ModelProvider(
              repo: repo1,
            );
          },
          onProviderReady: (ModelProvider provider) {
            provider.loadModelList(widget.categoryId);
            _modelProvider = provider;
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
              (BuildContext context, ModelProvider provider, Widget child) {
            return Stack(children: <Widget>[
              Container(

                  child: RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.modelList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.modelList.status == PsStatus.BLOCK_LOADING) {
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
                        final int count = provider.modelList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: SubCategorySearchListItem(
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              subCategory: provider.modelList.data[index],
                              selectedName: selectedName,
                              onTap: () {
                                print(provider.modelList.data[index]
                                    .defaultPhoto.imgPath);

                                Navigator.of(context, rootNavigator: true)
                                    .pop(provider.modelList.data[index]);
                              },
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetModelList(widget.categoryId);
                },
              )),
              PSProgressIndicator(provider.modelList.status,
              message: provider.modelList.message,)
            ]);
          }),
    );
  }
}
