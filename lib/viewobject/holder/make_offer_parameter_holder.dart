import 'package:flutteradmotors/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class MakeOfferParameterHolder extends PsHolder<MakeOfferParameterHolder> {
  MakeOfferParameterHolder({
    @required this.itemId,
    @required this.buyerUserId,
    @required this.sellerUserId,
    @required this.negoPrice,
    @required this.type,
  });

  final String itemId;
  final String buyerUserId;
  final String sellerUserId;
  final String negoPrice;
  final String type;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['item_id'] = itemId;
    map['buyer_user_id'] = buyerUserId;
    map['seller_user_id'] = sellerUserId;
    map['nego_price'] = negoPrice;
    map['type'] = type;
    return map;
  }

  @override
  MakeOfferParameterHolder fromMap(dynamic dynamicData) {
    return MakeOfferParameterHolder(
      itemId: dynamicData['item_id'],
      buyerUserId: dynamicData['buyer_user_id'],
      sellerUserId: dynamicData['seller_user_id'],
      negoPrice: dynamicData['nego_price'],
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
    if (negoPrice != '') {
      key += negoPrice;
    }
    if (type != '') {
      key += type;
    }

    return key;
  }
}
