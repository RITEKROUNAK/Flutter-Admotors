// import 'package:flutteradmotors/config/ps_config.dart';
// import 'package:flutteradmotors/ui/location/item_location_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutteradmotors/utils/utils.dart';

// class ItemPromoteContainerView extends StatefulWidget {
//   @override
//   ItemPromoteContainerViewState createState() =>
//       ItemPromoteContainerViewState();
// }

// class ItemPromoteContainerViewState extends State<ItemPromoteContainerView>
//     with SingleTickerProviderStateMixin {
//   AnimationController animationController;
//   @override
//   void initState() {
//     animationController =
//         AnimationController(duration: PsConfig.animation_duration, vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future<bool> _requestPop() {
//       animationController.reverse().then<dynamic>(
//         (void data) {
//           if (!mounted) {
//             return Future<bool>.value(false);
//           }
//           Navigator.pop(context, true);
//           return Future<bool>.value(true);
//         },
//       );
//       return Future<bool>.value(false);
//     }

//     print(
//         '............................Build UI Again ............................');
//     return WillPopScope(
//       onWillPop: _requestPop,
//       child: Scaffold(
//           appBar: AppBar(
//             brightness: Utils.getBrightnessForAppBar(context),
//             iconTheme: Theme.of(context).iconTheme.copyWith(color: PsColors.mainColorWithWhite),
//             title: Text(
//               Utils.getString(context, 'item_promote__entry'),
//               textAlign: TextAlign.center,
//               style: Theme.of(context)
//                   .textTheme
//                   .title
//                   .copyWith(fontWeight: FontWeight.bold),
//             ),
//             elevation: 0,
//           ),
//           body: null
//           // ItemLocationView(
//           //   animationController: animationController,
//           // ),
//           ),
//     );
//   }
// }
