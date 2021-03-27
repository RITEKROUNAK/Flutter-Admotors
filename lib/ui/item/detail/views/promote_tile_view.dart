// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:flutteradmotors/config/ps_colors.dart';
// import 'package:flutteradmotors/constant/ps_dimens.dart';
// import 'package:flutteradmotors/constant/route_paths.dart';
// import 'package:flutteradmotors/ui/common/ps_button_widget.dart';
// import 'package:flutteradmotors/ui/common/ps_expansion_tile.dart';
// import 'package:flutteradmotors/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutteradmotors/viewobject/product.dart';

// class PromoteTileView extends StatelessWidget {
//   const PromoteTileView(
//       {Key key, @required this.animationController, @required this.product})
//       : super(key: key);

//   final AnimationController animationController;
//   final Product product;

//   @override
//   Widget build(BuildContext context) {
//     final Widget _expansionTileTitleWidget = Text(
//         Utils.getString(context, 'item_detail__promote_your_item'),
//         style: Theme.of(context).textTheme.subtitle1);

//     final Widget _expansionTileLeadingIconWidget =
//         Icon(Ionicons.ios_megaphone, color: PsColors.mainColor);

//     return Container(
//       margin: const EdgeInsets.only(
//           left: PsDimens.space12,
//           right: PsDimens.space12,
//           bottom: PsDimens.space12),
//       decoration: BoxDecoration(
//         color: PsColors.backgroundColor,
//         borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8)),
//       ),
//       child: PsExpansionTile(
//         initiallyExpanded: true,
//         leading: _expansionTileLeadingIconWidget,
//         title: _expansionTileTitleWidget,
//         children: <Widget>[
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Divider(
//                 height: PsDimens.space1,
//                 color: Theme.of(context).iconTheme.color,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(PsDimens.space12),
//                 child: Text(
//                     Utils.getString(context, 'item_detail__promote_sub_title')),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: PsDimens.space12,
//                     right: PsDimens.space12,
//                     bottom: PsDimens.space12),
//                 child: Text(Utils.getString(
//                     context, 'item_detail__promote_description')),
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(left: PsDimens.space12),
//                     child: SizedBox(
//                         width: PsDimens.space180,
//                         child: PSButtonWithIconWidget(
//                             hasShadow: false,
//                             width: double.infinity,
//                             icon: Ionicons.ios_megaphone,
//                             titleText:
//                                 Utils.getString(context, 'item_detail__promte'),
//                             onPressed: () async {
//                               Navigator.pushNamed(
//                                   context, RoutePaths.itemPromote,
//                                   arguments: product);
//                             })
//                         //  RaisedButton(
//                         //   child: Text(
//                         //     Utils.getString(context, 'item_detail__promte'),
//                         //     overflow: TextOverflow.ellipsis,
//                         //     maxLines: 1,
//                         //     textAlign: TextAlign.center,
//                         //     softWrap: false,
//                         //   ),
//                         //   color: PsColors.mainColor,
//                         //   shape: const BeveledRectangleBorder(
//                         //       borderRadius: BorderRadius.all(
//                         //     Radius.circular(PsDimens.space8),
//                         //   )),
//                         //   textColor: Theme.of(context).textTheme.button.copyWith(color: Colors.white).color,
//                         //   onPressed: () {
//                         //     Navigator.pushNamed(context, RoutePaths.itemPromote, arguments: itemId);
//                         //   },
//                         // ),
//                         ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         right: PsDimens.space18, bottom: PsDimens.space8),
//                     child: Image.asset(
//                       'assets/images/baseline_promotion_color_74.png',
//                       width: PsDimens.space80,
//                       height: PsDimens.space80,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
