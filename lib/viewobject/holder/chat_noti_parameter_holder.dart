import 'package:flutteradmotors/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class ChatNotiParameterHolder extends PsHolder<ChatNotiParameterHolder> {
  ChatNotiParameterHolder(
      {@required this.itemId,
      @required this.buyerUserId,
      @required this.sellerUserId,
      @required this.message,
      @required this.type});

  final String itemId;
  final String buyerUserId;
  final String sellerUserId;
  final String message;
  final String type;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['item_id'] = itemId;
    map['buyer_user_id'] = buyerUserId;
    map['seller_user_id'] = sellerUserId;
    map['message'] = message;
    map['type'] = type;

    return map;
  }

  @override
  ChatNotiParameterHolder fromMap(dynamic dynamicData) {
    return ChatNotiParameterHolder(
      itemId: dynamicData['item_id'],
      buyerUserId: dynamicData['buyer_user_id'],
      sellerUserId: dynamicData['seller_user_id'],
      message: dynamicData['message'],
      type: dynamicData['type'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (itemId != '') {
      key += itemId;
    }
    if (buyerUserId != '') {
      key += buyerUserId;
    }

    if (sellerUserId != '') {
      key += sellerUserId;
    }
    if (message != '') {
      key += message;
    }
    if (type != '') {
      key += type;
    }
    return key;
  }
}
