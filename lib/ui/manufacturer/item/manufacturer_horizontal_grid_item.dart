import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';

class ManufacturerHorizontalGridItem extends StatelessWidget {
  const ManufacturerHorizontalGridItem({
    Key key,
    @required this.manufacturer,
    this.onTap,
  }) : super(key: key);

  final Manufacturer manufacturer;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: PsDimens.space100,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              PsNetworkCircleIconImage(
                photoKey: '',
                defaultIcon: manufacturer.defaultIcon,
                width: PsDimens.space52,
                height: PsDimens.space52,
                boxfit: BoxFit.fitHeight,
              ),
              const SizedBox(
                height: PsDimens.space8,
              ),
              Text(
                manufacturer.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
