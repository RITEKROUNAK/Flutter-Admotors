import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/bunner.dart';

class HomeBunnerSliderView extends StatefulWidget {
  const HomeBunnerSliderView({
    Key key,
    @required this.bunnerList,
    // this.onTap,
  }) : super(key: key);

  // final Function onTap;
  final List<Bunner> bunnerList;

  @override
  _HomeBunnerSliderState createState() => _HomeBunnerSliderState();
}

class _HomeBunnerSliderState extends State<HomeBunnerSliderView> {
  // String _currentId;
  @override
  Widget build(BuildContext context) {
    if (widget.bunnerList != null && widget.bunnerList.isNotEmpty)
      return CarouselSlider(
        options: CarouselOptions(
          height: PsDimens.space380,
          autoPlay: true,
          viewportFraction: 1.0,
          initialPage: 0,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          autoPlayInterval: const Duration(seconds: 10),
        ),
        items: widget.bunnerList.map((Bunner bunner) {
          return PsNetworkImage(
            photoKey: '',
            defaultPhoto: bunner.defaultPhoto,
            width: MediaQuery.of(context).size.width,
            height: PsDimens.space360,
            boxfit: BoxFit.cover,
            // onTap: () {
            //   widget.onTap(bunner);
            // }
          );
        }).toList(),
      );
    else
      return Container();
  }
}
