import 'dart:io';

import 'package:braintree_payment/braintree_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/api/ps_api_service.dart';
import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/provider/basket/basket_provider.dart';
import 'package:digitalproductstore/provider/coupon_discount/coupon_discount_provider.dart';
import 'package:digitalproductstore/provider/token/token_provider.dart';
import 'package:digitalproductstore/provider/transaction/transaction_header_provider.dart';
import 'package:digitalproductstore/provider/user/user_login_provider.dart';
import 'package:digitalproductstore/repository/basket_repository.dart';
import 'package:digitalproductstore/repository/coupon_discount_repository.dart';
import 'package:digitalproductstore/repository/transaction_header_repository.dart';
import 'package:digitalproductstore/repository/user_repository.dart';
import 'package:digitalproductstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:digitalproductstore/ui/common/ps_textfield_widget.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/loading_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/success_dialog.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/coupon_discount.dart';
import 'package:digitalproductstore/viewobject/holder/coupon_discount_holder.dart';
import 'package:digitalproductstore/viewobject/holder/intent_holder/credit_card_intent_holder.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:digitalproductstore/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({
    Key key,
    @required this.productList,
    @required this.publishKey,
    @required this.cartList,
  }) : super(key: key);
  final List<DocumentSnapshot> cartList;

  final List<Product> productList;
  final String publishKey;
  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

class _CheckoutViewState extends State<CheckoutView> {
  final TextEditingController couponController =
      TextEditingController();
  CouponDiscountRepository couponDiscountRepo;
  TransactionHeaderRepository transactionHeaderRepo;
  BasketRepository basketRepository;
  UserRepository userRepository;

  PsValueHolder valueHolder;
  // String couponDiscount;

  @override
  void initState() {
    // StripePayment.setOptions(StripeOptions(
    //     publishableKey: widget.publishKey,
    //     merchantId: 'Test',
    //     androidPayMode: 'test'));

    super.initState();
  }

  @override
  void dispose() {
    // StripePayment.false.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cartList.isNotEmpty) {
      const Widget spacingWidget = SizedBox(
        height: ps_space_10,
      );

      List<String> promocode = [];
      List<String> promoprice = [];
      String promocodePrice;
      int length = 0;
      for (int i = 0; i < widget.cartList.length; i++) {
        promocode.add(widget.cartList[i]['Promocode']);
      }
      // for (int i = 0; i < widget.cartList.length; i++) {
      //   promoprice.add(widget.cartList[i]['PromoPrice']);
      // }
      promocodeValidator(prmo) {
        for (var i = 0; i < promocode.length; i++) {
          if (promocode[i].contains(prmo)) {
            length = i;

            setState(() {
              promocodePrice = widget.cartList[i]['PromoPrice'];
              print('validate');
              print(promocodePrice);
            });

            return true;
          }
          //  else if (promocode[i] == '') {
          //   print('error');
          //   return false;
          // }
        }
      }

      // print(promocodeValidator('12345'));

      couponDiscountRepo =
          Provider.of<CouponDiscountRepository>(context);
      transactionHeaderRepo =
          Provider.of<TransactionHeaderRepository>(context);
      basketRepository = Provider.of<BasketRepository>(context);
      valueHolder = Provider.of<PsValueHolder>(context);
      userRepository = Provider.of<UserRepository>(context);

      return MultiProvider(
          providers: <SingleChildCloneableWidget>[
            ChangeNotifierProvider<CouponDiscountProvider>(
                create: (BuildContext context) {
              final CouponDiscountProvider provider =
                  CouponDiscountProvider(repo: couponDiscountRepo);

              return provider;
            }),
            ChangeNotifierProvider<BasketProvider>(
                create: (BuildContext context) {
              final BasketProvider provider =
                  BasketProvider(repo: basketRepository);

              return provider;
            }),
            ChangeNotifierProvider<UserLoginProvider>(
                create: (BuildContext context) {
              final UserLoginProvider provider = UserLoginProvider(
                  repo: userRepository, psValueHolder: valueHolder);
              provider
                  .getUserLogin(provider.psValueHolder.loginUserId);
              return provider;
            }),
            ChangeNotifierProvider<TransactionHeaderProvider>(
                create: (BuildContext context) {
              final TransactionHeaderProvider provider =
                  TransactionHeaderProvider(
                      repo: transactionHeaderRepo,
                      psValueHolder: valueHolder);

              return provider;
            }),
          ],
          child: Consumer<CouponDiscountProvider>(builder:
              (BuildContext context, CouponDiscountProvider provider,
                  Widget child) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                brightness: Utils.getBrightnessForAppBar(context),
                iconTheme: Theme.of(context).iconTheme.copyWith(
                    color: Utils.isLightMode(context)
                        ? ps_ctheme__color_speical
                        : Colors.white),
                title: Text(
                  Utils.getString(context, 'checkout__app_bar_name'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(
                          fontWeight: FontWeight.bold,
                          color: Utils.isLightMode(context)
                              ? ps_ctheme__color_speical
                              : Colors.white),
                ),
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                          top: ps_space_10,
                          left: ps_space_10,
                          right: ps_space_10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              Utils.getString(context,
                                  'checkout__coupon_discount'),
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(),
                            ),
                            spacingWidget,
                            const Divider(
                              height: ps_space_1,
                            ),
                            spacingWidget,
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    child: PsTextFieldWidget(
                                  hintText: Utils.getString(context,
                                      'checkout__coupon_code'),
                                  textEditingController:
                                      couponController,
                                  showTitle: false,
                                )),
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: ps_space_8),
                                  child: RaisedButton(
                                    color: ps_ctheme__color_speical,
                                    shape:
                                        const BeveledRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                            MaterialCommunityIcons
                                                .ticket_percent,
                                            color: Colors.white),
                                        const SizedBox(
                                          width: ps_space_4,
                                        ),
                                        Text(
                                          Utils.getString(context,
                                              'checkout__claim_button_name'),
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                                  color:
                                                      Colors.white),
                                        ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      if (couponController
                                          .text.isNotEmpty) {
                                        if (widget.cartList != null) {
                                          final result =
                                              promocodeValidator(
                                                  couponController
                                                      .text);
                                          print(result);
                                          setState(() {
                                            print(promocodePrice);
                                          });

                                          print(length);
                                          if (result == true) {
                                            showDialog<dynamic>(
                                                context: context,
                                                builder: (BuildContext
                                                    context) {
                                                  return SuccessDialog(
                                                    message: Utils
                                                        .getString(
                                                            context,
                                                            'checkout__couponcode_add_dialog_message'),
                                                  );
                                                });
                                          }

                                          // couponController.clear();
                                        } else {
                                          showDialog<dynamic>(
                                              context: context,
                                              builder: (BuildContext
                                                  context) {
                                                return ErrorDialog(
                                                  message:
                                                      '_apiStatus',
                                                );
                                              });
                                        }
                                      } else {
                                        showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext
                                                context) {
                                              return WarningDialog(
                                                message: Utils.getString(
                                                    context,
                                                    'checkout__warning_dialog_message'),
                                              );
                                            });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            spacingWidget,
                            Text(
                              Utils.getString(
                                  context, 'checkout__description'),
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _OrderSummaryWidget(
                      cartList: widget.cartList,
                      psValueHolder: valueHolder,
                      productList: widget.productList,
                      couponDiscount: promocodePrice ?? '-',
                    ),
                    Consumer<TransactionHeaderProvider>(builder:
                        (BuildContext context,
                            TransactionHeaderProvider provider,
                            Widget child) {
                      return Consumer<BasketProvider>(builder:
                          (BuildContext context,
                              BasketProvider basketProvider,
                              Widget child) {
                        return Consumer<UserLoginProvider>(builder:
                            (BuildContext context,
                                UserLoginProvider userLoginProvider,
                                Widget child) {
                          return Column(
                            children: <Widget>[
                              if (userLoginProvider
                                      .psValueHolder.paypalEnabled ==
                                  ONE)
                                Pay(
                                    productList: widget.productList,
                                    couponDiscount:
                                        'couponDiscount' ?? '0.0',
                                    transactionSubmitProvider:
                                        provider,
                                    userLoginProvider:
                                        userLoginProvider,
                                    basketProvider: basketProvider,
                                    psValueHolder: valueHolder)
                              else
                                Container(),
                              if (userLoginProvider
                                      .psValueHolder.stripeEnabled ==
                                  ONE)
                                Stripe(
                                    productList: widget.productList,
                                    couponDiscount:
                                        'couponDiscount' ?? '0.0',
                                    transactionSubmitProvider:
                                        provider,
                                    userLoginProvider:
                                        userLoginProvider,
                                    basketProvider: basketProvider,
                                    psValueHolder: valueHolder,
                                    name: Utils.getString(context,
                                        'checkout__master_button_name'),
                                    iconData:
                                        FontAwesome.cc_mastercard)
                              else
                                Container(),
                              if (userLoginProvider
                                      .psValueHolder.stripeEnabled ==
                                  ONE)
                                Stripe(
                                    productList: widget.productList,
                                    couponDiscount:
                                        'couponDiscount' ?? '0.0',
                                    transactionSubmitProvider:
                                        provider,
                                    userLoginProvider:
                                        userLoginProvider,
                                    basketProvider: basketProvider,
                                    psValueHolder: valueHolder,
                                    name: Utils.getString(context,
                                        'checkout__visa_button_name'),
                                    iconData: FontAwesome.cc_visa)
                              else
                                Container(),
                            ],
                          );
                        });
                      });
                    }),
                    const SizedBox(
                      height: ps_space_20,
                    )
                  ],
                ),
              ),
            );
          }));
    } else {
      return Scaffold(
          appBar: AppBar(
            brightness: Utils.getBrightnessForAppBar(context),
            iconTheme: const IconThemeData(),
            automaticallyImplyLeading: true,
            title: Text(
              Utils.getString(context, 'checkout__app_bar_name') ??
                  '',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: Center(
            child: Text(
              Utils.getString(context, 'checkout__no_product'),
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ));
    }
  }
}

class _OrderSummaryWidget extends StatefulWidget {
  const _OrderSummaryWidget({
    Key key,
    @required this.productList,
    @required this.couponDiscount,
    @required this.psValueHolder,
    @required this.cartList,
  }) : super(key: key);
  final List<DocumentSnapshot> cartList;
  final List<Product> productList;
  final String couponDiscount;
  final PsValueHolder psValueHolder;

  @override
  __OrderSummaryWidgetState createState() =>
      __OrderSummaryWidgetState();
}

class __OrderSummaryWidgetState extends State<_OrderSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    final BasketProvider basketProvider =
        Provider.of<BasketProvider>(context);

    String currencySymbol;

    if (widget.productList.isNotEmpty) {
      currencySymbol = widget.productList[0].currencySymbol;
    }
    basketProvider.checkoutCalculationHelper.calculate(
        productList: widget.productList,
        couponDiscountString: widget.couponDiscount,
        psValueHolder: widget.psValueHolder);

    const Widget _dividerWidget = Divider(
      height: ps_space_2,
      color: Colors.grey,
    );

    const Widget _spacingWidget = SizedBox(
      height: ps_space_12,
    );
    double totalPrice = 0.0;

    for (int i = 0; i < widget.cartList.length; i++) {
      totalPrice += widget.cartList[i]['price'] as double;
    }
    int totalDiscountPrice = 0;
    for (int i = 0; i < widget.cartList.length; i++) {
      totalDiscountPrice +=
          widget.cartList[i].data['Orignal Price'].toInt();
    }
    // final dicount = totalDiscountPrice;
    // print(totalPrice - totalDiscountPrice * 100 / 100);
    return Card(
        elevation: 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                Utils.getString(context, 'checkout__order_summary'),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            _dividerWidget,
            _OrderSummeryTextWidget(
              transationInfoText: widget.cartList.length.toString(),
              title:
                  '${Utils.getString(context, 'checkout__total_item_count')} :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText: '₹$totalDiscountPrice',
              title:
                  '${Utils.getString(context, 'checkout__total_item_price')} :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText: '-' +
                  '₹' +
                  (totalDiscountPrice - totalPrice)
                      .toString()
                      .replaceAll('-', ''),
              // '',
              title:
                  '${Utils.getString(context, 'checkout__discount')} :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText: widget.couponDiscount == null
                  ? '-'
                  : widget.couponDiscount,
              title:
                  '${Utils.getString(context, 'checkout__coupon_discount')} :',
            ),
            _spacingWidget,
            _dividerWidget,
            _OrderSummeryTextWidget(
              transationInfoText: '₹' + (totalPrice).toString(),
              title:
                  '${Utils.getString(context, 'checkout__sub_total')} :',
            ),
            // _OrderSummeryTextWidget(
            //   transationInfoText:
            //       '$currencySymbol ${basketProvider.checkoutCalculationHelper.taxFormattedString}',
            //   title:
            //       '${Utils.getString(context, 'checkout__tax')} (${psValueHolder.overAllTaxLabel} %) :',
            // ),
            _spacingWidget,
            _dividerWidget,
            _OrderSummeryTextWidget(
              transationInfoText: '₹' + (totalPrice).toString(),
              title:
                  '${Utils.getString(context, 'transaction_detail__total')} :',
            ),
            _spacingWidget,
          ],
        ));
  }
}

class _OrderSummeryTextWidget extends StatelessWidget {
  const _OrderSummeryTextWidget({
    Key key,
    @required this.transationInfoText,
    this.title,
    // @required this.productList,
  }) : super(key: key);

  final String transationInfoText;
  final String title;
  // final DocumentSnapshot productList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: ps_space_16, right: ps_space_16, top: ps_space_12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            transationInfoText ?? '-',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}

class Stripe extends StatefulWidget {
  const Stripe(
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
  _StripeState createState() => _StripeState();
}

class _StripeState extends State<Stripe> {
  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }

  @override
  Widget build(BuildContext context) {
    PsApiService psApiService;
    psApiService = Provider.of<PsApiService>(context);
    return ChangeNotifierProvider<TokenProvider>(create:
        (BuildContext context) {
      final TokenProvider provider =
          TokenProvider(psApiService: psApiService);
      provider.loadToken();
      return provider;
    }, child: Consumer<TokenProvider>(builder:
        (BuildContext context, TokenProvider provider, Widget child) {
      if (provider.tokenData != null &&
          provider.tokenData.data != null &&
          provider.tokenData.data.message != null) {
        return SizedBox(
          width: double.infinity,
          child: Container(
              padding: const EdgeInsets.only(
                  left: ps_space_16,
                  top: ps_space_8,
                  right: ps_space_16),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                shape: const BeveledRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(7.0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(widget.iconData, color: Colors.white),
                    const SizedBox(
                      width: ps_space_8,
                    ),
                    Text(
                      ' ' + widget.name,
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
                color: Colors.blue,
                onPressed: () async {
                  final dynamic returnData =
                      await Navigator.pushNamed(
                          context, RoutePaths.creditCard,
                          arguments: CreditCardIntentHolder(
                              productList: widget.productList,
                              couponDiscount:
                                  widget.couponDiscount ?? '0.0',
                              transactionSubmitProvider:
                                  widget.transactionSubmitProvider,
                              userLoginProvider:
                                  widget.userLoginProvider,
                              basketProvider: widget.basketProvider,
                              psValueHolder: widget.psValueHolder,
                              name: widget.name,
                              iconData: widget.iconData));
                  if (returnData != null && returnData) {
                    Navigator.pop(
                      context,
                    );
                  }
                },
              )),
        );
      } else {
        return Container();
      }
    }));
  }
}

class Pay extends StatefulWidget {
  const Pay({
    Key key,
    @required this.productList,
    @required this.couponDiscount,
    @required this.psValueHolder,
    @required this.transactionSubmitProvider,
    @required this.userLoginProvider,
    @required this.basketProvider,
  }) : super(key: key);

  final List<Product> productList;
  final String couponDiscount;
  final PsValueHolder psValueHolder;
  final TransactionHeaderProvider transactionSubmitProvider;
  final UserLoginProvider userLoginProvider;
  final BasketProvider basketProvider;

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  dynamic payNow(String clientNonce) async {
    final BasketProvider basketProvider =
        Provider.of<BasketProvider>(context);

    basketProvider.checkoutCalculationHelper.calculate(
        productList: widget.productList,
        couponDiscountString: widget.couponDiscount,
        psValueHolder: widget.psValueHolder);

    final BraintreePayment braintreePayment = BraintreePayment();
    final dynamic data = await braintreePayment.showDropIn(
        nonce: clientNonce,
        amount: basketProvider
            .checkoutCalculationHelper.totalPriceFormattedString,
        enableGooglePay: true);
    print(
        '${Utils.getString(context, 'checkout__payment_response')} $data');

    final ProgressDialog progressDialog = loadingDialog(
      context,
    );

    if (data != null && data != 'error' && data != 'cancelled') {
      print(data);

      progressDialog.show();

      if (widget.userLoginProvider.userLogin != null &&
          widget.userLoginProvider.userLogin.data != null) {
        final PsResource<TransactionHeader> _apiStatus = await widget
            .transactionSubmitProvider
            .postTransactionSubmit(
                widget.userLoginProvider.userLogin.data.user.userName,
                widget
                    .userLoginProvider.userLogin.data.user.userPhone,
                widget.productList,
                Platform.isIOS ? data : data['paymentNonce'],
                widget.couponDiscount.toString(),
                basketProvider
                    .checkoutCalculationHelper.taxFormattedString,
                basketProvider.checkoutCalculationHelper
                    .totalDiscountFormattedString,
                basketProvider.checkoutCalculationHelper
                    .subTotalPriceFormattedString,
                basketProvider.checkoutCalculationHelper
                    .totalPriceFormattedString,
                basketProvider.checkoutCalculationHelper
                    .totalOriginalPriceFormattedString,
                ONE,
                ZERO,
                ZERO);

        if (_apiStatus.data != null) {
          progressDialog.dismiss();

          if (_apiStatus.status == PsStatus.SUCCESS) {
            await widget.basketProvider.deleteWholeBasketList();

            Navigator.pop(
              context,
            );
            await Navigator.pushNamed(
              context,
              RoutePaths.checkoutSuccess,
            );
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
  }

  @override
  Widget build(BuildContext context) {
    PsApiService psApiService;
    psApiService = Provider.of<PsApiService>(context);
    return ChangeNotifierProvider<TokenProvider>(create:
        (BuildContext context) {
      final TokenProvider provider =
          TokenProvider(psApiService: psApiService);
      provider.loadToken();
      return provider;
    }, child: Consumer<TokenProvider>(builder:
        (BuildContext context, TokenProvider provider, Widget child) {
      if (provider.tokenData != null &&
          provider.tokenData.data != null &&
          provider.tokenData.data.message != null) {
        return SizedBox(
          width: double.infinity,
          child: Container(
              padding: const EdgeInsets.only(
                  left: ps_space_16, right: ps_space_16),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                shape: const BeveledRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(7.0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesome.paypal, color: Colors.white),
                    const SizedBox(
                      width: ps_space_8,
                    ),
                    Text(
                      Utils.getString(
                          context, 'checkout__paypal_button_name'),
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
                color: Colors.blue,
                onPressed: () async {
                  await payNow(provider.tokenData.data.message);
                },
              )),
        );
      } else {
        return Container();
      }
    }));
  }
}

String getBalancePriceFormat(String price) {
  final NumberFormat psFormat = NumberFormat('###.00');
  return psFormat.format(double.parse(price));
}
