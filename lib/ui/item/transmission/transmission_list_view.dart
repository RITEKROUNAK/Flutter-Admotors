import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/provider/transmission/transmission_provider.dart';
import 'package:flutteradmotors/repository/transmission_repository.dart';
import 'package:flutteradmotors/ui/item/transmission/transmission_list_item.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/transmission.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TransmissionListView extends StatefulWidget {
  const TransmissionListView({Key key, @required this.transmissionName})
      : super(key: key);
  final String transmissionName;
  @override
  State<StatefulWidget> createState() {
    return _TransmissionListViewState();
  }
}

class _TransmissionListViewState extends State<TransmissionListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  TransmissionProvider _transmissionProvider;
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
        _transmissionProvider.nextTransmissionList();
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

  TransmissionRepository transmissionRepo;
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

    transmissionRepo = Provider.of<TransmissionRepository>(context);

    print(
        '............................Build UI Again ............................');
    if (widget.transmissionName != null && selectedName != '') {
      selectedName = widget.transmissionName;
    }
    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<TransmissionProvider>(
          appBarTitle:
              Utils.getString(context, 'transmission_list__app_bar_name') ?? '',
          initProvider: () {
            return TransmissionProvider(
                repo: transmissionRepo,
                psValueHolder: Provider.of<PsValueHolder>(context));
          },
          onProviderReady: (TransmissionProvider provider) {
            provider.loadTransmissionList();
            _transmissionProvider = provider;
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
          builder: (BuildContext context, TransmissionProvider provider,
              Widget child) {
            return Stack(children: <Widget>[
              Container(
                  child:
              RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.transmissionList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.transmissionList.status ==
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
                        final int count = provider.transmissionList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: TransmissionListItem(
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              transmission:
                                  provider.transmissionList.data[index],
                              onTap: () {
                                final Transmission transmission =
                                    provider.transmissionList.data[index];
                                Navigator.pop(context, transmission);
                              },
                              selectedName: selectedName,
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetTransmissionList();
                },
              ),
              ),
              PSProgressIndicator(provider.transmissionList.status,
              message: provider.transmissionList.message)
            ]);
          }),
    );
  }
}
