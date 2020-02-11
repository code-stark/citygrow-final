import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckoutCalculationHelper {
  CheckoutCalculationHelper();
  int totalItemCount;
  double subTotalPrice = 0.00;
  String subTotalPriceFormattedString;
  double totalDiscount = 0.00;
  String totalDiscountFormattedString;
  double couponDiscount = 0.00;
  String couponDiscountFormattedString;
  double tax = 0.00;
  String taxFormattedString;
  double totalPrice = 0.00;
  String totalPriceFormattedString;
  double totalOriginalPrice = 0.00;
  String totalOriginalPriceFormattedString;

  void reset() {
    totalItemCount = 0;
    subTotalPrice = 0.00;
    subTotalPriceFormattedString = '';
    totalDiscount = 0.00;
    totalDiscountFormattedString = '';
    couponDiscount = 0.00;
    couponDiscountFormattedString = '';
    tax = 0.00;
    taxFormattedString = '';
    totalPrice = 0.00;
    totalPriceFormattedString = '';
    totalOriginalPrice = 0.00;
    totalOriginalPriceFormattedString = '';
  }

  void calculate(
      {@required List<Product> productList,
      @required String couponDiscountString,
      @required PsValueHolder psValueHolder}) {
    // reset Data
    reset();

    //  Product Discount and Product Original Price Calculation and  Product Count
    if (productList.isNotEmpty) {
      for (int i = 0; i < productList.length; i++) {
        //Product Original Price Calculation
        totalOriginalPrice += double.parse(productList[i].originalPrice);

        // Items Total Discount Calculation
        totalDiscount += double.parse(productList[i].discountAmount);
      }
      // Product Count Calculation
      totalItemCount = productList.length;

      // SubTotal Calculation
      subTotalPrice = totalOriginalPrice - totalDiscount;

      // Coupon Discount Calculation
      // subTotalPrice - coupondiscount = subTotalPrice  after coupon discount
      if (couponDiscountString != null &&
          couponDiscountString != '-' &&
          couponDiscountString != '') {
        couponDiscount = double.parse(couponDiscountString);
        subTotalPrice = subTotalPrice - couponDiscount;
      }

      // Tax Calculation
      // subTotalPrice * Tax Percentage = Tax Amount
      if (psValueHolder.overAllTaxLabel != '0') {
        tax = subTotalPrice * double.parse(psValueHolder.overAllTaxValue);
      }

      // Total Payable Amount
      // subTotalPrice + Tax Amount = Total
      totalPrice = subTotalPrice + tax;

      // Formatted String
      // - Total Product Original Price
      // - Total Discount Amount
      // - Coupon Discount Amount
      // - Sub Total Price
      // - Tax Amount
      // - Total Payable
      totalOriginalPriceFormattedString =
          getPriceFormat(totalOriginalPrice.toString());
      totalDiscountFormattedString = getPriceFormat(totalDiscount.toString());
      couponDiscountFormattedString = getPriceFormat(couponDiscount.toString());
      subTotalPriceFormattedString = getPriceFormat(subTotalPrice.toString());
      taxFormattedString = getPriceFormat(tax.toString());
      totalPriceFormattedString = getPriceFormat(totalPrice.toString());
    }
  }
}

String getPriceFormat(String price) {
  final NumberFormat psFormat = NumberFormat('###.00');
  return psFormat.format(double.parse(price));
}
