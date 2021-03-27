import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/ui/item/paid_ad/paid_ad_item_list_view.dart';

import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/material.dart';

class PaidItemListContainerView extends StatefulWidget {
  @override
  _PaidItemListContainerViewState createState() =>
      _PaidItemListContainerViewState();
}

class _PaidItemListContainerViewState extends State<PaidItemListContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          backgroundColor:
              Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
          title: Text(
            Utils.getString(context, 'more__paid_ads_title'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: PsColors.white),
          ),
          elevation: 0,
        ),
        body: PaidAdItemListView(
          scrollController: scrollController,
          animationController: animationController,
        ),
      ),
    );
  }
}
