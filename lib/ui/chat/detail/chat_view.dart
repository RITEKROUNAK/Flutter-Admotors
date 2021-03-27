import 'dart:async';
import 'dart:io' show File, Platform;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/chat/chat_history_list_provider.dart';
import 'package:flutteradmotors/provider/chat/get_chat_history_provider.dart';
import 'package:flutteradmotors/provider/chat/user_unread_message_provider.dart';
import 'package:flutteradmotors/provider/common/notification_provider.dart';
import 'package:flutteradmotors/provider/gallery/gallery_provider.dart';
import 'package:flutteradmotors/provider/product/product_provider.dart';
import 'package:flutteradmotors/repository/Common/notification_repository.dart';
import 'package:flutteradmotors/repository/chat_history_repository.dart';
import 'package:flutteradmotors/repository/gallery_repository.dart';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/repository/user_unread_message_repository.dart';
import 'package:flutteradmotors/ui/chat/dialog/chat_make_offer_dialog.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutteradmotors/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutteradmotors/ui/common/dialog/error_dialog.dart';
import 'package:flutteradmotors/ui/common/ps_textfield_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/rating/entry/rating_input_dialog.dart';
import 'package:flutteradmotors/utils/ps_progress_dialog.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/chat.dart';
import 'package:flutteradmotors/viewobject/chat_history.dart';
import 'package:flutteradmotors/viewobject/chat_user_presence.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/default_photo.dart';
import 'package:flutteradmotors/viewobject/holder/chat_noti_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/get_chat_history_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/make_mark_as_sold_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/make_offer_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/reset_unread_message_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/sync_chat_history_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/message.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    Key key,
    @required this.itemId,
    @required this.chatFlag,
    @required this.buyerUserId,
    @required this.sellerUserId,
    // @required this.isOffer,
  }) : super(key: key);

  final String itemId;
  final String chatFlag;
  final String buyerUserId;
  final String sellerUserId;
  // final String isOffer;
  @override
  _ChatViewState createState() => _ChatViewState();
}

enum ChatUserStatus { active, in_active, offline }

class _ChatViewState extends State<ChatView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController animationController;
  DatabaseReference _messagesRef;
  DatabaseReference _chatRef;
  DatabaseReference _userPresence;
  // StreamSubscription<Event> _counterSubscription;
  // StreamSubscription<Event> _messagesSubscription;
  final bool _anchorToBottom = true;
  FirebaseApp firebaseApp;
  PsValueHolder psValueHolder;
  String sessionId;
  ChatHistoryRepository chatHistoryRepository;
  NotificationRepository notiRepo;
  UserUnreadMessageRepository userUnreadMessageRepository;
  GalleryRepository galleryRepo;
  ProductRepository productRepo;
  GetChatHistoryProvider getChatHistoryProvider;
  UserUnreadMessageProvider userUnreadMessageProvider;
  ChatHistoryListProvider chatHistoryListProvider;
  ItemDetailProvider itemDetailProvider;
  GalleryProvider galleryProvider;
  NotificationProvider notiProvider;
  SyncChatHistoryParameterHolder holder;
  GetChatHistoryParameterHolder getChatHistoryParameterHolder;
  PsResource<ChatHistory> chatHistory;
  String lastTimeStamp;
  String status = '';
  String itemId;
  String receiverId;
  String senderId;
  String otherUserId;

  ChatUserStatus isActive;
  // bool isInActive = false;

  TextEditingController messageController = TextEditingController();

  Future<FirebaseApp> configureDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final FirebaseApp app = await Firebase.initializeApp(
      options: Platform.isIOS
          ? const FirebaseOptions(
              appId: PsConfig.iosGoogleAppId,
              messagingSenderId: PsConfig.iosGcmSenderId,
              databaseURL: PsConfig.iosDatabaseUrl,
              projectId: PsConfig.iosProjectId,
              apiKey: PsConfig.iosApiKey)
          : const FirebaseOptions(
              appId: PsConfig.androidGoogleAppId,
              apiKey: PsConfig.androidApiKey,
              projectId: PsConfig.androidProjectId,
              messagingSenderId: PsConfig.androidGcmSenderId,
              databaseURL: PsConfig.androidDatabaseUrl,
            ),
    );
    //   name: 'flutter-buy-and-sell',
    //   options: Platform.isIOS
    //       ? const FirebaseOptions(
    //           googleAppID: PsConfig.iosGoogleAppId,
    //           gcmSenderID: PsConfig.iosGcmSenderId,
    //           databaseURL: PsConfig.iosDatabaseUrl,
    //           apiKey: PsConfig.iosApiKey)
    //       : const FirebaseOptions(
    //           googleAppID: PsConfig.androidGoogleAppId,
    //           apiKey: PsConfig.androidApiKey,
    //           databaseURL: PsConfig.androidDatabaseUrl,
    //         ),
    // );

    return app;
  }

  @override
  void initState() {
    super.initState();
    configureDatabase().then((FirebaseApp app) {
      firebaseApp = app;
    });
    // Demonstrates configuring the database directly
    final FirebaseDatabase database = FirebaseDatabase(app: firebaseApp);
    _messagesRef = database.reference().child('Message');
    _chatRef = database.reference().child('Current_Chat_With');
    _userPresence = database.reference().child('User_Presence');

    if (database != null && database.databaseURL != null) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
    } else if (state == AppLifecycleState.inactive) {
      _chatRef.child(psValueHolder.loginUserId).remove();
      // app is inactive
    } else if (state == AppLifecycleState.paused) { 
      _chatRef.child(psValueHolder.loginUserId).remove();
      // user is about quit our app temporally
    } else if (state == AppLifecycleState.detached) {
      // app suspended (not used in iOS)
    }
  }


  @override
  void dispose() {
    super.dispose();
    //child(sessionId).
    if (mounted) {
    _chatRef.child(psValueHolder.loginUserId).remove();
    _userPresence.child(psValueHolder.loginUserId).remove();

    WidgetsBinding.instance.removeObserver(this);
    Utils.isReachChatView = false;

    // _messagesSubscription.cancel();
    // _counterSubscription.cancel();
    }
  }

  Future<bool> resetUnreadMessageCount(
      ChatHistoryListProvider chatHistoryListProvider,
      PsValueHolder valueHolder,
      UserUnreadMessageProvider userUnreadMessageProvider) async {
    final ResetUnreadMessageParameterHolder resetUnreadMessageParameterHolder =
        ResetUnreadMessageParameterHolder(
            itemId: widget.itemId,
            buyerUserId: widget.buyerUserId,
            sellerUserId: widget.sellerUserId,
            type: widget.chatFlag == PsConst.CHAT_FROM_BUYER
                ? PsConst.CHAT_TO_SELLER
                : PsConst.CHAT_TO_BUYER);

    final dynamic _returnData = await chatHistoryListProvider
        .resetUnreadMessageCount(resetUnreadMessageParameterHolder.toMap());

    if (_returnData == null) {
      //!= null && _returnData.status == PsStatus.SUCCESS) {
      if (valueHolder.loginUserId != null && valueHolder.loginUserId != '') {
        final UserUnreadMessageParameterHolder userUnreadMessageHolder =
            UserUnreadMessageParameterHolder(
                userId: valueHolder.loginUserId,
                deviceToken: valueHolder.deviceToken);
        userUnreadMessageProvider
            .userUnreadMessageCount(userUnreadMessageHolder);
      }
      return true;
    } else {
      return false;
    }
  }

  dynamic pushNoti() async {
    //check offline or online
    final ChatNotiParameterHolder chatNotiParameterHolder =
        ChatNotiParameterHolder(
            itemId: widget.itemId,
            buyerUserId: widget.buyerUserId,
            sellerUserId: widget.sellerUserId,
            message: messageController.text,
            type: widget.chatFlag == PsConst.CHAT_FROM_BUYER
                ? PsConst.CHAT_TO_BUYER
                : PsConst.CHAT_TO_SELLER);

    await notiProvider.postChatNoti(chatNotiParameterHolder.toMap());
  }

  Future<void> _insertDataToFireBase(
    String id,
    bool isSold,
    String itemId,
    String message,
    int offerStatus,
    String sendByUserId,
    String sessionId,
    int type,
  ) async {
    final Message messages = Message();
    messages.addedDate = Utils.getTimeStamp();
    messages.id = id;
    messages.isSold = isSold;
    messages.itemId = itemId;
    messages.message = message;
    messages.offerStatus = offerStatus;
    messages.sendByUserId = sendByUserId;
    messages.sessionId = sessionId;
    messages.type = type;

    final String newkey = _messagesRef.child(sessionId).push().key;
    messages.id = newkey;
    // Add / Update
    _messagesRef
        .child(sessionId)
        .child(newkey)
        .set(messages.toInsertMap(messages));
    if (isActive != ChatUserStatus.active) {
      pushNoti();
    }
  }

  Future<void> _updateDataToFireBase(
    int addedDate,
    String id,
    bool isSold,
    String itemId,
    String message,
    int offerStatus,
    String sendByUserId,
    String sessionId,
    int type,
  ) async {
    final Message messages = Message();
    // chat.addedDate = Utils.getTimeStamp();
    messages.id = id;
    messages.isSold = isSold;
    messages.itemId = itemId;
    messages.message = message;
    messages.offerStatus = offerStatus;
    messages.sendByUserId = sendByUserId;
    messages.sessionId = sessionId;
    messages.type = type;
    messages.addedDateTimeStamp = addedDate;

    // Update
    _messagesRef
        .child(sessionId)
        .child(messages.id)
        .set(messages.toUpdateMap(messages));
    if (isActive != ChatUserStatus.active) {
      pushNoti();
    }
  }

  Future<void> _insertSenderAndReceiverToFireBase(
      String sessionId,
      String itemId,
      String receiverId,
      String senderId,
      String userName) async {
    final Chat chat =
        Chat(itemId: itemId, receiverId: receiverId, senderId: senderId);
    // chat.itemId = itemId;
    // chat.receiverId = receiverId;
    // chat.senderId = senderId;

    // _chatRef.child(senderId).child(sessionId).set(chat.toMap(chat));
    _chatRef.child(senderId).set(chat.toMap(chat));

    final ChatUserPresence chatUserPresence =
        ChatUserPresence(userId: senderId, userName: userName);

    _userPresence.child(senderId).set(chatUserPresence.toMap(chatUserPresence));
  }

  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      width: PsDimens.space10,
    );
    lastTimeStamp = null;

    psValueHolder = Provider.of<PsValueHolder>(context);
    chatHistoryRepository = Provider.of<ChatHistoryRepository>(context);
    notiRepo = Provider.of<NotificationRepository>(context);
    galleryRepo = Provider.of<GalleryRepository>(context);
    productRepo = Provider.of<ProductRepository>(context);
    userUnreadMessageRepository =
        Provider.of<UserUnreadMessageRepository>(context);
    if (psValueHolder.loginUserId != null) {
      if (psValueHolder.loginUserId == widget.buyerUserId) {
        sessionId =
            Utils.sortingUserId(widget.sellerUserId, widget.buyerUserId);
        otherUserId = widget.sellerUserId;
      } else if (psValueHolder.loginUserId == widget.sellerUserId) {
        sessionId =
            Utils.sortingUserId(widget.buyerUserId, widget.sellerUserId);
        otherUserId = widget.buyerUserId;
      }

      _insertSenderAndReceiverToFireBase(sessionId, widget.itemId, otherUserId,
          psValueHolder.loginUserId, psValueHolder.loginUserName);
    }

    _chatRef.child(otherUserId).onValue.listen((Event event) {
      if (event.snapshot.value == null) {
        if (isActive != ChatUserStatus.offline && mounted) {
          if (mounted) {
            setState(() {
              status = Utils.getString(context, 'chat_view__status_offline');
              isActive = ChatUserStatus.offline;
            });
          }
        }
      } else {
        itemId = event.snapshot.value['itemId'];
        final String _receiverId = event.snapshot.value['receiver_id'];

        if (_receiverId == psValueHolder.loginUserId &&
            itemId == widget.itemId) {
          if (isActive != ChatUserStatus.active && mounted) {
            if (mounted) {
              setState(() {
                status = Utils.getString(context, 'chat_view__status_active');
                isActive = ChatUserStatus.active;
              });
            }
          }
        } else {
          if (isActive != ChatUserStatus.in_active) {
            if (mounted) {
              setState(() {
                status = Utils.getString(context, 'chat_view__status_inactive');
                isActive = ChatUserStatus.in_active;
              });
            }
          }
        }
      }
    });

    Future<void> checkOfferStatus(ChatHistory chatHistory) async {
      if (chatHistory != null &&
          chatHistory.isOffer == PsConst.ONE &&
          chatHistory.isAccept != PsConst.ONE) {
        await getChatHistoryProvider
            .getChatHistory(getChatHistoryParameterHolder);
      }
    }

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(
            status,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: PsColors.mainColorWithWhite),
          )),
      body: PsWidgetWithMultiProvider(
          child: MultiProvider(
              providers: <SingleChildWidget>[
            ChangeNotifierProvider<ItemDetailProvider>(
                lazy: false,
                create: (BuildContext context) {
                  itemDetailProvider = ItemDetailProvider(
                      repo: productRepo, psValueHolder: psValueHolder);

                  final String loginUserId =
                      Utils.checkUserLoginId(psValueHolder);
                  itemDetailProvider.loadProduct(widget.itemId, loginUserId);

                  return itemDetailProvider;
                }),
            ChangeNotifierProvider<UserUnreadMessageProvider>(
                lazy: false,
                create: (BuildContext context) {
                  userUnreadMessageProvider = UserUnreadMessageProvider(
                      repo: userUnreadMessageRepository);
                  return userUnreadMessageProvider;
                }),
            ChangeNotifierProvider<ChatHistoryListProvider>(
                lazy: false,
                create: (BuildContext context) {
                  chatHistoryListProvider =
                      ChatHistoryListProvider(repo: chatHistoryRepository);

                  //call read message count
                  resetUnreadMessageCount(chatHistoryListProvider,
                      psValueHolder, userUnreadMessageProvider);
                  return chatHistoryListProvider;
                }),
            ChangeNotifierProvider<NotificationProvider>(
                lazy: false,
                create: (BuildContext context) {
                  notiProvider = NotificationProvider(
                      repo: notiRepo, psValueHolder: psValueHolder);

                  return notiProvider;
                }),
            ChangeNotifierProvider<GalleryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  galleryProvider = GalleryProvider(
                    repo: galleryRepo,
                  );

                  return galleryProvider;
                }),
            ChangeNotifierProvider<GetChatHistoryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  getChatHistoryProvider =
                      GetChatHistoryProvider(repo: chatHistoryRepository);
                  getChatHistoryParameterHolder = GetChatHistoryParameterHolder(
                      itemId: widget.itemId,
                      buyerUserId: widget.buyerUserId,
                      sellerUserId: widget.sellerUserId);
                  getChatHistoryProvider
                      .getChatHistory(getChatHistoryParameterHolder);

                  return getChatHistoryProvider;
                }),
          ],
              child: Consumer<ItemDetailProvider>(builder:
                  (BuildContext context, ItemDetailProvider itemDetailProvider,
                      Widget child) {
                // if (getChatHistoryProvider.chatHistory != null &&
                //     getChatHistoryProvider.chatHistory.data != null &&
                if (itemDetailProvider.itemDetail != null &&
                    itemDetailProvider.itemDetail.data != null) {
                  return Container(
                    color: Utils.isLightMode(context)
                        ? Colors.grey[100]
                        : Colors.grey[900],
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              alignment: Alignment.topCenter,
                              width: double.infinity,
                              child: ItemInfoWidget(
                                insertDataToFireBase: _insertDataToFireBase,
                                sessionId: sessionId,
                                itemData: itemDetailProvider.itemDetail.data,
                                sendByUserId: psValueHolder.loginUserId ?? '',
                                chatFlag: widget.chatFlag,
                                buyerUserId: widget.buyerUserId,
                                sellerUserId: widget.sellerUserId,
                                chatHistoryProvider: getChatHistoryProvider,
                                isOffer:
                                    (getChatHistoryProvider.chatHistory.data !=
                                                null &&
                                            getChatHistoryProvider
                                                    .chatHistory.data.id !=
                                                '')
                                        ? getChatHistoryProvider
                                            .chatHistory.data.isOffer
                                        : '0',
                              ),
                            )),
                        Flexible(
                          child: Container(
                            margin:
                                const EdgeInsets.only(bottom: PsDimens.space12),
                            child: FirebaseAnimatedList(
                              key: ValueKey<bool>(_anchorToBottom),
                              query: _messagesRef
                                  .child(sessionId)
                                  .orderByChild('itemId')
                                  .equalTo(widget.itemId),
                              reverse: _anchorToBottom,
                              sort: _anchorToBottom
                                  ? (DataSnapshot a, DataSnapshot b) {
                                      return b.value['addedDate']
                                          .toString()
                                          .compareTo(
                                              a.value['addedDate'].toString());
                                    }
                                  : null,
                              itemBuilder: (BuildContext context,
                                  DataSnapshot snapshot,
                                  Animation<double> animation,
                                  int index) {
                                print('Index : $index');
                                bool isSameDate = false;
                                final Message messages =
                                    Message().fromMap(snapshot.value);
                                final String chatDateString =
                                    Utils.convertTimeStampToDate(
                                        messages.addedDateTimeStamp);

                                if (index == 0 || lastTimeStamp == null) {
                                  lastTimeStamp = chatDateString;
                                }

                                if (lastTimeStamp == chatDateString) {
                                  isSameDate = true;
                                } else {
                                  isSameDate = false;
                                }
                                final Widget _chatCell = _ChatPageWidget(
                                  buyerUserId: widget.buyerUserId,
                                  sellerUserId: widget.sellerUserId,
                                  chatFlag: widget.chatFlag,
                                  chatHistoryProvider: getChatHistoryProvider,
                                  chatHistoryParameterHolder:
                                      getChatHistoryParameterHolder,
                                  messageObj: messages,
                                  itemDetail:
                                      itemDetailProvider.itemDetail.data,
                                  psValueHolder: psValueHolder,
                                  updateDataToFireBase: _updateDataToFireBase,
                                  insertDataToFireBase: _insertDataToFireBase,
                                  checkOfferStatus: checkOfferStatus,
                                  index: index,
                                );

                                Widget _dateWidget;
                                if (!isSameDate) {
                                  _dateWidget = Container(
                                    margin: const EdgeInsets.only(
                                        top: PsDimens.space8,
                                        bottom: PsDimens.space8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        _spacingWidget,
                                        const Expanded(
                                          child: Divider(
                                              height: PsDimens.space1,
                                              color: Colors.black54),
                                        ),
                                        _spacingWidget,
                                        Container(
                                          padding: const EdgeInsets.all(
                                              PsDimens.space4),
                                          decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      PsDimens.space8)),
                                          child: Text(
                                            lastTimeStamp,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(color: Colors.white),
                                          ),
                                        ),
                                        _spacingWidget,
                                        const Expanded(
                                          child: Divider(
                                              height: PsDimens.space1,
                                              color: Colors.black54),
                                        ),
                                        _spacingWidget,
                                      ],
                                    ),
                                  );

                                  lastTimeStamp = chatDateString;
                                }

                                return isSameDate
                                    ? _chatCell
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          _chatCell,
                                          _dateWidget,
                                        ],
                                      );
                              },
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              width: double.infinity,
                              child: EditTextAndButtonWidget(
                                messageController: messageController,
                                insertDataToFireBase: _insertDataToFireBase,
                                sessionId: sessionId,
                                itemData: itemDetailProvider.itemDetail.data,
                                psValueHolder: psValueHolder,
                                chatFlag: widget.chatFlag,
                                chatHistoryProvider: getChatHistoryProvider,
                                galleryProvider: galleryProvider,
                                buyerUserId: widget.buyerUserId,
                                sellerUserId: widget.sellerUserId,
                              ),
                            ))
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }))),
    );
  }
}

class _ChatPageWidget extends StatefulWidget {
  const _ChatPageWidget(
      {@required this.psValueHolder,
      @required this.messageObj,
      @required this.itemDetail,
      @required this.buyerUserId,
      @required this.sellerUserId,
      @required this.updateDataToFireBase,
      @required this.insertDataToFireBase,
      @required this.chatHistoryProvider,
      @required this.chatHistoryParameterHolder,
      @required this.chatFlag,
      @required this.checkOfferStatus,
      @required this.index});
  final PsValueHolder psValueHolder;
  final Message messageObj;
  final Product itemDetail;
  final String buyerUserId;
  final String sellerUserId;
  final Function updateDataToFireBase;
  final Function insertDataToFireBase;
  final GetChatHistoryProvider chatHistoryProvider;
  final String chatFlag;
  final GetChatHistoryParameterHolder chatHistoryParameterHolder;
  final Function checkOfferStatus;
  final int index;

  @override
  __ChatPageWidgetState createState() => __ChatPageWidgetState();
}

class __ChatPageWidgetState extends State<_ChatPageWidget> {
  @override
  Widget build(BuildContext context) {
    // Checking User id
    if (widget.psValueHolder.loginUserId == '' ||
        widget.messageObj.sendByUserId == '') {
      return Container();
    }

    if (widget.psValueHolder.loginUserId == widget.messageObj.sendByUserId) {
      // sender
      if (widget.messageObj.type == PsConst.CHAT_TYPE_TEXT) {
        if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_OFFER) {
          return _ChatMakeOfferSenderBoxWidget(
            messageObj: widget.messageObj,
          );
        } else if (widget.messageObj.offerStatus ==
            PsConst.CHAT_STATUS_ACCEPT) {
          if (widget.psValueHolder.loginUserId == widget.sellerUserId &&
              !widget.messageObj.isSold) {
            return _OfferAcceptedWithMarkAsSoldWidget(
                messageObj: widget.messageObj,
                updateDataToFireBase: widget.updateDataToFireBase,
                insertDataToFireBase: widget.insertDataToFireBase,
                chatHistoryProvider: widget.chatHistoryProvider,
                loginUserId: widget.psValueHolder.loginUserId,
                sellerUserId: widget.sellerUserId,
                buyerUserId: widget.buyerUserId);
          } else {
            return _ChatAcceptedOrRejectedOfferSenderBoxWidget(
              messageObj: widget.messageObj,
            );
          }
        } else if (widget.messageObj.offerStatus ==
            PsConst.CHAT_STATUS_REJECT) {
          if (widget.index == 0) {
            widget
                .checkOfferStatus(widget.chatHistoryProvider.chatHistory.data);
          }
          return _ChatAcceptedOrRejectedOfferSenderBoxWidget(
            messageObj: widget.messageObj,
          );
        } else {
          return _ChatTextSenderWidget(widget: widget);
        }
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_OFFER) {
        return _ChatMakeOfferSenderBoxWidget(
          messageObj: widget.messageObj,
        );
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_SOLD) {
        return _MakeMarkAsSoldWidget(
          messageObj: widget.messageObj,
          itemDetail: widget.itemDetail,
          psValueHolder: widget.psValueHolder,
          buyerUserId: widget.buyerUserId,
          sellerUserId: widget.sellerUserId,
        );
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_IMAGE) {
        return _ChatImageSenderWidget(
          widget: widget,
        );
      } else {
        return const Text('something wrong Chat!');
      }
    } else {
      //receiver
      if (widget.messageObj.type == PsConst.CHAT_TYPE_TEXT) {
        if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_OFFER) {
          // return _ChatMakeOfferReceiverBoxWidget(
          //   messageObj: widget.messageObj,
          // );
          return _OfferReceivedBoxWithoutAcceptAndRejectWidget(
            messageObj: widget.messageObj,
          );
        } else if (widget.messageObj.offerStatus ==
            PsConst.CHAT_STATUS_ACCEPT) {
          if (widget.psValueHolder.loginUserId == widget.sellerUserId &&
              !widget.messageObj.isSold) {
            return _OfferAcceptedWithMarkAsSoldWidget(
                messageObj: widget.messageObj,
                updateDataToFireBase: widget.updateDataToFireBase,
                insertDataToFireBase: widget.insertDataToFireBase,
                chatHistoryProvider: widget.chatHistoryProvider,
                loginUserId: widget.psValueHolder.loginUserId,
                sellerUserId: widget.sellerUserId,
                buyerUserId: widget.buyerUserId);
          } else {
            return _ChatAcceptedOrRejectedOfferReceiverBoxWidget(
              messageObj: widget.messageObj,
            );
          }
        } else if (widget.messageObj.offerStatus ==
            PsConst.CHAT_STATUS_REJECT) {
          if (widget.index == 0) {
            widget
                .checkOfferStatus(widget.chatHistoryProvider.chatHistory.data);
          }
          return _ChatAcceptedOrRejectedOfferReceiverBoxWidget(
            messageObj: widget.messageObj,
          );
        } else {
          return _ChatTextReceiverWidget(widget: widget);
        }
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_OFFER) {
        return _OfferReceivedBoxWithAcceptAndRejectWidget(
          messageObj: widget.messageObj,
          chatFlag: widget.chatFlag,
          updateDataToFireBase: widget.updateDataToFireBase,
          insertDataToFireBase: widget.insertDataToFireBase,
          chatHistoryProvider: widget.chatHistoryProvider,
          loginUserId: widget.psValueHolder.loginUserId,
          sellerUserId: widget.sellerUserId,
          buyerUserId: widget.buyerUserId,
        );
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_SOLD) {
        return _MakeMarkAsSoldWidget(
          messageObj: widget.messageObj,
          itemDetail: widget.itemDetail,
          psValueHolder: widget.psValueHolder,
          buyerUserId: widget.buyerUserId,
          sellerUserId: widget.sellerUserId,
        );
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_IMAGE) {
        return _ChatImageReceiverWidget(
          widget: widget,
        );
      } else {
        return const Text('something wrong Chat!');
      }
    }

    // if (widget.psValueHolder.loginUserId == widget.messageObj.sendByUserId &&
    //     widget.messageObj.itemId == widget.itemDetail.id &&
    //     widget.messageObj.offerStatus == PsConst.CHAT_STATUS_NULL &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_TEXT) {
    //   ///
    //   /// Text UI ( Sender )true
    //   ///
    //   return _ChatTextSenderWidget(widget: widget);
    // } else if (widget.psValueHolder.loginUserId !=
    //         widget.messageObj.sendByUserId &&
    //     widget.messageObj.itemId == widget.itemDetail.id &&
    //     widget.messageObj.offerStatus == PsConst.CHAT_STATUS_NULL &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_TEXT) {
    //   ///
    //   /// Text UI ( Receiver ) true
    //   ///

    //   return _ChatTextReceiverWidget(widget: widget);
    // }
    // if (widget.psValueHolder.loginUserId == widget.messageObj.sendByUserId &&
    //     widget.messageObj.itemId == widget.itemDetail.id &&
    //     widget.messageObj.offerStatus == PsConst.CHAT_STATUS_NULL &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_IMAGE) {
    //   ///
    //   /// Image UI ( Sender )true
    //   ///
    //   return _ChatImageSenderWidget(
    //     widget: widget,
    //   );
    // } else if (widget.psValueHolder.loginUserId !=
    //         widget.messageObj.sendByUserId &&
    //     widget.messageObj.itemId == widget.itemDetail.id &&
    //     widget.messageObj.offerStatus == PsConst.CHAT_STATUS_NULL &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_IMAGE) {
    //   ///
    //   /// Image UI ( Receiver ) true
    //   ///

    //   return _ChatImageReceiverWidget(widget: widget);
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_OFFER &&
    //     (widget.messageObj.type == PsConst.CHAT_TYPE_OFFER ||
    //         widget.messageObj.type == PsConst.CHAT_TYPE_REJECT ||
    //         widget.messageObj.type == PsConst.CHAT_TYPE_ACCEPT) &&
    //     widget.psValueHolder.loginUserId != widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Make Offer UI (Sender)
    //   ///
    //   return _MakeOfferBoxWidget(
    //     messageObj: widget.messageObj,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_OFFER &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_OFFER &&
    //     widget.psValueHolder.loginUserId == widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Make Offer UI (Receiver) true
    //   ///
    //   return _OfferReceivedBoxWithAcceptAndRejectWidget(
    //     messageObj: widget.messageObj,
    //     chatFlag: widget.chatFlag,
    //     updateDataToFireBase: widget.updateDataToFireBase,
    //     insertDataToFireBase: widget.insertDataToFireBase,
    //     chatHistoryProvider: widget.chatHistoryProvider,
    //     loginUserId: widget.psValueHolder.loginUserId,
    //     sellerUserId: widget.sellerUserId,
    //     buyerUserId: widget.buyerUserId,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_OFFER &&
    //     (widget.messageObj.type == PsConst.CHAT_TYPE_ACCEPT ||
    //         widget.messageObj.type == PsConst.CHAT_TYPE_REJECT) &&
    //     widget.psValueHolder.loginUserId == widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Offer Received (Item Owner) true
    //   ///
    //   return _OfferReceivedBoxWithoutAcceptAndRejectWidget(
    //     messageObj: widget.messageObj,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT &&
    //     (widget.messageObj.type == PsConst.CHAT_TYPE_ACCEPT ||
    //         widget.messageObj.type == PsConst.CHAT_TYPE_SOLD) &&
    //     widget.psValueHolder.loginUserId == widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Offer Accepted (Item Owner) true
    //   ///
    //   return _OfferAcceptedWithMarkAsSoldWidget(
    //       messageObj: widget.messageObj,
    //       updateDataToFireBase: widget.updateDataToFireBase,
    //       insertDataToFireBase: widget.insertDataToFireBase,
    //       chatHistoryProvider: widget.chatHistoryProvider,
    //       loginUserId: widget.psValueHolder.loginUserId,
    //       sellerUserId: widget.sellerUserId,
    //       buyerUserId: widget.buyerUserId);
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_REJECT &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_REJECT &&
    //     widget.psValueHolder.loginUserId == widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Offer Rejected (Item Ownder) true
    //   ///
    //   return _AcceptedOrRejectedMessageWidget(
    //     messageObj: widget.messageObj,
    //   );
    // } else if ((widget.messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT ||
    //         widget.messageObj.offerStatus == PsConst.CHAT_STATUS_REJECT) &&
    //     (widget.messageObj.type == PsConst.CHAT_TYPE_ACCEPT ||
    //         widget.messageObj.type == PsConst.CHAT_TYPE_REJECT) &&
    //     widget.psValueHolder.loginUserId != widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Offer Received  (Item Buyer) true
    //   ///
    //   return _AcceptedOrRejectedOfferBoxWidget(
    //     messageObj: widget.messageObj,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_REJECT &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_REJECT &&
    //     widget.psValueHolder.loginUserId != widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Offer  Rejected (Item Buyer) true
    //   ///
    //   return _AcceptedOrRejectedOfferBoxWidget(
    //     messageObj: widget.messageObj,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_SOLD &&
    //     widget.psValueHolder.loginUserId != widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   ///
    //   ///
    //   return _AcceptedOrRejectedOfferBoxWidget(
    //     messageObj: widget.messageObj,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_SOLD &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_SOLD &&
    //     widget.psValueHolder.loginUserId == widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Mark As Sold (Item Owner)
    //   ///
    //   return _MakeMarkAsSoldWidget(
    //     messageObj: widget.messageObj,
    //     itemDetail: widget.itemDetail,
    //     psValueHolder: widget.psValueHolder,
    //     buyerUserId: widget.buyerUserId,
    //     sellerUserId: widget.sellerUserId,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_SOLD &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_SOLD &&
    //     widget.psValueHolder.loginUserId != widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Mark As Sold (Item Buyer)
    //   ///
    //   return _MakeMarkAsSoldWidget(
    //       messageObj: widget.messageObj,
    //       itemDetail: widget.itemDetail,
    //       psValueHolder: widget.psValueHolder,
    //       buyerUserId: widget.buyerUserId,
    //       sellerUserId: widget.sellerUserId);
    // } else {
    //   return Container();
    // }
  }
}

class _ChatImageReceiverWidget extends StatelessWidget {
  const _ChatImageReceiverWidget({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final _ChatPageWidget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
            child: Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(PsDimens.space8),
            child: PsNetworkImageWithUrl(
              photoKey: '',
              imagePath: widget.messageObj.message,
              width: double.infinity,
              height: PsDimens.space200,
              boxfit: BoxFit.cover,
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.chatImageDetailView,
                    arguments: widget.messageObj);
              },
            ),
          ),
        )),
        Expanded(
          child: Text(
            Utils.convertTimeStampToTime(widget.messageObj.addedDateTimeStamp),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }
}

class _ChatImageSenderWidget extends StatelessWidget {
  const _ChatImageSenderWidget({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final _ChatPageWidget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: Text(
            Utils.convertTimeStampToTime(widget.messageObj.addedDateTimeStamp),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space8,
                right: PsDimens.space8,
                top: PsDimens.space16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(PsDimens.space8),
              child: PsNetworkImageWithUrl(
                photoKey: '',
                imagePath: widget.messageObj.message,
                width: double.infinity,
                height: PsDimens.space200,
                boxfit: BoxFit.cover,
                onTap: () {
                  Navigator.pushNamed(context, RoutePaths.chatImageDetailView,
                      arguments: widget.messageObj);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatTextReceiverWidget extends StatelessWidget {
  const _ChatTextReceiverWidget({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final _ChatPageWidget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
            child: Container(
          // width: MediaQuery.of(context).size.width / 2,
          margin: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PsDimens.space4),
              color: PsColors.white),
          padding: const EdgeInsets.all(PsDimens.space12),
          child: Text(
            widget.messageObj.message,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: PsColors.textPrimaryColorForLight),
          ),
        )),
        Expanded(
          child: Text(
            Utils.convertTimeStampToTime(widget.messageObj.addedDateTimeStamp),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }
}

class _ChatTextSenderWidget extends StatelessWidget {
  const _ChatTextSenderWidget({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final _ChatPageWidget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: Text(
            Utils.convertTimeStampToTime(widget.messageObj.addedDateTimeStamp),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space8,
                right: PsDimens.space8,
                top: PsDimens.space16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(PsDimens.space4),
                color: Colors.lightBlue[100]),
            padding: const EdgeInsets.all(PsDimens.space12),
            child: Text(
              widget.messageObj.message,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: PsColors.textPrimaryColorForLight),
            ),
          ),
        ),
      ],
    );
  }
}

class _MakeMarkAsSoldWidget extends StatefulWidget {
  const _MakeMarkAsSoldWidget(
      {@required this.messageObj,
      @required this.itemDetail,
      @required this.psValueHolder,
      @required this.buyerUserId,
      @required this.sellerUserId});
  final Message messageObj;
  final Product itemDetail;
  final PsValueHolder psValueHolder;
  final String buyerUserId;
  final String sellerUserId;
  @override
  __MakeMarkAsSoldWidgetState createState() => __MakeMarkAsSoldWidgetState();
}

class __MakeMarkAsSoldWidgetState extends State<_MakeMarkAsSoldWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                top: PsDimens.space8,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  color: Colors.white),
              padding: const EdgeInsets.all(PsDimens.space12),
              child: Column(
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'chat_view__mark_as_sold_message'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: PsColors.textPrimaryColorForLight),
                  ),
                  const SizedBox(height: PsDimens.space12),
                  Text(
                    Utils.getChatPriceFormat(widget.messageObj.message),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: PsColors.textPrimaryColorForLight),
                  ),
                ],
              ),
            ),
            // if (widget.buyerUserId == widget.psValueHolder.loginUserId)
            InkWell(
              onTap: () async {
                Utils.psPrint('Buyer user id : ' + widget.buyerUserId);
                Utils.psPrint('Seller user id : ' + widget.sellerUserId);
                await showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return RatingInputDialog(
                        buyerUserId: widget.buyerUserId,
                        sellerUserId: widget.sellerUserId,
                      );
                    });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                    left: PsDimens.space8,
                    right: PsDimens.space8,
                    top: PsDimens.space16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    color: PsColors.mainColor),
                padding: const EdgeInsets.all(PsDimens.space12),
                child: Ink(
                  color: PsColors.backgroundColor,
                  child: Text(
                    Utils.getString(context, 'chat_view__give_review_button'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _OfferReceivedBoxWithoutAcceptAndRejectWidget extends StatelessWidget {
  const _OfferReceivedBoxWithoutAcceptAndRejectWidget(
      {@required this.messageObj});
  final Message messageObj;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: PsDimens.space140,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            left: PsDimens.space20,
            right: PsDimens.space8,
            top: PsDimens.space8,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PsDimens.space4),
              color: Colors.yellow[200]),
          padding: const EdgeInsets.all(PsDimens.space12),
          child: Column(
            children: <Widget>[
              Text(
                Utils.getString(context, 'chat_view__receive_offer_message'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: PsColors.textPrimaryColorForLight),
              ),
              const SizedBox(height: PsDimens.space12),
              Text(
                Utils.getChatPriceFormat(messageObj.message),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: PsColors.textPrimaryColorForLight),
              ),
            ],
          ),
        ),
        Text(
          Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
          style: Theme.of(context).textTheme.caption,
        )
      ],
    );
  }
}

class _OfferReceivedBoxWithAcceptAndRejectWidget extends StatelessWidget {
  const _OfferReceivedBoxWithAcceptAndRejectWidget(
      {@required this.messageObj,
      @required this.chatFlag,
      @required this.updateDataToFireBase,
      @required this.insertDataToFireBase,
      @required this.chatHistoryProvider,
      @required this.loginUserId,
      @required this.sellerUserId,
      @required this.buyerUserId});
  final Message messageObj;
  final String chatFlag;
  final Function updateDataToFireBase;
  final Function insertDataToFireBase;
  final GetChatHistoryProvider chatHistoryProvider;
  final String loginUserId;
  final String sellerUserId;
  final String buyerUserId;
  @override
  Widget build(BuildContext context) {
    MakeOfferParameterHolder makeOfferHolder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: PsDimens.space140,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            left: PsDimens.space20,
            right: PsDimens.space8,
            top: PsDimens.space8,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PsDimens.space4),
              color: Colors.yellow[200]),
          padding: const EdgeInsets.all(PsDimens.space12),
          child: Column(
            children: <Widget>[
              Text(
                Utils.getString(context, 'chat_view__receive_offer_message'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: PsColors.textPrimaryColorForLight),
              ),
              const SizedBox(height: PsDimens.space12),
              Text(
                Utils.getChatPriceFormat(messageObj.message),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: PsColors.textPrimaryColorForLight),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmDialogView(
                          description: Utils.getString(
                              context, 'chat_view__accept_description'),
                          leftButtonText: Utils.getString(
                              context, 'chat_view__accept_cancel_button'),
                          rightButtonText: Utils.getString(
                              context, 'chat_view__accept_ok_button'),
                          onAgreeTap: () async {
                            updateDataToFireBase(
                              messageObj.addedDateTimeStamp,
                              messageObj.id,
                              false,
                              messageObj.itemId,
                              messageObj.message,
                              PsConst.CHAT_STATUS_OFFER,
                              messageObj.sendByUserId,
                              messageObj.sessionId,
                              PsConst.CHAT_TYPE_ACCEPT,
                            );
                            insertDataToFireBase(
                                '',
                                false,
                                messageObj.itemId,
                                messageObj.message,
                                PsConst.CHAT_STATUS_ACCEPT,
                                loginUserId,
                                //messageObj.sendByUserId,
                                messageObj.sessionId,
                                PsConst.CHAT_TYPE_ACCEPT);
                            if (chatFlag == PsConst.CHAT_FROM_BUYER) {
                              makeOfferHolder = MakeOfferParameterHolder(
                                  itemId: messageObj.itemId,
                                  buyerUserId: buyerUserId,
                                  sellerUserId: sellerUserId,
                                  negoPrice:
                                      Utils.splitMessage(messageObj.message),
                                  type: PsConst.CHAT_TO_BUYER);
                              chatHistoryProvider.postAcceptedOffer(
                                  makeOfferHolder.toMap(), loginUserId);
                            } else {
                              makeOfferHolder = MakeOfferParameterHolder(
                                  itemId: messageObj.itemId,
                                  buyerUserId: buyerUserId,
                                  sellerUserId: sellerUserId,
                                  negoPrice:
                                      Utils.splitMessage(messageObj.message),
                                  type: PsConst.CHAT_TO_SELLER);
                              chatHistoryProvider.postAcceptedOffer(
                                  makeOfferHolder.toMap(), loginUserId);
                            }
                            Navigator.of(context).pop();
                          });
                    });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                    left: PsDimens.space8,
                    right: PsDimens.space8,
                    top: PsDimens.space8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    color: PsColors.mainColor),
                padding: const EdgeInsets.all(PsDimens.space12),
                child: Ink(
                  color: PsColors.backgroundColor,
                  child: Text(
                    Utils.getString(context, 'chat_view__offer_accept_button'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmDialogView(
                          description: Utils.getString(
                              context, 'chat_view__reject_description'),
                          leftButtonText: Utils.getString(
                              context, 'chat_view__reject_cancel_button'),
                          rightButtonText: Utils.getString(
                              context, 'chat_view__reject_ok_button'),
                          onAgreeTap: () async {
                            updateDataToFireBase(
                                messageObj.addedDateTimeStamp,
                                messageObj.id,
                                false,
                                messageObj.itemId,
                                messageObj.message,
                                PsConst.CHAT_STATUS_OFFER,
                                messageObj.sendByUserId,
                                messageObj.sessionId,
                                PsConst.CHAT_TYPE_REJECT);

                            insertDataToFireBase(
                                '',
                                false,
                                messageObj.itemId,
                                messageObj.message,
                                PsConst.CHAT_STATUS_REJECT,
                                messageObj.sendByUserId,
                                messageObj.sessionId,
                                PsConst.CHAT_TYPE_REJECT);

                            if (chatFlag == PsConst.CHAT_FROM_BUYER) {
                              makeOfferHolder = MakeOfferParameterHolder(
                                  itemId: messageObj.itemId,
                                  buyerUserId: buyerUserId,
                                  sellerUserId: sellerUserId,
                                  negoPrice: PsConst.ZERO,
                                  type: PsConst.CHAT_TO_BUYER);
                              chatHistoryProvider.postRejectedOffer(
                                  makeOfferHolder.toMap(), loginUserId);
                            } else {
                              makeOfferHolder = MakeOfferParameterHolder(
                                  itemId: messageObj.itemId,
                                  buyerUserId: buyerUserId,
                                  sellerUserId: sellerUserId,
                                  negoPrice: PsConst.ZERO,
                                  type: PsConst.CHAT_TO_SELLER);
                              chatHistoryProvider.postRejectedOffer(
                                  makeOfferHolder.toMap(), loginUserId);
                            }
                            Navigator.of(context).pop();
                          });
                    });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                    top: PsDimens.space8, right: PsDimens.space8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    color: PsColors.grey),
                padding: const EdgeInsets.all(PsDimens.space12),
                child: Ink(
                  color: PsColors.backgroundColor,
                  child: Text(
                    Utils.getString(context, 'chat_view__offer_reject_button'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ),
            Text(
              Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        )
      ],
    );
  }
}

class _OfferAcceptedWithMarkAsSoldWidget extends StatelessWidget {
  const _OfferAcceptedWithMarkAsSoldWidget(
      {@required this.messageObj,
      @required this.updateDataToFireBase,
      @required this.insertDataToFireBase,
      @required this.chatHistoryProvider,
      @required this.loginUserId,
      @required this.sellerUserId,
      @required this.buyerUserId});
  final Message messageObj;
  final Function updateDataToFireBase;
  final Function insertDataToFireBase;
  final GetChatHistoryProvider chatHistoryProvider;
  final String loginUserId;
  final String sellerUserId;
  final String buyerUserId;
  @override
  Widget build(BuildContext context) {
    MakeMarkAsSoldParameterHolder makeMarkAsSoldHolder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _AcceptedOrRejectedMessageWidget(
          messageObj: messageObj,
        ),
        const SizedBox(height: PsDimens.space8),
        if (messageObj.type == PsConst.CHAT_TYPE_ACCEPT)
          InkWell(
            onTap: () {
              updateDataToFireBase(
                  messageObj.addedDateTimeStamp,
                  messageObj.id,
                  true,
                  messageObj.itemId,
                  messageObj.message,
                  PsConst.CHAT_STATUS_ACCEPT,
                  loginUserId,
                  messageObj.sessionId,
                  PsConst.CHAT_TYPE_TEXT);
              insertDataToFireBase(
                  '',
                  true,
                  messageObj.itemId,
                  messageObj.message,
                  PsConst.CHAT_STATUS_SOLD,
                  loginUserId,
                  messageObj.sessionId,
                  PsConst.CHAT_TYPE_SOLD);

              // if (widget.chatFlag == PsConst.CHAT_FROM_BUYER) {
              makeMarkAsSoldHolder = MakeMarkAsSoldParameterHolder(
                itemId: messageObj.itemId,
                buyerUserId: buyerUserId,
                sellerUserId: sellerUserId,
              );
              chatHistoryProvider.makeMarkAsSoldItem(
                  loginUserId, makeMarkAsSoldHolder);
              // } else {
              //   makeMarkAsSoldHolder = MakeMarkAsSoldParameterHolder(
              //     itemId: widget.chatObj.itemId,
              //     buyerUserId: widget.buyerUserId,
              //     sellerUserId: widget.sellerUserId,
              //   );
              //   widget.chatHistoryProvider.makeMarkAsSoldItem(
              //       widget.loginUserId, makeMarkAsSoldHolder);
              // }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                    right: PsDimens.space14,
                    bottom: PsDimens.space8,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(PsDimens.space4),
                      color: PsColors.mainColor),
                  padding: const EdgeInsets.all(PsDimens.space12),
                  child: Ink(
                    child: Text(
                      Utils.getString(context, 'chat_view__mark_as_sold'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        else
          Container()
      ],
    );
  }
}

class _AcceptedOrRejectedMessageWidget extends StatelessWidget {
  const _AcceptedOrRejectedMessageWidget({@required this.messageObj});
  final Message messageObj;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: Text(
            Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Flexible(
          child: Container(
            width: PsDimens.space140,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
                left: PsDimens.space8,
                right: PsDimens.space8,
                top: PsDimens.space16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(PsDimens.space4),
                color: messageObj.offerStatus != PsConst.CHAT_STATUS_ACCEPT
                    ? Colors.red[100]
                    : Colors.green[200]),
            padding: const EdgeInsets.all(PsDimens.space12),
            child: Column(
              children: <Widget>[
                Text(
                  messageObj.offerStatus != PsConst.CHAT_STATUS_ACCEPT
                      ? Utils.getString(
                          context, 'chat_view__reject_offer_message')
                      : Utils.getString(
                          context, 'chat_view__accept_offer_message'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: PsColors.textPrimaryColorForLight),
                ),
                const SizedBox(height: PsDimens.space12),
                Text(
                  Utils.getChatPriceFormat(messageObj.message),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: PsColors.textPrimaryColorForLight),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EditTextAndButtonWidget extends StatefulWidget {
  const EditTextAndButtonWidget({
    Key key,
    @required this.messageController,
    @required this.insertDataToFireBase,
    @required this.sessionId,
    @required this.itemData,
    @required this.psValueHolder,
    @required this.chatFlag,
    @required this.chatHistoryProvider,
    @required this.galleryProvider,
    @required this.buyerUserId,
    @required this.sellerUserId,
  }) : super(key: key);

  final TextEditingController messageController;
  final Function insertDataToFireBase;
  final String sessionId;
  final Product itemData;
  final PsValueHolder psValueHolder;
  final String chatFlag;
  final GetChatHistoryProvider chatHistoryProvider;
  final GalleryProvider galleryProvider;
  final String buyerUserId;
  final String sellerUserId;

  @override
  _EditTextAndButtonWidgetState createState() =>
      _EditTextAndButtonWidgetState();
}

File pickedImage;
List<Asset> images = <Asset>[];
Asset defaultAssetImage;

class _EditTextAndButtonWidgetState extends State<EditTextAndButtonWidget> {
  Future<bool> requestGalleryPermission() async {
    final Permission _photos = Permission.photos;
    final PermissionStatus permissionss = await _photos.request();
    // await PermissionHandler()
    //     .requestPermissions(<Permission>[Permission.photos]);
    if (permissionss != null && permissionss == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _pickImage(GalleryProvider provider) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white),
          statusBarColor: Utils.convertColorToString(PsColors.black),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
    images = resultList;
    if (mounted) {
      setState(() {});
    }

    if (images.isNotEmpty) {
      if(images[0].name.contains('.webp')){
          showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message:
                        Utils.getString(context, 'error_dialog__webp_image'),
                  );
                });
        }else{
      await PsProgressDialog.showDialog(context);
      // pr.show();
      PsResource<DefaultPhoto> _apiStatus;
      if (widget.chatFlag == PsConst.CHAT_FROM_BUYER) {
        _apiStatus = await provider.postChatImageUpload(
          widget.psValueHolder.loginUserId,
          widget.psValueHolder.loginUserId,
          widget.buyerUserId,
          widget.itemData.id,
          PsConst.CHAT_TO_BUYER,
          await Utils.getImageFileFromAssets(
              images[0],PsConfig.chatImageSize),
        );
      } else {
        _apiStatus = await provider.postChatImageUpload(
          widget.sellerUserId,
          widget.sellerUserId,
          widget.psValueHolder.loginUserId,
          widget.itemData.id,
          PsConst.CHAT_TO_SELLER,
          await Utils.getImageFileFromAssets(
              images[0],PsConfig.chatImageSize),
        );
      }

      if (_apiStatus.data != null) {
        widget.insertDataToFireBase(
            '',
            false,
            widget.itemData.id,
            _apiStatus.data.imgPath,
            PsConst.CHAT_STATUS_NULL,
            widget.psValueHolder.loginUserId,
            widget.sessionId,
            PsConst.CHAT_TYPE_IMAGE);
        PsProgressDialog.dismissDialog();
      }
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    SyncChatHistoryParameterHolder holder;
    return Consumer<GalleryProvider>(builder:
        (BuildContext context, GalleryProvider provider, Widget child) {
      return SizedBox(
        width: double.infinity,
        height: PsDimens.space72,
        child: Container(
          decoration: BoxDecoration(
            color: Utils.isLightMode(context) ? Colors.white : Colors.grey[850],
            border: Border.all(
                color: Utils.isLightMode(context)
                    ? Colors.grey[200]
                    : Colors.grey[900]),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(PsDimens.space12),
                topRight: Radius.circular(PsDimens.space12)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Utils.isLightMode(context)
                    ? Colors.grey[300]
                    : Colors.grey[900],
                blurRadius: 1.0, // has the effect of softening the shadow
                spreadRadius: 0, // has the effect of extending the shadow
                offset: const Offset(
                  0.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(PsDimens.space1),
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: PsDimens.space8,
                ),
                InkWell(
                  onTap: () async {
                    await _pickImage(provider);
                  },
                  child: Icon(
                    Octicons.device_camera,
                    color: IconTheme.of(context).color,
                    size: PsDimens.space20,
                  ),
                ),
                Expanded(
                    flex: 6,
                    child: PsTextFieldWidget(
                      hintText: Utils.getString(
                          context, 'chat_view__message_hint_text'),
                      textEditingController: widget.messageController,
                      showTitle: false,
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: PsDimens.space44,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                        left: PsDimens.space4, right: PsDimens.space4),
                    decoration: BoxDecoration(
                      color: PsColors.mainColor,
                      borderRadius: BorderRadius.circular(PsDimens.space4),
                      border: Border.all(
                          color: Utils.isLightMode(context)
                              ? Colors.grey[200]
                              : Colors.black87),
                    ),
                    child: InkWell(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: PsDimens.space20,
                        ),
                      ),
                      onTap: () {
                        // print(DateTime.now().millisecondsSinceEpoch);
                        if (widget.messageController == null ||
                            widget.messageController.text == '') {
                          return;
                        }

                        widget.insertDataToFireBase(
                            '',
                            false,
                            widget.itemData.id,
                            widget.messageController.text,
                            PsConst.CHAT_STATUS_NULL,
                            widget.psValueHolder.loginUserId,
                            widget.sessionId,
                            PsConst.CHAT_TYPE_TEXT);
                        widget.messageController.clear();
                        if (widget.chatFlag == PsConst.CHAT_FROM_BUYER) {
                          holder = SyncChatHistoryParameterHolder(
                              itemId: widget.itemData.id,
                              buyerUserId: widget.buyerUserId,
                              sellerUserId: widget.sellerUserId,
                              type: PsConst.CHAT_FROM_SELLER);
                          widget.chatHistoryProvider
                              .postChatHistory(holder.toMap());
                        } else {
                          holder = SyncChatHistoryParameterHolder(
                              itemId: widget.itemData.id,
                              sellerUserId: widget.sellerUserId,
                              buyerUserId: widget.buyerUserId,
                              type: PsConst.CHAT_FROM_BUYER);
                          widget.chatHistoryProvider
                              .postChatHistory(holder.toMap());
                        }
                      },
                    ),

                    // onTap: () {
                    //   // print(DateTime.now().millisecondsSinceEpoch);

                    //   widget.insertDataToFireBase(
                    //       '',
                    //       false,
                    //       widget.itemData.id,
                    //       widget.messageController.text,
                    //       PsConst.CHAT_STATUS_NULL,
                    //       widget.psValueHolder.loginUserId,
                    //       widget.sessionId,
                    //       PsConst.CHAT_TYPE_TEXT);
                    //   widget.messageController.clear();
                    //   if (widget.chatFlag == PsConst.CHAT_FROM_BUYER) {
                    //     holder = SyncChatHistoryParameterHolder(
                    //         itemId: widget.itemData.id,
                    //         buyerUserId: widget.buyerUserId,
                    //         sellerUserId: widget.sellerUserId,
                    //         type: PsConst.CHAT_FROM_SELLER);
                    //     widget.chatHistoryProvider
                    //         .postChatHistory(holder.toMap());
                    //   } else {
                    //     holder = SyncChatHistoryParameterHolder(
                    //         itemId: widget.itemData.id,
                    //         sellerUserId: widget.sellerUserId,
                    //         buyerUserId: widget.buyerUserId,
                    //         type: PsConst.CHAT_FROM_BUYER);
                    //     widget.chatHistoryProvider
                    //         .postChatHistory(holder.toMap());
                    //   }
                    // },
                  ),
                ),
                const SizedBox(
                  width: PsDimens.space4,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ItemInfoWidget extends StatefulWidget {
  const ItemInfoWidget({
    Key key,
    @required this.insertDataToFireBase,
    @required this.sessionId,
    @required this.itemData,
    @required this.sendByUserId,
    @required this.chatFlag,
    @required this.chatHistoryProvider,
    @required this.buyerUserId,
    @required this.sellerUserId,
    @required this.isOffer,
  }) : super(key: key);

  final Function insertDataToFireBase;
  final String sessionId;
  final Product itemData;
  final String sendByUserId;
  final String chatFlag;
  final GetChatHistoryProvider chatHistoryProvider;
  final String buyerUserId;
  final String sellerUserId;
  final String isOffer;

  @override
  _ItemInfoWidgetState createState() => _ItemInfoWidgetState();
}

class _ItemInfoWidgetState extends State<ItemInfoWidget> {
  // String _isOffer;

  @override
  void initState() {
   Utils.isReachChatView = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PsResource<ChatHistory> _apiStatus;
    MakeOfferParameterHolder holder;

    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );

    final Widget _imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: widget.itemData.defaultPhoto,
      width: 50,
      height: 50,
      boxfit: BoxFit.cover,
      onTap: () {
        // Navigator.pushNamed(context, RoutePaths.userDetail, arguments: data);
      },
    );

     return GestureDetector(
      onTap: () {
        final ProductDetailIntentHolder holder = ProductDetailIntentHolder(
            productId: widget.itemData.id,
            heroTagImage: widget.chatHistoryProvider.hashCode.toString() +
                widget.itemData.id +
                PsConst.HERO_TAG__IMAGE,
            heroTagTitle: widget.chatHistoryProvider.hashCode.toString() +
                widget.itemData.id +
                PsConst.HERO_TAG__TITLE);
        Navigator.pushNamed(context, RoutePaths.productDetail,
            arguments: holder);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PsDimens.space4),
            color:
                Utils.isLightMode(context) ? Colors.white70 : Colors.black12),
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _imageWidget,
            const SizedBox(
              width: PsDimens.space12,
            ),
    
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      widget.itemData.title,
                      style: Theme.of(context).textTheme.subtitle1),
                  _spacingWidget,
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.itemData.price != ''
                              ? '${widget.itemData.itemCurrency.currencySymbol} ${Utils.getPriceFormat(widget.itemData.price)} ( ${widget.itemData.conditionOfItem.name} )'
                              : '',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(width: PsDimens.space8),
                        if (widget.chatFlag == PsConst.CHAT_FROM_BUYER &&
                            widget.itemData.isSoldOut == '1')
                          Container(
                            width: PsDimens.space44,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(PsDimens.space8),
                                color: PsColors.mainColor),
                            padding: const EdgeInsets.all(PsDimens.space2),
                            child: Text(
                              Utils.getString(context, 'chat_view__sold'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: Colors.white),
                            ),
                          )
                        else if (widget.chatFlag == PsConst.CHAT_FROM_SELLER &&
                            widget.itemData.isSoldOut == '1')
                          Container(
                            width: PsDimens.space44,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(PsDimens.space8),
                                color: PsColors.mainColor),
                            padding: const EdgeInsets.all(PsDimens.space2),
                            child: Text(
                              Utils.getString(context, 'chat_view__sold'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: Colors.white),
                            ),
                          )
                        else
                          Container(
                            width: PsDimens.space44,
                            height: PsDimens.space12,
                          )
                      ])
                ],
              ),
            ),
            Consumer<GetChatHistoryProvider>(builder: (BuildContext context,
                GetChatHistoryProvider getChatHistoryProvider, Widget child) {
              if (getChatHistoryProvider.chatHistory == null ||
                  getChatHistoryProvider.chatHistory.data == null) {
                return Container();
              }
              bool _showOffer = true;
              if (getChatHistoryProvider.chatHistory.data.id != '') {
                if (getChatHistoryProvider.chatHistory.data.isOffer == '1') {
                  _showOffer = false;
                }
              }
              return InkWell(
                  onTap: () {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ChatMakeOfferDialog(
                            itemDetail: widget.itemData,
                            onMakeOfferTap: (String price) async {
                              await PsProgressDialog.showDialog(context);

                              if (widget.chatFlag == PsConst.CHAT_FROM_BUYER) {
                                holder = MakeOfferParameterHolder(
                                    itemId: widget.itemData.id,
                                    buyerUserId: widget.buyerUserId == ''
                                        ? widget.sendByUserId
                                        : widget.buyerUserId,
                                    sellerUserId: widget.sellerUserId == ''
                                        ? widget.itemData.user.userId
                                        : widget.sellerUserId,
                                    type: PsConst.CHAT_TO_BUYER,
                                    negoPrice: price);

                                _apiStatus = await widget.chatHistoryProvider
                                    .postRejectedOffer(
                                        holder.toMap(), widget.sendByUserId);

                                if (_apiStatus.data != null) {
                                  setState(() {
                                  // _isOffer = _apiStatus.data.isOffer;
                                  });
                                }
                              } else {
                                holder = MakeOfferParameterHolder(
                                    itemId: widget.itemData.id,
                                    sellerUserId: widget.sellerUserId == ''
                                        ? widget.itemData.user.userId
                                        : widget.sellerUserId,
                                    buyerUserId: widget.buyerUserId == ''
                                        ? widget.sendByUserId
                                        : widget.buyerUserId,
                                    type: PsConst.CHAT_TO_SELLER,
                                    negoPrice: price);
                                _apiStatus = await widget.chatHistoryProvider
                                    .postRejectedOffer(
                                        holder.toMap(), widget.sendByUserId);

                                if (_apiStatus.data != null) {
                                  setState(() {
                                  // _isOffer = _apiStatus.data.isOffer;
                                  });
                                }
                              }

                              final String makeOfferMessae =
                                  '${widget.itemData.itemCurrency.currencySymbol} $price';
                              widget.insertDataToFireBase(
                                  '',
                                  false,
                                  widget.itemData.id,
                                  makeOfferMessae,
                                  PsConst.CHAT_STATUS_OFFER,
                                  widget.sendByUserId,
                                  widget.sessionId,
                                  PsConst.CHAT_TYPE_OFFER);

                              PsProgressDialog.dismissDialog();
                            },
                          );
                        });
                  },
                  child: widget.chatFlag != PsConst.CHAT_FROM_BUYER &&
                          widget.itemData.isSoldOut == PsConst.ZERO &&
                          _showOffer
                      ? Container(
                          width: PsDimens.space72,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: PsColors.mainColor,
                            borderRadius:
                                BorderRadius.circular(PsDimens.space4),
                            border: Border.all(
                                color: Utils.isLightMode(context)
                                    ? Colors.grey[200]
                                    : Colors.black87),
                          ),
                          child: Ink(
                            color: PsColors.backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(PsDimens.space8),
                              child: Text(
                                Utils.getString(context,
                                    'chat_view__make_offer_button_name'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : Container());
            })
          ],
        ),
      ),
    );
  }
}

class _ChatMakeOfferSenderBoxWidget extends StatelessWidget {
  const _ChatMakeOfferSenderBoxWidget({@required this.messageObj});
  final Message messageObj;
  @override
  Widget build(BuildContext context) {
    print(
        '******Make Offer time ${Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp)}');
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          child: Text(
            Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PsDimens.space4),
              color: Colors.yellow[200]),
          padding: const EdgeInsets.all(PsDimens.space12),
          child: Column(
            children: <Widget>[
              Text(
                Utils.getString(context, 'chat_view__make_offer_message'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: PsColors.textPrimaryColorForLight),
              ),
              const SizedBox(height: PsDimens.space12),
              Text(
                Utils.getChatPriceFormat(messageObj.message),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: PsColors.textPrimaryColorForLight),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// class _ChatMakeOfferReceiverBoxWidget extends StatelessWidget {
//   const _ChatMakeOfferReceiverBoxWidget({@required this.messageObj});
//   final Message messageObj;
//   @override
//   Widget build(BuildContext context) {
//     print(
//         '******Make Offer time ${Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp)}');
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: <Widget>[
//         Container(
//           alignment: Alignment.center,
//           margin: const EdgeInsets.only(
//               left: PsDimens.space8,
//               right: PsDimens.space8,
//               top: PsDimens.space16),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(PsDimens.space4),
//               color: Colors.yellow[200]),
//           padding: const EdgeInsets.all(PsDimens.space12),
//           child: Column(
//             children: <Widget>[
//               Text(
//                 Utils.getString(context, 'chat_view__make_offer_message'),
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context)
//                     .textTheme
//                     .subtitle1
//                     .copyWith(color: PsColors.textPrimaryColorForLight),
//               ),
//               const SizedBox(height: PsDimens.space12),
//               Text(
//                 messageObj.message,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context)
//                     .textTheme
//                     .title
//                     .copyWith(color: PsColors.textPrimaryColorForLight),
//               ),
//             ],
//           ),
//         ),
//         Text(
//           Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
//           style: Theme.of(context).textTheme.caption,
//         ),
//       ],
//     );
//   }
// }

class _ChatAcceptedOrRejectedOfferReceiverBoxWidget extends StatelessWidget {
  const _ChatAcceptedOrRejectedOfferReceiverBoxWidget({
    @required this.messageObj,
  });
  final Message messageObj;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PsDimens.space4),
              color: messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT
                  ? Colors.lightGreen[100]
                  : Colors.red[100]),
          padding: const EdgeInsets.all(PsDimens.space12),
          child: Column(
            children: <Widget>[
              Text(
                messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT
                    ? Utils.getString(
                        context, 'chat_view__accept_offer_message')
                    : Utils.getString(
                        context, 'chat_view__reject_offer_message'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: PsColors.textPrimaryColorForLight),
              ),
              const SizedBox(height: PsDimens.space12),
              Text(
                Utils.getChatPriceFormat(messageObj.message),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: PsColors.textPrimaryColorForLight),
              ),
            ],
          ),
        ),
        Text(
          Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}

class _ChatAcceptedOrRejectedOfferSenderBoxWidget extends StatelessWidget {
  const _ChatAcceptedOrRejectedOfferSenderBoxWidget({
    @required this.messageObj,
  });
  final Message messageObj;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
          style: Theme.of(context).textTheme.caption,
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PsDimens.space4),
              color: messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT
                  ? Colors.green[200]
                  : Colors.red[100]),
          padding: const EdgeInsets.all(PsDimens.space12),
          child: Column(
            children: <Widget>[
              Text(
                messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT
                    ? Utils.getString(
                        context, 'chat_view__accept_offer_message')
                    : Utils.getString(
                        context, 'chat_view__reject_offer_message'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: PsColors.textPrimaryColorForLight),
              ),
              const SizedBox(height: PsDimens.space12),
              Text(
                Utils.getChatPriceFormat(messageObj.message),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: PsColors.textPrimaryColorForLight),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
