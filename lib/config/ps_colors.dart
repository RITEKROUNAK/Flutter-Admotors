// Copyright (c) 2019, the PS Project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// PS license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutteradmotors/utils/utils.dart';

/// Colors Config For the whole App
/// Please change the color based on your brand need.

///
/// Dark Theme
///
// const Color ps_wtheme_color_primary = Color(0xFFFFFFFF);
// const Color ps_wtheme_color_primary_dark = Color(0xfFC7D180);
// const Color ps_wtheme_color_primary_light = Color(0xfEFAD670);

// const Color ps_wtheme_text__primary_color = Color(0xFF656565);
// const Color ps_wtheme_text__primary_light_color = Color(0xFFadadad);
// const Color ps_wtheme_text__primary_dark_color = Color(0xFF424242);

// const Color ps_wtheme_icon_color = Color(0xFF757575);
// const Color ps_wtheme_white_color = Colors.white;

// ///
// /// White Theme
// ///
// const Color ps_dtheme_color_primary = Color(0xFF303030);
// const Color ps_dtheme_color_primary_dark = Color(0xFF555555);
// const Color ps_dtheme_color_primary_light = Color(0xFF555555);

// const Color ps_dtheme_text__primary_color = Color(0xFFFFFFFF);
// const Color ps_dtheme_text__primary_light_color = Color(0xFFFFFFFF);
// const Color ps_dtheme_text__primary_dark_color = Color(0xFFFFFFFF);

// const Color ps_dtheme_icon_color = Colors.white;
// const Color ps_dtheme_white_color = Color(0xFF757575);

// ///
// /// Common Theme
// ///
// const Color ps_ctheme_text__category_title = Color(0xFFffcc00);
// const Color ps_ctheme_button__category_title = Color(0xFFffcc00);
// const Color ps_ctheme_text__color_gery = Color(0xFF757575);
// const Color ps_ctheme_text__color_primary_light = Color(0xFFbdbdbd);
// const Color ps_ctheme__color_speical = Color(0xFFD2232A);
// const Color ps_ctheme__color_about_us = Colors.cyan;
// const Color ps_ctheme__color_application = Colors.blue;
// const Color ps_ctheme__color_line = Color(0xFFbdbdbd);
// const Color ps_ctheme__sold_out = Color(0x80D2232A);
// const Color ps_ctheme__global_primary = Color(0xFFD2232A);

// Copyright (c) 2019, the PS Project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// PS license that can be found in the LICENSE file.

// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutteradmotors/utils/utils.dart';

class PsColors {
  PsColors._();

  ///
  /// Main Color
  ///
  static Color mainColor;
  static Color mainColorWithWhite;
  static Color mainColorWithBlack;
  static Color mainDarkColor;
  static Color mainLightColor;
  static Color mainLightColorWithBlack;
  static Color mainLightColorWithWhite;
  static Color mainShadowColor;
  static Color mainLightShadowColor;
  static Color mainDividerColor;
  static Color whiteColorWithBlack;

  ///
  /// Base Color
  ///
  static Color baseColor;
  static Color baseDarkColor;
  static Color baseLightColor;

  ///
  /// Text Color
  ///
  static Color textPrimaryColor;
  static Color textPrimaryDarkColor;
  static Color textPrimaryLightColor;

  static Color textPrimaryColorForLight;
  static Color textPrimaryDarkColorForLight;
  static Color textPrimaryLightColorForLight;

  ///
  /// Icon Color
  ///
  static Color iconColor;

  ///
  /// Background Color
  ///
  static Color coreBackgroundColor;
  static Color backgroundColor;

  ///
  /// General
  ///
  static Color white;
  static Color black;
  static Color grey;
  static Color transparent;

  ///
  /// Customs
  ///
  static Color facebookLoginButtonColor;
  static Color googleLoginButtonColor;
  static Color appleLoginButtonColor;
  static Color phoneLoginButtonColor;
  static Color disabledFacebookLoginButtonColor;
  static Color disabledGoogleLoginButtonColor;
  static Color disabledAppleLoginButtonColor;
  static Color disabledPhoneLoginButtonColor;

  static Color paypalColor;
  static Color stripeColor;

  static Color categoryBackgroundColor;
  static Color loadingCircleColor;
  static Color ratingColor;

  static Color soldOutUIColor;
  static Color itemTypeColor;

  static Color paidAdsColor;

  /// Colors Config For the whole App
  /// Please change the color based on your brand need.

  ///
  /// Light Theme
  ///
  static const Color _l_base_color = Color(0xFEF7F7F7);
  static const Color _l_base_dark_color = Color(0xFFFFFFFF);
  static const Color _l_base_light_color = Color(0xFFEFEFEF);

  static const Color _l_text_primary_color = Color(0xFF445E76);
  static const Color _l_text_primary_light_color = Color(0xFFadadad);
  static const Color _l_text_primary_dark_color = Color(0xFF25425D);

  static const Color _l_icon_color = Color(0xFF445E76);

  static const Color _l_divider_color = Color(0x15505050);

  ///
  /// Dark Theme
  ///
  static const Color _d_base_color = Color(0xFF212121);
  static const Color _d_base_dark_color = Color(0xFF303030);
  static const Color _d_base_light_color = Color(0xFF454545);

  static const Color _d_text_primary_color = Color(0xFFFFFFFF);
  static const Color _d_text_primary_light_color = Color(0xFFFFFFFF);
  static const Color _d_text_primary_dark_color = Color(0xFFFFFFFF);

  static const Color _d_icon_color = Colors.white;

  static const Color _d_divider_color = Color(0x1FFFFFFF);

  ///
  /// Common Theme
  ///
  // static const Color _c_main_color = Color(0xFFD31A20);
  // static const Color _c_main_light_color = Color(0xFFFFF0F1);
  // static const Color _c_main_dark_color = Color(0xFF95292C);
  static const Color _c_main_color = Color(0xFF202540);
  static const Color _c_main_light_color = Color(0xFFF0F3FF); //FFF0F1);
  static const Color _c_main_dark_color = Color(0xFF020203);

  static const Color _c_white_color = Colors.white;
  static const Color _c_black_color = Colors.black;
  static const Color _c_grey_color = Colors.grey;
  static const Color _c_blue_color = Colors.blue;
  static const Color _c_transparent_color = Colors.transparent;
  static const Color _c_paid_ads_color = Colors.lightGreen;

  static const Color _c_facebook_login_color = Color(0xFF2153B2);
  static const Color _c_google_login_color = Color(0xFFFF4D4D);
  static const Color _c_phone_login_color = Color(0xFF9F7A2A);
  static const Color _c_apple_login_color = Color(0xFF111111);

  static const Color _c_paypal_color = Color(0xFF3b7bbf);
  static const Color _c_stripe_color = Color(0xFF008cdd);

  static const Color _c_rating_color = Colors.yellow;
  static const Color _c_sold_out = Color(0x80D2232A);
  static const Color _c_item_type_color = Color(0xFFBDBDBD);

  // static const Color ps_ctheme__color_about_us = Colors.cyan;
  // static const Color ps_ctheme__color_application = Colors.blue;
  // static const Color ps_ctheme__color_line = Color(0xFFbdbdbd);

  static void loadColor(BuildContext context) {
    if (Utils.isLightMode(context)) {
      _loadLightColors();
    } else {
      _loadDarkColors();
    }
  }

  static void loadColor2(bool isLightMode) {
    if (isLightMode) {
      _loadLightColors();
    } else {
      _loadDarkColors();
    }
  }

  static void _loadDarkColors() {
    ///
    /// Main Color
    ///
    mainColor = _c_main_light_color;
    mainColorWithWhite = Colors.white;
    mainColorWithBlack = Colors.black;
    mainDarkColor = _c_main_dark_color;
    mainLightColor = _c_main_light_color;
    mainLightColorWithBlack = _d_base_color;
    mainLightColorWithWhite = Colors.white;
    mainShadowColor = Colors.black.withOpacity(0.5);
    mainLightShadowColor = Colors.black.withOpacity(0.5);
    mainDividerColor = _d_divider_color;
    whiteColorWithBlack = Colors.black;

    ///
    /// Base Color
    ///
    baseColor = _d_base_color;
    baseDarkColor = _d_base_dark_color;
    baseLightColor = _d_base_light_color;

    ///
    /// Text Color
    ///
    textPrimaryColor = _d_text_primary_color;
    textPrimaryDarkColor = _d_text_primary_dark_color;
    textPrimaryLightColor = _d_text_primary_light_color;

    textPrimaryColorForLight = _l_text_primary_color;
    textPrimaryDarkColorForLight = _l_text_primary_dark_color;
    textPrimaryLightColorForLight = _l_text_primary_light_color;

    ///
    /// Icon Color
    ///
    iconColor = _d_icon_color;

    ///
    /// Background Color
    ///
    coreBackgroundColor = _d_base_color;
    backgroundColor = _d_base_dark_color;

    ///
    /// General
    ///
    white = _c_white_color;
    black = _c_black_color;
    grey = _c_grey_color;
    transparent = _c_transparent_color;

    ///
    /// Custom
    ///
    facebookLoginButtonColor = _c_facebook_login_color;
    googleLoginButtonColor = _c_google_login_color;
    appleLoginButtonColor = _c_apple_login_color;
    phoneLoginButtonColor = _c_phone_login_color;
    disabledFacebookLoginButtonColor = _c_grey_color;
    disabledGoogleLoginButtonColor = _c_grey_color;
    disabledAppleLoginButtonColor = _c_grey_color;
    disabledPhoneLoginButtonColor = _c_grey_color;
    paypalColor = _c_paypal_color;
    stripeColor = _c_stripe_color;
    categoryBackgroundColor = _d_base_light_color;
    loadingCircleColor = _c_blue_color;
    ratingColor = _c_rating_color;
    soldOutUIColor = _c_sold_out;
    itemTypeColor = _c_item_type_color;
    paidAdsColor = _c_paid_ads_color;
  }

  static void _loadLightColors() {
    ///
    /// Main Color
    ///
    mainColor = _c_main_color;
    mainColorWithWhite = _c_main_color;
    mainColorWithBlack = _c_main_color;
    mainDarkColor = _c_main_dark_color;
    mainLightColor = _c_main_light_color;
    mainLightColorWithBlack = _c_main_light_color;
    mainLightColorWithWhite = _c_main_light_color;
    mainShadowColor = _c_main_color.withOpacity(0.6);
    mainLightShadowColor = _c_main_light_color;
    mainDividerColor = _l_divider_color;
    whiteColorWithBlack = _c_main_light_color;

    ///
    /// Base Color
    ///
    baseColor = _l_base_color;
    baseDarkColor = _l_base_dark_color;
    baseLightColor = _l_base_light_color;

    ///
    /// Text Color
    ///
    textPrimaryColor = _l_text_primary_color;
    textPrimaryDarkColor = _l_text_primary_dark_color;
    textPrimaryLightColor = _l_text_primary_light_color;

    textPrimaryColorForLight = _l_text_primary_color;
    textPrimaryDarkColorForLight = _l_text_primary_dark_color;
    textPrimaryLightColorForLight = _l_text_primary_light_color;

    ///
    /// Icon Color
    ///
    iconColor = _l_icon_color;

    ///
    /// Background Color
    ///
    coreBackgroundColor = _l_base_color;
    backgroundColor = _l_base_dark_color;

    ///
    /// General
    ///
    white = _c_white_color;
    black = _c_black_color;
    grey = _c_grey_color;
    transparent = _c_transparent_color;

    ///
    /// Custom
    ///
    facebookLoginButtonColor = _c_facebook_login_color;
    googleLoginButtonColor = _c_google_login_color;
    appleLoginButtonColor = _c_apple_login_color;
    phoneLoginButtonColor = _c_phone_login_color;
    disabledFacebookLoginButtonColor = _c_grey_color;
    disabledGoogleLoginButtonColor = _c_grey_color;
    disabledAppleLoginButtonColor = _c_grey_color;
    disabledPhoneLoginButtonColor = _c_grey_color;
    paypalColor = _c_paypal_color;
    stripeColor = _c_stripe_color;
    categoryBackgroundColor = _c_main_light_color;
    loadingCircleColor = _c_blue_color;
    ratingColor = _c_rating_color;
    soldOutUIColor = _c_sold_out;
    itemTypeColor = _c_item_type_color;
    paidAdsColor = _c_paid_ads_color;
  }
}
