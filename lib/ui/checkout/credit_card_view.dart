import 'dart:io';

import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/basket/basket_provider.dart';
import 'package:digitalproductstore/provider/transaction/transaction_header_provider.dart';
import 'package:digitalproductstore/provider/user/user_login_provider.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/loading_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:digitalproductstore/ui/common/ps_credit_card_form.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:digitalproductstore/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';

class CreditCardView extends StatefulWidget {
  const CreditCardView(
      {Key key,
      @required this.productList,
      @required this.couponDiscount,
      @required this.psValueHolder,
      @required this.transactionSubmitProvider,
      @required this.userLoginProvider,
      @required this.basketProvider,
      @required this.name,
      @required this.iconData})
      : super(key: key);

  final List<Product> productList;
  final String couponDiscount;
  final PsValueHolder psValueHolder;
  final TransactionHeaderProvider transactionSubmitProvider;
  final UserLoginProvider userLoginProvider;
  final BasketProvider basketProvider;
  final String name;
  final IconData iconData;
  @override
  State<StatefulWidget> createState() {
    return CreditCardViewState();
  }
}

dynamic callTransactionSubmitApi(
    BuildContext context,
    BasketProvider basketProvider,
    UserLoginProvider userLoginProvider,
    TransactionHeaderProvider transactionSubmitProvider,
    List<Product> productList,
    ProgressDialog progressDialog,
    String token,
    String couponDiscount) async {
  if (userLoginProvider.userLogin != null &&
      userLoginProvider.userLogin.data != null) {
    final PsResource<TransactionHeader> _apiStatus =
        await transactionSubmitProvider.postTransactionSubmit(
            userLoginProvider.userLogin.data.user.userName,
            userLoginProvider.userLogin.data.user.userPhone,
            productList,
            Platform.isIOS ? token : token,
            couponDiscount.toString(),
            basketProvider.checkoutCalculationHelper.taxFormattedString,
            basketProvider
                .checkoutCalculationHelper.totalDiscountFormattedString,
            basketProvider
                .checkoutCalculationHelper.subTotalPriceFormattedString,
            basketProvider.checkoutCalculationHelper.totalPriceFormattedString,
            basketProvider
                .checkoutCalculationHelper.totalOriginalPriceFormattedString,
            ZERO,
            ONE,
            ZERO);

    if (_apiStatus.data != null) {
      progressDialog.dismiss();

      if (_apiStatus.status == PsStatus.SUCCESS) {
        await basketProvider.deleteWholeBasketList();

        await Navigator.pushNamed(
          context,
          RoutePaths.checkoutSuccess,
        );
        Navigator.pop(context, true);
      } else {
        progressDialog.dismiss();

        return showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: _apiStatus.message,
              );
            });
      }
    } else {
      progressDialog.dismiss();

      return showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: _apiStatus.message,
            );
          });
    }
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    dynamic stripeNow(String token) async {
      // final BasketProvider basketProvider =
      //     Provider.of<BasketProvider>(context);

      widget.basketProvider.checkoutCalculationHelper.calculate(
          productList: widget.productList,
          couponDiscountString: widget.couponDiscount,
          psValueHolder: widget.psValueHolder);

      final ProgressDialog progressDialog = loadingDialog(
        context,
      );

      progressDialog.show();

      callTransactionSubmitApi(
          context,
          widget.basketProvider,
          widget.userLoginProvider,
          widget.transactionSubmitProvider,
          widget.productList,
          progressDialog,
          token,
          widget.couponDiscount);
    }

    return PsWidgetWithAppBarWithNoProvider(
      appBarTitle: widget.name,
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
                  // cardBgColor: Colors.black,
                  height: 175,
                  width: MediaQuery.of(context).size.width,
                  animationDuration: animation_duration,
                ),
                PsCreditCardForm(
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: ps_space_32, right: ps_space_32),
                  child: MaterialButton(
                      color: ps_ctheme__color_speical,
                      minWidth: double.infinity,
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
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
                              Utils.getString(context,
                                  'warning_dialog__input_holder_name'));
                        } else if (cvvCode.isEmpty) {
                          callWarningDialog(
                              context,
                              Utils.getString(
                                  context, 'warning_dialog__input_cvv'));
                        } else {
                          StripePayment.createTokenWithCard(
                            callCard(cardNumber, expiryDate, cardHolderName,
                                cvvCode),
                          ).then((Token token) async {
                            print(token.tokenId);
                            await stripeNow(token.tokenId);
                          }).catchError(setError);
                        }
                      },
                      child: Text(
                        Utils.getString(context, 'credit_card__pay'),
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.white),
                      )),
                ),
                const SizedBox(height: ps_space_40)
              ],
            )),
          ),
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
