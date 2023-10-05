import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';

class CoffeeShop extends StatefulWidget {
  CoffeeShop({Key? key, required this.amount, required this.description})
      : super(key: key);
  final int amount;
  final String description;

  @override
  State<CoffeeShop> createState() => _CoffeeShopState();
}

class _CoffeeShopState extends State<CoffeeShop> {
  late int a;
  @override
  void initState() {
    super.initState();
    a = widget.amount;
  }

  var paymentConfig = PaymentConfig(
    publishableApiKey: 'pk_test_r6eZg85QyduWZ7PNTHT56BFvZpxJgNJ2PqPMDoXA',
    amount: 100, // SAR 1
    description: 'order #1324',
    metadata: {'size': '250g'},
    creditCard: CreditCardConfig(saveCard: false, manual: false),
    applePay: ApplePayConfig(
      merchantId: 'merchant.mysr.fghurayri',
      label: 'Blue Coffee Beans',
      manual: true,
    ),
  );

  void onPaymentResult(result) {
    if (result is PaymentResponse) {
      showToast(context, result.status.name);
      switch (result.status) {
        case PaymentStatus.paid:
          // handle success.
          break;
        case PaymentStatus.failed:
          // handle failure.
          break;
        case PaymentStatus.authorized:
          // handle authorized
          break;
        default:
      }
      return;
    }

    // handle other types of failures.
    if (result is ApiError) {}
    if (result is AuthError) {}
    if (result is ValidationError) {}
    if (result is PaymentCanceledError) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView(
            children: [
              PaymentMethods(
                paymentConfig: paymentConfig,
                onPaymentResult: onPaymentResult,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showToast(BuildContext context, String status) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "Status: $status",
        style: const TextStyle(fontSize: 20),
      ),
    ),
  );
}

class PaymentMethods extends StatelessWidget {
  final PaymentConfig paymentConfig;
  final Function onPaymentResult;

  PaymentMethods(
      {Key? key, required this.paymentConfig, required this.onPaymentResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreditCard(
          config: paymentConfig,
          onPaymentResult: onPaymentResult,
        ),
        const Text("or"),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ApplePay(
            config: paymentConfig,
            onPaymentResult: onPaymentResult,
          ),
        ),
      ],
    );
  }
}
