import 'dart:io';
import 'dart:typed_data';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/db/common/ps_shared_preferences.dart';
import 'package:flutteradmotors/provider/common/notification_provider.dart';
import 'package:flutteradmotors/provider/user/user_provider.dart';
import 'package:flutteradmotors/repository/user_repository.dart';
import 'package:flutteradmotors/ui/common/dialog/chat_noti_dialog.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/noti_register_holder.dart';
import 'package:flutteradmotors/viewobject/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:launch_review/launch_review.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/common/dialog/noti_dialog.dart';

mixin Utils {

  static bool isReachChatView = false;
  static bool isNotiFromToolbar  = false;

  static String getString(BuildContext context, String key) {
    if (key != '') {
      return tr(key) ?? '';
    } else {
      return '';
    }
  }

  static DateTime previous;
  static void psPrint(String msg) {
    final DateTime now = DateTime.now();
    int min = 0;
    if (previous == null) {
      previous = now;
    } else {
      min = now.difference(previous).inMilliseconds;
      previous = now;
    }

    print('$now ($min)- $msg');
  }

  static String getPriceFormat(String price) {
    return PsConst.psFormat.format(double.parse(price));
  }

  static String getChatPriceFormat(String message) {
    String currencySymbol, price;
    try {
      currencySymbol = message.split(' ')[0];
      price = getPriceFormat(message.split(' ')[1]);
      return '$currencySymbol  $price';
    } catch (e) {
      return message;
    }
  }

  static String splitMessage(String message) {
    try {
      return message.split(' ')[1];
    } catch (e) {
      return message;
    }
  }

  static bool checkIsChatView() {
    return isReachChatView;
  }

  static bool isShowNotiFromToolbar() {
    return isNotiFromToolbar;
  }

  static String getPriceTwoDecimal(String price) {
    return PsConst.priceTwoDecimalFormat.format(double.parse(price));
  }

  static bool isLightMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }

  static Map<String, String> getTimeStamp() {
    // DateTime.now().microsecond;
    return ServerValue.timestamp;
  }

  static dynamic getBannerAdUnitId() {
    if (Platform.isIOS) {
      return PsConfig.iosAdMobUnitIdApiKey;
    } else {
      return PsConfig.androidAdMobUnitIdApiKey;
    }
  }

  static dynamic getAdAppId() {
    if (Platform.isIOS) {
      return PsConfig.iosAdMobAdsIdKey;
    } else {
      return PsConfig.androidAdMobAdsIdKey;
    }
  }

  static int getTimeStampDividedByOneThousand(DateTime dateTime) {
    final double dividedByOneThousand = dateTime.millisecondsSinceEpoch / 1000;
    final int doubleToInt = dividedByOneThousand.round();
    return doubleToInt;
  }

  static String convertTimeStampToDate(int timeStamp) {
    if (timeStamp == null) {
      return '';
    }
    final DateTime dateTime2 =
        DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: true);
    final DateTime dateTime = dateTime2.toLocal();
    final DateFormat format = DateFormat.yMMMMd(); //"6:00 AM"
    return format.format(dateTime);
  }

  static String convertTimeStampToTime(int timeStamp) {
    if (timeStamp == null) {
      return '';
    }

    final DateTime dateTime2 =
        DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: true);
    final DateTime dateTime = dateTime2.toLocal();
    final DateFormat format = DateFormat.jm(); //"6:00 AM"
    return format.format(dateTime);
  }

  static String getDateFormat(String dateTime) {
    final DateTime date = DateTime.parse(dateTime);
    return DateFormat(PsConfig.dateFormat).format(date);
  }

  static String getTimeString() {
    final DateTime dateTime = DateTime.now();
    final DateFormat format = DateFormat.Hms();
    return format.format(dateTime);
  }

  static Brightness getBrightnessForAppBar(BuildContext context) {
    if (Platform.isAndroid) {
      return Brightness.dark;
    } else {
      return Theme.of(context).brightness;
    }
  }

  static Future<File> getImageFileFromAssets(Asset asset, int imageAize) async {
    final int imageWidth = imageAize;
    final ByteData byteData = await asset.getByteData(
        quality: 80); // await rootBundle.load('assets/$path');

    final bool status = await Utils.requestWritePermission();

    // bool status =await Utils.requestWritePermission().then((bool status) async {
    if (status) {
      final Directory _appTempDir = await getTemporaryDirectory();

      final Directory _appTempDirFolder =
          Directory('${_appTempDir.path}/${PsConfig.tmpImageFolderName}');

      if (!_appTempDirFolder.existsSync()) {
        await _appTempDirFolder.create(recursive: true);
      }

      final File file = File('${_appTempDirFolder.path}/${asset.name}');
      //'${(await getTemporaryDirectory()).path}/$tmpImageFolderName/${asset.name}');

      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      print(file.path);
      final ImageProperties properties =
          await FlutterNativeImage.getImageProperties(file.path);
      final File compressedFile = await FlutterNativeImage.compressImage(
          file.path,
          quality: 80,
          targetWidth: imageWidth,
          targetHeight:
              (properties.height * imageWidth / properties.width).round());
      return compressedFile;
    } else {
      // Toast
      // We don't have permission to read/write images.
      Fluttertoast.showToast(
          msg: 'We don\'t have permission to read/write images.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white);
      return null;
    }

    // });
    // return null;
  }

  static String convertColorToString(Color color) {
    String convertedColorString = '';

    String colorString = color.toString().toUpperCase();

    colorString = colorString.replaceAll(')', '');

    convertedColorString = colorString.substring(colorString.length - 6);

    return '#' + convertedColorString;
  }

  static Future<bool> requestWritePermission() async {
    // final Map<Permission, PermissionStatus> permissionss =
    //     await PermissionHandler()
    //         .requestPermissions(<Permission>[Permission.storage]);
    // if (permissionss != null &&
    //     permissionss.isNotEmpty &&
    //     permissionss[Permission.storage] == PermissionStatus.granted) {
    final Permission _storage = Permission.storage;
    final PermissionStatus permissionss = await _storage.request();

    if (permissionss != null && permissionss == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkInternetConnectivity() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      // print('Mobile');
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // print('Wifi');
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      print('No Connection');
      return false;
    } else {
      return false;
    }
  }

  static dynamic launchURL() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.packageName);
    final String url =
        'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static dynamic launchAppStoreURL(
      {String iOSAppId, bool writeReview = false}) async {
    LaunchReview.launch(writeReview: writeReview, iOSAppId: iOSAppId);
  }

  static dynamic navigateOnUserVerificationView(
      dynamic provider, BuildContext context, Function onLoginSuccess) async {
    provider.psValueHolder = Provider.of<PsValueHolder>(context, listen: false);

    if (provider == null ||
        provider.psValueHolder.userIdToVerify == null ||
        provider.psValueHolder.userIdToVerify == '') {
      if (provider == null ||
          provider.psValueHolder == null ||
          provider.psValueHolder.loginUserId == null ||
          provider.psValueHolder.loginUserId == '') {
        final dynamic returnData = await Navigator.pushNamed(
          context,
          RoutePaths.login_container,
        );

        if (returnData != null && returnData is User) {
          final User user = returnData;
          provider.psValueHolder =
              Provider.of<PsValueHolder>(context, listen: false);
          provider.psValueHolder.loginUserId = user.userId;
        }
      } else {
        onLoginSuccess();
      }
    } else {
      Navigator.pushNamed(context, RoutePaths.user_verify_email_container,
          arguments: provider.psValueHolder.userIdToVerify);
    }
  }

  static String sortingUserId(String loginUserId, String itemAddedUserId) {
    if (loginUserId.compareTo(itemAddedUserId) == 1) {
      return '${itemAddedUserId}_$loginUserId';
    } else if (loginUserId.compareTo(itemAddedUserId) == -1) {
      return '${loginUserId}_$itemAddedUserId';
    } else {
      return '${loginUserId}_$itemAddedUserId';
    }
  }

  static String checkUserLoginId(PsValueHolder psValueHolder) {
    if (psValueHolder.loginUserId == null || psValueHolder.loginUserId == '') {
      return 'nologinuser';
    } else {
      return psValueHolder.loginUserId;
    }
  }

  static Widget flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  static int isAppleSignInAvailable = 0;
  static Future<void> checkAppleSignInAvailable() async {
    final bool _isAvailable = await AppleSignIn.isAvailable();

    isAppleSignInAvailable = _isAvailable ? 1 : 2;
  }

  static Future<void> launchMaps(String lat, String lng) async {
    final String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final String appleUrl = 'https://maps.apple.com/?sll=$lat,$lng';
    if (await canLaunch(googleUrl)) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }
  //  final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // static void subscribeToTopic(bool isEnable) {
  //   if (isEnable) {
  //     final FirebaseMessaging _fcm = FirebaseMessaging();
  //     if (Platform.isIOS) {
  //       _fcm.requestNotificationPermissions(const IosNotificationSettings());
  //     }
  //     _fcm.subscribeToTopic('broadcast');
  //   }
  // }

  // static Future<void> saveDeviceToken(
  //     FirebaseMessaging _fcm, NotificationProvider notificationProvider) async {
  //   // Get the token for this device
  //   final String fcmToken = await _fcm.getToken();
  //   await notificationProvider.replaceNotiToken(fcmToken);

  //   final NotiRegisterParameterHolder notiRegisterParameterHolder =
  //       NotiRegisterParameterHolder(
  //           platformName: PsConst.PLATFORM,
  //           deviceId: fcmToken,
  //           loginUserId: checkUserLoginId(notificationProvider.psValueHolder));
  //   print('Token Key $fcmToken');
  //   if (fcmToken != null) {
  //     await notificationProvider
  //         .rawRegisterNotiToken(notiRegisterParameterHolder.toMap());
  //   }
  //   return true;
  // }

  // static dynamic takeDataFromNoti(
  //     BuildContext context, Map<String, dynamic> message, String loginUserId) {
  //   final dynamic data = message['notification'] ?? message;
  //   if (Platform.isAndroid) {
  //     final String flag = message['data']['seller_id'];
  //     final String notiMessage = message['data']['message'];

  //     if (flag == null) {
  //       // _showBroadCastNotification(context, notiMessage);
  //       _onSelectNotification(context, notiMessage);
  //     } else {
  //       final String sellerId = message['data']['seller_id'];
  //       final String buyerId = message['data']['buyer_id'];
  //       final String senderName = message['data']['sender_name'];
  //       final String senderProflePhoto = message['data']['sender_profle_photo'];
  //       final String itemId = message['data']['item_id'];
  //       final String action = message['data']['action'];

  //       if (loginUserId != null && loginUserId != '') {
  //         _showChatNotification(context, notiMessage, sellerId, buyerId,
  //             senderName, senderProflePhoto, itemId, action, loginUserId);
  //       }
  //     }
  //   } else if (Platform.isIOS) {
  //     final String flag = data['seller_id'];
  //     String notiMessage = data['body'];
  //     notiMessage ??= data['message'];
  //     notiMessage ??= '';

  //     if (flag == null) {
  //       // _showBroadCastNotification(context, notiMessage);
  //       _onSelectNotification(context, notiMessage);
  //     } else {
  //       final String sellerId = data['seller_id'];
  //       final String buyerId = data['buyer_id'];
  //       final String senderName = data['sender_name'];
  //       final String senderProflePhoto = data['sender_profle_photo'];
  //       final String itemId = data['item_id'];
  //       final String action = data['action'];

  //       if (loginUserId != null && loginUserId != '') {
  //         _showChatNotification(context, notiMessage, sellerId, buyerId,
  //             senderName, senderProflePhoto, itemId, action, loginUserId);
  //       }
  //     }
  //   }
  // }

  static dynamic takeDataFromNoti(
      BuildContext context, Map<String, dynamic> message, String loginUserId) {
  final UserRepository userRepository  = Provider.of<UserRepository>(context,listen: false);
    final PsValueHolder psValueHolder=  Provider.of<PsValueHolder>(context,listen: false);
  final UserProvider userProvider = UserProvider(
                  repo: userRepository, psValueHolder: psValueHolder);
    final dynamic data = message['notification'] ?? message;
    if (Platform.isAndroid) {
      final String flag = message['data']['flag']; //backend flag
      final String notiMessage = message['data']['message'];

      if (flag == 'broadcast') {
        _onSelectNotification(context, notiMessage);
      } else if (flag == 'approval') {
        _onSelectApprovalNotification(context, notiMessage);
      }else if(flag == 'chat'){
        isNotiFromToolbar = true;
        final String sellerId = message['data']['seller_id'];
        final String buyerId = message['data']['buyer_id'];
        final String senderName = message['data']['sender_name'];
        final String senderProflePhoto = message['data']['sender_profle_photo'];
        final String itemId = message['data']['item_id'];
        final String action = message['data']['action'];

        if (userProvider.psValueHolder.loginUserId != null &&
        userProvider.psValueHolder.loginUserId != '' &&
        !isReachChatView) {
          _showChatNotification(context, notiMessage, sellerId, buyerId,
              senderName, senderProflePhoto, itemId, action, loginUserId);
        }
      } else if(flag == 'review') {
        final String rating = message['data']['rating'];
        final String ratingMessage = Utils.getString(context, 'noti_message__text1') + 
        rating.split('.')[0] + Utils.getString(context, 'noti_message__text2') + '\n"' +notiMessage +'"';
        _onSelectReviewNotification(context, ratingMessage, userProvider.psValueHolder.loginUserId);

      } else {
        _onSelectApprovalNotification(context, notiMessage);
      }
    } else if (Platform.isIOS) {
      final String flag = data['flag'];
      String notiMessage = data['body'];
      notiMessage ??= data['message'];
      notiMessage ??= '';

      if (flag == 'broadcast') {
        _onSelectNotification(context, notiMessage);
      } else if (flag == 'approval') {
        _onSelectApprovalNotification(context, notiMessage);
      }else if(flag == 'chat'){
        isNotiFromToolbar = true;
        final String sellerId = data['seller_id'];
        final String buyerId = data['buyer_id'];
        final String senderName = data['sender_name'];
        final String senderProflePhoto = data['sender_profle_photo'];
        final String itemId = data['item_id'];
        final String action = data['action'];

        if (userProvider.psValueHolder.loginUserId != null && 
        userProvider.psValueHolder.loginUserId != '' && 
        !isReachChatView) {
          _showChatNotification(context, notiMessage, sellerId, buyerId,
              senderName, senderProflePhoto, itemId, action, loginUserId);
        }
      } else if(flag == 'review'){
        final String rating = message['data']['rating'];
        final String ratingMessage = Utils.getString(context, 'noti_message__text1') + 
        rating.split('.')[0] + Utils.getString(context, 'noti_message__text2') + '\n"' +notiMessage +'"';
        _onSelectReviewNotification(context, ratingMessage, userProvider.psValueHolder.loginUserId);
      } else {
        _onSelectApprovalNotification(context, notiMessage);
      }
    }
  }

  static Future<void> _showChatNotification(
      BuildContext context,
      String payload,
      String sellerId,
      String buyerId,
      String senderName,
      String senderProflePhoto,
      String itemId,
      String action,
      String loginUserId) async {
    if (context != null) {
      return showDialog<dynamic>(
        context: context,
        builder: (_) {
          return ChatNotiDialog(
              description: '$payload',
              leftButtonText: Utils.getString(context, 'dialog__cancel'),
              rightButtonText: Utils.getString(context, 'chat_noti__open'),
              onAgreeTap: () {
                _navigateToChat(context, sellerId, buyerId, senderName,
                    senderProflePhoto, itemId, action, loginUserId);
              });
        },
      );
    }
  }

  static Future<void> _onSelectApprovalNotification(
      BuildContext context, String payload) async {
    if (context != null) {
      showDialog<dynamic>(
          context: context,
          builder: (_) {
            return NotiDialog(message: '$payload');
          });
    }
  }

  static void _navigateToChat(
      BuildContext context,
      String sellerId,
      String buyerId,
      String senderName,
      String senderProflePhoto,
      String itemId,
      String action,
      String loginUserId) {
    if (loginUserId == buyerId) {
      Navigator.pushNamed(context, RoutePaths.chatView,
          arguments: ChatHistoryIntentHolder(
            chatFlag: PsConst.CHAT_FROM_SELLER,
            itemId: itemId,
            buyerUserId: buyerId,
            sellerUserId: sellerId,
          ));
    } else {
      Navigator.pushNamed(context, RoutePaths.chatView,
          arguments: ChatHistoryIntentHolder(
              chatFlag: PsConst.CHAT_FROM_BUYER,
              itemId: itemId,
              buyerUserId: buyerId,
              sellerUserId: sellerId));
    }
  }

  // static Future<void> _showBroadCastNotification(
  //     BuildContext context, String payload) async {
  //   // if (context == null) {
  //   //   widget.onNotiClicked(payload);
  //   // } else {
  //   if (context != null) {
  //     return showDialog<dynamic>(
  //       context: context,
  //       builder: (_) {
  //         return NotiDialog(message: '$payload');
  //       },
  //     );
  //   }
  // }

  static bool checkEmailFormat(String email) {
    bool emailFormat;
    if (email != '') {
      emailFormat = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    } 
    return emailFormat;
  }

  static Future<void> _onSelectNotification(
      BuildContext context, String payload) async {
    if (context != null) {
      showDialog<dynamic>(
          context: context,
          builder: (_) {
            return ChatNotiDialog(
                description: '$payload',
                leftButtonText: Utils.getString(context, 'chat_noti__cancel'),
                rightButtonText: Utils.getString(context, 'chat_noti__open'),
                onAgreeTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutePaths.notiList,
                  );
                });
          });
    }
  }

  static Future<void> _onSelectReviewNotification(
      BuildContext context, String payload, String userId) async {
    if (context != null) {
      showDialog<dynamic>(
          context: context,
          builder: (_) {
            return ChatNotiDialog(
                description: '$payload',
                leftButtonText: Utils.getString(context, 'chat_noti__cancel'),
                rightButtonText: Utils.getString(context, 'chat_noti__open'),
                onAgreeTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutePaths.ratingList,
                    arguments: userId
                  );
                });
          });
    }
  }

  static void subscribeToTopic(bool isEnable) {
    if (isEnable) {
      final FirebaseMessaging _fcm = FirebaseMessaging();
      if (Platform.isIOS) {
        _fcm.requestNotificationPermissions(const IosNotificationSettings());
      }
      _fcm.subscribeToTopic('broadcast');
    }
  }

  static void fcmConfigure(
      BuildContext context, FirebaseMessaging _fcm, String loginUserId) {
    // final FirebaseMessaging _fcm = FirebaseMessaging();
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(const IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');

        final String notiMessage = _parseNotiMessage(message);

        // _onSelectNotification(context, notiMessage);
        Utils.takeDataFromNoti(context, message, loginUserId);

        PsSharedPreferences.instance.replaceNotiMessage(
          notiMessage,
        );
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');

        final String notiMessage = _parseNotiMessage(message);

        // _onSelectNotification(context, notiMessage);
        Utils.takeDataFromNoti(context, message, loginUserId);

        PsSharedPreferences.instance.replaceNotiMessage(
          notiMessage,
        );
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');

        final String notiMessage = _parseNotiMessage(message);

        // _onSelectNotification(context, notiMessage);
        Utils.takeDataFromNoti(context, message, loginUserId);

        PsSharedPreferences.instance.replaceNotiMessage(
          notiMessage,
        );
      },
    );
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print('onBackgroundMessage: $message');
    final String notiMessage = _parseNotiMessage(message);

    // Utils.takeDataFromNoti(context, message, loginUserId);

    PsSharedPreferences.instance.replaceNotiMessage(
      notiMessage,
    );
  }

  static String _parseNotiMessage(Map<String, dynamic> message) {
    final dynamic data = message['notification'] ?? message;
    String notiMessage = '';
    if (Platform.isAndroid) {
      notiMessage = message['data']['message'];
      notiMessage ??= '';
    } else if (Platform.isIOS) {
      notiMessage = data['body'];
      notiMessage ??= data['message'];
      notiMessage ??= '';
    }
    return notiMessage;
  }

  static Future<void> saveDeviceToken(
      FirebaseMessaging _fcm, NotificationProvider notificationProvider) async {
    // Get the token for this device
    final String fcmToken = await _fcm.getToken();
    await notificationProvider.replaceNotiToken(fcmToken);

    final NotiRegisterParameterHolder notiRegisterParameterHolder =
        NotiRegisterParameterHolder(
            platformName: PsConst.PLATFORM,
            deviceId: fcmToken,
            loginUserId:
                Utils.checkUserLoginId(notificationProvider.psValueHolder));
    print('Token Key $fcmToken');
    if (fcmToken != null) {
      await notificationProvider
          .rawRegisterNotiToken(notiRegisterParameterHolder.toMap());
    }
    return true;
  }
}
