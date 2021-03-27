///
/// ps_static static constants.dart
/// ----------------------------
/// Developed by Panacea-Soft
/// www.panacea-soft.com
///

import 'package:flutteradmotors/config/ps_config.dart';
import 'package:intl/intl.dart';

class PsConst {
  PsConst._();

  static const String THEME__IS_DARK_THEME = 'THEME__IS_DARK_THEME';

  static const String LANGUAGE__LANGUAGE_CODE_KEY =
      'LANGUAGE__LANGUAGE_CODE_KEY';
  static const String LANGUAGE__COUNTRY_CODE_KEY = 'LANGUAGE__COUNTRY_CODE_KEY';
  static const String LANGUAGE__LANGUAGE_NAME_KEY =
      'LANGUAGE__LANGUAGE_NAME_KEY';

  static const String APP_INFO__END_DATE_KEY = 'END_DATE';
  static const String APP_INFO__START_DATE_KEY = 'START_DATE';
  static const String APPINFO_PREF_VERSION_NO = 'APPINFO_PREF_VERSION_NO';
  static const String APPINFO_PREF_FORCE_UPDATE = 'APPINFO_PREF_FORCE_UPDATE';
  static const String APPINFO_FORCE_UPDATE_MSG = 'APPINFO_FORCE_UPDATE_MSG';
  static const String APPINFO_FORCE_UPDATE_TITLE = 'APPINFO_FORCE_UPDATE_TITLE';

  static const String FILTERING__DESC = 'desc'; // Don't Change
  static const String FILTERING__ASC = 'asc'; // Don't Change
  static const String FILTERING__ORDERING = 'ordering'; // Don't Change
  static const String FILTERING__ADDED_DATE = 'added_date'; // Don't Change
  static const String FILTERING__TRENDING = 'touch_count'; // Don't Change
  static const String FILTERING__FOLLOWING = 'following'; // Don't Change
  static const String FILTERING__FOLLOWER = 'follower'; // Don't Change
  static const String PAID_ITEM_FIRST = 'paid_item_first'; // Don't Change
  static const String PAID_AD_PROGRESS = 'Progress'; // Don't Change
  static const String CHAT_TYPE_BUYER = 'buyer'; // Don't Change
  static const String CHAT_TYPE_SELLER = 'seller'; // Don't Change
  static const String CHAT_TO_BUYER = 'to_buyer'; // Don't Change
  static const String CHAT_TO_SELLER = 'to_seller'; // Don't Change
  static const String ITEM_TYPE = 'item'; // Don't Change

  static const String ONE = '1';
  static const String FILTERING_FEATURE = 'featured_date';
  static const String FILTERING_TRENDING = 'touch_count';

  static const String PLATFORM = 'android';

  static const String RATING_ONE = '1';
  static const String RATING_TWO = '2';
  static const String RATING_THREE = '3';
  static const String RATING_FOUR = '4';
  static const String RATING_FIVE = '5';

  static const String IS_DISCOUNT = '1';
  static const String IS_FEATURED = '1';
  static const String ZERO = '0';
  static const String THREE = '3';

  static const String FILTERING_PRICE = 'unit_price';
  static const String FILTERING_NAME = 'title';

  static const String USER_DELECTED = 'deleted';
  static const String USER_BANNED = 'banned';
  static const String USER_UN_PUBLISHED = 'unpublished';

  static const String ADD_NEW_ITEM = 'ADD_NEW_ITEM';
  static const String EDIT_ITEM = 'EDIT_ITEM';

  static const String VALUE_HOLDER__USER_ID = 'USERID';
  static const String VALUE_HOLDER__USER_NAME = 'USER_NAME';
  static const String VALUE_HOLDER__NOTI_TOKEN = 'NOTI_TOKEN';
  static const String VALUE_HOLDER__NOTI_MESSAGE = 'NOTI_MESSAGE';
  static const String VALUE_HOLDER__NOTI_SETTING = 'NOTI_SETTING';
  static const String VALUE_HOLDER__USER_ID_TO_VERIFY = 'USERIDTOVERIFY';
  static const String VALUE_HOLDER__USER_NAME_TO_VERIFY = 'USER_NAME_TO_VERIFY';
  static const String VALUE_HOLDER__USER_EMAIL_TO_VERIFY =
      'USER_EMAIL_TO_VERIFY';
  static const String VALUE_HOLDER__USER_PASSWORD_TO_VERIFY =
      'USER_PASSWORD_TO_VERIFY';
  static const String VALUE_HOLDER__START_DATE = 'START_DATE';
  static const String VALUE_HOLDER__END_DATE = 'END_DATE';
  static const String VALUE_HOLDER__PAYPAL_ENABLED = 'PAYPAL_ENABLED';
  static const String VALUE_HOLDER__STRIPE_ENABLED = 'STRIPE_ENABLED';
  static const String VALUE_HOLDER__COD_ENABLED = 'COD_ENABLED';
  static const String VALUE_HOLDER__BANK_TRANSFER_ENABLE =
      'BANK_TRANSFER_ENABLE';
  static const String VALUE_HOLDER__PUBLISH_KEY = 'PUBLISH_KEY';
  static const String VALUE_HOLDER__STANDART_SHIPPING_ENABLE =
      'STANDART_SHIPPING_ENABLE';
  static const String VALUE_HOLDER__ZONE_SHIPPING_ENABLE =
      'ZONE_SHIPPING_ENABLE';
  static const String VALUE_HOLDER__NO_SHIPPING_ENABLE = 'NO_SHIPPING_ENABLE';
  static const String VALUE_HOLDER__LOCATION_ID = 'LOCATION_ID';
  static const String VALUE_HOLDER__LOCATION_NAME = 'LOCATION_NAME';
  static const String VALUE_HOLDER__LOCATION_LAT = 'LOCATION_LAT';
  static const String VALUE_HOLDER__LOCATION_LNG = 'LOCATION_LNG';

  static const String CALL_BACK_EDIT_TO_PROFILE = 'CALL_BACK_EDIT_TO_PROFILE';

  static const String MANUFACTURER_ID = 'manufacturer_id';
  static const String MODEL_ID = 'model_id';
  static const String MANUFACTURER_NAME = 'manufacturer_name';

  static const String CONST_CATEGORY = 'category';
  static const String CONST_SUB_CATEGORY = 'subcategory';
  static const String CONST_PRODUCT = 'product';

  static const String VIEW_MAP = 'VIEW_MAP';
  static const String PIN_MAP = 'PIN_MAP';
  static const String INVALID_LAT_LNG = '0.000000';

  static const String VALUE_HOLDER__OVERALL_TAX_LABEL = 'OVERALL_TAX_LABEL';
  static const String VALUE_HOLDER__OVERALL_TAX_VALUE = 'OVERALL_TAX_VALUE';
  static const String VALUE_HOLDER__SHIPPING_TAX_LABEL = 'SHIPPING_TAX_LABEL';
  static const String VALUE_HOLDER__SHIPPING_TAX_VALUE = 'SHIPPING_TAX_VALUE';
  static const String VALUE_HOLDER__SHIPPING_ID = 'SHIPPING_ID';
  static const String VALUE_HOLDER__SHOP_ID = 'shop_id';
  static const String VALUE_HOLDER__MESSENGER = 'messenger';
  static const String VALUE_HOLDER__WHATSAPP = 'whapsapp_no';
  static const String VALUE_HOLDER__PHONE = 'about_phone1';
  static const String FILTERING_TYPE_NAME_PRODUCT = 'product';
  static const String FILTERING_TYPE_NAME_CATEGORY = 'category';
  static const int REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT = 1001;
  static const int REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT = 1002;
  static const int REQUEST_CODE__MENU_REGISTER_FRAGMENT = 1003;
  static const int REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT = 1004;
  static const int REQUEST_CODE__MENU_HOME_FRAGMENT = 1005;
  static const int REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT = 1006;
  static const int REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT = 1007;
  static const int REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT = 1008;
  static const int REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT = 1009;
  static const int REQUEST_CODE__MENU_COLLECTION_FRAGMENT = 1010;
  static const int REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT = 1011;
  static const int REQUEST_CODE__MENU_LANGUAGE_FRAGMENT = 1012;
  static const int REQUEST_CODE__MENU_SETTING_FRAGMENT = 1013;
  static const int REQUEST_CODE__MENU_LOGIN_FRAGMENT = 1014;
  static const int REQUEST_CODE__MENU_BLOG_FRAGMENT = 1015;
  static const int REQUEST_CODE__MENU_FAVOURITE_FRAGMENT = 1016;
  static const int REQUEST_CODE__MENU_TRANSACTION_FRAGMENT = 1017;
  static const int REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT = 1018;
  static const int REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT = 1019;
  static const int REQUEST_CODE__MENU_CATEGORY_FRAGMENT = 1020;
  static const int REQUEST_CODE__MENU_CONTACT_US_FRAGMENT = 1021;
  static const int REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT = 1022;
  static const int REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT = 1023;
  static const int REQUEST_CODE__MENU_FB_SIGNIN_FRAGMENT = 1024;
  static const int REQUEST_CODE__MENU_GOOGLE_VERIFY_FRAGMENT = 1025;
  static const int REQUEST_CODE__MENU_OFFER_FRAGMENT = 2026;
  static const int REQUEST_CODE__MENU_BLOCKED_USER_FRAGMENT = 2027;
  static const int REQUEST_CODE__MENU_REPORTED_ITEM_FRAGMENT = 2028;

  static const int REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT = 2001;
  static const int REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT = 2002;
  static const int REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT = 2003;
  static const int REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT = 2004;
  static const int REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT = 2005;
  static const int REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT = 2006;
  static const int REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT = 2007;
  static const int REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT = 2008;
  static const int REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT = 2009;
  static const int REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT = 2010;
  static const int REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT = 2011;
  static const int REQUEST_CODE__DASHBOARD_FB_SIGNIN_FRAGMENT = 2012;
  static const int REQUEST_CODE__DASHBOARD_GOOGLE_VERIFY_FRAGMENT = 2013;

  static const String ADSPROGRESS = 'Progress';
  static const String ADSFINISHED = 'Finished';
  static const String ADSNOTYETSTART = 'Not yet start';
  static const String ADSNOTAVAILABLE = 'not_available';

  static final NumberFormat psFormat = NumberFormat(PsConfig.priceFormat);
  static const String priceTwoDecimalFormatString = '###.00';
  static final NumberFormat priceTwoDecimalFormat =
      NumberFormat(priceTwoDecimalFormatString);

  static const int CHAT_TYPE_TEXT = 0;
  static const int CHAT_TYPE_IMAGE = 1;
  static const int CHAT_TYPE_OFFER = 2;
  static const int CHAT_TYPE_DATE = 3;
  static const int CHAT_TYPE_SOLD = 4;
  static const int CHAT_TYPE_ACCEPT = 0;
  static const int CHAT_TYPE_REJECT = 0;

  static const int CHAT_STATUS_NULL = 0;
  static const int CHAT_STATUS_OFFER = 1;
  static const int CHAT_STATUS_REJECT = 2;
  static const int CHAT_STATUS_ACCEPT = 3;
  static const int CHAT_STATUS_SOLD = 4;
  static const String CHAT_FROM_BUYER = 'CHAT_FROM_BUYER';
  static const String CHAT_FROM_SELLER = 'CHAT_FROM_SELLER';

  static const String PAYMENT_PAYPAL_METHOD = 'paypal';
  static const String PAYMENT_STRIPE_METHOD = 'stripe';
  static const String PAYMENT_RAZOR_METHOD = 'razor';
  static const String PAYMENT_OFFLINE_METHOD = 'offline';
  static const String PAYMENT_PAY_STACK_METHOD = 'paystack';

  ///
  /// Hero Tags
  ///
  static const String HERO_TAG__IMAGE = '_image';
  static const String HERO_TAG__TITLE = '_title';
  static const String HERO_TAG__ORIGINAL_PRICE = '_original_price';
  static const String HERO_TAG__UNIT_PRICE = '_unit_price';

  ///
  /// Payment On/Off
  ///
  static const String PAYPAL_ENABLE = '1';
  static const String STRIPE_ENABLE = '1';
  static const String RAZOR_ENABLE = '1';
  static const String OFFLINE_PAYMENT_ENABLE = '1';

  ///
  /// Firebase Auth Providers
  ///
  static const String emailAuthProvider = 'password';
  static const String appleAuthProvider = 'apple';
  static const String facebookAuthProvider = 'facebook';
  static const String googleAuthProvider = 'google';
  static const String defaultEmail = 'admin@ps.com';
  static const String defaultPassword = 'admin@ps.com';

  ///
  /// Error Codes
  ///
  static const String ERROR_CODE_10001 = '10001'; // Totally No Record
  static const String ERROR_CODE_10002 =
      '10002'; // No More Record at pagination
}
