import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkLocale.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTransactionType.dart';
import '../../Features/Shared/Models/pay_tab_request_model.dart';

class PayTabsService {
  PaymentSdkConfigurationDetails configPayment({required PayTabsPaymentRequest payTabsPaymentRequest}) {
    final BillingDetails billingInfo = BillingDetails(
      payTabsPaymentRequest.name,
      payTabsPaymentRequest.email,
      payTabsPaymentRequest.phone,
      payTabsPaymentRequest.city,
      'SA',
      payTabsPaymentRequest.city,
      payTabsPaymentRequest.city,
      '12325',
    );
    final ShippingDetails shippingInfo = ShippingDetails(
      payTabsPaymentRequest.name,
      payTabsPaymentRequest.email,
      payTabsPaymentRequest.phone,
      payTabsPaymentRequest.city,
      'SA',
      payTabsPaymentRequest.city,
      payTabsPaymentRequest.city,
      '12325',
    );
    var configuration = PaymentSdkConfigurationDetails(
      profileId: '117468',
      serverKey: 'SDJNK9KHZT-JKN6JJ62WG-JZWNJW2MRM',
      clientKey: 'CRKM7T-R6NH6K-QG66GM-MB96KV',
      cartId: "Cart's ID",
      cartDescription: "Cart Description",
      merchantName: "Dev3Solutions",
      screentTitle: "Pay with Card",
      transactionType: PaymentSdkTransactionType.SALE,
      amount: payTabsPaymentRequest.amount.toDouble(),
      currencyCode: "SAR",
      locale: PaymentSdkLocale.EN,
      merchantCountryCode: "SA",
      billingDetails: billingInfo,
      linkBillingNameWithCardHolderName: true,
      shippingDetails: shippingInfo
    );
    configuration.showBillingInfo = false;
    configuration.showShippingInfo = false;
    configuration.tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
    return configuration;
  }
}