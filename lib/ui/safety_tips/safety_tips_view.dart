import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/utils/utils.dart';

class SafetyTipsView extends StatefulWidget {
  const SafetyTipsView({
    Key key,
    @required this.animationController,
    @required this.safetyTips,
  }) : super(key: key);

  final AnimationController animationController;
  final String safetyTips;
  @override
  _SafetyTipsViewState createState() => _SafetyTipsViewState();
}

class _SafetyTipsViewState extends State<SafetyTipsView> {
  @override
  Widget build(BuildContext context) {
    // final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
    //     .animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController.forward();
    return Scaffold(
        appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(
            Utils.getString(context, 'safety_tips__app_bar_name'),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Padding(
            padding: const EdgeInsets.all(PsDimens.space10),
            child: Text(
              widget.safetyTips ?? '',
              style: Theme.of(context).textTheme.bodyText1,
            )));
    //  AnimatedBuilder(
    //   animation: widget.animationController,
    //   builder: (BuildContext context, Widget child) {
    //     return FadeTransition(
    //       opacity: animation,
    //       child: Transform(
    //         transform: Matrix4.translationValues(
    //             0.0, 100 * (1.0 - animation.value), 0.0),
    //         child: Padding(
    //           padding: const EdgeInsets.all(PsDimens.space10),
    //           child: SingleChildScrollView(
    //             child: Text(
    //               widget.safetyTips ?? '',
    //               style: Theme.of(context).textTheme.bodyText1,
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // ));
  }
}
