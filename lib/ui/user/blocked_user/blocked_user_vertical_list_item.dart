import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/blocked_user.dart';

class BlockedUserVerticalListItem extends StatelessWidget {
  const BlockedUserVerticalListItem(
      {Key key,
      @required this.blockedUser,
      this.onTap,
      this.onUnblockTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final BlockedUser blockedUser;
  final Function onTap;
  final Function onUnblockTap;
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
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: PsDimens.space4),
            child: Ink(
              color: PsColors.backgroundColor,
              child: Padding(
                  padding: const EdgeInsets.all(PsDimens.space16),
                  child: UserWidget(user: blockedUser, onTap: onTap,onUnblockTap:onUnblockTap)
                  ),
            ),
          ),
        ),
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

class UserWidget extends StatelessWidget {
  const UserWidget({
    Key key,
    @required this.user,
    @required this.onTap,
    @required this.onUnblockTap
  }) : super(key: key);

  final BlockedUser user;
  final Function onTap;
  final Function onUnblockTap;

  @override
  Widget build(BuildContext context) {

    final Widget _imageWidget = PsNetworkCircleImageForUser(
      photoKey: '',
      imagePath: user.userProfilePhoto ?? '',
      width: PsDimens.space44,
      height: PsDimens.space44,
      boxfit: BoxFit.cover,
      onTap: () {
        onTap();
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            _imageWidget,
            const SizedBox(
              width: PsDimens.space12,
            ),
            Expanded(
                child: Text((user.userName == '' || user.userName == null )?
                    Utils.getString(context, 'default__user_name'):
                    user.userName,
                      style: Theme.of(context).textTheme.subtitle1),

            ),
            MaterialButton(
            color: PsColors.mainColor,
            height: 30,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(PsDimens.space2)),
            ),
            child: Text(
                    Utils.getString(context, 'blocked_user__unblock'),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  ),
            onPressed: (){
              showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
              return ConfirmDialogView(
                    description: Utils.getString(
                        context, 'blocked_user__unblock_confirm'),
                    leftButtonText: Utils.getString(
                        context, 'dialog__cancel'),
                    rightButtonText: Utils.getString(
                        context, 'dialog__ok'),
                    onAgreeTap: () async {
                      Navigator.of(context).pop();

                     onUnblockTap();
                    });
             });
            })
          ],
        ),
      ],
    );
  }
}
