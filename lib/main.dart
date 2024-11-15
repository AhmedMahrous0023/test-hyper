import 'package:flutter/material.dart';
import 'package:hyperpay_plugin/flutter_hyperpay.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:hyperpay_plugin/model/ready_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FlutterHyperPay flutterHyperPay;
  final String token =
      'eyJhbGciOiJSUzI1NiIsImtpZCI6IkVFMzhDMTEzQjczMTc4QjczM0U3REQ5ODc4ODU3Q0I4MUExM0NGQTUiLCJ4NXQiOiI3ampCRTdjeGVMY3o1OTJZZUlWOHVCb1R6NlUiLCJ0eXAiOiJhdCtqd3QifQ.eyJhdWQiOiJTbWFydFBhcmtpbmciLCJpc3MiOiJodHRwczovL3Rlc3QubWRraGwuY29tIiwiaWF0IjoxNzMxNTk2MzcyLCJzdWIiOiIzYTE2MzhhOS01NjQzLWVjMWEtY2Q3Ni1mNmE4NDFlOTQwODEiLCJnaXZlbl9uYW1lIjoidGVzdGVyMTAwIiwiZW1haWwiOiJ0ZXN0ZXIyMDBAZ21haWwuY29tIiwicm9sZSI6IkN1c3RvbWVyIiwidGVuYW50aWQiOiIiLCJzY29wZSI6ImFkZHJlc3MgZW1haWwgcGhvbmUgcm9sZXMgcHJvZmlsZSBvZmZsaW5lX2FjY2VzcyBTbWFydFBhcmtpbmcifQ.EFBiezq1F6uMHl-dPntaesYCB5UPncKfwD861Za2AxbiqYQr6eXouv6QoNmweW2nyyaFWTXkgVJOfJy4bvPtqmpC8JCOVGStej8GajWZujy0g5kowu4xJkwzLdRS-Y6xZ6okAQhCPCigHUjU8hNbOplfFc8KgpV2GQEe7xbflYh7XKRQt86agbB29fkySBhAftDj4AzE0x0BtnXeXG1aTDRCFUdYldIW-B3j8gmWrlmb4yFBNzYKGDETy2PDqRyShyP-SmDgpV1TUJ39fw-iwSAZbJDKAFjtg0gLWC4YFbEZgr_7Y7WBagBkIRjtX92c8tJ7e06p6Cp29RQlEJ_aFQ';

  @override
  void initState() {
    super.initState();
    flutterHyperPay = FlutterHyperPay(
      shopperResultUrl: 'com.testpayment.payment', 
      paymentMode: PaymentMode.test, 
      lang: 'ar', 
    );
  }

  Future<String?> getCheckOut() async {
    try{
    final url = Uri.parse('https://test.mdkhl.com/api/mobile/payment/CreateCheckoutPayment');

    final response = await http.post(url,body:{{
  "paymentMethod": 3,
  "paymentCategory": 1,
  "paymentCategoryId": 123,
  "amount": 500,
  "currency": "SAR",
  "paymentType": "DB",
  "entityId": "8ac7a4ca9244f53c01924741733e0327"
}},headers: {
  'Content-Type':'application/json',
  'Authorization':'Bearer $token'
} );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['value']['checkoutId']; 
    } else {
      return ('Error: ${response.statusCode}');
    }}catch(e){
      print(e.toString());
    }
    return null ;
  }

  payRequestNowReadyUI(String checkoutId) async {
    PaymentResultData paymentResultData = await flutterHyperPay.readyUICards(
      readyUI: ReadyUI(
        brandsName: ["VISA", "MASTER", "MADA"], 
        checkoutId: checkoutId, 
        merchantIdApplePayIOS: 'merchantId', 
        countryCodeApplePayIOS: 'SA',
        companyNameApplePayIOS: 'Test Co',
        themColorHexIOS: "#000000", 
        setStorePaymentDetailsMode:
            true, 
      ),
    );

    if (paymentResultData.paymentResult == PaymentResult.success ||
        paymentResultData.paymentResult == PaymentResult.sync) {
      dev.log('Payment Success');
    }
    print(paymentResultData.paymentResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pay with Ready UI",
                style: TextStyle(fontSize: 20, color: Colors.red)),
            InkWell(
              onTap: () async {
                String? checkoutId = await getCheckOut();
                print(checkoutId);
                print('ahmed');
                if (checkoutId != null) {
                  payRequestNowReadyUI(checkoutId);
                }
              },
              child: Text("Pay Now", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
