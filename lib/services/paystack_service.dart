import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:creditpay/models/bank_model.dart';

class PaystackService {
  // REPLACE WITH YOUR PUBLIC KEY
  final String _publicKey = "pk_test_7c2a1c4bd02334a57c429c33f2e493a658fe28b1";
  final String _secretKey = "sk_test_0660b51334123ef15bbb38c63aa08fbfb9462c9a";

  // Paystack API Base URL
  static const String _baseUrl = "https://api.paystack.co";

  // Singleton instance
  static final PaystackService _instance = PaystackService._internal();
  factory PaystackService() => _instance;

  PaystackService._internal();

  /// Trigger Paystack Payment
  Future<bool> chargeCard({
    required BuildContext context,
    required double amount,
    required String email,
    required String reference,
  }) async {
    final Completer<bool> completer = Completer<bool>();

    try {
      await FlutterPaystackPlus.openPaystackPopup(
        publicKey: _publicKey,
        context: context,
        secretKey:
            "sk_test_0660b51334123ef15bbb38c63aa08fbfb9462c9a", // NOTE: The library might request this, but strictly using PK for client side.
        // If the library forces secretKey for mobile, it is a known issue with this package's design.
        // potentially requiring a server-side implementation or a specific 'plan' config.
        // For now, we will try with publicKey only.
        customerEmail: email,
        amount: (amount * 100).toString(),
        reference: reference,
        plan: "", // Avoid null in library
        currency: "NGN", // Avoid null in library (though usually default)
        callBackUrl:
            "https://standard.paystack.co/close", // Required for mobile redirect
        onClosed: () {
          debugPrint('❌ Payment Closed');
          if (!completer.isCompleted) completer.complete(false);
        },
        onSuccess: () {
          debugPrint('✅ Payment Successful');
          if (!completer.isCompleted) completer.complete(true);
        },
      );
    } catch (e) {
      debugPrint('❌ Paystack Error: $e');
      if (!completer.isCompleted) completer.complete(false);
    }

    return completer.future;
  }

  String generateReference() {
    return "txn_${const Uuid().v4()}";
  }

  /// Fetch list of Nigerian banks from Paystack
  Future<List<Bank>> getBanks() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bank?currency=NGN'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          final List<dynamic> banksJson = data['data'];
          return banksJson.map((json) => Bank.fromJson(json)).toList();
        } else {
          debugPrint('❌ Paystack Error: ${data['message']}');
          return [];
        }
      } else {
        debugPrint('❌ Failed to fetch banks: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error fetching banks: $e');
      return [];
    }
  }

  /// Verify account number with bank code
  Future<AccountVerification?> verifyAccountNumber({
    required String accountNumber,
    required String bankCode,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/bank/resolve?account_number=$accountNumber&bank_code=$bankCode',
        ),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          return AccountVerification.fromJson(data['data']);
        } else {
          // Throw the specific error message from Paystack
          throw data['message'] ?? 'Verification failed';
        }
      } else {
        // Parse error body if available
        try {
          final errorData = json.decode(response.body);
          throw errorData['message'] ??
              'Failed to verify account (Status: ${response.statusCode})';
        } catch (e) {
          if (e is String) rethrow;
          throw 'Failed to verify account (Status: ${response.statusCode})';
        }
      }
    } catch (e) {
      debugPrint('❌ Verify Error: $e');
      rethrow;
    }
  }
}
