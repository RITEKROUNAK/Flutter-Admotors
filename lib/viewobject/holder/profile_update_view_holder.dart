import 'package:flutteradmotors/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class ProfileUpdateParameterHolder
    extends PsHolder<ProfileUpdateParameterHolder> {
  ProfileUpdateParameterHolder({
    @required this.userId,
    @required this.userName,
    @required this.userEmail,
    @required this.userPhone,
    @required this.userAboutMe,
    @required this.userAddress,
    @required this.city,
    @required this.deviceToken,
  });

  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String userAboutMe;
  final String userAddress;
  final String city;
  final String deviceToken;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['user_name'] = userName;
    map['user_email'] = userEmail;
    map['user_phone'] = userPhone;
    map['user_about_me'] = userAboutMe;
    map['user_address'] = userAddress;
    map['city'] = city;
    map['device_token'] = deviceToken;

    return map;
  }

  @override
  ProfileUpdateParameterHolder fromMap(dynamic dynamicData) {
    return ProfileUpdateParameterHolder(
      userId: dynamicData['user_id'],
      userName: dynamicData['user_name'],
      userEmail: dynamicData['user_email'],
      userPhone: dynamicData['user_phone'],
      userAboutMe: dynamicData['user_about_me'],
      userAddress: dynamicData['user_address'],
      city: dynamicData['city'],
      deviceToken: dynamicData['device_token'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (userName != '') {
      key += userName;
    }

    if (userEmail != '') {
      key += userEmail;
    }
    if (userPhone != '') {
      key += userPhone;
    }

    if (userAboutMe != '') {
      key += userAboutMe;
    }

    if (userAddress != '') {
      key += userAddress;
    }
    if (city != '') {
      key += city;
    }

    if (deviceToken != '') {
      key += deviceToken;
    }
    return key;
  }
}
