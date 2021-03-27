import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/common/ps_hero.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/product.dart';

class ProductHorizontalListItemForProfile extends StatelessWidget {
  const ProductHorizontalListItemForProfile({
    Key key,
    @required this.product,
    @required this.coreTagKey,
    this.onTap,
  }) : super(key: key);

  final Product product;
  final Function onTap;
  final String coreTagKey;

  @override
  Widget build(BuildContext context) {
    // print('***Tag*** $coreTagKey${PsConst.HERO_TAG__IMAGE}');

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 0.0,
        color: PsColors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: PsDimens.space4, vertical: PsDimens.space12),
          decoration: BoxDecoration(
            color: PsColors.backgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          width: PsDimens.space180,
          // child:
          //  ClipPath(
          // child: Container(
          //   // color: Colors.white,
          //   width: PsDimens.space180,
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: PsDimens.space4,
                      top: PsDimens.space4,
                      right: PsDimens.space12,
                      bottom: PsDimens.space4,
                    ),
                    child: Row(
                      children: <Widget>[
                        PsNetworkCircleImageForUser(
                          photoKey: '',
                          imagePath: product.user.userProfilePhoto,
                          width: PsDimens.space40,
                          height: PsDimens.space40,
                          boxfit: BoxFit.cover,
                          onTap: () {
                            Utils.psPrint(product.defaultPhoto.imgParentId);
                            onTap();
                          },
                        ),
                        const SizedBox(width : PsDimens.space8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: PsDimens.space8,
                                top: PsDimens.space8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(product.user.userName == ''?
                                  Utils.getString(context, 'default__user_name'):
                                  '${product.user.userName}',
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                  Text('${product.addedDateStr}',
                                      textAlign: TextAlign.start,
                                      style:
                                          Theme.of(context).textTheme.caption)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Stack(
                  //   children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        PsNetworkImage(
                          photoKey: '$coreTagKey${PsConst.HERO_TAG__IMAGE}',
                          defaultPhoto: product.defaultPhoto,
                          width: PsDimens.space180,
                          height: double.infinity,
                          boxfit: BoxFit.cover,
                          onTap: () {
                            Utils.psPrint(product.defaultPhoto.imgParentId);
                            onTap();
                          },
                        ),
                        Positioned(
                            bottom: 0,
                            child: product.isSoldOut == '1'
                                ? Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: PsDimens.space12),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            Utils.getString(
                                                context, 'dashboard__sold_out'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: PsColors.white)),
                                      ),
                                    ),
                                    height: 30,
                                    width: PsDimens.space180,
                                    decoration: BoxDecoration(
                                        color: PsColors.soldOutUIColor),
                                  )
                                : Container()
                            //   )
                            // ],
                            ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space12,
                        right: PsDimens.space8,
                        bottom: PsDimens.space4),
                    child: PsHero(
                      tag: '$coreTagKey$PsConst.HERO_TAG__TITLE',
                      child: Text(
                        product.title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space4,
                        right: PsDimens.space8),
                    child: Row(
                      children: <Widget>[
                        PsHero(
                          tag: '$coreTagKey$PsConst.HERO_TAG__UNIT_PRICE',
                          flightShuttleBuilder: Utils.flightShuttleBuilder,
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                                product.price != ''
                                    ? '${product.itemCurrency.currencySymbol}${Utils.getPriceFormat(product.price)}'
                                    : '',
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(color: PsColors.mainColor)),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: PsDimens.space8,
                                  right: PsDimens.space8),
                              child: Text('(${product.conditionOfItem.name})',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: PsColors.mainColor))),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space12,
                        right: PsDimens.space8,
                        bottom: PsDimens.space4),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/baseline_pin_black_24.png',
                          width: PsDimens.space10,
                          height: PsDimens.space10,
                          fit: BoxFit.contain,

                          // ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: PsDimens.space8, right: PsDimens.space8),
                            child: Text('${product.itemLocation.name}',
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.caption))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        right: PsDimens.space8,
                        bottom: PsDimens.space16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: PsDimens.space8,
                              height: PsDimens.space8,
                              decoration: BoxDecoration(
                                  color: PsColors.itemTypeColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(PsDimens.space4))),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: PsDimens.space8,
                                    right: PsDimens.space4),
                                child: Text('${product.itemType.name}',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.caption))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/baseline_favourite_grey_24.png',
                              width: PsDimens.space10,
                              height: PsDimens.space10,
                              fit: BoxFit.contain,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: PsDimens.space4,
                              ),
                              child: Text('${product.favouriteCount}',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.caption),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // ),
          // clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        ),
      ),
    );
  }
}
