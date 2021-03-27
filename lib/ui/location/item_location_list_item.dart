import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/item_location.dart';

class ItemLocationListItem extends StatelessWidget {
  const ItemLocationListItem(
      {Key key,
      @required this.itemLocation,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final ItemLocation itemLocation;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: InkWell(
            onTap: onTap,
            child: Container(
                margin: const EdgeInsets.only(bottom: PsDimens.space8),
                child: Ink(
                    child: ItemLocationListItemWidget(
                        itemLocation: itemLocation)))),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child));
        });
  }
}

class ItemLocationListItemWidget extends StatelessWidget {
  const ItemLocationListItemWidget({
    Key key,
    @required this.itemLocation,
  }) : super(key: key);

  final ItemLocation itemLocation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PsDimens.space16),
      child: Text(
        itemLocation.name,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
