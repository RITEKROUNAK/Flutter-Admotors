import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/chat/chat_history_list_provider.dart';
import 'package:flutteradmotors/repository/chat_history_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/ui/chat/item/chat_buyer_list_item.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/chat_history_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:provider/provider.dart';

class ChatBuyerListView extends StatefulWidget {
  const ChatBuyerListView({
    Key key,
    @required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;
  @override
  _ChatBuyerListViewState createState() => _ChatBuyerListViewState();
}

class _ChatBuyerListViewState extends State<ChatBuyerListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  ChatHistoryListProvider _chatHistoryListProvider;

  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        holder.getBuyerHistoryList().userId = psValueHolder.loginUserId;
        _chatHistoryListProvider.nextChatHistoryList(holder);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  ChatHistoryRepository chatHistoryRepository;
  ChatHistoryListProvider chattingBuyerProvider;
  PsValueHolder psValueHolder;
  ChatHistoryParameterHolder holder;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);
    holder = ChatHistoryParameterHolder().getBuyerHistoryList();
    holder.getBuyerHistoryList().userId = psValueHolder.loginUserId;

    chatHistoryRepository = Provider.of<ChatHistoryRepository>(context);

    return ChangeNotifierProvider<ChatHistoryListProvider>(
      lazy: false,
      create: (BuildContext context) {
        final ChatHistoryListProvider provider =
            ChatHistoryListProvider(repo: chatHistoryRepository);
        provider.loadChatHistoryList(holder);
        return provider;
      },
      child: Consumer<ChatHistoryListProvider>(builder: (BuildContext context,
          ChatHistoryListProvider provider, Widget child) {
        if (provider.chatHistoryList != null &&
            provider.chatHistoryList.data != null &&
            provider.chatHistoryList.data.isNotEmpty &&
            psValueHolder.loginUserId != null) {
          return Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: RefreshIndicator(
                          child: MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: provider.chatHistoryList.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final int count =
                                    provider.chatHistoryList.data.length;
                                widget.animationController.forward();
                                return ChatBuyerListItem(
                                  animationController: widget.animationController,
                                  animation:
                                      Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: widget.animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  chatHistory:
                                      provider.chatHistoryList.data[index],
                                  onTap: () async {
                                    print(provider
                                        .chatHistoryList.data[index].item.title);
                                    final dynamic returnData =
                                        await Navigator.pushNamed(
                                      context,
                                      RoutePaths.chatView,
                                      arguments: ChatHistoryIntentHolder(
                                          chatFlag: PsConst.CHAT_FROM_BUYER,
                                          itemId: provider.chatHistoryList
                                              .data[index].item.id,
                                          buyerUserId: provider.chatHistoryList
                                              .data[index].buyerUserId,
                                          sellerUserId: provider.chatHistoryList
                                              .data[index].sellerUserId),
                                    );
                                    if (returnData == null) {
                                      provider.loadChatHistoryListFromDB(holder);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          onRefresh: () {
                            return provider.resetChatHistoryList(holder);
                          },
                        ),
                      ),
                      PSProgressIndicator(provider.chatHistoryList.status)
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          widget.animationController.forward();
          return Container();
        }
      }),
      // )
    );
  }
}
