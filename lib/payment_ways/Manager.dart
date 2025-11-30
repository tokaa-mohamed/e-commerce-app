import 'dart:convert';
import 'package:ecommerce/payment_ways/Stripe_key.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static const String _apiBase = "https://api.stripe.com/v1";

static  Future<void> makePayment(int amount, String currency) async {

    try {

      String clientSecret = await _getClientSecret((amount*100).toString(), currency);
     await _initializesheet(clientSecret);
await Stripe.instance.presentPaymentSheet();
      print("Client Secret: $clientSecret");


    } catch (e) {
      print("Error in makePayment: $e");
    }
  }

  static Future<void> _initializesheet(String client_secret) async{
    await Stripe.instance.initPaymentSheet(paymentSheetParameters: 
    SetupPaymentSheetParameters(paymentIntentClientSecret: 
    client_secret,
    merchantDisplayName: 'toka'
    )
    );
    
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    final url = Uri.parse("$_apiBase/payment_intents");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer ${Apikeys.secretkey}",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "amount": amount.toString(), 
        "currency": currency,
        "payment_method_types[]": "card",
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body["client_secret"];
    } else {
      throw Exception("Failed to create PaymentIntent: ${response.body}");
    }
  }
}
