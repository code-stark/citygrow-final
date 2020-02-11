import 'package:digitalproductstore/provider/basket/basket_provider.dart';
import 'package:digitalproductstore/provider/transaction/transaction_header_provider.dart';
import 'package:digitalproductstore/provider/user/user_login_provider.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/cupertino.dart';

class CreditCardIntentHolder {
  const CreditCardIntentHolder(
      {@required this.productList,
      @required this.couponDiscount,
      @required this.psValueHolder,
      @required this.transactionSubmitProvider,
      @required this.userLoginProvider,
      @required this.basketProvider,
      @required this.name,
      @required this.iconData});

  final List<Product> productList;
  final String couponDiscount;
  final PsValueHolder psValueHolder;
  final TransactionHeaderProvider transactionSubmitProvider;
  final UserLoginProvider userLoginProvider;
  final BasketProvider basketProvider;
  final String name;
  final IconData iconData;
}
