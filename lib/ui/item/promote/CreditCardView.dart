import 'dart:io';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/provider/promotion/item_promotion_provider.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:flutteradmotors/ui/common/dialog/error_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/success_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradmotors/ui/common/ps_button_widget.dart';
import 'package:flutteradmotors/ui/common/ps_credit_card_form.dart';
import 'package:flutteradmotors/utils/ps_progress_dialog.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/holder/item_paid_history_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/item_paid_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:stripe_payment/stripe_payment.dart';

class CreditCardView extends StatefulWidget {
  const CreditCardView(
      {Key key,
      @required this.product,
      @required this.amount,
      @required this.howManyDay,
      @required this.paymentMethod,
      @required this.stripePublishableKey,
      @required this.startDate,
      @required this.startTimeStamp,
      @required this.itemPaidHistoryProvider})
      : super(key: key);

  final Product product;
  final String amount;
  final String howManyDay;
  final String paymentMethod;
  final String stripePublishableKey;
  final String startDate;
  final String startTimeStamp;
  final ItemPromotionProvider itemPaidHistoryProvider;

  @override
  State<StatefulWidget> createState() {
    return CreditCardViewState();
  }
}

dynamic callPaidAdSubmitApi(
  BuildContext context,
  Product product,
  String amount,
  String howManyDay,
  String paymentMethod,
  String stripePublishableKey,
  String startDate,
  String startTimeStamp,
  ItemPromotionProvider itemPaidHistoryProvider,
  // ProgressDialog progressDialog,
  String token,
) async {
  if (await Utils.checkInternetConnectivity()) {
    final ItemPaidHistoryParameterHolder itemPaidHistoryParameterHolder =
        ItemPaidHistoryParameterHolder(
            itemId: product.id,
            amount: amount,
            howManyDay: howManyDay,
            paymentMethod: paymentMethod,
            paymentMethodNounce: Platform.isIOS ? token : token,
            startDate: startDate,
            startTimeStamp: startTimeStamp,
            razorId: '',
            isPaystack: PsConst.ZERO);

    final PsResource<ItemPaidHistory> padiHistoryDataStatus =
        await itemPaidHistoryProvider
            .postItemHistoryEntry(itemPaidHistoryParameterHolder.toMap());

    if (padiHistoryDataStatus.data != null) {
      // progressDialog.dismiss();
      PsProgressDialog.dismissDialog();
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext contet) {
            return SuccessDialog(
              message: Utils.getString(context, 'item_promote__success'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            );
          });
    } else {
      PsProgressDialog.dismissDialog();
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: padiHistoryDataStatus.message,
            );
          });
    }
  } else {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: Utils.getString(context, 'error_dialog__no_internet'),
          );
        });
  }
}

CreditCard callCard(String cardNumber, String expiryDate, String cardHolderName,
    String cvvCode) {
  final List<String> monthAndYear = expiryDate.split('/');
  return CreditCard(
      number: cardNumber,
      expMonth: int.parse(monthAndYear[0]),
      expYear: int.parse(monthAndYear[1]),
      name: cardHolderName,
      cvc: cvvCode);
}

class CreditCardViewState extends State<CreditCardView> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  void initState() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: widget.stripePublishableKey,
        merchantId: 'Test',
        androidPayMode: 'test'));
    super.initState();
  }

  void setError(dynamic error) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: Utils.getString(context, error.toString()),
          );
        });
  }

  dynamic callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: Utils.getString(context, text),
            onPressed: (){}
            );
        });
  }

  @override
  Widget build(BuildContext context) {
    dynamic stripeNow(String token) async {
      // if (widget.psValueHolder.standardShippingEnable == PsConst.ONE) {
      //   widget.basketProvider.checkoutCalculationHelper.calculate(
      //       basketList: widget.basketList,
      //       couponDiscountString: widget.couponDiscount,
      //       psValueHolder: widget.psValueHolder,
      //       shippingPriceStringFormatting:
      //           widget.shippingMethodProvider.selectedPrice == '0.0'
      //               ? widget.shippingMethodProvider.defaultShippingPrice
      //               : widget.shippingMethodProvider.selectedPrice ?? '0.0');
      // }
      // final ProgressDialog progressDialog = loadingDialog(
      //   context,
      // );

      // progressDialog.show();
      await PsProgressDialog.showDialog(context);
      callPaidAdSubmitApi(
        context,
        widget.product,
        widget.amount,
        widget.howManyDay,
        widget.paymentMethod,
        widget.stripePublishableKey,
        widget.startDate,
        widget.startTimeStamp,
        widget.itemPaidHistoryProvider,
        // progressDialog,
        token,
      );
    }

    return PsWidgetWithAppBarWithNoProvider(
      appBarTitle: 'Credit Card',
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  height: 175,
                  width: MediaQuery.of(context).size.width,
                  animationDuration: PsConfig.animation_duration,
                ),
                PsCreditCardForm(
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space12, right: PsDimens.space12),
                  child: PSButtonWidget(
                    hasShadow: true,
                    width: double.infinity,
                    titleText: Utils.getString(context, 'credit_card__pay'),
                    onPressed: () async {
                      if (cardNumber.isEmpty) {
                        callWarningDialog(
                            context,
                            Utils.getString(
                                context, 'warning_dialog__input_number'));
                      } else if (expiryDate.isEmpty) {
                        callWarningDialog(
                            context,
                            Utils.getString(
                                context, 'warning_dialog__input_date'));
                      } else if (cardHolderName.isEmpty) {
                        callWarningDialog(
                            context,
                            Utils.getString(
                                context, 'warning_dialog__input_holder_name'));
                      } else if (cvvCode.isEmpty) {
                        callWarningDialog(
                            context,
                            Utils.getString(
                                context, 'warning_dialog__input_cvv'));
                      } else {
                        StripePayment.createTokenWithCard(
                          callCard(
                              cardNumber, expiryDate, cardHolderName, cvvCode),
                        ).then((Token token) async {
                          await stripeNow(token.tokenId);
                        }).catchError(setError);
                      }
                    },
                  ),
                ),
                const SizedBox(height: PsDimens.space40)
              ],
            )),
          ),
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    if (mounted) {
      setState(() {
        cardNumber = creditCardModel.cardNumber;
        expiryDate = creditCardModel.expiryDate;
        cardHolderName = creditCardModel.cardHolderName;
        cvvCode = creditCardModel.cvvCode;
        isCvvFocused = creditCardModel.isCvvFocused;
      });
    }
  }
}
